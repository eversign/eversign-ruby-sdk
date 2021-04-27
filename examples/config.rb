require 'dotenv/load'
require_relative '../lib/eversign-sdk'
require 'configurations'

module Config
  include Configurations
  configurable String, :document_hash
  configurable String, :template_id
  configurable String, :signer_email
  configurable String, :field_identifier
  configurable String, :oauth_client_id
  configurable String, :oauth_client_secret
  configurable String, :code
  configurable String, :state
end


Eversign.configure do |c|
  c.api_base = ENV['API_BASE']
  c.access_key = ENV['ACCESS_KEY']
  c.business_id = ENV['BUSINESS_ID'].to_i
end

Config.configure do |c|
  c.document_hash = 'xxx'
  c.signer_email = 'test@example.com'
  c.template_id = ENV['TEMPLATE_ID']
  c.field_identifier = ENV['FIELD_ID']
  c.oauth_client_id = 'xxx'
  oauth_client_secret = 'xxx'
  code = ''
  state = ''
end
