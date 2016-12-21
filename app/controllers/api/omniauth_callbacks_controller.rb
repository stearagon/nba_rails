module Api
  class OmniauthCallbacksController < Devise:: OmniauthCallbacksController
    def self.provides_callback_for(provider)
      class_eval %Q{
        def #{provider}
          @user = User.find_for_oauth(env["omniauth.auth"], current_user)

          if @user.persisted?
            sign_in_and_redirect @user, event: :authentication
            set_flash_message(:notice, :success, kind: "#{provider}".capitalize) if is_navigational_format?
          else
            session["devise.#{provider}_data"] = env["omniauth.auth"]
            redirect_to new_user_registration_url
          end
        end
      }
    end

    [:twitter].each do |provider|
      provides_callback_for provider
    end

    def after_sign_in_path_for(resource)
      if resource.identity.provider == 'twitter' && !resource.email_verified?
        finish_signup_path(resource)
      elsif resource.identity.provider == 'twitter'
        "#{ENV['STAT_STOP_URL']}/?code=#{resource.authentication_token},#{resource.email}"
      else
        super resource
      end
    end
  end
end
