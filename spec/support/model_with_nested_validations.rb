shared_examples 'a model with nested validations' do
  describe '#valid?' do
    let(:object) { described_class.new(attributes).tap(&:valid?) }

    context 'with invalid belongs_to' do
      let(:attributes) do
        { belongs_to_object_attributes: {} }
      end

      it 'should have presence validation' do
        expect(object).to error_on(:'belongs_to_object.attribute_three', :blank)
      end

      it 'should have nested presence validation' do
        expect(object.belongs_to_object).to error_on(:attribute_three, :blank)
      end
    end

    context 'with invalid has_many' do
      let(:attributes) do
        { has_many_objects_attributes: [{}] }
      end

      it 'should have presence validation' do
        expect(object).to error_on(:'has_many_objects.attribute_five', :blank)
      end

      it 'should have nested presence validation' do
        expect(object.has_many_objects.first).to error_on(
          :attribute_five,
          :blank
        )
      end
    end
  end
end
