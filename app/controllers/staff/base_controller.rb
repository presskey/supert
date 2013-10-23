class Staff::BaseController < ActionController::Base

  protect_from_forgery
  layout 'staff'
  before_filter :authenticate_member!

end