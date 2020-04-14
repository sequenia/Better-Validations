require 'rspec/expectations'

module ValidationHelper
  RSpec::Matchers.define :error_on do |field, error|
    match do |object|
      details = object.errors.details[field]

      if error.is_a? Symbol
        details.any? { |hash| hash[:error] == error }
      else
        details.any?(error)
      end
    end

    failure_message do |object|
      field, error = expected
      "expected that #{object} would has an error '#{error}' in a field '#{field}'"
    end
  end

  RSpec::Matchers.define :has_same_field_messages do |field, messages|
    match do |detailed_messages|
      field_messages = messages[field]
      field_detailed_messages = detailed_messages[field]

      field_messages.present? &&
        field_messages.to_set == field_detailed_messages.to_set
    end

    failure_message do |detailed_messages|
      field, messages = expected

      if messages.blank?
        "expected that messages for field '#{field}' would present"
      else
        "expected that detailed messages '#{detailed_messages}' " \
        "would has the same messages with '#{messages}' " \
        "in field '#{field}'"
      end
    end
  end
end
