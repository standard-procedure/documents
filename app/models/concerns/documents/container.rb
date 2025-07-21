module Documents::Container
  extend ActiveSupport::Concern

  included do
    has_many :elements, -> { order :position }, class_name: "Documents::Element", as: :container, dependent: :destroy
  end

  def load_elements_from configuration
    result = Documents::DocumentDefinition.new.call(configuration)
    raise ArgumentError.new(result.errors.to_h.to_json) if result.errors.any?

    configuration["elements"].each do |element_config|
      case element_config["element"]
      when "paragraph"
        elements.create!(
          type: "Documents::Paragraph",
          position: :last,
          html: element_config["html"],
          description: element_config["description"] || ""
        )
      when "form"
        form = elements.create!(
          type: "Documents::Form",
          position: :last,
          section_type: element_config["section_type"],
          display_type: element_config["display_type"],
          description: element_config["description"] || ""
        )

        # Create field values for the first section
        section = form.sections.first
        element_config["fields"]&.each do |field_config|
          section.field_values.create!(
            type: field_config["field_type"],
            name: field_config["name"],
            description: field_config["description"],
            required: field_config["required"] || false,
            position: :last
          )
        end
      end
    end
  end
end
