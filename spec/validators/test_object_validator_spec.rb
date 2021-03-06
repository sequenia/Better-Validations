RSpec.describe TestObjectValidator, type: :validator do
  it_behaves_like 'a model with validations'
  it_behaves_like 'a model with nested validations'
  it_behaves_like 'a model with better validations', attribute: :attribute_one
  it_behaves_like 'a model with better validations', attribute: :attribute_two
  it_behaves_like 'a model with better nested validations'

  it_behaves_like 'a validator instance', params_class: TestObject
  it_behaves_like 'a validator instance',
                  params_class: Hash,
                  instantiator: ->(params) { params }
  it_behaves_like 'a validator instance',
                  params_class: ActionController::Parameters,
                  instantiator: ->(params) do
                    ActionController::Parameters.new(params)
                  end

  let(:string) { 'string' }

  describe '#new' do
    context 'when filling by accessors' do
      it 'should accept values by setter' do
        validator = described_class.new
        validator.attribute_one = string
        expect(validator.attribute_one).to eq(string)
      end

      it 'should accept nested validator by setter' do
        validator = described_class.new
        belongs_to_object = BelongsToObjectValidator.new(
          attribute_three: string
        )
        validator.belongs_to_object = belongs_to_object
        expect(validator.belongs_to_object.attribute_three).to eq(string)
      end

      it 'should accept nested validators list by setter' do
        validator = described_class.new
        has_many_objects = [HasManyObjectValidator.new(attribute_five: string)]
        validator.has_many_objects = has_many_objects
        expect(validator.has_many_objects.first.attribute_five).to eq(string)
      end

      it 'should accept nested object without _attributes suffix' do
        attributes = { belongs_to_object: { attribute_three: string } }
        validator = described_class.new(attributes)
        expect(validator.belongs_to_object.attribute_three).to eq(string)
      end

      it 'shoud accept nested list without _attributes prefix' do
        attributes = { has_many_objects: [{ attribute_five: string }] }
        validator = described_class.new(attributes)
        expect(validator.has_many_objects.first.attribute_five).to eq(string)
      end
    end
  end
end
