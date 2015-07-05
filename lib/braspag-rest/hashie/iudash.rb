require 'hashie/extensions/ignore_undeclared'

module Hashie
  class IUDash < Hashie::Dash
    include Hashie::Extensions::IgnoreUndeclared
  end
end
