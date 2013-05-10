require 'spec_helper'

module Refinery

  module Calendar

    describe Attendee do

      before do
        @attendee = FactoryGirl.build :attendee
      end

      describe 'validations' do

        describe 'email' do

          it 'is required' do
            @attendee.email = ''
            @attendee.should_not be_valid
          end

          it 'is not required, if user present' do
            @attendee.user_id = 1
            @attendee.email = ''
            @attendee.should be_valid
          end

        end

        describe 'event_id' do

          it 'is required' do
            @attendee.event_id = nil
            @attendee.should_not be_valid
          end

        end

        describe 'name' do

          it 'is required' do
            @attendee.name = ''
            @attendee.should_not be_valid
          end

          it 'is not required, if user present' do
            @attendee.user_id = 1
            @attendee.name = ''
            @attendee.should be_valid
          end

        end

        describe 'number_attending' do

          it 'is required' do
            @attendee.number_attending = nil
            @attendee.should_not be_valid
          end

        end

      end

    end

  end

end
