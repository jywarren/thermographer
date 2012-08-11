class ApplicationController < ActionController::Base

	protect_from_forgery

	def mobile?
		(request.env['HTTP_USER_AGENT'].match("Mobi") || params[:format] == "mobile") && params[:format] != "html" && params[:m] != "false" || params[:m] == "true"
	end

end
