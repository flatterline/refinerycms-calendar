class CreateCalendarEvents < ActiveRecord::Migration

  def up
    create_table :refinery_calendar_events do |t|
      t.belongs_to :organizer
      t.string     :title, :venue, :slug
      t.text       :description
      t.datetime   :ends_at, :starts_at

      t.timestamps
    end

  end

  def down
    if defined?(::Refinery::UserPlugin)
      ::Refinery::UserPlugin.destroy_all({:name => "refinerycms-calendar"})
    end

    if defined?(::Refinery::Page)
      ::Refinery::Page.delete_all({:link_url => "/calendar/events"})
    end

    drop_table :refinery_calendar_events
  end

end
