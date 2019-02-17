class Api::V1::TasksController < ApplicationController
    before_action :authenticate_with_token!

    def index
        tasks = current_user.task
        render json: { tasks: tasks }, status: 200
    end

    def show
        begin
            task = current_user.task.find(params[:id])
            render json: task, status: 200
        rescue 
            render status: 404
        end
    end
end
