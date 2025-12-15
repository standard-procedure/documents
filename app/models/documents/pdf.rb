module Documents
  class Pdf < Element
    validates :url, presence: true, format: URI::DEFAULT_PARSER.make_regexp
  end
end
