module Documents
  class Image < Element
    validates :url, presence: true, format: URI::DEFAULT_PARSER.make_regexp
  end
end
