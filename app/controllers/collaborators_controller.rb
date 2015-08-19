class CollaboratorsController < ApplicationController
  def create
    wiki = Wiki.find(params[:wiki_id])
  end

  def destroy
  end
end
