module Documents
  class FieldValue < ApplicationRecord
    belongs_to :section
    positioned on: :section
    attribute :value
  end
end
