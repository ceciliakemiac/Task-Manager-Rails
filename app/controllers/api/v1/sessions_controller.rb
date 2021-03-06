class Api::V1::SessionsController < ApplicationController
    def create
        user = User.find_by(email: session_params[:email])
        if user && user.valid_password?(session_params[:password])
            sign_in user, store: false
            user.generate_auth_token!
            user.save
            render json: user, status: 200
        elsif user
            render json: { errors: 'Invalid email or password' }, status: 401
        else
            render status: 422
        end
    end

    def destroy
        user = User.find_by(auth_token: params[:id])
        user.generate_auth_token!
        user.save
        render status: 204
    end

    private

    def session_params
        params.require(:session).permit(:email, :password)
    end
end
