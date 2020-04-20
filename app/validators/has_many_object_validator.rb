class HasManyObjectValidator
  include BetterValidations::Validator

  attr_accessor :attribute_five, :attribute_six

  validates :attribute_five, presence: true, length: { minimum: 1 }
  validates :attribute_six, presence: true
end
