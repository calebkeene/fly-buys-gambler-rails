class ChangeFlyBuysCardsBalanceFromMoneyToPoints < ActiveRecord::Migration[5.2]
  def change
    change_column :fly_buys_cards, :balance, :integer, default: 0
  end
end
