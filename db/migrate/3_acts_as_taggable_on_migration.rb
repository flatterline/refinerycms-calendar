class ActsAsTaggableOnMigration < ActiveRecord::Migration
  def self.up
    create_table :tags do |t|
      t.string :name
    end rescue nil

    create_table :taggings do |t|
      t.references :tag

      # You should make sure that the column created is
      # long enough to store the required class names.
      t.references :taggable, :polymorphic => true
      t.references :tagger, :polymorphic => true

      # Limit is created to prevent MySQL error on index
      # length for MyISAM table type: http://bit.ly/vgW2Ql
      t.string :context, :limit => 128

      t.datetime :created_at
    end rescue nil

    add_index :taggings, :tag_id rescue nil
    add_index :taggings, [:taggable_id, :taggable_type, :context] rescue nil
  end

  def self.down
    drop_table :taggings rescue nil
    drop_table :tags rescue nil
  end
end
