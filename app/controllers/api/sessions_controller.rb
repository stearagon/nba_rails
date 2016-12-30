module Api
  class SessionsController < Devise::SessionsController
      skip_before_action :verify_signed_out_user
      respond_to :html, :json

      def create
          super do |user|
              if request.format.json?
                  data = {
                      token: user.authentication_token,
                      email: user.email
                  }
                  render json: data, status: 201 and return
              end
          end
      end

      def destroy
          super do |user|
              user = User.find_by(email: params['email'])
              data = {}
              if user && Devise.secure_compare(user.authentication_token, params['token'])
                user.authentication_token = nil
                user.ensure_authentication_token
                user.save
                p user.authentication_token
                data[:signed_out] = true
              else
                data[:signed_out] = false
              end

              render json: data, status: 201 and return
          end
      end
  end
end
