class RegistrationsController < Devise::RegistrationsController
    before_filter :configure_permitted_parameters

  protected
    def update_resource(resource, params)
      resource.update_without_password(params)
    end
end
