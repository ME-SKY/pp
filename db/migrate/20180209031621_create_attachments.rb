class CreateAttachments < ActiveRecord::Migration[5.1]
  def change
    create_table :attachments do |t|
      t.references :post, foreign_key: true
      # t.references :message, foreign_key: true
      t.string :file
      t.integer :file_size
      t.string :content_type
      # t.datetime :trashed_at

      t.timestamps
    end
  end
end
