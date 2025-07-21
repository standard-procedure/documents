module Documents
  FieldDefinitionSchema = Dry::Schema.Params do
    required(:name).filled(:string)
    required(:caption).filled(:string)
    required(:description).filled(:string)
    required(:field_type).filled(included_in?: %w[Documents::CheckboxValue Documents::DateValue Documents::DateTimeValue Documents::DecimalValue Documents::EmailValue Documents::FileValue Documents::ImageValue Documents::ModelValue Documents::MultiSelectValue Documents::NumberValue Documents::PhoneValue Documents::RichTextValue Documents::SelectValue Documents::TextValue Documents::TimeValue Documents::UrlValue, Documents::SignatureValue])
    required(:required).filled(:bool)
    required(:allow_comments).filled(:bool)
    required(:allow_attachments).filled(:bool)
    required(:allow_tasks).filled(:bool)
    optional(:default_value).maybe(:string)
    optional(:options).filled(:hash)
  end

  class FieldDefinition < Dry::Validation::Contract
    params(FieldDefinitionSchema)

    rule(:options) do
      key.failure(:blank) if %w[Documents::SelectValue Documents::MultiSelectValue].include?(values[:field_type]) && values[:options].empty?
    end
  end
end
