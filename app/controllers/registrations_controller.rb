class RegistrationsController < Devise::RegistrationsController
  before_filter :configure_permitted_parameters

  protected
    def update_resource(resource, params)
      resource.update_without_password(params)
    end

    def after_update_path_for(resource)
      edit_user_registration_path
    end
end
