module Documents
  class UrlValue < TextValue
    validates :value, format: {with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), message: :invalid_url}, on: :update, allow_blank: true
  end
end
