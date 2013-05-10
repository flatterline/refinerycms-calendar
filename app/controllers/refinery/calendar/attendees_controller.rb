module Refinery
  module Calendar
    class AttendeesController < ::ApplicationController
      before_filter :find_event

      def new
        @attendee = @event.attendees.build
        present(@page)
      end

      def create
        @attendee = @event.attendees.build(params[:attendee])

        if @attendee.save
          ::Refinery::Calendar::EventMailer.new_registration(@event, request).deliver
          redirect_to refinery.thanks_calendar_event_attendees_path(@event)
        else
          render :new
        end
      end

      def thanks
        present(@page)
      end

    protected

      def find_event
        @event = ::Refinery::Calendar::Event.find(params[:event_id])
      end

      def find_page
        @page = ::Refinery::Page.where(link_url: '/calendar/events').first
      end

    end
  end
end
