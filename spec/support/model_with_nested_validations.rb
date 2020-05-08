shared_examples 'a model with nested validations' do |validatable_class|
  context 'when validating nested objects' do
    it 'should have presence validation in belongs_to object' do
      object = validatable_class.new(belongs_to_object_attributes: {})
                                .tap(&:valid?)
      expect(object).to error_on(:'belongs_to_object.attribute_three', :blank)
      expect(object.belongs_to_object).to error_on(:attribute_three, :blank)
    end

    it 'should have presence validation in has_many objects' do
      object = validatable_class.new(has_many_objects_attributes: [{}])
                                .tap(&:valid?)
      expect(object).to error_on(:'has_many_objects.attribute_five', :blank)
      expect(object.has_many_objects.first).to error_on(:attribute_five, :blank)
    end
  end
end
