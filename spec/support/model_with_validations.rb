shared_examples 'a model with validations' do
  context 'when validating attributes' do
    it "should have presence validation on 'attribute_one'" do
      object = described_class.new(attribute_one: nil).tap(&:valid?)
      expect(object).to error_on(:attribute_one, :blank)
    end

    it "should have length validation on 'attribute_one'" do
      object = described_class.new(attribute_one: '').tap(&:valid?)
      expect(object).to error_on(:attribute_one, error: :too_short, count: 1)
    end

    it "should have presence validation on 'attribute_two'" do
      object = described_class.new(attribute_two: nil).tap(&:valid?)
      expect(object).to error_on(:attribute_two, :blank)
    end
  end
end
