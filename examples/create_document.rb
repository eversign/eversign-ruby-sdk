require_relative 'config'

document = Eversign::Models::Document.new
document.title = 'Tile goes here'
document.message = 'tester@gmail.com'
document.sandbox = 1 #enable or disable sandbox mode  
document.use_hidden_tags = 1

recipient = Eversign::Models::Recipient.new(name='Test', email='recipient@gmail.com')

file = Eversign::Models::File.new(name="Test")
file.file_url = 'pic.jpg'

signer = Eversign::Models::Signer.new
signer.id="1"
signer.name = "Jane Doe"
signer.email = 'signer@gmail.com'

field = Eversign::Models::Field.new

field.identifier = "Test"
field.x = "120.43811219947"
field.y = "479.02760463045"
field.page = 1
field.signer = 1
field.width = 120
field.height = 35
field.required = 1
field.readonly = 1
field.merge = 0
field.type = 'signature'

document.add_field(field)
document.add_file(file)
document.add_signer(signer)
document.add_recipient(recipient)
recipient = Eversign::Models::Recipient.new(name='Test2', email='recipient2@gmail.com')
document.add_recipient(recipient)

client = Eversign::Client.new
p client.create_document(document)
