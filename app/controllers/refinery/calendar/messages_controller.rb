module Refinery
  module Calendar
    class MessagesController < ::ApplicationController
      before_filter :find_event

      def new
      end

      def create
        EventMailer.new_message(@event, params, request).deliver

        flash[:success] = ::I18n.t('success', scope: 'refinery.controllers.messages.create')
        redirect_to refinery.calendar_event_url(@event)
      end

    protected

      def find_event
        @event = Refinery::Calendar::Event.find(params[:event_id])
      end

    end
  end
end
