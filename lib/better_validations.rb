require_relative 'better_validations/railtie'

require_relative 'better_validations/errors'
require_relative 'better_validations/object'
require_relative 'better_validations/list'
require_relative 'better_validations/nested_validator'
require_relative 'better_validations/validator'
require_relative 'better_validations/validators_list'

module BetterValidations
end

ActiveModel::Errors.include BetterValidations::Errors
ActiveRecord::Base.include BetterValidations::Object
ActiveRecord::Associations::CollectionProxy.include BetterValidations::List
Array.include BetterValidations::List
