class CreateFlyBuysCards < ActiveRecord::Migration[5.2]
  def change
    create_table :fly_buys_cards do |t|
      t.string :number
      t.decimal :balance, precision: 8, scale: 2
      t.belongs_to :member, index: true
      t.timestamps
    end
  end
end
