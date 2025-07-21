module Documents
  class PhoneValue < TextValue
    validates :value, format: {with: /\A[\+\-\(\)\s\d\.]+\z/, message: :invalid_phone}, on: :update, allow_blank: true
  end
end
