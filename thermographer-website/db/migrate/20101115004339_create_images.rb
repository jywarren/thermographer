class CreateImages < ActiveRecord::Migration
  def self.up
    create_table :images do |t|
      t.integer :id
      t.string :name
      t.string :author
      t.text :description
      t.integer :version
      t.text :data
      t.integer :width
      t.integer :height
      t.string :composite

      t.timestamps
    end
  end

  def self.down
    drop_table :images
  end
end
