class TestObjectValidator
  include BetterValidations::Validator

  attr_accessor :attribute_one, :attribute_two
  attr_accessor :belongs_to_object, :has_many_objects

  validates :attribute_one, presence: true, length: { minimum: 1 }
  validates :attribute_two, presence: true

  validate_nested :belongs_to_object, BelongsToObjectValidator
  validate_nested :has_many_objects, HasManyObjectValidator
end
