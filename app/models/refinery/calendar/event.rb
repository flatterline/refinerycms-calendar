module Refinery
  module Calendar
    class Event < Refinery::Core::BaseModel
      extend FriendlyId
      friendly_id :title, use: :slugged

      acts_as_indexed :fields => [:title, :description, :venue]
      acts_as_taggable_on :categories

      belongs_to :organizer, class_name: 'Refinery::User'
      has_many   :attendees

      validates :title, presence: true, uniqueness: true
      validates :ends_at, :organizer_id, :starts_at, presence: true
      validate  :validates_start_before_end, :validates_categories

      attr_accessible :category_list, :description, :ends_at, :organizer, :organizer_id, :starts_at, :title, :venue, :is_private

      scope :is_private, where(is_private: true)
      scope :is_public,  where(is_private: false)

      class << self
        def archive
          where('refinery_calendar_events.starts_at < ?', Time.now)
        end

        def default_categories
          %w(conference workshop networking trade_mission trade_show)
        end

        def per_page
          10
        end

        def upcoming
          where('refinery_calendar_events.starts_at >= ?', Time.now).order("refinery_calendar_events.starts_at ASC")
        end
      end

      def attendees_count
        self.attendees.sum(&:number_attending)
      end

      def duration
        seconds = (self.ends_at - self.starts_at).abs

        hours, minutes_as_seconds = seconds.divmod(3600)
        minutes = minutes_as_seconds / 60

        [hours, minutes]
      end

      def ends_at= date
        date = DateTime.parse(date, "%b %d, %Y %I:%M %p") if date.is_a?(String) && date.present?
        write_attribute :ends_at, date
      end

      def starts_at= date
        date = DateTime.parse(date, "%b %d, %Y %I:%M %p") if date.is_a?(String) && date.present?
        write_attribute :starts_at, date
      end

    private

      def validates_categories
        if self.category_list.present?
          if (invalid_categories = category_list - self.class.default_categories)
            invalid_categories.each do |category|
              errors.add(:category_list, category + ' is not a valid category')
            end
          end
        end
      end

      def validates_start_before_end
        if ends_at && starts_at && starts_at > ends_at
          self.errors.add(:base, "An event's end must come after it's start")
        end
      end

    end
  end
end
