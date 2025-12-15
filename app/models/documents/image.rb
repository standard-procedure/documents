module Documents
  class Image < Element
    validates :url, presence: true, format: URI::DEFAULT_PARSER.make_regexp
    validates :filename, presence: true, format: /.*\.(png|jpg|jpeg|gif)/
  end
end
