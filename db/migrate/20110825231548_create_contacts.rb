class CreateContacts < ActiveRecord::Migration
  def self.up
    create_table :contacts do |t|

      t.string    :email,               :null => false
      t.string	  :name,				:null => false
      t.integer	  :user_id				
      t.timestamps
    end
  end

  def self.down
    drop_table :contacts
  end
end
