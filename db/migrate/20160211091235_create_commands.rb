class CreateCommands < ActiveRecord::Migration
  def change
    create_table :commands do |t|
      t.string :line

      t.timestamps null: false
    end
  end
end