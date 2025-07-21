require "rails_helper"

module Documents
  RSpec.describe NumberValue, type: :model do
    describe "validations" do
      it "requires a value when the field is required" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @section = @form.sections.first
        @number_field = @section.field_values.create! type: "Documents::NumberValue", name: "quantity", description: "Quantity", required: true

        @number_field.value = nil
        @number_field.valid?(:update)
        expect(@number_field.errors[:value]).to include("can't be blank")

        @number_field.value = 42
        @number_field.valid?(:update)
        expect(@number_field.errors[:value]).to be_empty
      end

      it "does not require a value when the field is not required" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @section = @form.sections.first
        @number_field = @section.field_values.create! type: "Documents::NumberValue", name: "optional_count", description: "Optional Count", required: false

        @number_field.value = nil
        @number_field.valid?(:update)
        expect(@number_field.errors[:value]).to be_empty
      end

      it "converts string values to integers" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @section = @form.sections.first
        @number_field = @section.field_values.create! type: "Documents::NumberValue", name: "quantity", description: "Quantity", required: true

        @number_field.value = "3.14"
        expect(@number_field.value).to eq 3

        @number_field.value = "42"
        expect(@number_field.value).to eq 42
      end
    end

    describe "default values" do
      it "uses the default value when no value is provided" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @section = @form.sections.first
        @number_field = @section.field_values.create! type: "Documents::NumberValue", name: "quantity", description: "Quantity", default_value: "10"

        expect(@number_field.value).to eq 10
      end

      it "overrides the default value when a value is provided" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @section = @form.sections.first
        @number_field = @section.field_values.create! type: "Documents::NumberValue", name: "quantity", description: "Quantity", default_value: "10", value: 25

        expect(@number_field.value).to eq 25
      end

      it "handles nil default value" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @section = @form.sections.first
        @number_field = @section.field_values.create! type: "Documents::NumberValue", name: "quantity", description: "Quantity", default_value: nil

        expect(@number_field.value).to be_nil
      end
    end
  end
end
