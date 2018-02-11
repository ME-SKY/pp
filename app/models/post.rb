class Post < ApplicationRecord
  before_create :description_crop

  has_many :attachments, class_name: 'Attachment', dependent: :delete_all
  mount_uploader :file, AttachmentUploader

  def description_crop
    if text.length > 181
      self.description = text.slice(0, 180) + '...'
    else
      text
    end
  end

  def header_img
    attachments.last.file
  end
end
