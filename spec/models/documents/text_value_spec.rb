require "rails_helper"

module Documents
  RSpec.describe TextValue, type: :model do
    describe "validations" do
      it "requires a value when the field is required" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @section = @form.sections.first
        @text_field = @section.field_values.create! type: "Documents::TextValue", name: "company", description: "Company Name", required: true

        @text_field.value = ""
        @text_field.valid?(:update)
        expect(@text_field.errors[:value]).to include("can't be blank")

        @text_field.value = "ACME Corp"
        @text_field.valid?(:update)
        expect(@text_field.errors[:value]).to be_empty
      end

      it "does not require a value when the field is not required" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @section = @form.sections.first
        @text_field = @section.field_values.create! type: "Documents::TextValue", name: "notes", description: "Optional Notes", required: false

        @text_field.value = ""
        @text_field.valid?(:update)
        expect(@text_field.errors[:value]).to be_empty
      end
    end

    describe "default values" do
      it "uses the default value when no value is provided" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @section = @form.sections.first
        @text_field = @section.field_values.create! type: "Documents::TextValue", name: "company", description: "Company Name", default_value: "Default Company"

        expect(@text_field.value).to eq "Default Company"
      end

      it "overrides the default value when a value is provided" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @section = @form.sections.first
        @text_field = @section.field_values.create! type: "Documents::TextValue", name: "company", description: "Company Name", default_value: "Default Company", value: "ACME Corp"

        expect(@text_field.value).to eq "ACME Corp"
      end

      it "handles nil default value" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @section = @form.sections.first
        @text_field = @section.field_values.create! type: "Documents::TextValue", name: "company", description: "Company Name", default_value: nil

        expect(@text_field.value).to be_nil
      end
    end
  end
end
