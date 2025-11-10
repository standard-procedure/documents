module Documents
  ElementDefinitionSchema = Dry::Schema.Params do
    required(:element).filled(:string, included_in?: %w[paragraph form download image video pdf])
    optional(:description).maybe(:string)
    optional(:contents).filled(:string)
    optional(:url).filled(:string).value(format?: URI::DEFAULT_PARSER.make_regexp)
    optional(:filename).filled(:string)
    optional(:section_type).filled(:string, included_in?: %w[static repeating])
    optional(:display_type).filled(:string, included_in?: %w[form table])
    optional(:fields).array(Documents::FieldDefinitionSchema)
  end

  class ElementDefinition < Dry::Validation::Contract
    params(ElementDefinitionSchema)

    rule :contents do
      key.failure(:blank) if (values[:element] == "paragraph") && values[:contents].blank?
    end
    rule :section_type do
      key.failure(:blank) if (values[:element] == "form") && values[:section_type].blank?
    end
    rule :display_type do
      key.failure(:blank) if (values[:element] == "form") && values[:display_type].blank?
    end
    rule :fields do
      key.failure(:blank) if (values[:element] == "form") && values[:fields].empty?
    end
    rule :url do
      key.failure(:blank) if REQUIRE_URL.include?(values[:element]) && values[:url].empty?
    end
    rule :filename do
      key.failure(:blank) if REQUIRE_URL.include?(values[:element]) && values[:filename].empty?
    end
  end

  REQUIRE_URL = %w[download image video pdf].freeze
end
