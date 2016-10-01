module Api
    class PossessionsController < ApplicationController
        def index
            possessions_finder = ModelFinder::Possession.new(params)
            @posessions = possession_finder.find

            render json: @possessions, each_serializer: ::Api::PossessionSerializer, root: :possession
        end
    end
end
