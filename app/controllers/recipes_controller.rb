class RecipesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_authorized

    def create
        user = User.find(session[:user_id])
        recipe = Recipe.create(user_id: user.id, title: recipe_params[:title], instructions: recipe_params[:instructions], minutes_to_complete: recipe_params[:minutes_to_complete])
        if recipe.valid?
            render json: recipe, status: :created
        else
            render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def index
        user = User.find(session[:user_id])
        recipes = Recipe.all
        render json: recipes, status: 200
    end

    private
    def recipe_params
      params.permit(:user_id, :title, :instructions, :minutes_to_complete)
    end

    def not_authorized
        render json: { errors: ["you are not authorized"] }, status: 401
    end
  end