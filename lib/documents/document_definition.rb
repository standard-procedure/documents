module Documents
  # Describes a document template, built out of multiple "elements".
  # Each element can be a paragraph or other piece of content,
  # or it could be the definition of a "form",
  # describing the questions the eventual document will contain
  # that must be answered by the end-user

  DocumentDefinitionSchema = Dry::Schema.Params do
    required(:title).filled(:string)
    required(:elements).array(Documents::ElementDefinitionSchema)
  end

  class DocumentDefinition < Dry::Validation::Contract
    params(DocumentDefinitionSchema)
  end
end
