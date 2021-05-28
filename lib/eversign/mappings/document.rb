require "kartograph"
require_relative "../models/document"

module Eversign
  module Mappings
    class File
      include Kartograph::DSL

      kartograph do
        mapping Eversign::Models::File

        property :name, :file_id, :file_url, :file_base64
      end
    end

    class Signer
      include Kartograph::DSL

      kartograph do
        mapping Eversign::Models::Signer

        property :id, :name, :email, :order, :pin, :message, :deliver_email, :role
      end
    end

    class Field
      include Kartograph::DSL

      kartograph do
        mapping Eversign::Models::Field

        property :name, :type, :x, :y, :width, :height, :page, :signer, :identifier, :required, :readonly, :merge, :type,
                 :validation_type, :text_style, :text_font, :text_size, :text_color, :value, :options, :group
      end
    end

    class Recipient
      include Kartograph::DSL

      kartograph do
        mapping Eversign::Models::Recipient

        property :name, :email, :role
      end
    end

    class Document
      include Kartograph::DSL

      kartograph do
        mapping Eversign::Models::Document

        property :document_hash, :template_id, :sandbox, :is_draft, :title, :message, :use_signer_order, :reminders, :require_all_signers,
                 :redirect, :redirect_decline, :client, :expires, :embedded_signing_enabled, :requester_email, :is_template,
                 :is_completed, :is_archived, :is_deleted, :is_trashed, :is_cancelled, :embedded, :in_person, :permission,
                 :use_hidden_tags
        property :files, plural: true, include: File
        property :signers, plural: true, include: Signer
        property :recipients, plural: true, include: Recipient
      end

      def self.extract_collection(content, scope)
        data = JSON.parse(content)
        result = []
        data.each do |item|
          result << extract_single(item.to_json, nil)
        end
        result
      end

      def self.extract_single(content, scope)
        obj = super(content, scope)
        data = JSON.parse(content)
        if data["fields"]
          data["fields"].each do |field_list|
            field_data = []
            field_list.each do |field|
              extracted_field = Field.extract_single(field.to_json, nil)
              field_data << extracted_field if extracted_field
            end
            obj.add_field_list(field_data)
          end
        end
        obj
      end

      def self.representation_for(document, isFromTemplate = false)
        data = super(nil, document)
        list = []
        if document.fields
          document.fields.each do |field_list|
            field_data = []
            field_list.each do |field|
              field_data << JSON.parse(Field.representation_for(nil, field))
            end
            list << field_data
          end
        end
        data = JSON.parse(data)
        # Fix for issue 7. When we create a document from template (isFromTemplate=true) fields array is 1 dimentional, so we flatten it:
        data["fields"] = isFromTemplate ? list.flatten : list
        JSON.dump(data)
      end
    end
  end
end
