module Refinery
  module Calendar
    class Event < Refinery::Core::BaseModel
      extend FriendlyId
      friendly_id :title, use: :slugged

      acts_as_indexed :fields => [:title, :description, :venue]

      belongs_to :organizer, class_name: 'Refinery::User'
      has_many   :attendees

      validates :title, presence: true, uniqueness: true
      validates :ends_at, :organizer_id, :starts_at, presence: true
      validate  :starts_before_end

      attr_accessible :description, :ends_at, :organizer_id, :starts_at, :title, :venue

      def attendees_count
        self.attendees.sum(&:number_attending)
      end

      def ends_at= date
        date = DateTime.parse(date, "%b %d, %Y %I:%M %p") if date.is_a?(String) && date.present?
        write_attribute :ends_at, date
      end

      def starts_at= date
        date = DateTime.parse(date, "%b %d, %Y %I:%M %p") if date.is_a?(String) && date.present?
        write_attribute :starts_at, date
      end

      def starts_before_end
        if ends_at && starts_at && starts_at > ends_at
          self.errors.add(:base, "An event's end must come after it's start")
        end
      end

      class << self
        def per_page
          10
        end

        def upcoming
          where('refinery_calendar_events.starts_at >= ?', Time.now)
        end

        def archive
          where('refinery_calendar_events.starts_at < ?', Time.now)
        end
      end
    end
  end
end
