module Api
  class UsersController < ApplicationController
    before_action :set_user, only: [:show, :edit, :update, :destroy, :finish_signup]

    def index
        @user = User.find_by(user_params)

        render json: @user, serializer: ::Api::UserSerializer, root: :users
    end

    private
      def set_user
        @user = User.find(params[:id])
      end

      def user_params
        accessible = [ :id, :name, :email ] # extend with your own params
        params.require(:filter).permit(accessible)
      end

      def user_auth_params
        params.permit(:id)
      end
    end
end
