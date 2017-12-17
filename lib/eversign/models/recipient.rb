module Eversign
	module Models
		class Recipient
	    attr_accessor :name, :email, :role

	    def initialize(name=nil, email=nil, role=nil)
	    	self.name = name
	    	self.email = email
        self.role = role
	    end
		end
	end
end
