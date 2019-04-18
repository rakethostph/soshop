module ApplicationHelper

	def app_name
		@app_name = "#{'Yintly'}"
	end

	def app_logo
		@app_logo =  asset_path("img/sos-logo-only.png")
	end

end
