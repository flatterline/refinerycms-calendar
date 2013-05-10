require 'spec_helper'

module Refinery
  module Calendar
    describe Event do
      before do
        @event = FactoryGirl.build(:event)
      end

      describe "validations" do

        describe 'ends_at' do

          it 'is required' do
            @event.ends_at = nil
            @event.should_not be_valid
          end

          it "ensures an event's end is after it's start" do
            @event.starts_at = "Apr 24, 2013 12:00 pm"
            @event.ends_at   = "Apr 23, 2013 12:00 pm"

            @event.should_not be_valid
            @event.errors[:base].should include("An event's end must come after it's start")
          end

        end

        describe 'organizer_id' do

          it 'is required' do
            @event.organizer_id = nil
            @event.should_not be_valid
          end

        end

        describe 'starts_at' do

          it 'is required' do
            @event.starts_at = nil
            @event.should_not be_valid
          end

        end

        describe 'title' do

          it 'is required' do
            @event.title = ''
            @event.should_not be_valid
          end

        end

      end
    end
  end
end
