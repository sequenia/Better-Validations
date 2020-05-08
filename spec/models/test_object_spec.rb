RSpec.describe TestObject, type: :model do
  it_behaves_like 'a model with validations'
  it_behaves_like 'a model with nested validations'
  it_behaves_like 'a model with better validations'
  it_behaves_like 'a model with better nested validations'
end
