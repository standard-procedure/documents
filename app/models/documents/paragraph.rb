module Documents
  class Paragraph < Element
    attribute :html, :string, default: ""
    validates :html, presence: true
  end
end
