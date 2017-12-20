require 'spec_helper'
require 'faraday/adapter/test'

@conn = Faraday.new do |builder|
  builder.adapter :test
end

describe Eversign::Client do

  let(:api_base) { 'https://test.com' }
  let(:access_key) { 'test_access_key' }
  let(:business_id) { 1234 }
  let(:oauth_base) { 'http://test.oauth_base.com' }
  let(:obj) { Eversign::Client.new }

  before do
    allow(Eversign).to receive(:configuration).and_return(double(api_base: api_base, access_key: access_key, business_id: business_id, oauth_base: oauth_base))
  end
  
  describe '#initializer' do  
    context 'when api_base is defined' do
      it 'sets base_uri' do
        expect(obj.base_uri).to eq(api_base)
      end
    end

    context 'when api_base is not defined' do
      let(:api_base) { }

      it 'defaults base_uri' do
        expect(obj.base_uri).to eq('https://api.eversign.com')
      end
    end
  end

  describe '#generate_oauth_authorization_url' do

    context 'when required arguments are defined' do
      let(:options) { { client_id: 'test_client_id', state: 'test_state' } }
      it 'sets base_uri' do
        expect(obj.generate_oauth_authorization_url(options)).to eq(oauth_base + '/authorize')
      end
    end

    context 'when required arguments are not defined' do
      context 'client_id missing' do 
        let(:options) { { state: 'test_state' } }
        
        it 'raising an error' do
          expect{ obj.generate_oauth_authorization_url(options) }.to raise_error('Please specify client_id')
        end
      end

      context 'state missing' do 
        let(:options) { { client_id: 'test_client_id' } }
        
        it 'raising an error' do
          expect{ obj.generate_oauth_authorization_url(options) }.to raise_error('Please specify state')
        end
      end
    end
  end

  describe '#get_buisnesses' do
    let(:path) { "/api/business?access_key=#{access_key}" }
    let(:business1_id) { 12345 }
    let(:business1_name) { 'test_b_1' }
    let(:business_1) { { business_id: business1_id, business_name: business1_name } }
    let(:business_2) { { business_id: 14567, business_name: 'test_2' } }


    before do
      expect_any_instance_of(Eversign::Client).to receive(:execute_request).with(:get, path).and_return(double(body: response.to_json))
    end

    context 'when businesses are returned from service' do
      let(:response) { [business_1, business_2] }
      
      it 'returns buisnesses' do
        obj = Eversign::Client.new
        businesses = obj.get_buisnesses
        expect(businesses.size).to eq(2)
        expect(businesses[0].business_id).to eq(business1_id)
        expect(businesses[0].business_name).to eq(business1_name)
      end
    end

    context 'when no businesses are returned from service' do
      let(:response) { [] }
      it 'returns empty array' do
        expect(obj.get_buisnesses).to be_empty
      end
    end
  end

  describe '#get_document' do
    let(:path) { "/api/document?access_key=#{access_key}&business_id=#{business_id}&document_hash=#{document_hash}" }
    let(:document_hash) { 'abcdefg' }
    let(:title) { 'test_title' }
    let(:doc) { { document_hash: document_hash, title: title } }

    before do
      expect_any_instance_of(Eversign::Client).to receive(:execute_request).with(:get, path).and_return(double(body: response.to_json))
    end

    context 'when document is found' do
      let(:response) { doc }

      it 'returns document' do
        expect(obj.get_document(document_hash).title).to eq(title)
      end
    end

    context 'when document is found' do
      let(:response) { { success: false } }
      it 'returns exception' do
        expect(obj.get_document(document_hash).success).to eq(false)
      end
    end
  end

  describe '#cancel_document' do
    let(:path) { "/api/document?access_key=#{access_key}&business_id=#{business_id}&document_hash=#{document_hash}&cancel=1" }
    let(:document_hash) { 'abcdefg' }

    before do
      expect_any_instance_of(Eversign::Client).to receive(:execute_request).with(:delete, path).and_return(double(body: {success: response}.to_json))
    end

    context 'when cancel is successful' do
      let(:response) { true }

      it 'returns true' do
        expect(obj.cancel_document(document_hash)).to be_truthy
      end
    end

    context 'when cancel is not successful' do
      let(:response) { false }

      it 'returns error' do
        expect(obj.cancel_document(document_hash).success).to be_falsey
      end
    end
  end

  describe '#delete_document' do
    let(:path) { "/api/document?access_key=#{access_key}&business_id=#{business_id}&document_hash=#{document_hash}" }
    let(:document_hash) { 'abcdefg' }

    before do
      expect_any_instance_of(Eversign::Client).to receive(:execute_request).with(:delete, path).and_return(double(body: {success: response}.to_json))
    end

    context 'when delete is successful' do
      let(:response) { true }

      it 'returns true' do
        expect(obj.delete_document(document_hash)).to be_truthy
      end
    end

    context 'when delete is not successful' do
      let(:response) { false }

      it 'returns error' do
        expect(obj.delete_document(document_hash).success).to be_falsey
      end
    end
  end

  describe '#send_reminder_for_document' do
    let(:path) { "/api/send_reminder?access_key=#{access_key}&business_id=#{business_id}" }
    let(:document_hash) { 'abcdefg' }
    let(:signer_id) { 'test_id' }
    let(:request) { { document_hash: document_hash, signer_id: signer_id } }

    before do
      expect_any_instance_of(Eversign::Client).to receive(:execute_request).with(:post, path, request.to_json).and_return(double(body: {success: response}.to_json))
    end

    context 'when send is successful' do
      let(:response) { true }

      it 'returns true' do
        expect(obj.send_reminder_for_document(document_hash, signer_id)).to be_truthy
      end
    end

    context 'when send is not successful' do
      let(:response) { false }

      it 'returns error' do
        expect(obj.send_reminder_for_document(document_hash, signer_id).success).to be_falsey
      end
    end
  end

  describe '#download_document_to_path' do
    let(:document_hash) { 'abcdefg' }
    let(:response) { double(body: 'test') }
    let(:file_path) { 'test' }

    before do
      expect_any_instance_of(Eversign::Client).to receive(:execute_request).with(:get, path).and_return(double(body: response.to_json))
      expect(File).to receive(:open).with(file_path, 'wb').and_return(double('file_path'))
    end

    context 'raw' do
      let(:path) { "/api/download_raw_document?access_key=#{access_key}&business_id=#{business_id}&document_hash=#{document_hash}"}

      it 'downloads file' do
        expect(obj.download_raw_document_to_path(document_hash, file_path)).to be_truthy
      end
    end

    context 'raw' do
      let(:path) { "/api/download_raw_document?access_key=#{access_key}&business_id=#{business_id}&document_hash=#{document_hash}&audit_trail=1"}

      it 'downloads file' do
        expect(obj.download_final_document_to_path(document_hash, file_path)).to be_truthy
      end
    end
  end

  describe '#create_document' do
    let(:path) { "/api/document?access_key=#{access_key}&business_id=#{business_id}" }
    let(:file_path) { "/api/file?access_key=#{access_key}&business_id=#{business_id}" }
    let(:document_hash) { 'abcdefg' }
    let(:title) { 'test_title' }
    let(:response) { { document_hash: document_hash, title: title, files: [file], recipients: [recipient], signers: [signer], feilds: [[feild]]} }
    let(:file_name) { 'test_file' }
    let(:file_url) { 'test_file_url' }
    let(:file) { { name: file_name, file_url: file_url } }
    let(:feild_name) { 'test_feild' }
    let(:feild) { { name: feild_name } }
    let(:recipient_email) { 'recipeient@email.com' }
    let(:recipient_name) { 'test_recipient' }
    let(:recipient) { { name: recipient_name, email: recipient_email } }
    let(:signer) { { name: signer_name, email: recipient_email } }
    let(:signer_name) { 'test_signer' }

    before do
      expect_any_instance_of(Eversign::Client).to receive(:execute_request).with(:post, path, any_args).and_return(double(body: response.to_json))
      expect_any_instance_of(Eversign::Client).to receive(:execute_request).with(:post, file_path, any_args).and_return(double(body: '{}'))
      allow(File).to receive(:open).with(file_url).and_return(true)
    end

    it 'creates document' do
      doc = Eversign::Models::Document.new
      doc.title = title
      file = Eversign::Models::File.new(file_name)
      file.file_url = file_url
      doc.add_file(file)
      feild = Eversign::Models::Field.new
      doc.add_field(feild)
      feild.name = 
      doc.add_field_list([feild])
      doc.add_recipient(Eversign::Models::Recipient.new(recipient_name, recipient_email))
      doc.add_signer(Eversign::Models::Signer.new(signer_name, recipient_email))
      created_doc = obj.create_document(doc)
      expect(created_doc.document_hash).to eq(document_hash)
      expect(created_doc.files.size).to eq(1)
    end
  end

  describe '#get_templates' do
    let(:path) { "/api/document?access_key=#{access_key}&business_id=#{business_id}&type=#{doc_type}" }
    let(:template1_id) { 'abcdefg' }
    let(:template_1) { { template_id: template1_id } }
    let(:template_2) { { template_id: 'test_template_id_2' } }

    shared_examples 'get templates' do
      before do
        expect_any_instance_of(Eversign::Client).to receive(:execute_request).with(:get, path).and_return(double(body: response.to_json))
      end

      context 'when templates are returned from service' do
        let(:response) { [template_1, template_2] }
        
        it 'returns templates' do
          templates = obj.send(method)
          expect(templates.size).to eq(2)
          expect(templates[0].template_id).to eq(template1_id)
        end
      end

      context 'when no templates are returned from service' do
        let(:response) { [] }
        it 'returns empty array' do
          expect(obj.send(method)).to be_empty
        end
      end
    end

    context 'all' do
      let(:doc_type) { 'templates' }
      let(:method) {'get_templates'}

      it_behaves_like 'get templates'
    end

    context 'archived' do
      let(:doc_type) { 'templates_archived' }
      let(:method) {'get_archived_templates'}

      it_behaves_like 'get templates'
    end

    context 'draft' do
      let(:doc_type) { 'template_draft' }
      let(:method) {'get_draft_templates'}

      it_behaves_like 'get templates'
    end
  end

  describe '#get_documents' do
    let(:path) { "/api/document?access_key=#{access_key}&business_id=#{business_id}&type=#{doc_type}" }
    let(:document1_hash) { 'abcdefg' }
    let(:doc_1) { { document_hash: document1_hash } }
    let(:doc_2) { { document_hash: 'test_doc_hash_2' } }

    shared_examples 'get documents' do
      before do
        expect_any_instance_of(Eversign::Client).to receive(:execute_request).with(:get, path).and_return(double(body: response.to_json))
      end

      context 'when documents are returned from service' do
        let(:response) { [doc_1, doc_2] }
        
        it 'returns documents' do
          docs = obj.send(method)
          expect(docs.size).to eq(2)
          expect(docs[0].document_hash).to eq(document1_hash)
        end
      end

      context 'when no documents are returned from service' do
        let(:response) { [] }
        it 'returns empty array' do
          expect(obj.send(method)).to be_empty
        end
      end
    end

    context 'all' do
      let(:doc_type) { 'all' }
      let(:method) {'get_all_documents'}

      it_behaves_like 'get documents'
    end

    context 'completed' do
      let(:doc_type) { 'completed' }
      let(:method) {'get_completed_documents'}

      it_behaves_like 'get documents'
    end

    context 'draft' do
      let(:doc_type) { 'draft' }
      let(:method) {'get_draft_documents'}

      it_behaves_like 'get documents'
    end

    context 'cancelled' do
      let(:doc_type) { 'cancelled' }
      let(:method) {'get_cancelled_documents'}

      it_behaves_like 'get documents'
    end

    context 'my_action_required' do
      let(:doc_type) { 'my_action_required' }
      let(:method) {'get_action_required_documents'}

      it_behaves_like 'get documents'
    end

    context 'waiting_for_others' do
      let(:doc_type) { 'waiting_for_others' }
      let(:method) {'get_waiting_for_others_documents'}

      it_behaves_like 'get documents'
    end
  end
end
