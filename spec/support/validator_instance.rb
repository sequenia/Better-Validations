shared_examples 'a validator instance' do |params_class:, instantiator: ->(params) { params }|
  let(:attributes) { { attribute_one: 'string' } }
  let(:nested_attributes_with_belongs_to) do
    { belongs_to_object_attributes: { attribute_three: 'string' } }
  end
  let(:nested_attributes_with_has_many) do
    { has_many_objects_attributes: [{ attribute_five: 'string' }] }
  end

  describe '#new' do
    context "with #{params_class.name}" do
      it 'should fill attributes' do
        params = instantiator.call(attributes)
        validator = described_class.new(params)
        expect(validator.attribute_one).to eq(string)
      end

      it 'should convert nested object to validator' do
        params = instantiator.call(nested_attributes_with_belongs_to)
        validator = described_class.new(params)
        expect(validator.belongs_to_object).to be_a(BelongsToObjectValidator)
      end

      it 'should accept nested object' do
        params = instantiator.call(nested_attributes_with_belongs_to)
        validator = described_class.new(params)
        expect(validator.belongs_to_object.attribute_three).to eq(string)
      end

      it 'should convert nested list of objects to validators list' do
        params = instantiator.call(nested_attributes_with_has_many)
        validator = described_class.new(params)
        expect(validator.has_many_objects.first).to be_a(HasManyObjectValidator)
      end

      it 'should accept nested list of objects' do
        params = instantiator.call(nested_attributes_with_has_many)
        validator = described_class.new(params)
        expect(validator.has_many_objects.first.attribute_five).to eq(string)
      end
    end
  end
end
