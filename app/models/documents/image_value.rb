module Documents
  class ImageValue < FileValue
    validate :files_are_images, if: -> { files.attached? }, on: :update

    private def files_are_images
      errors.add :files, :invalid unless files.all?(&:image?)
    end
  end
end
