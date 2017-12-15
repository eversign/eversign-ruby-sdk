require 'addressable/template'
require 'faraday'
require 'json'

module EversignClient
	class Client
		attr_accessor :access_key, :base_uri
		BUSINESS_PATH = '/business{?access_key}'
		DOCUMENTS_PATH = '/document{?access_key,business_id,type}'
		DOCUMENT_PATH = '/document{?access_key,business_id,document_hash}'
		
		def initialize()
			self.base_uri = EversignClient.configuration.api_base || 'https://api.eversign.com/api'
			self.access_key = EversignClient.configuration.access_key
		end

		def get_buisnesses
	  	template = Addressable::Template.new(self.base_uri + BUSINESS_PATH)
	  	response = Faraday.get template.partial_expand(access_key: access_key).pattern
	  	extract_response(response.body, EversignClient::Mappings::Business)
		end

		def get_documents(business_id, doc_type)
	  	template = Addressable::Template.new(self.base_uri + DOCUMENTS_PATH)
	  	url = template.partial_expand(access_key: access_key, business_id: business_id, type: doc_type).pattern
	  	response = Faraday.get url
	  	extract_response(response.body, EversignClient::Mappings::Document)
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
			p Faraday.delete url
		end


		private
			def extract_response(body, mapping)
				data = eval(body)
				if data.kind_of?(Array)
					mapping.extract_collection(body, nil)
				else
					p data
					if data.key?(:success)
						EversignClient::Mappings::Exception.extract_single(body, nil)
					else
						mapping.extract_single(body, nil)
					end
				end
			end
	end
end