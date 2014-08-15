class CategoriesController < ApplicationController
  def index
    @heads = Head.includes(:categories).all
    @categories = Category.all
    respond_to do |format|
      format.html
      format.json
    end
  end

  def show
    @category = Category.find( params[:id] )
    @projects_count = @category.projects.size
    @projects = @category.projects.page( params[:page] )
  end

  def autocomplete
    max = 5
    search = params.permit(:search)[:search]
    if search.nil?
      searched = Category.limit(max)
      render_success( nil, data: categories_json(searched) )
    else
      searched = Category.where("name like ?", "%#{search}%").limit(max)
      render_success( nil, data: categories_json(searched) )
    end
  end

  private
  def categories_json( categories )
    categories.collect do | category |
      {
        name: category.name
      }
    end
  end
end
