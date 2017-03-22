class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.string :name
      t.datetime :start_at
      t.datetime :end_at
      t.text :options

      t.timestamps
    end
  end
end
