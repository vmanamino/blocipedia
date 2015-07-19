class WikisController < ApplicationController
  def index
    @wikis = Wiki.all
  end

  def show
    @wiki = Wiki.find(params[:id])
  end

  def new
    @wiki = Wiki.new
  end

  def create
    @wiki = current_user.wikis.build(wiki_params)
    if @wiki.save
      redirect_to @wiki, notice: 'Your wiki was saved'
    else
      flash[:error] = 'Your wiki failed to save'
      render :new
    end
  end

  def edit
    @wiki = Wiki.find(params[:id])
  end

  def update
    @wiki = Wiki.find(params[:id])
    if @wiki.update_attributes(wiki_params)
      flash[:notice] = 'Your wiki was updated'
      redirect_to @wiki
    else
      flash[:error] = 'Your wiki failed to update'
      redirect_to @wiki
    end
  end

  def destroy
    @wiki = Wiki.find(params[:id])
    if @wiki.destroy
      flash[:notice] = "Your wiki was deleted successfully."
      redirect_to root_path
    else
      flash[:error] = 'Your wiki failed to delete, try again'
      render :show
    end
  end

  def wiki_params
    params.require(:wiki).permit(:title, :body, :private)
  end
end
