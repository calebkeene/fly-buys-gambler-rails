class AddAccountPasswordToMember < ActiveRecord::Migration[5.2]
  def change
    add_column :members, :encrypted_password, :string
  end
end
