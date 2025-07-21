require "rails_helper"

module Documents
  RSpec.describe UrlValue, type: :model do
    describe "validations" do
      it "inherits TextValue validations for required fields" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @section = @form.sections.first
        @url_field = @section.field_values.create! type: "Documents::UrlValue", name: "website", description: "Website URL", required: true

        @url_field.value = ""
        @url_field.valid?(:update)
        expect(@url_field.errors[:value]).to include("can't be blank")

        @url_field.value = "https://example.com"
        @url_field.valid?(:update)
        expect(@url_field.errors[:value]).to be_empty
      end

      it "validates URL format" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @section = @form.sections.first
        @url_field = @section.field_values.create! type: "Documents::UrlValue", name: "website", description: "Website URL"

        @url_field.value = "not-a-url"
        @url_field.valid?(:update)
        expect(@url_field.errors[:value]).to include("must be a valid URL")

        @url_field.value = "https://example.com"
        @url_field.valid?(:update)
        expect(@url_field.errors[:value]).to be_empty

        @url_field.value = "http://www.example.com/path?param=value#section"
        @url_field.valid?(:update)
        expect(@url_field.errors[:value]).to be_empty

        @url_field.value = "https://subdomain.example-domain.co.uk/path"
        @url_field.valid?(:update)
        expect(@url_field.errors[:value]).to be_empty
      end

      it "allows blank values when not required" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @section = @form.sections.first
        @url_field = @section.field_values.create! type: "Documents::UrlValue", name: "website", description: "Website URL", required: false

        @url_field.value = ""
        @url_field.valid?(:update)
        expect(@url_field.errors[:value]).to be_empty
      end
    end

    describe "default values" do
      it "inherits default value functionality from TextValue" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @section = @form.sections.first
        @url_field = @section.field_values.create! type: "Documents::UrlValue", name: "website", description: "Website URL", default_value: "https://www.example.com"

        expect(@url_field.value).to eq "https://www.example.com"
      end
    end
  end
end
