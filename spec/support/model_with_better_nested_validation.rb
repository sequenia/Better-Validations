shared_examples 'a model with better nested validations' do
  describe '#valid?' do
    context 'when validating nested objects' do
      it 'should have nested detailed messages in belongs_to' do
        attributes = { belongs_to_object_attributes: {} }
        object = described_class.new(attributes).tap(&:valid?)

        belongs_to_messages = object.belongs_to_object.errors.messages
        belongs_to_detailed_messages =
          object.errors
                .detailed_messages[:belongs_to_object]

        expect(belongs_to_detailed_messages).to has_same_field_messages(
          :attribute_three,
          belongs_to_messages
        )
      end

      it 'should have nested detailed messages in has_many' do
        attributes = { has_many_objects_attributes: [{}] }
        object = described_class.new(attributes).tap(&:valid?)

        has_many_messages = object.has_many_objects.first.errors.messages
        has_many_detailed_messages =
          object.errors
                .detailed_messages[:has_many_objects]
                .first

        expect(has_many_detailed_messages).to has_same_field_messages(
          :attribute_five,
          has_many_messages
        )
      end

      it 'should wrap attributes in detailed messages for belongs_to' do
        attributes = { belongs_to_object_attributes: {} }
        object = described_class.new(attributes).tap(&:valid?)

        belongs_to_messages = object.belongs_to_object.errors.messages
        belongs_to_detailed_messages =
          object.errors
                .detailed_messages(wrap_attributes_to: :fields)
                .public_send(:[], :belongs_to_object)
                .public_send(:[], :fields)

        expect(belongs_to_detailed_messages).to has_same_field_messages(
          :attribute_three,
          belongs_to_messages
        )
      end

      it 'should wrap attributes in detailed messages for has_many' do
        attributes = { has_many_objects_attributes: [{}] }
        object = described_class.new(attributes).tap(&:valid?)

        has_many_messages = object.has_many_objects.first.errors.messages
        has_many_detailed_messages =
          object.errors
                .detailed_messages(wrap_attributes_to: :fields)
                .public_send(:[], :has_many_objects)
                .first[:fields]

        expect(has_many_detailed_messages).to has_same_field_messages(
          :attribute_five,
          has_many_messages
        )
      end

      it 'should return client_id assigned to the right object' do
        attributes = {
          has_many_objects_attributes: [
            {
              client_id: 'one',
              attribute_five: 'filled',
              attribute_six: nil
            },
            {
              client_id: 'two',
              attribute_five: nil,
              attribute_six: 'filled'
            }
          ]
        }

        object = described_class.new(attributes).tap(&:valid?)
        detailed_messages = object.errors
                                  .detailed_messages[:has_many_objects]
                                  .find { |hash| hash[:client_id] == 'one' }
        messages = object.has_many_objects
                         .find { |nested| nested.client_id == 'one' }
                         .errors
                         .messages

        expect(detailed_messages.except(:client_id)).to eq(messages)
      end
    end
  end
end
