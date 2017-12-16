module Eversign
	module Models
		class File
	    attr_accessor :name, :file_id, :file_url, :file_base64, :pages, :total_pages

	    def initialize(name=nil)
	    	self.name = name
	    end
		end
	end
end
