module Refinery
  module Calendar
    class EventsController < ::ApplicationController
      def index
        @events = Event.public.upcoming.order('refinery_calendar_events.starts_at DESC').page(params[:page])

        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @event in the line below:
        present(@page)
      end

      def show
        @event = Event.find(params[:id])

        raise CanCan::AccessDenied unless can? :read, @event

        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @event in the line below:
        respond_to do |format|
          format.html { present(@page) }
          format.ics
        end
      end

      def archive
        @events = Event.archive.public.order('refinery_calendar_events.starts_at DESC').page(params[:page])
        render :template => 'refinery/calendar/events/index'
      end

      protected
      def find_page
        @page = ::Refinery::Page.where(:link_url => "/calendar/events").first
      end

    end
  end
end
