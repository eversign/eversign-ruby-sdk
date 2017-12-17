require_relative 'config'

client = Eversign::Client.new

for document in client.get_all_documents()
  client.download_raw_document_to_path(document.document_hash, 'raw.pdf')
  client.download_final_document_to_path(document.document_hash, 'final.pdf')
  break
end
