# encoding: utf-8
require "spec_helper"

describe Refinery do

  describe 'Calendar' do

    describe 'Event' do

      before do
        Factory(:refinery_user)

        @public_events = [].tap do |events|
          3.times { events << FactoryGirl.create(:event) }
        end

        @private_events = [].tap do |events|
          3.times { events << FactoryGirl.create(:private_event) }
        end

        visit refinery.calendar_events_path
      end

      describe 'list' do

        it 'only shows public events' do
          @public_events.each do |event|
            page.should have_link(event.title)
          end

          @private_events.each do |event|
            page.should_not have_link(event.title)
          end
        end

      end

      describe 'view' do

        it 'shows a public event' do
          event = @public_events.last
          click_link event.title
          page.should have_content(event.title)
        end

        it 'does not show a private event' do
          event = @private_events.last
          lambda { visit refinery.calendar_event_path(event) }.should raise_error(ActiveRecord::RecordNotFound)
        end

      end

    end

  end

end
