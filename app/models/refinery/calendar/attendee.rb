require 'csv'

module Refinery
  module Calendar
    class Attendee < Refinery::Core::BaseModel
      acts_as_indexed :fields => [:name, :email]

      belongs_to :event
      belongs_to :user, class_name: 'Refinery::User'

      validates :name, :email, presence: { unless: Proc.new { |a| a.user_id.present? } }
      validates :event_id, :number_attending, presence: true

      attr_accessible :address, :company_name, :email, :event_id, :message, :name, :number_attending, :phone, :user_id

      class << self
        def to_csv_download
          CSV.generate do |csv|
            csv << ['Name', 'Email', 'Company Name', 'Address', 'Phone', 'Message', '# Attending']
            order(:created_at).each do |attendee|
              csv << [attendee.name, attendee.email, attendee.company_name, attendee.address, attendee.phone, attendee.message, attendee.number_attending]
            end
          end
        end
      end
    end
  end
end
