class HomesController < ApplicationController
  
  def index
  	redirect_to accounts_path if user_signed_in?
  end
  
end
