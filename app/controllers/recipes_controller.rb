class RecipesController < ApplicationController
   before_action :set_recipe, only: [:edit, :update, :show, :like]
   before_action :require_user, except: [:show, :index, :like]
   before_action :require_user_like, only: [:like]
   before_action :require_same_user, only: [:edit, :update]
   before_action :admin_user, only: [:destroy]
   
   def index
      @recipes = Recipe.paginate(page: params[:page], per_page: 4)
   end
   
   def show
      
   end
   
   def new
      @recipe = Recipe.new
   end
   
   def create
      @recipe = Recipe.new(recipe_params)
      @recipe.chef = current_user
      
      if @recipe.save
         flash[:success] = "Your \"#{@recipe.name}\" recipe was created!"
         redirect_to recipes_path
      else
         render :new   
      end
   end
   
   def edit
      
   end
   
   def update
      if @recipe.update_attributes(recipe_params)
         flash[:success] = "\"#{@recipe.name}\" recipe was updated!"
         redirect_to recipe_path(@recipe)
      else
         render :edit
      end
   end
   
   def destroy
      @recipe = Recipe.find(params[:id])
      if @recipe.destroy
         flash[:success] = "\"#{@recipe.name}\" recipe deleted."
         redirect_to recipes_path
      else
         render :show
         flash[:warning] = "An error occurred on your delete attempt."
      end
   end
   
   def like
      like = Like.create(like: params[:like], chef: current_user, recipe: @recipe)
      if like.valid? && params[:like] == 'true'
         flash[:success] = "You liked #{@recipe.chef.chefname}'s #{@recipe.name}!"
      elsif like.valid? && params[:like] == 'false'
         flash[:danger] = "You don't like #{@recipe.chef.chefname}'s #{@recipe.name}"
      else
         flash[:warning] = "You may like/dislike a recipe only once!"
      end
      redirect_to :back
   end
   
   private
   
      def recipe_params
         params.require(:recipe).permit(:name, :summary, :description, :picture, style_ids: [], ingredient_ids: [])
      end
      
      def set_recipe
         @recipe = Recipe.find(params[:id])
      end
      
      def require_same_user
         if current_user != @recipe.chef && !current_user.admin?
           flash[:danger] = "You may edit only your recipes."
           redirect_to root_path
         end
      end
      
      def require_user_like
       if !logged_in?
         flash[:warning] = "You must be logged in to perform that action."
         redirect_to :back
       end
      end
      
      def admin_user
         redirect_to recipes_path unless current_user.admin?
      end
end