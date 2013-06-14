module Refinery
  module Calendar
    module Admin
      class EventsController < ::Refinery::AdminController
        load_and_authorize_resource :class => 'Refinery::Calendar::Event'

        crudify :'refinery/calendar/event',
                xhr_paging: true,
                sortable:   false,
                order:      'refinery_calendar_events.starts_at DESC'

        def create_with_organizer
          params[:event][:organizer_id] = current_refinery_user.id
          create_without_organizer
        end
        alias_method_chain :create, :organizer

        def upcoming
          @events = Refinery::Calendar::Event.upcoming
          paginate_all_events

          render_partial_response?
        end

      end
    end
  end
end
