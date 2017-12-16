require 'addressable/template'
require 'faraday'
require 'json'

module EversignClient
	class Client
		attr_accessor :access_key, :base_uri
		BUSINESS_PATH = '/business{?access_key}'
		DOCUMENTS_PATH = '/document{?access_key,business_id,type}'
		DOCUMENT_PATH = '/document{?access_key,business_id,document_hash,cancel}'
		
		def initialize()
			self.base_uri = EversignClient.configuration.api_base || 'https://api.eversign.com/api'
			self.access_key = EversignClient.configuration.access_key
		end

		def get_buisnesses
	  	template = Addressable::Template.new(self.base_uri + BUSINESS_PATH)
	  	response = Faraday.get template.partial_expand(access_key: access_key).pattern
	  	extract_response(response.body, EversignClient::Mappings::Business)
		end

		def get_all_documents(business_id)
	  	get_documents(business_id, 'all')
		end

		def get_completed_documents(business_id)
	  	get_documents(business_id, 'completed')
		end

		def get_drafts_documents(business_id)
	  	get_documents(business_id, 'drafts')
		end

		def get_cancelled_documents(business_id)
	  	get_documents(business_id, 'cancelled')
		end

		def get_action_required_documents(business_id)
	  	get_documents(business_id, 'my_action_required')
		end

		def get_waiting_for_others_documents(business_id)
	  	get_documents(business_id, 'waiting_for_others')
		end

		def get_document(business_id, document_hash)
	  	template = Addressable::Template.new(self.base_uri + DOCUMENT_PATH)
			url = template.partial_expand(access_key: access_key, business_id: business_id, document_hash: document_hash).pattern
	  	response = Faraday.get url
	  	extract_response(response.body, EversignClient::Mappings::Document)
		end

		def create_document(business_id, document)
			template = Addressable::Template.new(self.base_uri + DOCUMENT_PATH)
			url = template.partial_expand(access_key: access_key, business_id: business_id).pattern
			response = Faraday.post url, EversignClient::Mappings::Document.representation_for(nil, document)
			extract_response(response.body, EversignClient::Mappings::Document)
		end

		def delete_document(business_id, document_hash)
			template = Addressable::Template.new(self.base_uri + DOCUMENT_PATH)
			url = template.partial_expand(access_key: access_key, business_id: business_id, document_hash: document_hash).pattern
			Faraday.delete url
		end

		def cancel_document(business_id, document_hash)
			template = Addressable::Template.new(self.base_uri + DOCUMENT_PATH)
			url = template.partial_expand(access_key: access_key, business_id: business_id, document_hash: document_hash, cancel: 1).pattern
			Faraday.delete url
		end

		private
			def get_documents(business_id, doc_type)
		  	template = Addressable::Template.new(self.base_uri + DOCUMENTS_PATH)
		  	url = template.partial_expand(access_key: access_key, business_id: business_id, type: doc_type).pattern
		  	response = Faraday.get url
		  	extract_response(response.body, EversignClient::Mappings::Document)
			end

			def extract_response(body, mapping)
				data = eval(body)
				if data.kind_of?(Array)
					mapping.extract_collection(body, nil)
				else
					if data.key?(:success)
						EversignClient::Mappings::Exception.extract_single(body, nil)
					else
						mapping.extract_single(body, nil)
					end
				end
			end
	end
end