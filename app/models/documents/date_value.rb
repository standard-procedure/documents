module Documents
  class DateValue < FieldValue
    has_attribute :value, :date
    validates :value, presence: true, on: :update, if: -> { required? }
  end
end
