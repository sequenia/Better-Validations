# Better Validations

[![Gem Version](https://badge.fury.io/rb/better_validations.svg)](https://badge.fury.io/rb/better_validations)

Better Validations is an extension for default Rails validations with useful features.

## Table of contents

- [Installation](#installation)
- [Features](#features)
  - [Structured error messages](#structured-error-messages)
  - [Nested validations](#nested-validations)
  - [Merge error messages from multiple validators](#merge-error-messages-from-multiple-validators)
- [Best practices](#best-practices)

## Installation

Add to your Gemfile:

```ruby
gem 'better_validations'
```

Run:

```bash
bundle install
```

## Features

### Structured error messages

Better Validations provides a way to get error messages from an active record keeping structure of nested objects represented by relations such as `belongs_to`, `has_one`, `has_many` instead of a flat structure. Just call:

```ruby
active_record.errors.detailed_messages
```

This calling returns a hash such as:

```ruby
{
  attribute_one: ['Error 1', 'Error 2'],
  attribute_two: ['Error 3'],
  nested_object: {
    attribute_three: ['Error 4']
  },
  nested_objects: [
    {
      attribute_four: ['Error 5']
    }
  ]
}
```

Instead of default `active_record.errors.messages`:

```ruby
{
  attribute_one: ['Error 1', 'Error 2'],
  attribute_two: ['Error 3'],
  'nested_object.attribute_three': ['Error 4'],
  'nested_objects.attribute_four': ['Error 5']
}
```

You can wrap attributes in some key by passing optional `wrap_attributes_to` argument in all levels of nesting:

```ruby
active_record.errors.detailed_messages(
  wrap_attributes_to: :fields
)

{
  fields: {
    attribute_one: ['Error 1', 'Error 2'],
    attribute_two: ['Error 3']
  },
  nested_object: {
    fields: {
      attribute_three: ['Error 4']
    }
  },
  nested_objects: [
    {
      fields: {
        attribute_four: ['Error 5']
      }
    }
  ]
}
```

This is useful if you have validations both on the relation and in the nested object of this relation:

```ruby
# Try to create an object with a nested list where must be at least 2 elements
object = SomeModel.create(nested_objects_attributes: [{ attribute_one: nil }])
object.errors.detailed_messages(wrap_attributes_to: :fields)

{
  fields: {
    nested_objects: ['too few nested objects. Must be at least 2']
  },
  nested_objects: [
    {
      fields: {
        attribute_one: "can't be blank"
      }
    }
  ]
}
```

**Note!** The order of objects in a nested list returned by `detailed_messages` can be different from the order in a passed nested attributes. You can match objects by identifiers or pass a `client_id` attribute for objects that have not yet been created:

```ruby
object.update(nested_objects_attributes: [
  {
    id: 1,
    client_id: 'identifier_one'
    attribute_one: nil,
    attribute_two: 'filled'
  },
  {
    client_id: 'identifier_two',
    attribute_one: 'filled',
    attribute_two: nil
  }
])

object.errors.detailed_messages

{
  nested_objects: [
    {
      {
        id: 1,
        client_id: 'identifier_one'
        attribute_one: ["can't be blank"]
      },
      {
        client_id: 'identifier_two',
        attribute_two: ["can't be blank"]
      }
    }
  ]
}
```

### Nested validations

Better Validation provides the ability to validate nested objects in separated validators with included `ActiveModel::Validations`.

Just include `BetterValidations::Validator` instead of `ActiveModel::Validations` and you will can to validate nested objects with the other validator by calling a `validate_nested` method:

```ruby
class SomeModelValidator
  include BetterValidations::Validator
  attr_accessor :nested_object
  validate_nested :nested_object, NestedObjectValidator
end

class NestedObjectValidator
  include BetterValidations::Validator
  attr_accessor :attribute_one
  validates_presence_of :attribute_one
end

validator = SomeModelValidator.new(nested_object: { attribute_one: nil })
validator.valid? # false
validator.errors.detailed_messages

{ nested_object: { attribute_one: ["can't be blank"] } }
```

You also can validate active record object or `ActionController::Parameters` with nested objects by passing them to the validator:

```ruby
object = SomeModel.new(nested_object: NestedObject.new(attribute_one: nil))
# OR
object = ActionController::Parameters.new(nested_object: { attribute_one: nil })

validator = SomeModelValidator.new(object)
```

### Merge error messages from multiple validators

Better Validations provides the ability to merge validators in order to get merged detailed errors.

Useful when you needs to get errors from multiple validators or if a part of validations implemented inside a model. Usage:

```ruby
validator = validator_one.merge(validator_two, object, ...)
validator.valid?
validator.errors.detailed_messages
```

## Best practices

### Base class for all validators

Create a base `ApplicationValidator` class for all validators in the project. By analogy with `ApplicationRecord` and `ApplicationController`:

```ruby
class ApplicationValidator
  include BetterValidations::Validator
end

class SomeModelValidator < ApplicationValidator
end
```

This will allow you to easily add common functionality to the validators. For example, add automatic  parsing of keys with `_attributes` suffix to validator properties in order to support format of `accepts_nested_attributes_for` parameters:

```ruby
class ApplicationValidator
  include BetterValidations::Validator

  def self.validate_nested(nested_name, validator_class)
    define_attributes_accessor(nested_name)
    bind_validator(nested_name, validator_class)
  end

  def self.define_attributes_accessor(nested_name)
    setter_name = "#{nested_name}_attributes="
    define_method(setter_name) { |value| set_value(nested_name, value) }
  end
end

```

## Development

1. Clone project.

2. Copy `.env.example` file to `.env` file.

3. Feel `.env` file by actual values of DATABASE_USER and DATABASE_PASSWORD.

4. Run `rails db:create` to create a database.

5. Run `rails db:migrate` to run migrations for test models.

6. Run `rspec` to check tests.
