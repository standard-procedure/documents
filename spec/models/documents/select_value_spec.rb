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

      it "accepts a valid value" do
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

    describe "display style" do
      it "defaults to select" do
        container = OrderForm.create!
        form = container.elements.create!(type: "Documents::Form", description: "Test Form")
        section = form.sections.first
        field = section.field_values.create!(type: "Documents::SelectValue", name: "status", description: "Order Status", options: {"pending" => "Pending Order"})

        expect(field.display_style).to eq "select"
      end

      it "allows select or buttons as styles" do
        container = OrderForm.create!
        form = container.elements.create!(type: "Documents::Form", description: "Test Form")
        section = form.sections.first
        field = section.field_values.new(type: "Documents::SelectValue", name: "status", description: "Order Status", display_style: "select", options: {"pending" => "Pending Order"})
        field.validate
        expect(field.errors).to_not include :display_style

        field.display_style = "buttons"
        field.validate
        expect(field.errors).to_not include :display_style

        field.display_style = "something_else"
        field.validate
        expect(field.errors).to include :display_style
      end
    end

    describe "scoring" do
      it "uses the selected value as the score" do
        container = OrderForm.create!
        form = container.elements.create!(type: "Documents::Form", description: "Test Form")
        section = form.sections.first
        field = section.field_values.create!(type: "Documents::SelectValue", name: "status", description: "Order Status", options: {"0" => "Zero", "1.1" => "One", "2.2" => "Two"}, default_value: "0")

        expect(field.score).to eq 0.0
        field.value = "1.1"
        expect(field.score).to eq 1.1
        field.value = "2.2"
        expect(field.score).to eq 2.2
      end
    end
  end
end
