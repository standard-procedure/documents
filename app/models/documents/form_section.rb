module Documents
  class FormSection < ApplicationRecord
    belongs_to :form, inverse_of: :sections
    positioned on: :form
    has_many :field_values, -> { order :position }, inverse_of: :section, dependent: :destroy
    after_create :build_field_values
    accepts_nested_attributes_for :field_values
    validates_associated :field_values

    def path = [form.path, position.to_s].join("/")

    private def build_field_values
      form.field_templates.each do |field_config|
        field_values.create! attributes_from(field_config)
      end
    end

    private def attributes_from(field_config) = field_config.merge(type: field_config.delete("field_type"))
  end
end
