require "rails_helper"

module Documents
  RSpec.describe CheckboxValue, type: :model do
    describe "validations" do
      it "requires a boolean value when the field is required" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @section = @form.sections.first
        @checkbox_field = @section.field_values.create! type: "Documents::CheckboxValue", name: "terms_accepted", description: "Terms Accepted", required: true

        @checkbox_field.value = nil
        @checkbox_field.valid?(:update)
        expect(@checkbox_field.errors).to include :value

        @checkbox_field.value = true
        @checkbox_field.valid?(:update)
        expect(@checkbox_field.errors[:value]).to be_empty

        @checkbox_field.value = false
        @checkbox_field.valid?(:update)
        expect(@checkbox_field.errors[:value]).to be_empty
      end

      it "does not require a value when the field is not required" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @section = @form.sections.first
        @checkbox_field = @section.field_values.create! type: "Documents::CheckboxValue", name: "newsletter", description: "Subscribe to Newsletter", required: false

        @checkbox_field.value = nil
        @checkbox_field.valid?(:update)
        expect(@checkbox_field.errors[:value]).to be_empty
      end

      it "accepts boolean values" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @section = @form.sections.first
        @checkbox_field = @section.field_values.create! type: "Documents::CheckboxValue", name: "active", description: "Active", required: true

        @checkbox_field.value = true
        expect(@checkbox_field.value).to be true

        @checkbox_field.value = false
        expect(@checkbox_field.value).to be false
      end

      it "converts string values to booleans" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @section = @form.sections.first
        @checkbox_field = @section.field_values.create! type: "Documents::CheckboxValue", name: "active", description: "Active"

        @checkbox_field.value = "true"
        expect(@checkbox_field.value).to be true

        @checkbox_field.value = "false"
        expect(@checkbox_field.value).to be false

        @checkbox_field.value = "f"
        expect(@checkbox_field.value).to be false

        @checkbox_field.value = "true"
        expect(@checkbox_field.value).to be true

        @checkbox_field.value = "t"
        expect(@checkbox_field.value).to be true

        @checkbox_field.value = "1"
        expect(@checkbox_field.value).to be true

        @checkbox_field.value = "0"
        expect(@checkbox_field.value).to be false
      end
    end

    describe "default values" do
      it "uses boolean default value when no value is provided" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @section = @form.sections.first
        @checkbox_field = @section.field_values.create! type: "Documents::CheckboxValue", name: "active", description: "Active", default_value: "true"

        expect(@checkbox_field.value).to be true
      end

      it "handles string boolean default values" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @section = @form.sections.first

        @yes_field = @section.field_values.create! type: "Documents::CheckboxValue", name: "yes_field", description: "Yes Field", default_value: "yes"
        expect(@yes_field.value).to be true

        @no_field = @section.field_values.create! type: "Documents::CheckboxValue", name: "no_field", description: "No Field", default_value: "no"
        expect(@no_field.value).to be false

        @true_field = @section.field_values.create! type: "Documents::CheckboxValue", name: "true_field", description: "True Field", default_value: "true"
        expect(@true_field.value).to be true

        @false_field = @section.field_values.create! type: "Documents::CheckboxValue", name: "false_field", description: "False Field", default_value: "false"
        expect(@false_field.value).to be false

        @one_field = @section.field_values.create! type: "Documents::CheckboxValue", name: "one_field", description: "One Field", default_value: "1"
        expect(@one_field.value).to be true

        @zero_field = @section.field_values.create! type: "Documents::CheckboxValue", name: "zero_field", description: "Zero Field", default_value: "0"
        expect(@zero_field.value).to be false
      end

      it "overrides the default value when a value is provided" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @section = @form.sections.first
        @checkbox_field = @section.field_values.create! type: "Documents::CheckboxValue", name: "active", description: "Active", default_value: "true", value: false

        expect(@checkbox_field.value).to be false
      end

      it "handles nil default value" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @section = @form.sections.first
        @checkbox_field = @section.field_values.create! type: "Documents::CheckboxValue", name: "active", description: "Active", default_value: nil

        expect(@checkbox_field.value).to be_nil
      end
    end
  end
end
