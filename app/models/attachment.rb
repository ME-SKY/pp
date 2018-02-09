# require

class Attachment < ApplicationRecord
  FILE_SIZE_LIMIT = 50.megabytes.to_i

  belongs_to :post, optional: true
  mount_uploader :file, AttachmentUploader
  validates :file, file_size: {maximum: FILE_SIZE_LIMIT}
end