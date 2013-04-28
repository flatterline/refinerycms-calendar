module Refinery
  module Calendar
    module Admin
      class EventsController < ::Refinery::AdminController
        before_filter :find_venues, :except => [:index, :destroy]

        crudify :'refinery/calendar/event',
                :xhr_paging => true,
                :sortable => false,
                :order => "refinery_calendar_events.from DESC"

        def upcoming
          @events = Refinery::Calendar::Event.upcoming
          paginate_all_events

          render_partial_response?
        end

        private
        def find_venues
          @venues = Venue.order('name')
        end
      end
    end
  end
end
