module Documents
  class Download < Element
    validates :url, presence: true, format: URI::DEFAULT_PARSER.make_regexp
  end
end
