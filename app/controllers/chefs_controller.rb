class ChefsController < ApplicationController
    
    def new
        @chef = Chef.new
    end
    
    def create
        @chef = Chef.new(chef_params)
        
        if @chef.save
            flash[:success] = "You have successfully registered. Now create some recipes!"
            redirect_to recipes_path
        else 
            render :new
        end
    end
    
    def edit
        @chef = Chef.find(params[:id])
    end
    
    def update
        @chef = Chef.find(params[:id])

        if @chef.update_attributes(chef_params)
         flash[:success] = "Your profile was updated!"
         redirect_to chef_path
        else
         render :edit
        end
    end
    
    private
    
        def chef_params
           params.require(:chef).permit(:chefname, :email, :password)
        end
    
end