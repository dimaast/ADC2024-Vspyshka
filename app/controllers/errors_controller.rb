class ErrorsController < ApplicationController
  def not_found
    respond_to do |format|
      format.html { render template: 'errors/not_found', status: 404 }
      format.json { render json: { error: 'Not Found' }, status: 404 }
      format.all { render plain: '404 Not Found', status: 404 }
    end
  end
end