class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.string      :reference
      t.string      :client_name
      t.string      :client_email
      t.belongs_to  :department
      t.string      :subject
      t.text        :body
      t.timestamps
    end

    add_index :tickets, :reference, unique: true
    add_index :tickets, :department_id
  end
end
