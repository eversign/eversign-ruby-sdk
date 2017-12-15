require 'eversign_client/version'
require 'configurations'
require 'addressable/uri'
require_relative 'eversign_client/client'
require_relative 'eversign_client/models/business'
require_relative 'eversign_client/models/file'
require_relative 'eversign_client/models/field'
require_relative 'eversign_client/models/signer'
require_relative 'eversign_client/models/recipient'
require_relative 'eversign_client/models/document'
require_relative 'eversign_client/models/error'
require_relative 'eversign_client/models/exception'
require_relative 'eversign_client/mappings/business'
require_relative 'eversign_client/mappings/file'
require_relative 'eversign_client/mappings/document'
require_relative 'eversign_client/mappings/exception'

module EversignClient
	include Configurations
	configurable String, :access_key
	configurable String, :api_base do |value|
		parsed = Addressable::URI.parse(value)
  	if %w(http https).include?(parsed.scheme)
  		value
		else
			raise ArgumentError 'Invalid API Base URL' 
		end
	end
end
