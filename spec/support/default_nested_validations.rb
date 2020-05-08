shared_examples 'a default validator with nested' do |validatable_class|
  context 'attributes errors in relations without better_validations' do
    it 'should have presence validation attribute in belongs_to' do
      object = validatable_class.new(belongs_to_attributes).tap(&:valid?)
      expect(object).to error_on(:'belongs_to_object.attribute_three', :blank)
      expect(object.belongs_to_object).to error_on(:attribute_three, :blank)
    end

    it 'should have presence validation attribute in has_many' do
      object = validatable_class.new(has_many_attributes).tap(&:valid?)
      expect(object).to error_on(:'has_many_objects.attribute_five', :blank)
      expect(object.has_many_objects.first).to error_on(:attribute_five, :blank)
    end
  end
end
