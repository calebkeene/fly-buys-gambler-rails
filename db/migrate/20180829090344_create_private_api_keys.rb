class CreatePrivateApiKeys < ActiveRecord::Migration[5.2]
  def change
    create_table :private_api_keys do |t|
      t.string :value

      t.timestamps
    end
  end
end
