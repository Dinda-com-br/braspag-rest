module Hashie
  class IUTrash < Hashie::IUDash
    include Hashie::Extensions::Dash::PropertyTranslation

    def self.build(attributes)
      new.tap do |object|
        inverse_translations.each do |property, from|
          translations_hash[from].each do |name, with|
            value = with.respond_to?(:call) ? with.call(attributes[name]) : attributes[name]
            object.send("#{name}=", value) if property?(name)
          end
        end
      end
    end

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
