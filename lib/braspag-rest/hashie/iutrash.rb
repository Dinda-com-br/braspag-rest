module Hashie
  class IUTrash < Hashie::IUDash
    include Hashie::Extensions::Dash::PropertyTranslation

    def inverse_attributes
      {}.tap do |attributes|
        self.class.translations.each do |(from, property)|
          value = self.send(property)
          attributes[from] = value.respond_to?(:inverse_attributes) ? value.inverse_attributes : value
        end
      end
    end
  end
end
