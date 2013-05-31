module Refinery
  module Calendar
    class EventMailer < ActionMailer::Base

      def new_message event, params, request
        @url   = refinery.calendar_admin_event_url(event, { host: request.host_with_port })
        @name  = params[:name]
        @body  = params[:body]

        mail(to: event.organizer.email,
             reply_to: "\"#{@name}\" <#{params[:email]}>",
             subject: t('subject', scope: 'refinery.event_mailer.new_message'),
             from: "\"#{Refinery::Core.site_name}\" <no-reply@#{request.domain}>")
      end

      def new_registration event, request
        @url = refinery.calendar_admin_event_url(event, { host: request.host_with_port })
        mail(to: event.organizer.email,
             subject: t('subject', scope: 'refinery.event_mailer.new_registration'),
             from: "\"#{Refinery::Core.site_name}\" <no-reply@#{request.domain}>")
      end

    end
  end
end
