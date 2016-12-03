module Api
  class ChartsController < ApplicationController
    def index
        @charts = Chart.where(id: chart_params[:id].split(','))

        render json: @charts, each_serializer: ::Api::ChartSerializer, root: :charts
    end

    def show
        @chart = Chart.find(request.params[:id])

        render json: @chart, serializer: ::Api::ChartSerializer, root: :charts
    end

    private

    def chart_params
      params.require(:filter).permit(:id)
    end
  end
end
