module Documents
  class Image < Element
    validate :file_is_attached, on: :update
    validate :file_is_image, on: :update
    has_one_attached :file do |image|
      image.variant :tiny, resize_to_limit: [64, 64]
      image.variant :thumb, resize_to_limit: [128, 128]
      image.variant :small, resize_to_limit: [256, 256]
      image.variant :medium, resize_to_limit: [512, 512]
      image.variant :large, resize_to_limit: [1024, 1024]
      image.variant :xlarge, resize_to_limit: [4096, 4096]
    end

    private def file_is_attached
      errors.add :file, :blank unless file.attached?
    end

    private def file_is_image
      errors.add :file, :invalid if file.attached? && !file.image?
    end
  end
end
