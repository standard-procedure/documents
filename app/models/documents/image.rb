module Documents
  class Image < Element
    validate :file_is_attached
    validate :file_is_image

    private def file_is_attached
      errors.add :file, :blank unless file.attached?
    end

    private def file_is_image
      errors.add :file, :invalid unless file.image?
    end
  end
end
