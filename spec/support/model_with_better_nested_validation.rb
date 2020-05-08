shared_examples 'a model with better nested validations' do |validatable_class|
  context 'when validating nested objects' do
    it 'should have nested detailed_messages equals to messages from belongs_to' do
      object = validatable_class.new(belongs_to_object_attributes: {})
                                .tap(&:valid?)

      messages = object.belongs_to_object.errors.messages
      detailed_messages = object.errors.detailed_messages[:belongs_to_object]

      expect(detailed_messages).to has_same_field_messages(:attribute_three,
                                                           messages)
    end

    it 'should have nested detailed_messages equals to messages from has_many' do
      object = validatable_class.new(has_many_objects_attributes: [{}])
                                .tap(&:valid?)

      messages = object.has_many_objects.first.errors.messages
      detailed_messages = object.errors
                                .detailed_messages[:has_many_objects]
                                .first

      expect(detailed_messages).to has_same_field_messages(:attribute_five,
                                                           messages)
    end

    it 'should return wrapped attributes from detailed_message for belongs_to attribute' do
      object = validatable_class.new(belongs_to_object_attributes: {})
                                .tap(&:valid?)

      messages = object.belongs_to_object.errors.messages
      detailed_messages = object.errors.detailed_messages(
        wrap_attributes_to: :fields
      )[:belongs_to_object][:fields]

      expect(detailed_messages).to has_same_field_messages(:attribute_three,
                                                           messages)
    end

    it 'should return wrapped attributes from detailed_message for has_many attribute' do
      object = validatable_class.new(has_many_objects_attributes: [{}])
                                .tap(&:valid?)

      messages = object.has_many_objects.first.errors.messages
      detailed_messages = object.errors.detailed_messages(
        wrap_attributes_to: :fields
      )[:has_many_objects].first[:fields]

      expect(detailed_messages).to has_same_field_messages(:attribute_five,
                                                           messages)
    end

    it 'should return passed client_id in detailed messages assigned to right object' do
      object = validatable_class.new(
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
      ).tap(&:valid?)

      detailed_messages = object.errors
                                .detailed_messages[:has_many_objects]
                                .find { |hash| hash[:client_id] == 'one' }

      messages =
        object.has_many_objects
              .find { |has_many_object| has_many_object.client_id == 'one' }
              .errors
              .messages

      expect(detailed_messages.except(:client_id)).to eq(messages)
    end
  end
end
