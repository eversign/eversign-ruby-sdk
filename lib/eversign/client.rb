require 'addressable/template'
require 'faraday'
require 'json'
require 'logger'

module Eversign
	
	class FileNotFoundException < Exception
	end

	class Client
		attr_accessor :access_key, :base_uri, :business_id

		def initialize()
			self.base_uri = Eversign.configuration.api_base || 'https://api.eversign.com/api'
			self.access_key = Eversign.configuration.access_key
			self.business_id = Eversign.configuration.business_id
		end

		def get_buisnesses
	  	template = Addressable::Template.new(self.base_uri + '/business{?access_key}')
	  	response = Faraday.get template.partial_expand(access_key: access_key).pattern
	  	extract_response(response.body, Eversign::Mappings::Business)
		end

		def get_all_documents
	  	get_documents('all')
		end

		def get_completed_documents
	  	get_documents('completed')
		end

		def get_drafts_documents
	  	get_documents('drafts')
		end

		def get_cancelled_documents
	  	get_documents('cancelled')
		end

		def get_action_required_documents
	  	get_documents('my_action_required')
		end

		def get_waiting_for_others_documents
	  	get_documents('waiting_for_others')
		end

		def get_templates
	  	get_documents('templates')
		end

		def get_archived_templates
	  	get_documents('templates_archived')
		end

		def get_drafts_templates
	  	get_documents('template_drafts')
		end

		def get_document(document_hash)
	  	template = Addressable::Template.new(self.base_uri + '/document{?access_key,business_id,document_hash}')
			url = template.partial_expand(access_key: access_key, business_id: business_id, document_hash: document_hash).pattern
	  	response = Faraday.get url
	  	extract_response(response.body, Eversign::Mappings::Document)
		end

		def create_document(document)
			template = Addressable::Template.new(self.base_uri + '/document{?access_key,business_id}')
			url = template.partial_expand(access_key: access_key, business_id: business_id).pattern
			for file in document.files
        if file.file_url
          file_response = self.upload_file(file.file_url)
          file.file_url = nil
          file.file_id = file_response.file_id
        end
      end
      data = Eversign::Mappings::Document.representation_for(document)
			response = Faraday.post url, data
			extract_response(response.body, Eversign::Mappings::Document)
		end

		def delete_document(document_hash)
			delete('/document{?access_key,business_id,document_hash}', document_hash)
		end

		def cancel_document(document_hash)
			delete('/document{?access_key,business_id,document_hash,cancel}', document_hash)
		end

		def download_raw_document_to_path(document_hash, path)
			sub_uri = '/download_raw_document{?access_key,business_id,document_hash}'
			download(document_hash, nil, sub_uri, path)
		end

		def download_final_document_to_path(document_hash, path, audit_trail=1)
			sub_uri = '/download_raw_document{?access_key,business_id,document_hash,audit_trail}'
			download(document_hash, audit_trail, sub_uri, path)
		end

		def upload_file(file_path)
	  	template = Addressable::Template.new(self.base_uri + '/file{?access_key,business_id}')
			url = template.partial_expand(access_key: access_key, business_id: business_id).pattern
			conn = Faraday.new(url) do |f|
			  f.request :multipart
			  f.adapter :net_http
			end
			payload = { upload: Faraday::UploadIO.new(file_path, 'text/plain') }
			response = conn.post url, payload
			extract_response(response.body, Eversign::Mappings::File)
		end

		private
			def delete(sub_uri, document_hash)
				template = Addressable::Template.new(self.base_uri + sub_uri)
				url = template.partial_expand(access_key: access_key, business_id: business_id, document_hash: document_hash, cancel: 1).pattern
				response = Faraday.delete url
				eval(response.body)[:success] ? true : extract_response(response.body, nil)
			end

			def download(document_hash, audit_trail, sub_uri, path)
				template = Addressable::Template.new(self.base_uri + sub_uri)
				url = template.partial_expand(access_key: access_key, business_id: business_id, document_hash:document_hash, audit_trail: audit_trail).pattern
				response = Faraday.get url
				File.open(path, 'wb') { |fp| fp.write(response.body) }
			end

			def get_documents(doc_type)
		  	template = Addressable::Template.new(self.base_uri + '/document{?access_key,business_id,type}')
		  	url = template.partial_expand(access_key: access_key, business_id: business_id, type: doc_type).pattern
		  	response = Faraday.get url
		  	extract_response(response.body, Eversign::Mappings::Document)
			end

			def extract_response(body, mapping)
				data = eval(body)
				if data.kind_of?(Array)
					mapping.extract_collection(body, nil)
				else
					if data.key?(:success)
						Eversign::Mappings::Exception.extract_single(body, nil)
					else
						mapping.extract_single(body, nil)
					end
				end
			end
	end
end
