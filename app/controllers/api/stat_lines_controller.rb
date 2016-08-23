module Api
  class StatLinesController < ApplicationController
    def index
      stat_line_finder = ModelFinder::StatLine.new(params)
      @stat_lines = stat_line_finder.find

      render json: { stat_lines: @stat_lines }
    end
  end
end
