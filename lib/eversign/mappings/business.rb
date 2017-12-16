require 'kartograph'
require_relative '../models/business'

module Eversign
	module Mappings
		class Business
			include Kartograph::DSL

			kartograph do
		    mapping Eversign::Models::Business

		    property :business_id, :business_status, :business_identifier, :business_name, :creation_time_stamp, :is_primary
		  end
		end
	end
end
