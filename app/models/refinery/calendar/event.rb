module Refinery
  module Calendar
    class Event < Refinery::Core::BaseModel
      extend FriendlyId

      friendly_id :title, :use => :slugged

      # belongs_to :venue
      belongs_to :world_trade_center

      validates :title, :presence => true, :uniqueness => true
      validates :from, :presence => true
      validates :to, :presence => true
      validate :to_after_from

      attr_accessible :title, :from, :to, :registration_link,
                      :venue_id, :excerpt, :description,
                      :featured, :position, :world_trade_center_id, :venue

      # delegate :name, :address,
      #           :to => :venue,
      #           :prefix => true,
      #           :allow_nil => true

      def to=(date)
        if date.is_a? String # Apr 24, 2013 12:00 am
          write_attribute(:to, DateTime.parse(date, "%b %d, %Y %I:%M %p") )
        else
          write_attribute(:to, date)
        end
      end

      def from=(date)
        if date.is_a? String
          write_attribute(:from, DateTime.parse(date, "%b %d, %Y %I:%M %p") )
        else
          write_attribute(:from, date)
        end
      end

      def to_after_from
        if to && from && to < from
          self.errors.add(:base, "An event's end must come after it's start")
        end
      end

      class << self
        def upcoming
          where('refinery_calendar_events.from >= ?', Time.now)
        end

        def featured
          where(:featured => true)
        end

        def archive
          where('refinery_calendar_events.from < ?', Time.now)
        end
      end
    end
  end
end
