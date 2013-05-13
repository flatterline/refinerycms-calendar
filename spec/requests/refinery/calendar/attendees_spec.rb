# encoding: utf-8
require "spec_helper"

describe Refinery do

  describe 'Calendar' do

    describe 'Attendees' do

      describe 'register' do

        before do
          Factory(:refinery_user)

          @event = FactoryGirl.create(:event)
          visit refinery.calendar_event_path(@event)
        end

        context 'non-user' do

          before do
            click_link 'Register'
          end

          context 'valid data' do

            before do
              mail = mock('event_mailer')
              mail.should_receive(:deliver)
              ::Refinery::Calendar::EventMailer.should_receive(:new_registration).and_return mail
            end

            it 'should succeed' do
              fill_in 'Name', with: 'John Smith'
              fill_in 'Email', with: 'john@smith.com'
              click_button 'Register'

              page.should have_content('Thanks for registering for this event!')

              attendee = Refinery::Calendar::Attendee.first
              attendee.name.should == 'John Smith'
              attendee.email.should == 'john@smith.com'
              attendee.number_attending.should == 1
              attendee.event_id.should == @event.id
            end

          end

          context 'invalid data' do

            it 'should fail' do
              click_button 'Register'

              page.should have_content("Name can't be blank")
              Refinery::Calendar::Attendee.count.should be_zero
            end

          end

        end

        context 'user' do
          login_refinery_user

          before do
            Refinery::User.any_instance.stub(:name).and_return('Mary Johnson')
            Refinery::User.any_instance.stub(:phone).and_return('123-456-7890')

            @user = Refinery::User.last

            visit refinery.calendar_event_path(@event)
            click_link 'Register'
          end

          it 'prepopulates the fields' do
            page.should have_field 'attendee_name',  with: @user.name
            page.should have_field 'attendee_email', with: @user.email
            page.should have_field 'attendee_phone', with: @user.phone
          end

          context 'valid data' do

            before do
              mail = mock('event_mailer')
              mail.should_receive(:deliver)
              ::Refinery::Calendar::EventMailer.should_receive(:new_registration).and_return mail
            end

            it 'records the user ID' do
              click_button 'Register'

              page.should have_content('Thanks for registering for this event!')

              attendee = Refinery::Calendar::Attendee.first
              attendee.name.should             == @user.name
              attendee.email.should            == @user.email
              attendee.number_attending.should == 1
              attendee.event_id.should         == @event.id
              attendee.user_id.should          == @user.id
            end

          end

        end

      end

    end

  end

end
