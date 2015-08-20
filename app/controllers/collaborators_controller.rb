class CollaboratorsController < ApplicationController
  def create
    @wiki = Wiki.find(params[:wiki_id])
    @collaborator = Collaborator.new(params.require(:collaborator).permit(:user_id, :wiki_id))
    authorize @collaborator
    if @collaborator.save
      flash[:notice] = 'Successfully made this user a collaborator!'
      redirect_to @wiki
    else
      flash[:error] = 'Please try again to make this user a collaborator!'
      redirect_to @wiki
    end
  end

  def destroy
    @wiki = Wiki.find(params[:wiki_id])
    @collaborator = Collaborator.find(params[:id])
    authorize @collaborator
    if @collaborator.destroy
      flash[:notice] = 'This user is no longer a collaborator!'
      redirect_to @wiki
    else
      flash[:error] = 'Try again, this user is still a collaborator!'
      redirect_to @wiki
    end
  end
end
