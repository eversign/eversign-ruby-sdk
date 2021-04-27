require 'eversign/version'
require 'configurations'
require 'addressable/uri'
require_relative 'eversign/client'
require_relative 'eversign/models/business'
require_relative 'eversign/models/file'
require_relative 'eversign/models/field'
require_relative 'eversign/models/signer'
require_relative 'eversign/models/recipient'
require_relative 'eversign/models/document'
require_relative 'eversign/models/template'
require_relative 'eversign/models/error'
require_relative 'eversign/models/exception'
require_relative 'eversign/mappings/business'
require_relative 'eversign/mappings/file'
require_relative 'eversign/mappings/document'
require_relative 'eversign/mappings/exception'

module Eversign
	include Configurations
	configurable String, :access_key
	configurable Integer, :business_id
	configurable String, :oauth_base
	configurable String, :api_base do |value|
		value ||= 'https://api.eversign.com'
		parsed = Addressable::URI.parse(value)
  	if %w(http https).include?(parsed.scheme)
  		value
		else
			raise ArgumentError 'Invalid API Base URL' 
		end
	end
end
