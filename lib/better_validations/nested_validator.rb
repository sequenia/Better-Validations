class BetterValidations::NestedValidator < ActiveModel::EachValidator
  attr_reader :validator_class

  def initialize(options)
    @validator_class = options.delete(:validator_class)
    super
  end

  def validate_each(record, attr_name, value)
    return if value.nil?

    validator = init_validator(value)
    cache_validator(record, attr_name, validator)
    return if validator_valid?(validator)

    record.errors.add(error_key(attr_name), error_text)
  end

  protected

  def init_validator(value)
    # A value can be a single object or a list of objects
    if value.is_a?(Enumerable)
      value.map { |object| validator_class.new(object) }
    else
      validator_class.new(value)
    end
  end

  def cache_validator(record, attr_name, validator)
    record.nested_object_validators[attr_name.to_sym] = validator
  end

  def validator_valid?(validator)
    validators = validator.is_a?(Enumerable) ? validator : [validator]
    validators.map(&:valid?).all?
  end

  def error_key(attr_name)
    # Create a key with a dot to tell a framework that an error happened in
    # a nested object
    "#{attr_name}.attributes".to_sym
  end

  def error_text
    I18n.t('errors.messages.invalid')
  end
end
