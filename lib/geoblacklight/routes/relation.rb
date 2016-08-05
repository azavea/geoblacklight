module Geoblacklight
  module Routes
    class Relation

      def initialize(defaults = {})
        @defaults = defaults
      end

      def call(mapper, _options = {})
        mapper.get '/catalog/:id/ancestors', action: 'ancestors', as: :ancestor
        mapper.get '/catalog/:id/descendants', action: 'descendants', as: :descendant
      end
    end
  end
end