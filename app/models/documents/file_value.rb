module Documents
  class FileValue < FieldValue
    def value = files
    validate :files_are_attached, on: :update, if: -> { required? }

    def has_value? = files.attached?

    def to_s = files.map(&:filename).map(&:to_s).join(", ")

    private def files_are_attached
      errors.add :files, :blank unless files.attached?
    end
  end
end
