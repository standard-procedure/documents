module Documents
  class FormSection < ApplicationRecord
    belongs_to :form, inverse_of: :sections
    positioned on: :form
    has_many :field_values, -> { order :position }, inverse_of: :section, dependent: :destroy
  end
end
