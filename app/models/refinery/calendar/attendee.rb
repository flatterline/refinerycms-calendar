require 'csv'

module Refinery
  module Calendar
    class Attendee < Refinery::Core::BaseModel
      acts_as_indexed :fields => [:name, :email]

      belongs_to :event
      belongs_to :user, class_name: 'Refinery::User'

      validates :name, :email, presence: { unless: Proc.new { |a| a.user_id.present? } }
      validates :event_id, :number_attending, presence: true

      attr_accessible :address, :company_name, :email, :event_id, :message, :name, :number_attending, :phone, :user, :user_id, :ip_address

      # Fall back on the user's info, if possible.
      %w(email name phone).each do |a|
        define_method a do
          read_attribute(a) || self.user.try(a)
        end
      end

      class << self
        def to_csv_download
          CSV.generate do |csv|
            csv << ['Name', 'Email', 'Company Name', 'Address', 'Phone', 'Message', '# Attending', 'IP Address', 'Timestamp']
            order(:created_at).each do |attendee|
              csv << [attendee.name, attendee.email, attendee.company_name, attendee.address, attendee.phone, attendee.message, attendee.number_attending, attendee.ip_address, attendee.created_at.strftime("%m/%d/%Y %I:%M %p") ]
            end
          end
        end
      end
    end
  end
end
