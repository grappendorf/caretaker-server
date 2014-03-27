class CatchallController < ApplicationController

	def index
		respond_to do |format|
			format.html
			format.json { render nothing: true, status: :not_found }
		end
	end

end
