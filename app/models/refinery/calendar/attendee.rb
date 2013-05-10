module Refinery
  module Calendar
    class Attendee < Refinery::Core::BaseModel
      belongs_to :event
      belongs_to :user, class_name: 'Refinery::User'

      validates :name, :email, presence: { unless: Proc.new { |a| a.user_id.present? } }
      validates :event_id, :number_attending, presence: true

      attr_accessible :address, :company_name, :email, :event_id, :message, :name, :number_attending, :phone, :user_id
    end
  end
end
