require_relative "config"

document_template = Eversign::Models::Template.new
document_template.template_id = Config.configuration.template_id
document_template.title = "Tile goes here"
document_template.message = "my message"

signer = Eversign::Models::Signer.new(
  name = "Jane Doe", email = "signer@gmail.com", role = "Client"
)
document_template.add_signer(signer)
signer = Eversign::Models::Signer.new(
  name = "Jane Doe2", email = "signer2@gmail.com", role = "Partner"
)
document_template.add_signer(signer)

recipient = Eversign::Models::Recipient.new(name = "Test", email = "recipient@gmail.com", role = "Partner")
document_template.add_recipient(recipient)
field = Eversign::Models::Field.new
field.identifier = Config.configuration.template_id
field.value = "Merge Field Content"
document_template.add_field(field)

client = Eversign::Client.new
finished_document = client.create_document_from_template(document_template)
p finished_document


## if we now stdout fields: template.fields.inspect: 

# [[#<Eversign::Models::Field:0x00007fea3882fa30 @identifier="8ee8fb5a995e492ab4c08d1920cbc22b", @value="Merge Field Content">]]

## sounds like what our sdk user means with --->

# I have managed to get my calls to succeed using Postman after the sales team informed me that the fields array 
# should be a single dimensional array rather than the 2d [[field1, field2]] the sdk seems to build. 
# Obviously this isn't that useful as we want to use the SDK!