class AddMinPaymentToLoans < ActiveRecord::Migration[5.1]
  def change
    add_column :loans, :monthly_min_payment, :float
  end
end
