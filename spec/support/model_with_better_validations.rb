shared_examples 'a model with better validations' do |attribute:|
  describe '#valid?' do
    let(:object) { described_class.new(attributes).tap(&:valid?) }

    context "with invalid attribute #{attribute}" do
      let(:attributes) do
        { attribute => nil }
      end

      let(:messages) do
        object.errors.messages.fetch(attribute)
      end

      let(:detailed_messages) do
        object.errors.detailed_messages.fetch(attribute)
      end

      let(:wrapped_detailed_messages) do
        object.errors
              .detailed_messages(wrap_attributes_to: :fields)
              .fetch(:fields)
              .fetch(attribute)
      end

      it 'should have detailed messages' do
        expect(detailed_messages).to_not be_empty
      end

      it 'should have right detailed messages' do
        expect(detailed_messages).to eq(messages)
      end

      it 'should wrap detailed messages' do
        expect(wrapped_detailed_messages).to eq(messages)
      end
    end
  end
end
