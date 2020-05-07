RSpec.describe TestObjectValidator, type: :service do
  let(:belongs_to_attributes) do
    { belongs_to_object_attributes: { attribute_three: nil,
                                      attribute_four: nil } }
  end

  let(:has_many_attributes) do
    { has_many_objects_attributes: [{ attribute_five: nil,
                                      attribute_six: nil }] }
  end

  it_behaves_like 'a default attribute validator', TestObjectValidator
  it_behaves_like 'a better attribute validator', TestObjectValidator
end
