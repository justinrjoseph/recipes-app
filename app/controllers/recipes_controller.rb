class RecipesController < ApplicationController
   
   def index
      @recipes = Recipe.all.sort_by { |likes| likes.thumbs_up_total }.reverse
   end
   
   def show
      @recipe = Recipe.find(params[:id])
   end
   
   def new
      @recipe = Recipe.new
   end
   
   def create
      @recipe = Recipe.new(recipe_params)
      @recipe.chef = Chef.find(2)
      
      if @recipe.save
         flash[:success] = "Your Recipe was created!"
         redirect_to recipes_path
      else
         render :new   
      end
   end
   
   def edit
      @recipe = Recipe.find(params[:id])
   end
   
   def update
      @recipe = Recipe.find(params[:id])
      
      if @recipe.update_attributes(recipe_params)
         flash[:success] = "Your Recipe was updated!"
         redirect_to recipe_path(@recipe)
      else
         render :edit
      end
   end
   
   def like
      @recipe = Recipe.find(params[:id])
      like = Like.create(like: params[:like], chef: Chef.first, recipe: @recipe)
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
         params.require(:recipe).permit(:name, :summary, :description, :picture)
      end
end