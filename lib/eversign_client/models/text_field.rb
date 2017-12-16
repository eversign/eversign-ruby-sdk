module EversignClient
  module Models
    class TextField
      attr_accessor :identifier, :value

      def initialize(identifier=nil, value=nil)
        self.identifier = identifier
        self.value = value
      end
    end
  end
end
