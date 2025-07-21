require "rails_helper"

module Documents
  RSpec.describe DecimalValue, type: :model do
    describe "validations" do
      it "requires a value when the field is required" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @section = @form.sections.first
        @decimal_field = @section.field_values.create! type: "Documents::DecimalValue", name: "price", description: "Price", required: true

        @decimal_field.value = nil
        @decimal_field.valid?(:update)
        expect(@decimal_field.errors[:value]).to include("can't be blank")

        @decimal_field.value = 29.99
        @decimal_field.valid?(:update)
        expect(@decimal_field.errors[:value]).to be_empty
      end

      it "does not require a value when the field is not required" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @section = @form.sections.first
        @decimal_field = @section.field_values.create! type: "Documents::DecimalValue", name: "discount", description: "Optional Discount", required: false

        @decimal_field.value = nil
        @decimal_field.valid?(:update)
        expect(@decimal_field.errors[:value]).to be_empty
      end

      it "accepts decimal values" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @section = @form.sections.first
        @decimal_field = @section.field_values.create! type: "Documents::DecimalValue", name: "price", description: "Price", required: true

        @decimal_field.value = 3.14159
        @decimal_field.valid?
        expect(@decimal_field.errors[:value]).to be_empty
        expect(@decimal_field.value).to eq 3.14159

        @decimal_field.value = 42
        @decimal_field.valid?
        expect(@decimal_field.errors[:value]).to be_empty
        expect(@decimal_field.value).to eq 42.0
      end

      it "converts string values to decimals" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @section = @form.sections.first
        @decimal_field = @section.field_values.create! type: "Documents::DecimalValue", name: "price", description: "Price", required: true

        @decimal_field.value = "29.99"
        expect(@decimal_field.value).to eq 29.99

        @decimal_field.value = "42"
        expect(@decimal_field.value).to eq 42.0

        # Non-numeric strings convert to 0.0
        @decimal_field.value = "not a number"
        expect(@decimal_field.value).to eq 0.0
      end
    end

    describe "default values" do
      it "uses the default value when no value is provided" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @section = @form.sections.first
        @decimal_field = @section.field_values.create! type: "Documents::DecimalValue", name: "price", description: "Price", default_value: "19.99"

        expect(@decimal_field.value).to eq 19.99
      end

      it "overrides the default value when a value is provided" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @section = @form.sections.first
        @decimal_field = @section.field_values.create! type: "Documents::DecimalValue", name: "price", description: "Price", default_value: "19.99", value: 29.95

        expect(@decimal_field.value).to eq 29.95
      end

      it "handles nil default value" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @section = @form.sections.first
        @decimal_field = @section.field_values.create! type: "Documents::DecimalValue", name: "price", description: "Price", default_value: nil

        expect(@decimal_field.value).to be_nil
      end

      it "converts string default values to decimal" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @section = @form.sections.first
        @decimal_field = @section.field_values.create! type: "Documents::DecimalValue", name: "rate", description: "Rate", default_value: "0.075"

        expect(@decimal_field.value).to eq 0.075
      end
    end
  end
end
