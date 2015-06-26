module Hashie
  class IUTrash < Hashie::IUDash
    include Hashie::Extensions::Dash::PropertyTranslation

    def inverse_attributes
      self.class.translations.inject({}) do |attributes, (property_from, property_to)|
        value = self.send(property_to)
        attributes[property_from] = value.respond_to?(:inverse_attributes) ? value.inverse_attributes : value
        attributes
      end
    end
  end
end
