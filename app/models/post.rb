class Post < ApplicationRecord
  before_create :set_description

  has_many :attachments, class_name: 'Attachment', dependent: :delete_all
  mount_uploader :file, AttachmentUploader

  def set_description
    self.description_image ||= 'catbug.gif'

    # if text.length > 181
    #   self.description = text.slice(0, 180) + '...'
    # else
    #   self.description = text
    # end
  end

  def header_img
    attachments.last.file if attachments.present?
  end

end
