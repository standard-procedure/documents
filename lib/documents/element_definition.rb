module Documents
  class ElementDefinition < Dry::Validation::Contract
    params do
      required(:element).filled(:string, included_in?: %w[page_break paragraph image video download form])
      required(:description).maybe(:string)
      optional(:html).filled(:string)
      rule :html do
        key.failure(:blank) if (values[:element] == "paragraph") && values[:html].blank?
      end
      optional(:url).filled(:string, format?: /\A#{URI::RFC2396_REGEXP::PATTERN::ABS_URI}\Z/o)
      optional(:section_type).filled(:string, included_in?: %w[static repeating])
      rule :section_type do
        key.failure(:blank) if (values[:element] == "form") && values[:section_type].blank?
      end
      optional(:display_type).filled(:string, included_in?: %w[form table])
      rule :display_type do
        key.failure(:blank) if (values[:element] == "form") && values[:display_type].blank?
      end
      optional(:fields).array(Documents::FieldDefinition)
      rule :fields do
        key.failure(:blank) if (values[:element] == "form") && values[:fields].empty?
      end
    end
  end
end
