class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected
  	def configure_permitted_parameters
      registration_params = [:firstname, :lastname, :description, :email, :password, :current_password, :password_confirmation, :phone_number, :avatar, :role]

      if params[:action] == 'update'
        devise_parameter_sanitizer.for(:account_update) {
          |u| u.permit(registration_params << :firstname, :lastname, :description, :email, :password, :current_password, :phone_number, :avatar, :role)
        }
      elsif params[:action] == 'create'
        devise_parameter_sanitizer.for(:sign_up) {
          |u| u.permit(registration_params << :firstname, :lastname, :description, :email, :password, :current_password, :phone_number, :business_name, :business_position, :avatar, :role)
        }
      end
  		#devise_parameter_sanitizer.for(:sign_up) { |u| u.permit( :firstname, :lastname, :email, :password, :avatar) }
  		#devise_parameter_sanitizer.for(:account_update) { |u| u.permit( :firstname, :lastname, :description, :email, :phone_number, :password, :current_password, :avatar) }
  	end

    def after_sign_in_path_for(resource)
      main_path
    end
end
