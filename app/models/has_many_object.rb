class HasManyObject < ApplicationRecord
  belongs_to :test_object

  validates :attribute_five, presence: true, length: { minimum: 3 }
  validates :attribute_six, presence: true
end
