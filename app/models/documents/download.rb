module Documents
  class Download < Element
    validate :file_is_attached

    private def file_is_attached
      errors.add :file, :blank unless file.attached?
    end
  end
end
