require 'eversign'

Eversign.configure do |c|
  c.api_base = 'https://api.eversign.com/api'
  c.access_key = '<YOUR_ACCESS_KEY>'
end

