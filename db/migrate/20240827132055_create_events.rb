class CreateEvents < ActiveRecord::Migration[7.2]
  def change
    create_table :events do |t|
      t.timestamps
      t.string :name, null: false
      t.text :description
      t.string :location, null: false
      t.datetime :start_time, null: false
      t.datetime :end_time, null: false
      t.references :user
    end
  end
end
