shared_examples 'a default attribute validator' do |validatable_class|
  context 'attributes errors without better_validations' do
    it 'should have presence validation on attribute' do
      object = validatable_class.new(attribute_one: nil).tap(&:valid?)
      expect(object).to error_on(:attribute_one, :blank)
    end

    it 'should have some another validation on attribute' do
      object = validatable_class.new(attribute_one: '').tap(&:valid?)
      expect(object).to error_on(:attribute_one, error: :too_short, count: 1)
    end

    it 'should have some validator on another attribute' do
      object = validatable_class.new(attribute_two: nil).tap(&:valid?)
      expect(object).to error_on(:attribute_two, :blank)
    end
  end
end
