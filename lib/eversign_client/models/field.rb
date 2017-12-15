module EversignClient
	module Models
		class Field
	    attr_accessor :name, :type, :x, :y, :width, :height, :page, :signer, :identifier, :required, :readonly,
		    					:validation_type, :text_style, :text_font, :text_size, :text_color, :value, :options, :group
		end
	end
end