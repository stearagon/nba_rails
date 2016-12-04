module Api
  class GamesController < ApplicationController
    def index
        @games = Game.where(date: Date.parse(game_params['date']))

        render json: @games, each_serializer: ::Api::GameSerializer, root: :games
    end

    def show
      @game = Game.find(params['id'])

      render json: @game, serializer: ::Api::GameSerializer, root: :games
    end

    private

    def game_params
      params.require(:filter).permit(:id, :date)
    end
  end
end
