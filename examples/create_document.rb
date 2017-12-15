require_relative 'config'

document = EversignClient::Models::Document.new
document.title = 'Tile goes here'
document.message = 'tester@gmail.com'

recipient = EversignClient::Models::Recipient.new(name='Test', email='recipient@gmail.com')

file = EversignClient::Models::File.new(name="Test")
file.file_url = 'https://images.pexels.com/photos/34950/pexels-photo.jpg?h=350&dpr=2&auto=compress&cs=tinysrgb'

signer = EversignClient::Models::Signer.new
signer.id="1"
signer.name = "Jane Doe"
signer.email = 'signer@gmail.com'

field = EversignClient::Models::Field.new

field.identifier = "Test"
field.x = "120.43811219947"
field.y = "479.02760463045"
field.page = 1
field.signer = 1
field.width = 120
field.height = 35
field.required = 1

document.add_field(field)
document.add_file(file)
document.add_signer(signer)
document.add_recipient(recipient)

client = EversignClient::Client.new
business =  client.get_buisnesses[0]
p client.create_document(business.business_id, document)
