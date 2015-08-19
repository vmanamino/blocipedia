class WikisController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @wikis = Wiki.visible_to(current_user)
    authorize @wikis
  end

  def show
    @wiki = Wiki.friendly.find(params[:id])
    unless request.path == wiki_path(@wiki)
      redirect_to @wiki, status: :moved_permanently
    end
    authorize @wiki
  end

  def new
    @wiki = Wiki.new
    authorize @wiki
  end

  def create
    @wiki = current_user.wikis.build(wiki_params)
    authorize @wiki
    if @wiki.save
      flash[:notice] = 'Your wiki was saved'
      redirect_to @wiki
    else
      flash[:error] = 'Your wiki failed to save'
      render :new
    end
  end

  def edit
    @wiki = Wiki.friendly.find(params[:id])
    @users = User.all
    authorize @wiki
  end

  def update
    @wiki = Wiki.friendly.find(params[:id])
    authorize @wiki
    @wiki.slug = nil
    if @wiki.update_attributes(wiki_params)
      flash[:notice] = 'Your wiki was updated'
      redirect_to @wiki
    else
      flash[:error] = 'Your wiki failed to update'
      redirect_to @wiki
    end
  end

  def destroy
    @wiki = Wiki.friendly.find(params[:id])
    authorize @wiki
    if @wiki.destroy
      flash[:notice] = 'Your wiki was deleted successfully.'
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
