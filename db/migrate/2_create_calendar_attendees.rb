class CreateCalendarAttendees < ActiveRecord::Migration

  def up
    create_table :refinery_calendar_attendees do |t|
      t.belongs_to :event, :user
      t.string     :name, :email, :company_name, :phone, :address
      t.text       :message
      t.integer    :number_attending, default: 1

      t.timestamps
    end

  end

  def down
    drop_table :refinery_calendar_attendees
  end

end
