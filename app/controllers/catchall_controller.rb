class CatchallController < ApplicationController

  def index
    render nothing: true, status: :not_found
  end

end
