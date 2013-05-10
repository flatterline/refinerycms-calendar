module Refinery
  module Calendar
    class EventMailer < ActionMailer::Base

      def new_registration event, request
        @url = refinery.calendar_admin_event_url(event, { host: request.host_with_port })
        mail(to: event.organizer.email,
             subject: t('subject', scope: 'refinery.event_mailer.new_registration'),
             from: "\"#{Refinery::Core.site_name}\" <no-reply@#{request.domain}>")
      end

    end
  end
end
