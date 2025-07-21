module Documents::Container
  extend ActiveSupport::Concern

  included do
    has_many :elements, -> { order :position }, class_name: "Documents::Element", as: :container, dependent: :destroy
  end

  def load_elements_from configuration
    elements_from(configuration).select do |config|
      %w[paragraph form].include? config[:element]
    end.collect do |config|
      send :"create_#{config[:element]}_from", config.except(:element)
    end
  end

  private def create_paragraph_from(config) = elements.create!(config.merge(type: "Documents::Paragraph", position: :last))

  private def create_form_from(config) = elements.create!(config.merge(type: "Documents::Form", position: :last, field_templates: config.delete(:fields)))

  private def elements_from configuration
    Documents::DocumentDefinition.new.call(configuration).tap do |result|
      raise ArgumentError.new(result.errors.to_h.to_json) if result.errors.any?
    end.values["elements"]
  end
end
