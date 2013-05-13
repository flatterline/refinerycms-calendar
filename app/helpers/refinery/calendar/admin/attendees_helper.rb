module Refinery::Calendar::Admin::AttendeesHelper
  def attendee_info attendee
    simple_format [attendee.company_name, attendee.address, attendee.phone].compact.join("\n")
  end
end
