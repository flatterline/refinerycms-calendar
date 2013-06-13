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

        @past_events = [].tap do |events|
          3.times { events << FactoryGirl.create(:past_event) }
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

        it 'links to past events' do
          click_link 'View past events'

          @past_events.each do |event|
            page.should have_link(event.title)
          end

          page.should have_link('View upcoming events')
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

      describe 'contact the organizer' do

        it 'sends an email to the organizer' do
          event = @public_events.last
          click_link event.title

          click_link 'Contact the Organizer'

          name  = 'Mary Smith'
          email = 'mary@smith.com'
          body  = 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Tempora, corporis iusto quasi vitae incidunt earum a. Culpa, esse, necessitatibus aperiam ab consequatur laborum sed distinctio doloribus error maiores natus saepe.'

          mail = mock('event_mailer')
          mail.should_receive(:deliver)
          ::Refinery::Calendar::EventMailer.should_receive(:new_message).and_return mail

          fill_in 'Your Name',     with: name
          fill_in 'Email Address', with: email
          fill_in 'Your Message',  with: body
          click_button 'Send Message'
        end

      end

    end

  end

end
