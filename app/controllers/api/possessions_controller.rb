module Api
    class PossessionsController < ApplicationController
        def index
            possessions_finder = ModelFinder::Possession.new(possession_params)
            @posessions = possession_finder.get_possessions

            render(
                json: @possessions,
                each_serializer: ::Api::PossessionSerializer,
                root: :possession
            )
        end

        private

        def possession_params
            params.require(:possession).permit(
                :team_id,
                :start_date,
                :end_date,
                :number_of_games
            )
        end
    end
end
