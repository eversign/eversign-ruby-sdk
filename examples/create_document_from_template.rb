require_relative "config"

document_template = Eversign::Models::Template.new
document_template.template_id = Config.configuration.template_id
document_template.title = "Tile goes here"
document_template.message = "my message"

# existing template should have this 2 signer types (Client and Partner)
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
field.identifier = Config.configuration.field_identifier # should be id of existing field in this template
field.value = "Merge Field Content"

document_template.add_field(field)

client = Eversign::Client.new
finished_document = client.create_document_from_template(document_template)
p finished_document