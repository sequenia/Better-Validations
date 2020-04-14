class TestObject < ApplicationRecord
  belongs_to :belongs_to_object, dependent: :destroy, optional: true
  has_many :has_many_objects, dependent: :destroy

  accepts_nested_attributes_for :belongs_to_object, update_only: true
  accepts_nested_attributes_for :has_many_objects, allow_destroy: true

  validates :attribute_one, presence: true, length: { minimum: 1 }
  validates :attribute_two, presence: true
end
