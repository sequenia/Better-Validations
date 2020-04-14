class CreateTestObjects < ActiveRecord::Migration[6.0]
  def change
    create_table :test_objects do |t|
      t.string :attribute_one
      t.string :attribute_two
      t.integer :belongs_to_object_id

      t.timestamps
    end

    add_index :test_objects, :belongs_to_object_id
  end
end
