module Documents
  class SignatureValue < FieldValue
    has_attribute :value, :string
    validates :value, presence: true, on: :update, if: -> { required? }
  end
end
