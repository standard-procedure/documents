module Documents
  class Form < Element
    enum :section_type, {static: 0, repeating: 1}, prefix: true
    enum :display_type, {form: 0, table: 1}, prefix: true
    enum :form_submission_status, draft: 0, submitted: 1, cancelled: -1

    has_many :sections, -> { order :position }, class_name: "FormSection", dependent: :destroy
    validates_associated :sections, on: :update
    accepts_nested_attributes_for :sections
    has_attribute :field_templates, :json, default: []
    after_save :create_first_section, if: -> { sections.empty? }

    def add_section
      sections.create!(position: :last) if section_type_repeating?
    end

    def remove_section
      sections.last.destroy if section_type_repeating? && sections.size > 1
    end

    def field_values = sections.collect(&:field_values).flatten

    private def create_first_section = sections.create!
  end
end
