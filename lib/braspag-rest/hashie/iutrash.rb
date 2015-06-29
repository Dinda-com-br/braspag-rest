module Hashie
  class IUTrash < Hashie::IUDash
    include Hashie::Extensions::Dash::PropertyTranslation

    def inverse_attributes
      {}.tap do |attributes|
        self.class.translations.each do |(from, property)|
          value = self.send(property)
          value = value.respond_to?(:inverse_attributes) ? value.inverse_attributes : value
          
          attributes[from] = value unless value.nil?
        end
      end
    end
  end
end
