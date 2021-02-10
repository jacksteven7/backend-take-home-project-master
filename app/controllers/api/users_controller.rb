module Api
  class UsersController < ApplicationController

    def index
      users = filter_users(User.all.order(created_at: :desc))
      
      render json: {users: users}, :except => excluded_fields
    end

    def create
      user = User.new(user_params)
    
      if user.save
        AccessWorker.perform_async(user.id)
        render json: user, :except => excluded_fields , status: 201
        
      else
        render json: {errors: user.errors.messages}, status: 422
      end
    end

    private

    def user_params
      params.require(:user).permit(:email, :phone_number, :full_name, :password, :metadata)
    end

    def filter_users(users)
      [:email, :full_name, :metadata].each do |field|
        users = users.where("#{field.to_s} LIKE ? ", "%#{params[field]}%") if params[field].present?  
      end
      users
    end

    def excluded_fields
      [:id, :password, :created_at, :updated_at]      
    end
  end
end