module Api
  class DashboardsController < ApplicationController
    def index
        @dashboards = Dashboard.where(id: dashboard_params[:id].split(','))

        render json: @dashboards, include: ['charts'], each_serializer: ::Api::DashboardSerializer, root: :dashboards
    end

    def show
        @dashboard = Dashboard.find(params[:id])

        render json: @dashboard, include: ['charts'], serializer: ::Api::DashboardSerializer, root: :dashboards
    end

    private

    def dashboard_params
      params.require(:filter).permit(:id)
    end
  end
end
