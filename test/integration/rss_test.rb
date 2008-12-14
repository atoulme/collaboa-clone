require "#{File.dirname(__FILE__)}/../test_helper"

class RssTest < ActionController::IntegrationTest
  fixtures :users, :changesets, :tickets

  def test_links
    get '/rss/changesets'
    
    assert_select_feed :rss , '2.0' do
      assert_select "channel" do
        assert_select "channel > link", "http://www.example.com/"
        assert_select "item" do
          assert_select 'link', /http:\/\/www.example.com\/repository\/changesets\/\d+/
        end
      end
    end
  end
    
  def test_links_when_https
    https!
    get '/rss/changesets'

    assert_select_feed :rss , '2.0' do
      assert_select "channel" do
        assert_select "channel > link", /^https/
        assert_select "item" do
          assert_select 'link', /^https/
        end
      end
    end
  end
  
  def test_links_when_in_subdirectory
    ActionController::TestRequest.relative_url_root = '/subdir'
    get '/subdir/rss/changesets'
  
    assert_select_feed :rss , '2.0' do
      assert_select "channel" do
        assert_select "channel > link", /\/subdir/
        assert_select "item" do
          assert_select 'link', /\/subdir/
        end
      end
    end
  end
end
