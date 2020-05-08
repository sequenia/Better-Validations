module BetterValidations::Validator
  extend ActiveSupport::Concern
  included do
    include ActiveModel::Validations
    include BetterValidations::Object

    # A system accessors required by BetterValidations::Object
    attr_accessor :id, :client_id

    # A validation object as a possible data source
    attr_reader :validation_object

    # A helper method to validate nested object/list
    # represented by other validator.
    #
    # Example of usage in a User model for validating nested PersonalInfo:
    # validate_nested :personal_info, PersonalInfoValidator
    def self.validate_nested(nested_name, validator_class)
      bind_validator(nested_name)
      init_nested_object_setter(nested_name, validator_class)
    end

    # Calls a validates_with method to save information about
    # the validating object to the validator and run validations.
    def self.bind_validator(nested_name)
      validates_with BetterValidations::NestedValidator,
                     attributes: [nested_name]
    end

    # Overriders the setter for nested object in order to create the
    # instance of validator instead of hash/params/ActiveRecord.
    def self.init_nested_object_setter(nested_name, validator_class)
      define_method("#{nested_name}=".to_sym) do |value|
        validator = init_nested_object_validator(validator_class, value)
        instance_variable_set("@#{nested_name}".to_sym, validator)
      end
    end

    # Returns a structure of validators such as:
    # { field: { kind: true }, nested: { field: { kind: true } } }
    # where "kind" is a validator kind such as "presence".
    def self.structure
      validators_by_field_name.reduce({}) do |structure, (field, validator)|
        validations = (structure[field] || {}).merge(validator_hash(validator))
        structure.merge(field => validations)
      end
    end

    # Returns an array:
    # [[:field_one, validator], [:field_two, validator]]
    # fields can duplicate if have multiple validators.
    def self.validators_by_field_name
      validators.map do |validator|
        validator.attributes.map { |attribute| [attribute, validator] }
      end.flatten(1)
    end

    # Returns a hash such as:
    # { kind: true }
    # where "kind" is a validator kind such as "presence".
    def self.validator_hash(validator)
      kind = validator.kind
      kind == :nested ? validator.validator_class.structure : { kind => true }
    end

    # Attributes - Hash, ActionController::Parameters or ActiveRecord::Base
    def initialize(attributes = {})
      assign_attributes(attributes)
    end

    def assign_attributes(attributes)
      prepare_attributes(attributes).each { |key, value| set_value(key, value) }
    end

    def merge(*validators)
      BetterValidations::ValidatorsList.new(*([self] + validators))
    end

    protected

    def prepare_attributes(attributes)
      if attributes.is_a? ActiveRecord::Base
        @validation_object = attributes
        attributes = convert_active_record_to_attributes(attributes)
      end

      attributes
    end

    def convert_active_record_to_attributes(object)
      attribute_names.reduce({}) do |hash, name|
        next hash unless object.respond_to?(name)

        hash.merge(name => object.public_send(name))
      end
    end

    def attribute_names
      (self.class.validators.map(&:attributes).flatten + [:client_id, :id]).uniq
    end

    def set_value(key, value)
      setter = "#{key}=".to_sym
      public_send(setter, value) if respond_to?(setter)
    end

    def init_nested_object_validator(validator_class, value)
      return nil if value.nil?

      # A value can be a single object or a list of objects
      if value.is_a?(Hash) || value.is_a?(ActionController::Parameters)
        validator_class.new(value)
      elsif value.is_a?(Enumerable)
        value.map { |object| validator_class.new(object) }
      else
        validator_class.new(value)
      end
    end
  end
end
