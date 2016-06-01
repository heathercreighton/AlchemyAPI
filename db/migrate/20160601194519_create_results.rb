class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.string :target
      t.string :urltext
      t.string :url
      t.string :senttype
      t.float :score

      t.timestamps null: false
    end
  end
end
