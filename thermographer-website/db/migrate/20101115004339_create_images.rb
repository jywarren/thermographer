class CreateImages < ActiveRecord::Migration
  def self.up
    create_table :images do |t|
      t.integer :id
      t.string :name
      t.string :author
      t.text :description
      t.integer :version, :default => 0
      t.text :data
      t.integer :width
      t.integer :height
      t.string :composite
      t.string :photo_file_name
      t.string :photo_content_type
      t.string :photo_file_size

      t.timestamps
    end
  end

  def self.down
    drop_table :images
  end
end
