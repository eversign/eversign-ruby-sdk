require 'kartograph'
#require_relative '../models/document'

module Eversign
	module Mappings
		class Error
			include Kartograph::DSL

			kartograph do
		    mapping Eversign::Models::Error

		    property :code, :type, :info
		  end
		end

		class Exception
			include Kartograph::DSL

			kartograph do
		    mapping Eversign::Models::Exception

		    property :success
		    property :error, include: Error
		  end
		end
	end
end
