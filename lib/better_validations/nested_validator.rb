class BetterValidations::NestedValidator < ActiveModel::EachValidator
  def validate_each(record, attr_name, value)
    return if value.nil?

    validator = value
    return if validator_valid?(validator)

    record.errors.add(error_key(attr_name), error_text)
  end

  protected

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
