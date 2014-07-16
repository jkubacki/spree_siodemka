class AddSiodemkaNumberToSpreeAdress < ActiveRecord::Migration
  def change
    add_column :spree_addresses, :siodemka_number, :integer
  end
end
