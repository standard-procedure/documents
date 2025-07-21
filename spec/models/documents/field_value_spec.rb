require "rails_helper"

module Documents
  RSpec.describe FieldValue, type: :model do
    describe "path" do
      it "generates correct path based on section path and field name" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @section = @form.sections.first
        @field = @section.field_values.create! type: "Documents::TextValue", name: "company", description: "Company Name"

        expect(@field.path).to eq "1/1/company"
      end

      it "handles different field names" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @section = @form.sections.first
        @field1 = @section.field_values.create! type: "Documents::TextValue", name: "first_name", description: "First Name"
        @field2 = @section.field_values.create! type: "Documents::DateValue", name: "order_date", description: "Order Date"

        expect(@field1.path).to eq "1/1/first_name"
        expect(@field2.path).to eq "1/1/order_date"
      end

      it "updates path when section position changes" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @additional_section = @form.sections.create!
        @field = @additional_section.field_values.create! type: "Documents::NumberValue", name: "quantity", description: "Quantity"

        expect(@field.path).to eq "1/2/quantity"
      end

      it "updates path when form position changes" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        expect(@form.position).to eq 1

        # Create another form to test different form positions
        @form2 = @container.elements.create! type: "Documents::Form", position: :last, description: "Second form"
        @section = @form2.sections.first
        @field = @section.field_values.create! type: "Documents::SignatureValue", name: "signature", description: "Signature"

        # The second form should have position 2
        expect(@form2.position).to eq 2
        expect(@field.path).to eq "2/1/signature"
      end
    end
  end
end
