require_relative 'config'

client = Eversign::Client.new

documents = client.get_all_documents()

# documents.first is actually last added document
document = documents.first

client.download_raw_document_to_path(document.document_hash, 'raw.pdf')
client.download_final_document_to_path(document.document_hash, 'final.pdf')