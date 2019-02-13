class CreateEvent < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.integer :venue_id
      t.integer :attraction_id
      t.string :name
      t.datetime :date
      t.string :url
    end
  end
end
