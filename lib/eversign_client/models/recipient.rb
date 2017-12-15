module EversignClient
	module Models
		class Recipient
	    attr_accessor :name, :email

	    def initialize(name=nil, email=nil)
	    	self.name = name
	    	self.email = email
	    end
		end
	end
end