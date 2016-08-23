module Api
  class UsersController < ApplicationController
    def index
        @user = User.find_by(user_params)

        render json: @user, serializer: ::Api::UserSerializer, root: :user
    end

    private

    def user_params
        params.require(:user).permit(:authentication_token)
    end
  end
end
