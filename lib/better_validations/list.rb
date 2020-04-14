module BetterValidations::List
  extend ActiveSupport::Concern
  included do
    # A helper method to get messages from the active record collection
    def detailed_errors_messages(wrap_attributes_to)
      select { |object| object.errors.messages.present? }.map do |object|
        messages = object.detailed_errors_messages(wrap_attributes_to)

        # Add service information about the object in order
        # to distinguish objects in collection from each other

        unless object.id.nil?
          messages = messages.merge(id: object.id)
        end

        unless object.client_id.nil?
          messages = messages.merge(client_id: object.client_id)
        end

        messages
      end
    end
  end
end
