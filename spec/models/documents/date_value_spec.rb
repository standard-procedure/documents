require "rails_helper"

module Documents
  RSpec.describe DateValue, type: :model do
    describe "validations" do
      it "requires a value when the field is required" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @section = @form.sections.first
        @date_field = @section.field_values.create! type: "Documents::DateValue", name: "order_date", description: "Order Date", required: true

        @date_field.value = nil
        @date_field.valid?(:update)
        expect(@date_field.errors[:value]).to include("can't be blank")

        @date_field.value = Date.new(2024, 1, 15)
        @date_field.valid?(:update)
        expect(@date_field.errors[:value]).to be_empty
      end

      it "does not require a value when the field is not required" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @section = @form.sections.first
        @date_field = @section.field_values.create! type: "Documents::DateValue", name: "optional_date", description: "Optional Date", required: false

        @date_field.value = nil
        @date_field.valid?(:update)
        expect(@date_field.errors[:value]).to be_empty
      end
    end

    describe "default values" do
      it "uses the default value when no value is provided" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @section = @form.sections.first
        @date_field = @section.field_values.create! type: "Documents::DateValue", name: "order_date", description: "Order Date", default_value: "2024-01-01"

        expect(@date_field.value).to eq Date.new(2024, 1, 1)
      end

      it "overrides the default value when a value is provided" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @section = @form.sections.first
        @date_field = @section.field_values.create! type: "Documents::DateValue", name: "order_date", description: "Order Date", default_value: "2024-01-01", value: Date.new(2024, 12, 25)

        expect(@date_field.value).to eq Date.new(2024, 12, 25)
      end

      it "handles nil default value" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @section = @form.sections.first
        @date_field = @section.field_values.create! type: "Documents::DateValue", name: "order_date", description: "Order Date", default_value: nil

        expect(@date_field.value).to be_nil
      end
    end
  end
end
