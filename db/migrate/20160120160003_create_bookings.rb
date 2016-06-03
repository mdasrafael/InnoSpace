class CreateBookings < ActiveRecord::Migration
  def change
    create_table :bookings do |t|
      t.references :user, index: true, foreign_key: true
      t.references :space, index: true, foreign_key: true
      t.datetime :start_date
      t.datetime :end_date
      t.integer :price
      t.integer :total
      t.boolean :payment_status
      t.string :payment_method
      t.datetime :confirmed_at
      t.datetime :canceled_at

      t.timestamps null: false
    end
  end
end
