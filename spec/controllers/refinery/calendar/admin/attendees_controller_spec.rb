require 'spec_helper'

describe Refinery::Calendar::Admin::AttendeesController do
  login_refinery_user

  before do
    @attendee = FactoryGirl.create(:attendee)
  end

  it "should render a csv file" do
    file_name  = "#{@attendee.event.slug}.csv"

    get :index, :event_id => @attendee.event.id, :format => 'csv'

    response.content_type.should eq("text/csv")
    response.headers["Content-Disposition"].should eq("attachment; filename=\"#{file_name}\"")
  end

end