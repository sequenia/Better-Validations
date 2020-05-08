RSpec.describe TestObject, type: :model do
  it_behaves_like 'a model with validations', TestObject
  it_behaves_like 'a model with nested validations', TestObject
  it_behaves_like 'a model with better validations', TestObject
  it_behaves_like 'a model with better nested validations', TestObject
end
