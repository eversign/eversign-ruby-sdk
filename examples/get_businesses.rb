require_relative 'config'

client = Eversign::Client.new
businnesses = client.get_businesses()
p businnesses[0].business_id
