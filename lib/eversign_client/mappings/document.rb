require 'kartograph'
require_relative '../models/document'

module EversignClient
	module Mappings
		class Document
			include Kartograph::DSL

			kartograph do
		    mapping EversignClient::Models::Document

		    property :sandbox, :is_draft, :title, :message, :use_signer_order, :reminders, :require_all_signers,
		    				  :redirect, :redirect_decline, :client, :expires, :embedded_signing_enabled
		    property :files, plural: true, include: File
		  end
		end
	end
end