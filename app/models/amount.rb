class Amount < ActiveRecord::Base
  def default
    self.amount = 2_00
  end
end
