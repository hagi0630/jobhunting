class AddColumnMemoToCompanies < ActiveRecord::Migration[5.2]
  def change
    add_column :companies, :memo, :text
  end
end
