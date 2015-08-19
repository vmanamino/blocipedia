class CollaboratorsController < ApplicationController
  def create
    wiki = Wiki.find(params[:wiki_id])
    user = User.find(params[:user_id])
    collaborator = Collaborator.new(user: user, wiki: wiki)
    authorize collaborator
    if collaborator.save
      redirect_to [wiki, user], notice: 'Successfully made this user a collaborator!'
    else
      redirect_to [wiki, user], notice: 'Please try again to make this user a collaborator!'
    end
  end

  def destroy
  end
end
