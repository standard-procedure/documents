module Documents
  FieldDefinitionSchema = Dry::Schema.Params do
    required(:name).filled(:string)
    required(:description).filled(:string)
    required(:field_type).filled(included_in?: %w[Documents::CheckboxValue Documents::DateValue Documents::DateTimeValue Documents::DecimalValue Documents::EmailValue Documents::FileValue Documents::LocationValue Documents::ImageValue Documents::DataValue Documents::MultiSelectValue Documents::NumberValue Documents::PhoneValue Documents::RichTextValue Documents::SelectValue Documents::TextValue Documents::TimeValue Documents::UrlValue Documents::SignatureValue])
    required(:required).filled(:bool)
    optional(:allow_comments).filled(:bool)
    optional(:allow_attachments).filled(:bool)
    optional(:allow_tasks).filled(:bool)
    optional(:default_value).maybe(:string)
    optional(:display_style).filled(:string)
    optional(:options).filled(:hash)
    optional(:data_class).filled(:string)
  end

  class FieldDefinition < Dry::Validation::Contract
    params(FieldDefinitionSchema)

    rule(:options) do
      key.failure(:blank) if %w[Documents::SelectValue Documents::MultiSelectValue].include?(values[:field_type]) && values[:options].empty?
    end
    rule(:display_style) do
      key.failure(:invalid) if %w[Documents::SelectValue].include?(values[:field_type]) && !values[:display_style].empty? && !%w[drop_down buttons].include?(values[:display_style])
    end
  end
end
