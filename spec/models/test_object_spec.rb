RSpec.describe TestObject, type: :model do
  let(:belongs_to_attributes) do
    { belongs_to_object_attributes: { attribute_three: nil,
                                      attribute_four: nil } }
  end

  let(:has_many_attributes) do
    { has_many_objects_attributes: [{ attribute_five: nil,
                                      attribute_six: nil }] }
  end

  it_behaves_like 'a default attribute validator', TestObject
  it_behaves_like 'a better attribute validator', TestObject

  context 'attributes errors in relations without better_validations' do
    it 'should have presence validation attribute in belongs_to' do
      object = TestObject.new(belongs_to_attributes).tap(&:valid?)
      expect(object).to error_on(:'belongs_to_object.attribute_three', :blank)
      expect(object.belongs_to_object).to error_on(:attribute_three, :blank)
    end

    it 'should have presence validation attribute in has_many' do
      object = TestObject.new(has_many_attributes).tap(&:valid?)
      expect(object).to error_on(:'has_many_objects.attribute_five', :blank)
      expect(object.has_many_objects.first).to error_on(:attribute_five, :blank)
    end
  end

  context 'with better_validations on relations attributes' do
    it 'should have nested detailed_messages equals to messages from belongs_to' do
      object = TestObject.create(belongs_to_attributes)

      expect(
        object.errors.detailed_messages[:belongs_to_object]
      ).to has_same_field_messages(
        :attribute_three,
        object.belongs_to_object.errors.messages
      )
    end

    it 'should have nested detailed_messages equals to messages from has_many' do
      object = TestObject.create(has_many_attributes)

      expect(
        object.errors.detailed_messages[:has_many_objects].first
      ).to has_same_field_messages(
        :attribute_five,
        object.has_many_objects.first.errors.messages
      )
    end
  end

  context 'with wrapped attributes in detailed_messages for relations' do
    it 'should return wrapped attributes from detailed_message for belongs_to attribute' do
      object = TestObject.create(belongs_to_attributes)
      wrapper = :fields

      expect(
        object.errors.detailed_messages(
          wrap_attributes_to: wrapper
        )[:belongs_to_object][wrapper]
      ).to has_same_field_messages(
        :attribute_three,
        object.belongs_to_object.errors.messages
      )
    end

    it 'should return wrapped attributes from detailed_message for has_many attribute' do
      object = TestObject.create(has_many_attributes)
      wrapper = :fields

      expect(
        object.errors.detailed_messages(
          wrap_attributes_to: wrapper
        )[:has_many_objects].first[wrapper]
      ).to has_same_field_messages(
        :attribute_five,
        object.has_many_objects.first.errors.messages
      )
    end
  end

  context 'with client_id passed' do
    it 'should return passed client_id in detailed messages assigned to right object' do
      object = TestObject.create(
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
      )

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
