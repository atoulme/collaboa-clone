module EventsHelper
  def format_author(address)
    if address =~ /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/
      mail_to(address, address, :encode => "javascript")
    else
      address
    end
  end
end
