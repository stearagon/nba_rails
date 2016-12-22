module Api
  class UsersController < ApplicationController
    before_action :set_user, only: [:show, :edit, :update, :destroy, :finish_signup]

    def index
        @user = User.find_by(user_params)

        render json: @user, serializer: ::Api::UserSerializer, root: :users
    end


    # GET /users/:id.:format
    def show
      # authorize! :read, @user
    end

    # GET /users/:id/edit
    def edit
      # authorize! :update, @user
    end

    def finish_signup
      # authorize! :update, @user 
      if request.patch? && params[:user] #&& params[:user][:email]
        if @user.update(user_auth_params)
          redirect_to "#{ENV['STAT_STOP_URL']}/?code=#{@user.authentication_token},#{@user.email}", notice: 'Your profile was successfully updated.'
        else
          @show_errors = true
        end
      end
    end

    # PATCH/PUT /users/:id.:format
    def update
      # authorize! :update, @user
        if @user.update(user_auth_params)
          redirect_to @user, notice: 'Your profile was successfully updated.'
        else
          render action: 'edit'
        end
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
      params.require(:user).permit(:email)
    end
  end
end
