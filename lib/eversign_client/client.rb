require 'addressable/template'
require 'faraday'
require 'json'

module EversignClient
	class Client
		attr_accessor :access_key
		BUSINESS_PATH = 'https://api.eversign.com/api/business{?access_key}'
		
		def initialize(access_key)
			self.access_key = access_key
		end


		def list_buisnesses
	  	template = Addressable::Template.new(BUSINESS_PATH)
	  	response = Faraday.get template.partial_expand({access_key: access_key}).pattern
			JSON.parse(response.body)[0]
		end
	end
end