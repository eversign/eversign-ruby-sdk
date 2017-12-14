module EversignClient
	module Models
		class Document
	    attr_accessor :sandbox, :is_draft, :title, :message, :use_signer_order, :reminders, :require_all_signers,
		    				  :redirect, :redirect_decline, :client, :expires, :embedded_signing_enabled, :files
		end
	end
end