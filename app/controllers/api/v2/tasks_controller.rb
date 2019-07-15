class Api::V2::TasksController < ApplicationController
    before_action :authenticate_with_token!

    def index
        tasks = current_user.task.ransack(params[:q]).result
        render json: tasks, status: 200
    end

    def show
        begin
            task = current_user.task.find(params[:id])
            render json: task, status: 200
        rescue 
            render status: 404
        end
    end

    def create
        #task = current_user.task.build(task_params)
        task = Task.new(task_params)
        task.user_id = current_user.id
        if task.save
            render json: task, status: 201
        else
            render json: { errors: task.errors }, status: 422
        end
    end

    def update
        task = current_user.task.find(params[:id])
        if task.update_attributes(task_params)
            render json: task, status: 200
        else
            render json: { errors: task.errors }, status: 422
        end
    end

    def destroy
        task = current_user.task.find(params[:id])
        task.destroy
        render status: 204
    end

    private 

    def task_params
        params.require(:task).permit(:title, :description, :deadline, :done)
    end
end
