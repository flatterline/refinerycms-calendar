# encoding: utf-8
require "spec_helper"

describe Refinery do

  describe "Calendar" do

    describe "Admin" do

      describe "attendees" do
        login_refinery_user

        describe "attendees list" do

          before do
            @attendee = FactoryGirl.create(:attendee)
            @event = @attendee.event
            3.times { FactoryGirl.create(:attendee, event: @attendee.event) }

            @other_attendee = FactoryGirl.create(:attendee)

            visit refinery.calendar_admin_event_path(@event)
          end

          it 'shows the number of attendees, not the number of registrations' do
            a = FactoryGirl.create :attendee, number_attending: 3
            visit refinery.calendar_admin_event_path(a.event)

            page.should have_link("View Attendees (3)")
          end

          it 'shows 0 attendees, when there are none' do
            event = FactoryGirl.create :event
            visit refinery.calendar_admin_event_path(event)

            page.should have_link("View Attendees (0)")
          end

          it "shows all 4 attendees" do
            click_link 'View Attendees (4)'

            attendees = @event.attendees

            attendees.should have(4).entries

            attendees.each do |attendee|
              page.should have_content(attendee.name)
              page.should have_content(attendee.email)
            end

            page.should_not have_content(@other_attendee.name)
            page.should_not have_content(@other_attendee.email)
          end

          it 'exports the 4 attendees' do
            click_link 'View Attendees (4)'
            click_link 'Export Attendees (.csv)'

            attendees = @event.attendees

            attendees.should have(4).entries

            attendees.each do |attendee|
              page.should have_content(attendee.name)
              page.should have_content(attendee.email)
            end

            page.should_not have_content(@other_attendee.name)
            page.should_not have_content(@other_attendee.email)
          end

        end

      end

    end

  end

end
