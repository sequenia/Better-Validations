RSpec.describe TestObjectValidator, type: :service do
  it_behaves_like 'a model with validations', TestObjectValidator
  it_behaves_like 'a model with nested validations', TestObjectValidator
  it_behaves_like 'a model with better validations', TestObjectValidator
  it_behaves_like 'a model with better nested validations', TestObjectValidator
end
