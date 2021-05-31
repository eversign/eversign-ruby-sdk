require "addressable/template"
require "faraday"
require "json"
require "logger"

module Eversign
  class FileNotFoundException < Exception
  end

  class Client
    attr_accessor :access_key, :base_uri, :business_id, :token

    def initialize()
      self.base_uri = Eversign.configuration.api_base || "https://api.eversign.com"
      access_key = Eversign.configuration.access_key
      if access_key.start_with?("Bearer ")
        self.set_oauth_access_token(access_key)
      else
        self.access_key = access_key
      end
      self.business_id = Eversign.configuration.business_id
    end

    def set_oauth_access_token(oauthtoken)
      if oauthtoken.startswith("Bearer ")
        self.token = oauthtoken
      else
        self.token = "Bearer " + oauthtoken
      end
      self.get_businesses()
    end

    def generate_oauth_authorization_url(options)
      check_arguments(["client_id", "state"], options)
      template = Addressable::Template.new(Eversign.configuration.oauth_base + "/authorize{?clinet_id,state}")
      return template.partial_expand(clinet_id: options["client_id"], state: options["state"]).pattern
    end

    def request_oauth_token(options)
      check_arguments(["client_id", "client_secret", "code", "state"], options)

      req = execute_request(:post, "/token", options)
      if req.status == 200
        response_obj = JSON.parse(req.body)

        if response_obj.key?("success")
          raise response_obj["message"]
        else
          return response_obj["access_token"]
        end
      end
      raise "no success"
    end

    def get_buisnesses
      response = execute_request(:get, "/api/business?access_key=#{access_key}")
      extract_response(response.body, Eversign::Mappings::Business)
    end

    def get_all_documents
      get_documents("all")
    end

    def get_completed_documents
      get_documents("completed")
    end

    def get_draft_documents
      get_documents("draft")
    end

    def get_cancelled_documents
      get_documents("cancelled")
    end

    def get_action_required_documents
      get_documents("my_action_required")
    end

    def get_waiting_for_others_documents
      get_documents("waiting_for_others")
    end

    def get_templates
      get_documents("templates")
    end

    def get_archived_templates
      get_documents("templates_archived")
    end

    def get_draft_templates
      get_documents("template_draft")
    end

    def get_document(document_hash)
      path = "/api/document?access_key=#{access_key}&business_id=#{business_id}&document_hash=#{document_hash}"
      response = execute_request(:get, path)
      extract_response(response.body, Eversign::Mappings::Document)
    end

    def create_document(document, isFromTemplate = false)
      if document.files
        for file in document.files
          file.keys.each {|key| file.define_singleton_method(key) { self[key] }} if file.is_a? Hash
          if file.file_url
            file_response = self.upload_file(file.file_url)
            file.file_url = nil
            file.file_id = file_response.file_id
          end
        end
      end
      path = "/api/document?access_key=#{access_key}&business_id=#{business_id}"
      data = Eversign::Mappings::Document.representation_for(document, isFromTemplate)
      response = execute_request(:post, path, data)
      extract_response(response.body, Eversign::Mappings::Document)
    end

    def create_document_from_template(template)
      create_document(template, true)
    end

    def delete_document(document_hash)
      path = "/api/document?access_key=#{access_key}&business_id=#{business_id}&document_hash=#{document_hash}"
      delete(path, document_hash)
    end

    def cancel_document(document_hash)
      path = "/api/document?access_key=#{access_key}&business_id=#{business_id}&document_hash=#{document_hash}&cancel=1"
      delete(path, document_hash)
    end

    def download_raw_document_to_path(document_hash, path)
      sub_uri = "/api/download_raw_document?access_key=#{access_key}&business_id=#{business_id}&document_hash=#{document_hash}"
      download(sub_uri, path)
    end

    def download_final_document_to_path(document_hash, path, audit_trail = 1)
      sub_uri = "/api/download_raw_document?access_key=#{access_key}&business_id=#{business_id}&document_hash=#{document_hash}&audit_trail=#{audit_trail}"
      download(sub_uri, path)
    end

    def upload_file(file_path)
      payload = { upload: Faraday::UploadIO.new(file_path, "text/plain") }
      path = "/api/file?access_key=#{access_key}&business_id=#{business_id}"
      response = execute_request(:post, path, payload, true)
      extract_response(response.body, Eversign::Mappings::File)
    end

    def send_reminder_for_document(document_hash, signer_id)
      path = "/api/send_reminder?access_key=#{access_key}&business_id=#{business_id}"
      response = execute_request(:post, path, { document_hash: document_hash, signer_id: signer_id }.to_json)
      eval(response.body)[:success] ? true : extract_response(response.body)
    end

    private

    def append_sdk_id (body) 
      begin
        bodyHash = JSON.parse(body)
        bodyHash['client'] = 'ruby-sdk'
        return bodyHash.to_json
      rescue 
        return body
      end
    end

    def execute_request(method, path, body = nil, multipart = false)
      @faraday ||= Faraday.new(base_uri) do |conn|
        conn.headers = {}
        conn.headers["User-Agent"] = "Eversign_Ruby_SDK"
        conn.headers["Authorization"] = token if token
        conn.request :multipart if multipart
        conn.adapter :net_http
      end

      body = append_sdk_id(body)


      @faraday.send(method) do |request|
        request.url path
        request.body = body if body
      end
    end

    def check_arguments(arguments = [], options = {})
      arguments.each do |argument|
        raise ("Please specify " + argument) unless options.has_key?(argument.to_sym)
      end
    end

    def delete(path, document_hash)
      response = execute_request(:delete, path)
      eval(response.body)[:success] ? true : extract_response(response.body)
    end

    def download(sub_uri, path)
      response = execute_request(:get, sub_uri)
      File.open(path, "wb") { |fp| fp.write(response.body) }
    end

    def get_documents(doc_type)
      path = "/api/document?access_key=#{access_key}&business_id=#{business_id}&type=#{doc_type}"
      response = execute_request(:get, path)
      extract_response(response.body, Eversign::Mappings::Document)
    end

    def extract_response(body, mapping = nil)
      data = JSON.parse(body)
      if data.kind_of?(Array)
        mapping.extract_collection(body, nil)
      else
        if data.key?("success")
          Eversign::Mappings::Exception.extract_single(body, nil)
        else
          mapping.extract_single(body, nil)
        end
      end
    end
  end
end
