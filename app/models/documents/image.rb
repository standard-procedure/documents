module Documents
  class Image < Element
    validate :file_is_attached, on: :update
    validate :file_is_image, on: :update

    private def file_is_attached
      errors.add :file, :blank unless file.attached?
    end

    private def file_is_image
      errors.add :file, :invalid if file.attached? && !file.image?
    end
  end
end
