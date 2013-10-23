class AddStatusIdToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :status_id, :integer, null: false, default: 0
    add_index  :tickets, :status_id
  end
end
