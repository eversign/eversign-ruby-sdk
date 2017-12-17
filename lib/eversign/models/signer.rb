module Eversign
	module Models
		class Signer
	    attr_accessor :id, :name, :email, :order, :pin, :message, :deliver_email, :role  

      def initialize(name=nil, email=nil, role=nil)
        self.name = name
        self.email = email
        self.role = role
      end
		end
	end
end
