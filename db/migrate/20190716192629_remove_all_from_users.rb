class RemoveAllFromUsers < ActiveRecord::Migration[5.2]
  def change
    # remove_column :users, :name, :string
    # remove_column :users, :tokens, :text
    # remove_column :users, :provider, :string
    # remove_column :users, :uid, :string
    remove_column :users, :unconfirmed_email, :string
    remove_column :users, :confirmation_sent_at, :datetime
    remove_column :users, :confirmed_at, :datetime
    remove_column :users, :confirmation_token, :string
  end
end
