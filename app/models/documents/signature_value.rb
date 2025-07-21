module Documents
  class SignatureValue < FieldValue
    has_attribute :value, :text
    validates :value, presence: {message: :required_signature}, on: :update, if: -> { required? }
    validates :value, format: {with: /\Adata:image\/(png|svg\+xml);base64,[A-Za-z0-9+\/]+=*\z/, message: :invalid_signature}, on: :update, allow_blank: true
  end
end
