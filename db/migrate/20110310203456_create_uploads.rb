class CreateUploads < ActiveRecord::Migration
  def self.up
    create_table :uploads do |t|
      t.string :uuid
      t.string :path
      t.string :comment

      t.timestamps
    end
  end

  def self.down
    drop_table :uploads
  end
end
