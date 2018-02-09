class Post < ApplicationRecord
  before_create :description_crop

  has_many :attachments, class_name: 'Attachment', dependent: :delete_all

  def description_crop
    if text.length > 181
      self.description = text.slice(0, 180) + '...'
    else
      text
    end
  end
end
