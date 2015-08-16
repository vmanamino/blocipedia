class AddCollaboratorToWikis < ActiveRecord::Migration
  def change
    add_column :wikis, :collaborator_id, :integer
    add_index :wikis, :collaborator_id
  end
end
