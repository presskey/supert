class CreateReplies < ActiveRecord::Migration
  def change
    create_table :replies do |t|
      t.integer     :author_id
      t.belongs_to  :ticket
      t.text        :response
      t.integer     :new_assignee_id
      t.integer     :new_status_id
      t.timestamps
    end
    add_index :replies, :author_id
    add_index :replies, :ticket_id
  end
end
