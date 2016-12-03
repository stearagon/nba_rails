module Api
  class StatLinesController < ApplicationController
    def index
      stat_line_finder = ModelFinder::StatLine.new(stat_params)
      @stat_lines = stat_line_finder.find_team_stats

      render json: @stat_lines, each_serializer: ::Api::StatLineSerializer, root: :stat_lines
    end

    private
    def stat_params
      params.require(:filter).permit(
        :date, :home_team_id, :away_team_id, data_inputs: [ :data1, 'date-period' ]
      )
    end
  end
end
