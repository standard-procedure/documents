module Documents
  class Video < Element
    attribute :url, :string, default: ""
    validates :url, presence: true, format: /\A#{URI::RFC2396_REGEXP::PATTERN::ABS_URI}\Z/o

    # override Element's automatic URL attachment
    private def attach_file = nil
  end
end
