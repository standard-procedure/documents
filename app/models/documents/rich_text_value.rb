module Documents
  class RichTextValue < FieldValue
    before_validation :set_default_value, if: -> { value.to_plain_text.blank? && default_value.present? }
    has_rich_text :value
    validates :value, presence: true, on: :update, if: -> { required? }

    private def set_default_value
      self.value = default_value
    end
  end
end
