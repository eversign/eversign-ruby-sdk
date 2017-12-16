require 'kartograph'
require_relative '../models/file'

module EversignClient
	module Mappings
		class File
			include Kartograph::DSL

			kartograph do
		    mapping EversignClient::Models::File

		    property :name, :file_id, :file_url, :file_base64, :pages, :total_pages
		  end
		end
	end
end
