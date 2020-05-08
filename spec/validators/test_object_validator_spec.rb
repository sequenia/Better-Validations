RSpec.describe TestObjectValidator, type: :validator do
  it_behaves_like 'a model with validations'
  it_behaves_like 'a model with nested validations'
  it_behaves_like 'a model with better validations'
  it_behaves_like 'a model with better nested validations'
end
