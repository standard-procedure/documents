require "rails_helper"

module Documents
  RSpec.describe SelectValue, type: :model do
    describe "validation" do
      it "requires a value when field is required" do
        container = OrderForm.create!
        form = container.elements.create! type: "Documents::Form", description: "Test Form"
        section = form.sections.first
        field = section.field_values.create! type: "Documents::SelectValue", name: "status", description: "Order Status", required: true, option_values: [{key: "pending", value: "Pending", colour: "#999999", score: 0}, {key: "shipped", value: "Shipped", colour: "#009900", score: 100}]

        field.value = ""
        field.valid?(:update)

        expect(field.errors[:value]).to include("Required")
      end

      it "does not require a value when field is not required" do
        container = OrderForm.create!
        form = container.elements.create! type: "Documents::Form", description: "Test Form"
        section = form.sections.first
        field = section.field_values.create! type: "Documents::SelectValue", name: "priority", description: "Optional Priority", required: false, option_values: [{key: "pending", value: "Pending", colour: "#999999", score: 0}, {key: "shipped", value: "Shipped", colour: "#009900", score: 100}]

        field.value = ""
        field.valid?(:update)

        expect(field.errors[:value]).to be_empty
      end

      it "accepts a valid value" do
        container = OrderForm.create!
        form = container.elements.create! type: "Documents::Form", description: "Test Form"
        section = form.sections.first
        field = section.field_values.create! type: "Documents::SelectValue", name: "status", description: "Order Status", option_values: [{key: "pending", value: "Pending", colour: "#999999", score: 0}, {key: "shipped", value: "Shipped", colour: "#009900", score: 100}]

        field.value = "pending"
        field.valid?(:update)

        expect(field.errors[:value]).to be_empty
      end

      it "rejects invalid option key" do
        container = OrderForm.create!
        form = container.elements.create! type: "Documents::Form", description: "Test Form"
        section = form.sections.first
        field = section.field_values.create! type: "Documents::SelectValue", name: "status", description: "Order Status", option_values: [{key: "pending", value: "Pending", colour: "#999999", score: 0}, {key: "shipped", value: "Shipped", colour: "#009900", score: 100}]

        field.value = "invalid"
        field.valid?(:update)

        expect(field.errors[:value]).to include("Invalid option")
      end
    end

    describe "default values" do
      it "uses default value when no value is provided" do
        container = OrderForm.create!
        form = container.elements.create! type: "Documents::Form", description: "Test Form"
        section = form.sections.first
        field = section.field_values.create! type: "Documents::SelectValue", name: "status", description: "Order Status", option_values: [{key: "pending", value: "Pending", colour: "#999999", score: 0}, {key: "shipped", value: "Shipped", colour: "#009900", score: 100}], default_value: "pending"

        expect(field.value).to eq("pending")
      end

      it "validates default value is in options" do
        container = OrderForm.create!
        form = container.elements.create! type: "Documents::Form", description: "Test Form"
        section = form.sections.first
        field = section.field_values.build type: "Documents::SelectValue", name: "status", description: "Order Status", option_values: [{key: "pending", value: "Pending", colour: "#999999", score: 0}, {key: "shipped", value: "Shipped", colour: "#009900", score: 100}], default_value: "invalid"

        field.valid?

        expect(field.errors[:default_value]).to include("Invalid default option")
      end

      it "allows valid default value" do
        container = OrderForm.create!
        form = container.elements.create! type: "Documents::Form", description: "Test Form"
        section = form.sections.first
        field = section.field_values.build type: "Documents::SelectValue", name: "status", description: "Order Status", option_values: [{key: "pending", value: "Pending", colour: "#999999", score: 0}, {key: "shipped", value: "Shipped", colour: "#009900", score: 100}], default_value: "pending"

        field.valid?

        expect(field.errors[:default_value]).to be_empty
      end
    end

    describe "to_s method" do
      it "returns the display value for selected option" do
        container = OrderForm.create!
        form = container.elements.create! type: "Documents::Form", description: "Test Form"
        section = form.sections.first
        field = section.field_values.create! type: "Documents::SelectValue", name: "status", description: "Order Status", option_values: [{key: "pending", value: "Pending Order", colour: "#999999", score: 0}, {key: "shipped", value: "Shipped", colour: "#009900", score: 100}]

        field.value = "pending"

        expect(field.to_s).to eq("Pending Order")
      end

      it "returns the key when no matching option found" do
        container = OrderForm.create!
        form = container.elements.create! type: "Documents::Form", description: "Test Form"
        section = form.sections.first
        field = section.field_values.create! type: "Documents::SelectValue", name: "status", description: "Order Status", option_values: [{key: "pending", value: "Pending", colour: "#999999", score: 0}, {key: "shipped", value: "Shipped", colour: "#009900", score: 100}]

        field.value = "unknown"

        expect(field.to_s).to eq("unknown")
      end

      it "returns empty string when value is nil" do
        container = OrderForm.create!
        form = container.elements.create! type: "Documents::Form", description: "Test Form"
        section = form.sections.first
        field = section.field_values.create! type: "Documents::SelectValue", name: "status", description: "Order Status", option_values: [{key: "pending", value: "Pending", colour: "#999999", score: 0}]

        field.value = nil

        expect(field.to_s).to eq("")
      end
    end

    describe "querying" do
      it "returns the available keys" do
        container = OrderForm.create!
        form = container.elements.create! type: "Documents::Form", description: "Test Form"
        section = form.sections.first
        field = section.field_values.create! type: "Documents::SelectValue", name: "status", description: "Order Status", required: true, option_values: [{key: "pending", value: "Pending", colour: "#999999", score: 0}, {key: "shipped", value: "Shipped", colour: "#009900", score: 100}]

        expect(field.keys).to eq ["pending", "shipped"]
      end

      it "returns the available values" do
        container = OrderForm.create!
        form = container.elements.create! type: "Documents::Form", description: "Test Form"
        section = form.sections.first
        field = section.field_values.create! type: "Documents::SelectValue", name: "status", description: "Order Status", required: true, option_values: [{key: "pending", value: "Pending", colour: "#999999", score: 0}, {key: "shipped", value: "Shipped", colour: "#009900", score: 100}]

        expect(field.values).to eq ["Pending", "Shipped"]
      end

      it "returns the selected colour" do
        container = OrderForm.create!
        form = container.elements.create! type: "Documents::Form", description: "Test Form"
        section = form.sections.first
        field = section.field_values.create! type: "Documents::SelectValue", name: "status", description: "Order Status", required: true, option_values: [{key: "pending", value: "Pending", colour: "#999999", score: 0}, {key: "shipped", value: "Shipped", colour: "#009900", score: 100}]

        field.value = "shipped"
        expect(field.colour).to eq "#009900"
      end

      it "returns the selected score" do
        container = OrderForm.create!
        form = container.elements.create! type: "Documents::Form", description: "Test Form"
        section = form.sections.first
        field = section.field_values.create! type: "Documents::SelectValue", name: "status", description: "Order Status", option_values: [{key: "pending", value: "Pending", colour: "#999999", score: 0}, {key: "packing", value: "Packing", colour: "#000099", score: 50}, {key: "shipped", value: "Shipped", colour: "#009900", score: 100}], default_value: "pending"

        expect(field.score).to eq 0.0
        field.value = "packing"
        expect(field.score).to eq 50.0
        field.value = "shipped"
        expect(field.score).to eq 100.0
      end
    end

    describe "display" do
      it "defaults to select" do
        container = OrderForm.create!
        form = container.elements.create! type: "Documents::Form", description: "Test Form"
        section = form.sections.first
        field = section.field_values.create! type: "Documents::SelectValue", name: "status", description: "Order Status", option_values: [{key: "pending", value: "Pending", colour: "#999999", score: 0}]

        expect(field.display_style).to eq "select"
      end

      it "allows select or buttons as styles" do
        container = OrderForm.create!
        form = container.elements.create! type: "Documents::Form", description: "Test Form"
        section = form.sections.first
        field = section.field_values.new type: "Documents::SelectValue", name: "status", description: "Order Status", display_style: "select", option_values: [{key: "pending", value: "Pending", colour: "#999999", score: 0}]
        field.validate
        expect(field.errors).to_not include :display_style

        field.display_style = "buttons"
        field.validate
        expect(field.errors).to_not include :display_style

        field.display_style = "something_else"
        field.validate
        expect(field.errors).to include :display_style
      end

      it "returns an array for select controls" do
        container = OrderForm.create!
        form = container.elements.create! type: "Documents::Form", description: "Test Form"
        section = form.sections.first
        field = section.field_values.create! type: "Documents::SelectValue", name: "status", description: "Order Status", required: true, option_values: [{key: "pending", value: "Pending", colour: "#999999", score: 0}, {key: "shipped", value: "Shipped", colour: "#009900", score: 100}]

        expect(field.options_for_select).to eq [["Pending", "pending"], ["Shipped", "shipped"]]
      end
    end

    describe "legacy data conversion" do
      it "converts an options hash to an array of options values" do
        container = OrderForm.create!
        form = container.elements.create! type: "Documents::Form", description: "Test Form"
        section = form.sections.first
        field = section.field_values.create! type: "Documents::SelectValue", name: "status", description: "Order Status", options: {pending: "Pending order", shipped: "Shipped"}

        expect(field.options).to be_empty
        expect(field.option_values.size).to eq 2
      end
    end
  end
end
