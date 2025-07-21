require "rails_helper"

module Documents
  RSpec.describe MultiSelectValue, type: :model do
    describe "validation" do
      it "requires a value when field is required" do
        container = OrderForm.create!
        form = container.elements.create!(type: "Documents::Form", description: "Test Form")
        section = form.sections.first
        field = section.field_values.create!(type: "Documents::MultiSelectValue", name: "tags", description: "Order Tags", required: true, options: {"urgent" => "Urgent", "fragile" => "Fragile"})

        field.value = []
        field.valid?(:update)

        expect(field.errors[:value]).to include("Required")
      end

      it "does not require a value when field is not required" do
        container = OrderForm.create!
        form = container.elements.create!(type: "Documents::Form", description: "Test Form")
        section = form.sections.first
        field = section.field_values.create!(type: "Documents::MultiSelectValue", name: "tags", description: "Optional Tags", required: false, options: {"urgent" => "Urgent", "fragile" => "Fragile"})

        field.value = []
        field.valid?(:update)

        expect(field.errors[:value]).to be_empty
      end

      it "accepts valid option keys" do
        container = OrderForm.create!
        form = container.elements.create!(type: "Documents::Form", description: "Test Form")
        section = form.sections.first
        field = section.field_values.create!(type: "Documents::MultiSelectValue", name: "tags", description: "Order Tags", options: {"urgent" => "Urgent", "fragile" => "Fragile", "heavy" => "Heavy"})

        field.value = ["urgent", "fragile"]
        field.valid?(:update)

        expect(field.errors[:value]).to be_empty
      end

      it "rejects invalid option keys" do
        container = OrderForm.create!
        form = container.elements.create!(type: "Documents::Form", description: "Test Form")
        section = form.sections.first
        field = section.field_values.create!(type: "Documents::MultiSelectValue", name: "tags", description: "Order Tags", options: {"urgent" => "Urgent", "fragile" => "Fragile"})

        field.value = ["urgent", "invalid"]
        field.valid?(:update)

        expect(field.errors[:value]).to include("Invalid option")
      end

      it "accepts single valid option key" do
        container = OrderForm.create!
        form = container.elements.create!(type: "Documents::Form", description: "Test Form")
        section = form.sections.first
        field = section.field_values.create!(type: "Documents::MultiSelectValue", name: "tags", description: "Order Tags", options: {"urgent" => "Urgent", "fragile" => "Fragile"})

        field.value = ["urgent"]
        field.valid?(:update)

        expect(field.errors[:value]).to be_empty
      end
    end

    describe "default values" do
      it "uses default value array when no value is provided" do
        container = OrderForm.create!
        form = container.elements.create!(type: "Documents::Form", description: "Test Form")
        section = form.sections.first
        field = section.field_values.create!(type: "Documents::MultiSelectValue", name: "tags", description: "Order Tags", options: {"urgent" => "Urgent", "fragile" => "Fragile"}, default_value: '["urgent"]')

        expect(field.value).to eq(["urgent"])
      end

      it "converts single default value to array" do
        container = OrderForm.create!
        form = container.elements.create!(type: "Documents::Form", description: "Test Form")
        section = form.sections.first
        field = section.field_values.create!(type: "Documents::MultiSelectValue", name: "tags", description: "Order Tags", options: {"urgent" => "Urgent", "fragile" => "Fragile"}, default_value: "urgent")

        expect(field.value).to eq(["urgent"])
      end

      it "validates default values are in options" do
        container = OrderForm.create!
        form = container.elements.create!(type: "Documents::Form", description: "Test Form")
        section = form.sections.first
        field = section.field_values.build(type: "Documents::MultiSelectValue", name: "tags", description: "Order Tags", options: {"urgent" => "Urgent", "fragile" => "Fragile"}, default_value: '["invalid"]')

        field.valid?

        expect(field.errors[:default_value]).to include("Invalid default option")
      end

      it "allows valid default values" do
        container = OrderForm.create!
        form = container.elements.create!(type: "Documents::Form", description: "Test Form")
        section = form.sections.first
        field = section.field_values.build(type: "Documents::MultiSelectValue", name: "tags", description: "Order Tags", options: {"urgent" => "Urgent", "fragile" => "Fragile"}, default_value: '["urgent", "fragile"]')

        field.valid?

        expect(field.errors[:default_value]).to be_empty
      end
    end

    describe "to_s method" do
      it "returns comma-separated display values for selected options" do
        container = OrderForm.create!
        form = container.elements.create!(type: "Documents::Form", description: "Test Form")
        section = form.sections.first
        field = section.field_values.create!(type: "Documents::MultiSelectValue", name: "tags", description: "Order Tags", options: {"urgent" => "Rush Order", "fragile" => "Handle with Care", "heavy" => "Heavy Item"})

        field.value = ["urgent", "fragile"]

        expect(field.to_s).to eq("Rush Order, Handle with Care")
      end

      it "returns single display value for single selection" do
        container = OrderForm.create!
        form = container.elements.create!(type: "Documents::Form", description: "Test Form")
        section = form.sections.first
        field = section.field_values.create!(type: "Documents::MultiSelectValue", name: "tags", description: "Order Tags", options: {"urgent" => "Rush Order"})

        field.value = ["urgent"]

        expect(field.to_s).to eq("Rush Order")
      end

      it "returns keys when no matching options found" do
        container = OrderForm.create!
        form = container.elements.create!(type: "Documents::Form", description: "Test Form")
        section = form.sections.first
        field = section.field_values.create!(type: "Documents::MultiSelectValue", name: "tags", description: "Order Tags", options: {})

        field.value = ["unknown", "other"]

        expect(field.to_s).to eq("unknown, other")
      end

      it "returns empty string when value is empty" do
        container = OrderForm.create!
        form = container.elements.create!(type: "Documents::Form", description: "Test Form")
        section = form.sections.first
        field = section.field_values.create!(type: "Documents::MultiSelectValue", name: "tags", description: "Order Tags", options: {"urgent" => "Rush Order"})

        field.value = []

        expect(field.to_s).to eq("")
      end

      it "returns empty string when value is nil" do
        container = OrderForm.create!
        form = container.elements.create!(type: "Documents::Form", description: "Test Form")
        section = form.sections.first
        field = section.field_values.create!(type: "Documents::MultiSelectValue", name: "tags", description: "Order Tags", options: {"urgent" => "Rush Order"})

        field.value = nil

        expect(field.to_s).to eq("")
      end
    end
  end
end
