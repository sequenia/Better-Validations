shared_examples 'a model with better nested validations' do
  describe '#valid?' do
    let(:object) { described_class.new(attributes).tap(&:valid?) }

    context 'with invalid belongs_to' do
      let(:attributes) do
        { belongs_to_object_attributes: {} }
      end

      let(:messages) do
        object.belongs_to_object
              .errors
              .messages[:attribute_three]
      end

      let(:detailed_messages) do
        object.errors
              .detailed_messages
              .fetch(:belongs_to_object)
              .fetch(:attribute_three)
      end

      let(:wrapped_detailed_messaged) do
        object.errors
              .detailed_messages(wrap_attributes_to: :fields)
              .fetch(:belongs_to_object)
              .fetch(:fields)
              .fetch(:attribute_three)
      end

      it 'should have details messages' do
        expect(detailed_messages).to_not be_empty
      end

      it 'should have right details messages' do
        expect(detailed_messages).to eq(messages)
      end

      it 'should wrap detailed messages' do
        expect(wrapped_detailed_messaged).to eq(messages)
      end
    end

    context 'with invalid has_many' do
      let(:attributes) do
        { has_many_objects_attributes: [{}] }
      end

      let(:messages) do
        object.has_many_objects
              .first
              .errors
              .messages
              .fetch(:attribute_five)
      end

      let(:detailed_messages) do
        object.errors
              .detailed_messages
              .fetch(:has_many_objects)
              .first
              .fetch(:attribute_five)
      end

      let(:wrapped_detailed_messaged) do
        object.errors
              .detailed_messages(wrap_attributes_to: :fields)
              .fetch(:has_many_objects)
              .first
              .fetch(:fields)
              .fetch(:attribute_five)
      end

      it 'should have detailed messages' do
        expect(detailed_messages).to_not be_empty
      end

      it 'should have right detailed messages' do
        expect(detailed_messages).to eq(messages)
      end

      it 'should wrap detailed messages' do
        expect(wrapped_detailed_messaged).to eq(messages)
      end
    end

    context 'with filled client_id' do
      let(:client_id_one) { 'one' }
      let(:client_id_two) { 'two' }

      let(:object_one_attributes) do
        { client_id: client_id_one,
          attribute_five: 'filled',
          attribute_six: nil }
      end

      let(:object_two_attributes) do
        { client_id: client_id_two,
          attribute_five: nil,
          attribute_six: 'filled' }
      end

      let(:attributes) do
        { has_many_objects_attributes: [object_one_attributes,
                                        object_two_attributes] }
      end

      let(:messages) do
        object.has_many_objects
              .find { |nested| nested.client_id == client_id_one }
              .errors
              .messages
      end

      let(:detailed_messages) do
        object.errors
              .detailed_messages
              .fetch(:has_many_objects)
              .find { |hash| hash[:client_id] == client_id_one }
      end

      it 'should return client_id assigned to the right object' do
        expect(detailed_messages.except(:client_id)).to eq(messages)
      end
    end
  end
end
