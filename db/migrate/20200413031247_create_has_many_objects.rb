class CreateHasManyObjects < ActiveRecord::Migration[6.0]
  def change
    create_table :has_many_objects do |t|
      t.integer :test_object_id
      t.string :attribute_five
      t.string :attribute_six

      t.timestamps
    end

    add_index :has_many_objects, :test_object_id
  end
end
