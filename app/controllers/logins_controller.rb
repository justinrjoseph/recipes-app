class LoginsController < ApplicationController
    
    def new
        
    end
    
    def create
        chef = Chef.find_by(email: params[:email])
        if chef && chef.authenticate(params[:password])
            session[:chef_id] = chef.id
            flash[:success] = "Welcome #{chef.chefname}!"
            redirect_to recipes_path
        else
            flash.now[:danger] = "Your login credentials do not match any of our records."
            render :new
        end
    end
    
    def destroy
        session[:chef_id] = nil
        flash[:success] = "You successfully logged out."
        redirect_to root_path
    end
end