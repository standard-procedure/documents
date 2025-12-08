module Documents
  module Types
    include Dry::Types()
  end

  OptionsValue = Dry::Schema.Params do
    required(:key).filled(:string)
    required(:value).filled(:string)
    optional(:colour).filled(:string).value(format?: /^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$/)
    optional(:score).filled(:float)
    optional(:configuration).maybe(:hash)
  end

  FieldDefinitionSchema = Dry::Schema.Params do
    required(:name).filled(:string)
    required(:description).filled(:string)
    required(:field_type).filled(included_in?: %w[Documents::CheckboxValue Documents::DateValue Documents::DateTimeValue Documents::DecimalValue Documents::EmailValue Documents::FileValue Documents::LocationValue Documents::ImageValue Documents::DataValue Documents::MultiSelectValue Documents::NumberValue Documents::PhoneValue Documents::RichTextValue Documents::SelectValue Documents::TextValue Documents::TimeValue Documents::UrlValue Documents::SignatureValue Documents::YesNoValue])
    required(:required).filled(:bool)
    optional(:allow_comments).filled(:bool)
    optional(:allow_attachments).filled(:bool)
    optional(:allow_tasks).filled(:bool)
    optional(:default_value).maybe(:string)
    optional(:display_style).filled(:string)
    optional(:options).maybe(:hash)
    optional(:option_values).array(OptionsValue)
    optional(:data_class).filled(:string)
    optional(:configuration).maybe(:hash)
  end

  class FieldDefinition < Dry::Validation::Contract
    params(FieldDefinitionSchema)

    rule(:option_values) do
      key.failure(:blank) if %w[Documents::SelectValue].include?(values[:field_type]) && values[:option_values].empty?
    end

    rule(:options) do
      key.failure(:blank) if %w[Documents::MultiSelectValue].include?(values[:field_type]) && values[:options].empty?
    end

    rule(:display_style) do
      key.failure(:invalid) if %w[Documents::SelectValue].include?(values[:field_type]) && !values[:display_style].empty? && !%w[select buttons].include?(values[:display_style])
    end
  end
end
