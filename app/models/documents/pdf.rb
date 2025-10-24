module Documents
  class Pdf < Element
    validate :file_is_attached, on: :update
    validate :file_is_pdf, on: :update

    private def file_is_attached
      errors.add :file, :blank unless file.attached?
    end

    private def file_is_image
      errors.add :file, :invalid if file.attached? && !file.content_type.include?("pdf")
    end
  end
end
