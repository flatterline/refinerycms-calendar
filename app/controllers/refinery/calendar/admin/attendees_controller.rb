module Refinery
  module Calendar
    module Admin
      class AttendeesController < ::Refinery::AdminController
        before_filter :find_event

        crudify :'refinery/calendar/attendee',
                xhr_paging: true,
                sortable:   false

        def index
          search_all_attendees if searching?

          respond_to do |format|
            format.html {
              paginate_all_attendees
              render_partial_response?
            }
            format.csv #{
              # @filename        = "#{@event.slug}.csv"
              # @output_encoding = 'UTF-8'
              # @streaming       = true
            #}
          end
        end

        def find_all_attendees conditions = nil
          @attendees = @event.attendees.order(:created_at)
        end

      protected

        def find_event
          @event = ::Refinery::Calendar::Event.find(params[:event_id])
        end

      end
    end
  end
end
