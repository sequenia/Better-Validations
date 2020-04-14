class BelongsToObject < ApplicationRecord
  has_one :test_object, dependent: :nullify

  validates :attribute_three, presence: true, length: { minimum: 1 }
  validates :attribute_four, presence: true
end
