module Documents
  class Table < Element
    include Container
    attribute :column, :integer, default: 0
  end
end
