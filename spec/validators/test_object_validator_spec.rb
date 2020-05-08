RSpec.describe TestObjectValidator, type: :validator do
  it_behaves_like 'a model with validations'
  it_behaves_like 'a model with nested validations'
  it_behaves_like 'a model with better validations'
  it_behaves_like 'a model with better nested validations'

  let(:string) { 'string' }
  let(:attributes) { { attribute_one: string } }

  let(:attributes_with_belongs_to) do
    { belongs_to_object: { attribute_three: string } }
  end

  let(:nested_attributes_with_belongs_to) do
    { belongs_to_object_attributes: { attribute_three: string } }
  end

  let(:attributes_with_has_many) do
    { has_many_objects: [{ attribute_five: string }] }
  end

  let(:nested_attributes_with_has_many) do
    { has_many_objects_attributes: [{ attribute_five: string }] }
  end

  context 'when creating from object' do
    it 'should accept object' do
      object = TestObject.new(attributes)
      validator = described_class.new(object)
      expect(validator.attribute_one).to eq(string)
    end

    it 'should convert object to validator' do
      object = TestObject.new(nested_attributes_with_belongs_to)
      validator = described_class.new(object)
      expect(validator.belongs_to_object).to be_a(BelongsToObjectValidator)
    end

    it 'should accept object with nested object' do
      object = TestObject.new(nested_attributes_with_belongs_to)
      validator = described_class.new(object)
      expect(validator.belongs_to_object.attribute_three).to eq(string)
    end

    it 'should convert nested list of objects to validators list' do
      object = TestObject.new(nested_attributes_with_has_many)
      validator = described_class.new(object)
      expect(validator.has_many_objects.first).to be_a(HasManyObjectValidator)
    end

    it 'should accept object with nested list of objects' do
      object = TestObject.new(nested_attributes_with_has_many)
      validator = described_class.new(object)
      expect(validator.has_many_objects.first.attribute_five).to eq(string)
    end
  end

  context 'when creating from hash' do
    it 'should accept attributes' do
      validator = described_class.new(attributes)
      expect(validator.attribute_one).to eq(string)
    end

    it 'should convert nested hash to validator' do
      validator = described_class.new(attributes_with_belongs_to)
      expect(validator.belongs_to_object).to be_a(BelongsToObjectValidator)
    end

    it 'should accept nested hash for single object' do
      validator = described_class.new(attributes_with_belongs_to)
      expect(validator.belongs_to_object.attribute_three).to eq(string)
    end

    it 'should convert nested list of hashes to validators list' do
      validator = described_class.new(attributes_with_has_many)
      expect(validator.has_many_objects.first).to be_a(HasManyObjectValidator)
    end

    it 'should accept nested hash for list' do
      validator = described_class.new(attributes_with_has_many)
      expect(validator.has_many_objects.first.attribute_five).to eq(string)
    end
  end

  context 'when creating from params' do
    it 'should accept params' do
      params = ActionController::Parameters.new(attributes)
      validator = described_class.new(params)
      expect(validator.attribute_one).to eq(string)
    end

    it 'should convert nested params to validator' do
      params = ActionController::Parameters.new(attributes_with_belongs_to)
      validator = described_class.new(params)
      expect(validator.belongs_to_object).to be_a(BelongsToObjectValidator)
    end

    it 'should accept nested params for single object' do
      params = ActionController::Parameters.new(attributes_with_belongs_to)
      validator = described_class.new(params)
      expect(validator.belongs_to_object.attribute_three).to eq(string)
    end

    it 'should convert nested list of params to validators list' do
      params = ActionController::Parameters.new(attributes_with_has_many)
      validator = described_class.new(params)
      expect(validator.has_many_objects.first).to be_a(HasManyObjectValidator)
    end

    it 'should accept nested params for list' do
      params = ActionController::Parameters.new(attributes_with_has_many)
      validator = described_class.new(params)
      expect(validator.has_many_objects.first.attribute_five).to eq(string)
    end
  end

  context 'when filling by accessors' do
    it 'should accept values by setter' do
      validator = described_class.new
      validator.attribute_one = string
      expect(validator.attribute_one).to eq(string)
    end

    it 'should accept nested validator by setter' do
      validator = described_class.new
      belongs_to_object = BelongsToObjectValidator.new(attribute_three: string)
      validator.belongs_to_object = belongs_to_object
      expect(validator.belongs_to_object.attribute_three).to eq(string)
    end

    it 'should accept nested validators list by setter' do
      validator = described_class.new
      has_many_objects = [HasManyObjectValidator.new(attribute_five: string)]
      validator.has_many_objects = has_many_objects
      expect(validator.has_many_objects.first.attribute_five).to eq(string)
    end
  end
end
