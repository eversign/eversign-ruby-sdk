require_relative 'config'

def print_response(response, str)
  if response.instance_of?(Array)
    p "#{response.length} #{str} found"
  else
    p "#{response.error.type} for #{str}"
  end
end

client = Eversign::Client.new

print_response(client.get_all_documents(), 'all_documents')
print_response(client.get_cancelled_documents(), 'get_cancelled_documents')
print_response(client.get_action_required_documents(), 'get_action_required_documents')
print_response(client.get_waiting_for_others_documents(), 'get_waiting_for_others_documents')
print_response(client.get_completed_documents(), 'get_completed_documents')
print_response(client.get_draft_documents(), 'get_draft_documents')
print_response(client.get_templates(), 'get_templates')
print_response(client.get_archived_templates(), 'get_archived_templates')
print_response(client.get_draft_templates(), 'get_draft_templates')

client.get_all_documents().each do |document|
  p document.signers
  p document.fields
end
