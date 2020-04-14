class CreateBelongsToObjects < ActiveRecord::Migration[6.0]
  def change
    create_table :belongs_to_objects do |t|
      t.string :attribute_three
      t.string :attribute_four

      t.timestamps
    end
  end
end
