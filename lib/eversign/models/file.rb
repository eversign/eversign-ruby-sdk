require 'active_model'
module Eversign
	module Models
		class File
      include ActiveModel::Validations

	    attr_accessor :name, :file_id, :file_url, :file_base64, :pages, :total_pages

      validate :only_one_option

	    def initialize(name=nil)
	    	self.name = name
	    end

      def only_one_option()
        error = false
        if file_id && !file_id.empty?
          error = file_url || file_base64
        elsif file_url && !file_url.empty?
          error = file_id || file_base64
        elsif file_base64 && !file_base64.empty?
          error = file_id || file_url
        else
          error = true
        end
        errors.add('Please provide only one file option') if error
      end
		end
	end
end
