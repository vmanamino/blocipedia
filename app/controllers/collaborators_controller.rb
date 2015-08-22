class CollaboratorsController < ApplicationController
  before_action :authenticate_user!

  def create # rubocop:disable Metrics/AbcSize
    @wiki = Wiki.friendly.find(params[:wiki_id])
    @collaborator = Collaborator.new(params.require(:collaborator).permit(:user_id, :wiki_id))
    authorize @collaborator
    # raise
    if @collaborator.save
      flash[:notice] = 'This user is a collaborator!'
      redirect_to edit_wiki_path(@wiki)
    else
      flash[:error] = 'Please try again to make this user a collaborator!'
      redirect_to edit_wiki_path(@wiki)
    end
  end

  def destroy # rubocop:disable Metrics/AbcSize
    @wiki = Wiki.friendly.find(params[:wiki_id])
    @collaborator = Collaborator.find(params[:id])
    authorize @collaborator
    if @collaborator.destroy
      flash[:notice] = 'This user is no longer a collaborator!'
      redirect_to edit_wiki_path(@wiki)
    else
      flash[:error] = 'Try again, this user is still a collaborator!'
      redirect_to edit_wiki_path(@wiki)
    end
  end
end
