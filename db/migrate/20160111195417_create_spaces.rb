class CreateSpaces < ActiveRecord::Migration
  def change
    create_table :spaces do |t|
      t.string :space_type
      t.string :accomodation_type
      t.string :capacity
      t.string :space_name
      t.text :summary
      t.string :address
      t.float :latitude
      t.float :longitude
      t.boolean :is_air
      t.boolean :is_heating
      t.boolean :is_bar
      t.boolean :is_bathroom
      t.boolean :is_projector
      t.boolean :is_sound_system
      t.boolean :is_stage
      t.boolean :is_stage
      t.boolean :is_podium
      t.boolean :is_wifi
      t.boolean :is_catering
      t.integer :price
      t.boolean :active
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
