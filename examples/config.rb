require 'eversign'
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
  c.api_base = 'https://api.eversign.com/api'
  c.access_key = '<ACCESS_KEY>'
  c.business_id = 1234
end

Config.configure do |c|
  c.document_hash = 'xxx'
  c.signer_email = 'test@example.com'
  c.template_id = 'xxxx'
  c.field_identifier = 'xxx'
  c.oauth_client_id = 'xxx'
  oauth_client_secret = 'xxx'
  code = ''
  state = ''
end
