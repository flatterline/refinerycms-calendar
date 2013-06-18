# encoding: utf-8
require "spec_helper"

describe Refinery do
  describe "Calendar" do
    describe "Admin" do
      describe "events" do
        login_refinery_user

        describe "events list" do
          before(:each) do
            FactoryGirl.create(:event, :title => "UniqueTitleOne")
            FactoryGirl.create(:event, :title => "UniqueTitleTwo")
          end

          it "shows two items" do
            visit refinery.calendar_admin_events_path
            page.should have_content("UniqueTitleOne")
            page.should have_content("UniqueTitleTwo")
          end
        end

        describe "create" do
          before(:each) do
            visit refinery.calendar_admin_events_path

            click_link "Add New Event"
          end

          context "valid data" do
            it "should succeed" do
              fill_in "Title", with: "This is a test of the first string field"
              fill_in 'From',  with: (Time.now + 1.day).strftime("%b %d, %Y %I:%M %p")
              fill_in 'To',    with: (Time.now + 1.day + 2.hours).strftime("%b %d, %Y %I:%M %p")
              check 'Conference'

              click_button "Save"

              page.should have_content("'This is a test of the first string field' was successfully added.")

              event = Refinery::Calendar::Event.where(title: 'This is a test of the first string field').first
              event.should be_present
              event.category_list.should include('conference')
            end
          end

          context "invalid data" do
            it "should fail" do
              click_button "Save"

              page.should have_content("Title can't be blank")
              Refinery::Calendar::Event.count.should == 0
            end
          end

          context "duplicate" do
            before(:each) { FactoryGirl.create(:event, :title => "UniqueTitle") }

            it "should fail" do
              visit refinery.calendar_admin_events_path

              click_link "Add New Event"

              fill_in "Title", :with => "UniqueTitle"
              click_button "Save"

              page.should have_content("There were problems")
              Refinery::Calendar::Event.count.should == 1
            end
          end

        end

        describe "edit" do
          before :each do
            FactoryGirl.create :event, title: 'A title', category_list: 'conference'
          end

          it "should succeed" do
            visit refinery.calendar_admin_events_path

            within ".actions" do
              click_link "Edit this event"
            end

            fill_in "Title", :with => "A different title"
            uncheck 'Conference'
            check 'Networking'

            click_button "Save"

            page.should have_content("'A different title' was successfully updated.")
            page.should have_no_content("A title")

            event = Refinery::Calendar::Event.where(title: 'A different title').first
            event.should be_present
            event.category_list.should_not include('conference')
            event.category_list.should include('networking')
          end
        end

        describe "destroy" do
          before(:each) { FactoryGirl.create(:event, :title => "UniqueTitleOne") }

          it "should succeed" do
            visit refinery.calendar_admin_events_path

            click_link "Remove this event forever"

            page.should have_content("'UniqueTitleOne' was successfully removed.")
            Refinery::Calendar::Event.count.should == 0
          end
        end

      end
    end
  end
end
