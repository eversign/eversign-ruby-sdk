require 'eversign'

Eversign.configure do |c|
  c.api_base = 'https://api.eversign.com/api'
  c.access_key = '<ACCESS_KEY>'
  c.business_id = 12345
end

