class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.string :theme
      t.string :text
      t.timestamps
    end
  end
end
