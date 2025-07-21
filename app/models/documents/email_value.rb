module Documents
  class EmailValue < TextValue
    validates :value, format: {with: URI::MailTo::EMAIL_REGEXP, message: :invalid_email}, on: :update, allow_blank: true
  end
end
