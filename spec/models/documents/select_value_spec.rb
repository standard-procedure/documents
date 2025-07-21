require "rails_helper"

module Documents
  RSpec.describe SelectValue, type: :model do
    describe "validation" do
      it "requires a value when field is required" do
        container = OrderForm.create!
        form = container.elements.create!(type: "Documents::Form", description: "Test Form")
        section = form.sections.first
        field = section.field_values.create!(type: "Documents::SelectValue", name: "status", description: "Order Status", required: true, options: {"pending" => "Pending", "shipped" => "Shipped"})

        field.value = ""
        field.valid?(:update)

        expect(field.errors[:value]).to include("Required")
      end

      it "does not require a value when field is not required" do
        container = OrderForm.create!
        form = container.elements.create!(type: "Documents::Form", description: "Test Form")
        section = form.sections.first
        field = section.field_values.create!(type: "Documents::SelectValue", name: "priority", description: "Optional Priority", required: false, options: {"low" => "Low", "high" => "High"})

        field.value = ""
        field.valid?(:update)

        expect(field.errors[:value]).to be_empty
      end

      it "accepts valid option key" do
        container = OrderForm.create!
        form = container.elements.create!(type: "Documents::Form", description: "Test Form")
        section = form.sections.first
        field = section.field_values.create!(type: "Documents::SelectValue", name: "status", description: "Order Status", options: {"pending" => "Pending", "shipped" => "Shipped"})

        field.value = "pending"
        field.valid?(:update)

        expect(field.errors[:value]).to be_empty
      end

      it "rejects invalid option key" do
        container = OrderForm.create!
        form = container.elements.create!(type: "Documents::Form", description: "Test Form")
        section = form.sections.first
        field = section.field_values.create!(type: "Documents::SelectValue", name: "status", description: "Order Status", options: {"pending" => "Pending", "shipped" => "Shipped"})

        field.value = "invalid"
        field.valid?(:update)

        expect(field.errors[:value]).to include("Invalid option")
      end
    end

    describe "default values" do
      it "uses default value when no value is provided" do
        container = OrderForm.create!
        form = container.elements.create!(type: "Documents::Form", description: "Test Form")
        section = form.sections.first
        field = section.field_values.create!(type: "Documents::SelectValue", name: "status", description: "Order Status", options: {"pending" => "Pending", "shipped" => "Shipped"}, default_value: "pending")

        expect(field.value).to eq("pending")
      end

      it "validates default value is in options" do
        container = OrderForm.create!
        form = container.elements.create!(type: "Documents::Form", description: "Test Form")
        section = form.sections.first
        field = section.field_values.build(type: "Documents::SelectValue", name: "status", description: "Order Status", options: {"pending" => "Pending", "shipped" => "Shipped"}, default_value: "invalid")

        field.valid?

        expect(field.errors[:default_value]).to include("Invalid default option")
      end

      it "allows valid default value" do
        container = OrderForm.create!
        form = container.elements.create!(type: "Documents::Form", description: "Test Form")
        section = form.sections.first
        field = section.field_values.build(type: "Documents::SelectValue", name: "status", description: "Order Status", options: {"pending" => "Pending", "shipped" => "Shipped"}, default_value: "pending")

        field.valid?

        expect(field.errors[:default_value]).to be_empty
      end
    end

    describe "to_s method" do
      it "returns the display value for selected option" do
        container = OrderForm.create!
        form = container.elements.create!(type: "Documents::Form", description: "Test Form")
        section = form.sections.first
        field = section.field_values.create!(type: "Documents::SelectValue", name: "status", description: "Order Status", options: {"pending" => "Pending Order", "shipped" => "Order Shipped"})

        field.value = "pending"

        expect(field.to_s).to eq("Pending Order")
      end

      it "returns the key when no matching option found" do
        container = OrderForm.create!
        form = container.elements.create!(type: "Documents::Form", description: "Test Form")
        section = form.sections.first
        field = section.field_values.create!(type: "Documents::SelectValue", name: "status", description: "Order Status", options: {"pending" => "Pending Order"})

        field.value = "unknown"

        expect(field.to_s).to eq("unknown")
      end

      it "returns empty string when value is nil" do
        container = OrderForm.create!
        form = container.elements.create!(type: "Documents::Form", description: "Test Form")
        section = form.sections.first
        field = section.field_values.create!(type: "Documents::SelectValue", name: "status", description: "Order Status", options: {"pending" => "Pending Order"})

        field.value = nil

        expect(field.to_s).to eq("")
      end
    end
  end
end
