require "rails_helper"

module Documents
  RSpec.describe SignatureValue, type: :model do
    describe "validation" do
      it "requires a signature when field is required" do
        container = OrderForm.create!
        form = container.elements.create!(type: "Documents::Form", description: "Test Form")
        section = form.sections.first
        field = section.field_values.create!(type: "Documents::SignatureValue", name: "signature", description: "User Signature", required: true)

        field.value = ""
        field.valid?(:update)

        expect(field.errors[:value]).to include("Required signature")
      end

      it "accepts valid PNG signature data URL" do
        container = OrderForm.create!
        form = container.elements.create!(type: "Documents::Form", description: "Test Form")
        section = form.sections.first
        field = section.field_values.create!(type: "Documents::SignatureValue", name: "signature", description: "User Signature")
        valid_signature = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChAI9jU77zwAAAABJRU5ErkJggg=="

        field.value = valid_signature
        field.valid?(:update)

        expect(field.errors[:value]).to be_empty
      end

      it "accepts valid SVG signature data URL" do
        container = OrderForm.create!
        form = container.elements.create!(type: "Documents::Form", description: "Test Form")
        section = form.sections.first
        field = section.field_values.create!(type: "Documents::SignatureValue", name: "signature", description: "User Signature")
        valid_signature = "data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTAwIiBoZWlnaHQ9IjEwMCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48L3N2Zz4="

        field.value = valid_signature
        field.valid?(:update)

        expect(field.errors[:value]).to be_empty
      end

      it "rejects invalid signature format" do
        container = OrderForm.create!
        form = container.elements.create!(type: "Documents::Form", description: "Test Form")
        section = form.sections.first
        field = section.field_values.create!(type: "Documents::SignatureValue", name: "signature", description: "User Signature")

        field.value = "invalid signature"
        field.valid?(:update)

        expect(field.errors[:value]).to include("Invalid signature")
      end

      it "rejects img tag format" do
        container = OrderForm.create!
        form = container.elements.create!(type: "Documents::Form", description: "Test Form")
        section = form.sections.first
        field = section.field_values.create!(type: "Documents::SignatureValue", name: "signature", description: "User Signature")

        field.value = '<img src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChAI9jU77zwAAAABJRU5ErkJggg==" alt="signature">'
        field.valid?(:update)

        expect(field.errors[:value]).to include("Invalid signature")
      end
    end
  end
end
