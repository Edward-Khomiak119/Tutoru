class ApplicationController < ActionController::Base
  before_action :authenticate_user!, :except => [:landing]
  before_action :configure_permitted_parameters, if: :devise_controller?

  def landing; end

  def home; end

  def current_request
    if current_user.student?
      @help_requests = current_user.help_requests
    else
      @help_requests = HelpRequest.where(state: 0)
    end
  end

  def account
    @user = User.find(params[:id])
    if current_user.tutor?
      @offers = current_user.offers
      @help_requests = current_user.help_requests
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(
      :sign_up, keys: %i[
        email
        first_name
        last_name
        user_name
        age
        major
        school
        address
        zip_code
        type
      ]
    )
  end
end
