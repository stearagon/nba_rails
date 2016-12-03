module Api
  class UsersController < ApplicationController
    def index
        @user = User.find_by(user_params)

        render json: @user, serializer: ::Api::UserSerializer, root: :users
    end

    private

    def user_params
      params.require(:filter).permit(:email)
    end
  end
end
