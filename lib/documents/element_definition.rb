module Documents
  ElementDefinitionSchema = Dry::Schema.Params do
    required(:element).filled(:string, included_in?: %w[paragraph form])
    optional(:description).maybe(:string)
    optional(:contents).filled(:string)
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
  end
end
