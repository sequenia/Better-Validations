class BelongsToObjectValidator
  include BetterValidations::Validator

  attr_accessor :attribute_three, :attribute_four

  validates :attribute_three, presence: true, length: { minimum: 2 }
  validates :attribute_four, presence: true
end
