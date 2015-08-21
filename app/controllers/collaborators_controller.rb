class CollaboratorsController < ApplicationController

  def create
    @wiki = Wiki.friendly.find(params[:wiki_id])
    @collaborator = Collaborator.new(params.require(:collaborator).permit(:user_id, :wiki_id))
    authorize @collaborator
    # raise
    if @collaborator.save
      flash[:notice] = "#{@collaborator.name} is a collaborator!"
      redirect_to edit_wiki_path(@wiki)
    else
      flash[:error] = 'Please try again to make this user a collaborator!'
      redirect_to edit_wiki_path@wiki
    end
  end

  def destroy
    @wiki = Wiki.friendly.find(params[:wiki_id])
    @collaborator = Collaborator.find(params[:id])
    authorize @collaborator
    if @collaborator.destroy
      flash[:notice] = "#{@collaborator.name} is no longer a collaborator!"
      redirect_to edit_wiki_path(@wiki)
    else
      flash[:error] = 'Try again, this user is still a collaborator!'
      redirect_to edit_wiki_path(@wiki)
    end
  end
end
