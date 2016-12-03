module Api
  class TeamsController < ApplicationController
    def index
        @teams = Team.where(id: team_params[:id].split(','))

        render json: @teams, each_serializer: ::Api::TeamSerializer, root: :teams
    end

    def show
        @team = Team.find(params[:id])

        render json: @team, serializer: ::Api::TeamSerializer, root: :teams
    end

    private
    def team_params
      params.require(:filter).permit(:id)
    end
  end
end
