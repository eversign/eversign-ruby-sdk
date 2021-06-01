module Eversign
	module Models
		class Document
	    attr_accessor :document_hash, :template_id, :sandbox, :is_draft, :title, :message, :use_signer_order, :reminders, :require_all_signers,
		    				  :redirect, :redirect_decline, :client, :expires, :embedded_signing_enabled, :requester_email, :is_template,
		    				  :is_completed, :is_archived, :is_deleted, :is_trashed, :is_cancelled, :embedded, :in_person, :permission,
		    				  :files, :signers, :recipients, :meta, :fields, :use_hidden_tags

		  def add_file(file)
		  	self.files ||= []
		  	self.files << file
		  end

		  def add_field(field)
		  	add_field_list([field])
		  end

		  def add_field_list(field_list)
		  	self.fields ||= []
		  	self.fields << field_list
		  end

		  def add_recipient(recipient)
		  	self.recipients ||= []
		  	self.recipients << recipient
		  end

		  def add_signer(signer)
		  	self.signers ||= []
		  	self.signers << signer
		  end
		end
	end
end
