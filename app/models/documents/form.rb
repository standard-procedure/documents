module Documents
  class Form < Element
    enum :section_type, {static: 0, repeating: 1}, prefix: true
    enum :display_type, {form: 0, table: 1}, prefix: true
    enum :form_submission_status, draft: 0, submitted: 1, cancelled: -1

    has_many :sections, -> { order :position }, class_name: "FormSection", dependent: :destroy
    has_attribute :field_template, :json, default: []
    after_save :create_first_section, if: -> { sections.empty? }

    def add_section
      sections.create!(position: :last).tap { |new_section| populate_section_fields(new_section) } if section_type_repeating?
    end

    def remove_section
      sections.last.destroy if section_type_repeating? && sections.size > 1
    end

    private def create_first_section = sections.create!

    private def populate_section_fields(section)
      field_template.each do |field_config|
        attributes = {
          type: field_config["field_type"],
          name: field_config["name"],
          description: field_config["description"],
          required: field_config["required"] || false,
          position: :last
        }

        attributes[:default_value] = field_config["default_value"] if field_config["default_value"].present?
        attributes[:options] = field_config["options"] if field_config["options"].present?

        section.field_values.create!(attributes)
      end
    end
  end
end
