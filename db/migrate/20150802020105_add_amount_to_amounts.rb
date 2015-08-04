class AddAmountToAmounts < ActiveRecord::Migration
  def change
    add_column :amounts, :amount, :integer
  end
end
