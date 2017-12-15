module EversignClient
	module Models
		class Document
	    attr_accessor :document_hash, :sandbox, :is_draft, :title, :message, :use_signer_order, :reminders, :require_all_signers,
		    				  :redirect, :redirect_decline, :client, :expires, :embedded_signing_enabled,
		    				  :files, :signers, :recipients, :meta, :fields

		  def add_file(file)
		  	self.files ||= []
		  	self.files << file
		  end

		  def add_field(field)
		  	self.fields ||= []
		  	self.fields << field
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