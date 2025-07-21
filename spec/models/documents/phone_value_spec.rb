require "rails_helper"

module Documents
  RSpec.describe PhoneValue, type: :model do
    describe "validations" do
      it "inherits TextValue validations for required fields" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @section = @form.sections.first
        @phone_field = @section.field_values.create! type: "Documents::PhoneValue", name: "phone", description: "Phone Number", required: true

        @phone_field.value = ""
        @phone_field.valid?(:update)
        expect(@phone_field.errors[:value]).to include("can't be blank")

        @phone_field.value = "+1 (555) 123-4567"
        @phone_field.valid?(:update)
        expect(@phone_field.errors[:value]).to be_empty
      end

      it "validates phone format" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @section = @form.sections.first
        @phone_field = @section.field_values.create! type: "Documents::PhoneValue", name: "phone", description: "Phone Number"

        @phone_field.value = "abc-def-ghij"
        @phone_field.valid?(:update)
        expect(@phone_field.errors[:value]).to include("must be a valid phone number")

        @phone_field.value = "+1 (555) 123-4567"
        @phone_field.valid?(:update)
        expect(@phone_field.errors[:value]).to be_empty

        @phone_field.value = "555.123.4567"
        @phone_field.valid?(:update)
        expect(@phone_field.errors[:value]).to be_empty

        @phone_field.value = "15551234567"
        @phone_field.valid?(:update)
        expect(@phone_field.errors[:value]).to be_empty
      end

      it "allows blank values when not required" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @section = @form.sections.first
        @phone_field = @section.field_values.create! type: "Documents::PhoneValue", name: "phone", description: "Phone Number", required: false

        @phone_field.value = ""
        @phone_field.valid?(:update)
        expect(@phone_field.errors[:value]).to be_empty
      end
    end

    describe "default values" do
      it "inherits default value functionality from TextValue" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @section = @form.sections.first
        @phone_field = @section.field_values.create! type: "Documents::PhoneValue", name: "phone", description: "Phone Number", default_value: "+1 (555) 000-0000"

        expect(@phone_field.value).to eq "+1 (555) 000-0000"
      end
    end
  end
end
