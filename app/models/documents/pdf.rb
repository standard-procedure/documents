module Documents
  class Pdf < Element
    validates :url, presence: true, format: URI::DEFAULT_PARSER.make_regexp
    validates :filename, presence: true, format: /.*\.pdf/
  end
end
