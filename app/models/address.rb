class Address < ApplicationRecord

	def to_s
		"Street: '#{street}', City: '#{city}', State: '#{state}', Zip Code: '#{zip_code}'"
	end
end
