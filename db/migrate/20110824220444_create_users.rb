class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string    :email,               :null => false
      t.string    :persistence_token,   :null => false
      t.datetime  :current_login_at
      t.datetime  :last_login_at
      t.string    :current_login_ip
      t.string    :last_login_ip
      t.timestamps
    end

    add_index :users, ["email"], :name => "index_users_on_email", :unique => true
    add_index :users, ["persistence_token"], :name => "index_users_on_persistence_token", :unique => true

  end

  def self.down
    drop_table :users
  end
end