require File.dirname(__FILE__) + '/../test_helper'

class ApplicationHelperTest < Test::Unit::TestCase
  include ActionView::Helpers::UrlHelper 
  include ActionView::Helpers::TextHelper 
  include ActionView::Helpers::TagHelper 
  include ApplicationHelper
  
  fixtures :projects, :tickets, :repositories, :changesets
  
  def setup 
    @controller = TicketsController.new
    request = ActionController::TestRequest.new
    @controller.instance_eval { self.params = {}, self.request = request } 
    @controller.send(:initialize_current_url)
    
    @project = projects(:first_project)
  end
  
  def test_make_links_recognizes_tickets
    ticket_strings = <<-EOS
      Ticket #1
      ticket #1
      Ticket 1
      ticket 1
      ticket   1
      ticket # 1
      Ticket#1
      bug 1
      bug #1
      #1
      # 1
    EOS
    
    ticket_strings.each do |ticket_string|
      ticket_string.strip!
      assert_equal link_to(ticket_string, {:controller => 'tickets', :action => 'show', :id => 1}), make_links(ticket_string), "#{ticket_string} was not recognized as a ticket."
    end
  end
  
  def test_make_links_recognizes_changesets
    changeset_strings = <<-EOS
      Changeset [1]
      changeset [1]
      changeset: 1
      Changeset 1
      changeset 1
      changeset   1
      changeset[1]
      [1]
      revision 1
      rev 1
      r1
    EOS
    
    changeset_strings.each do |changeset_string|
      changeset_string.strip!
      assert_equal link_to(changeset_string, {:controller => 'repository', :action => 'changesets', :id => 1}), make_links(changeset_string), "#{changeset_string} was not recognized as a changeset."
    end
  end
  
  def test_make_links_does_not_recognize_nontickets_or_nonchangesets
    nonmatch_strings = <<-EOS
      1
      nonmatch 9999
      [9999]
      Ticket 99999
      #9999
    EOS
    
    nonmatch_strings.each do |nonmatch_string|
      nonmatch_string.strip!
      assert_equal nonmatch_string, make_links(nonmatch_string), "#{nonmatch_string} was recognized as a ticket or changeset."
    end
  end
  
  # Make sure RedCloth is doing what it ought.
  def test_format_and_make_links
    input = <<EOS
h1. Attention, please.

Testing out "very" & *strong*, &bull;, http://dev.collaboa.org, "Google":http://www.google.com. <a href="..">up</a> [1] closes #1.  <table><script src=http://evil.collaboa.org />

* One
* Two

<pre>
  <html><head><b><p>
  And another thing.
</pre>

Sincerely,
Jason
EOS
    
    expected = <<EOS
<h1>Attention, please.</h1>

\t<p>Testing out &#8220;very&#8221; &#38; <strong>strong</strong>, &bull;, <a href=\"http://dev.collaboa.org\">http://dev.collaboa.org</a>, <a href=\"http://www.google.com\">Google</a>. &lt;a href=&quot;..&quot;&gt;up&lt;/a&gt; <a href=\"/repository/changesets/1\">[1]</a> closes <a href=\"/tickets/1\">#1</a>.  &lt;table&gt;&lt;script src=http://evil.collaboa.org /&gt;</p>


<ul>
\t<li>One</li>
\t<li>Two</li>
</ul>

<pre>
  &lt;html&gt;&lt;head&gt;&lt;b&gt;&lt;p&gt;
  And another thing.
</pre>
\t<p>Sincerely,<br />Jason</p>
EOS
    
    assert_equal expected.chomp, format_and_make_links(input)
  end
end