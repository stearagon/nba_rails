module Api
  class PlayersController < ApplicationController
    def index
      player_finder = ModelFinder::Player.new(params)
      @players = player_finder.find

      render json: @players
    end
  end
end
