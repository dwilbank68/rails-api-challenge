class UsersController < ApplicationController

    # before_create :set_auth_token
    # is in the model

def create
        user = User.new
        if user.save
            render json: user, status: 201, location: user # *
        else
            render json: user.errors, status: 422 # **
        end
    end

    def destroy
        user = User.find(params[:id])
        user.destroy
        head 204
    end
end