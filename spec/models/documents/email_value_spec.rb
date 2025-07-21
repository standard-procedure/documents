require "rails_helper"

module Documents
  RSpec.describe EmailValue, type: :model do
    describe "validations" do
      it "inherits TextValue validations for required fields" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @section = @form.sections.first
        @email_field = @section.field_values.create! type: "Documents::EmailValue", name: "email", description: "Email Address", required: true

        @email_field.value = ""
        @email_field.valid?(:update)
        expect(@email_field.errors[:value]).to include("can't be blank")

        @email_field.value = "user@example.com"
        @email_field.valid?(:update)
        expect(@email_field.errors[:value]).to be_empty
      end

      it "validates email format" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @section = @form.sections.first
        @email_field = @section.field_values.create! type: "Documents::EmailValue", name: "email", description: "Email Address"

        @email_field.value = "invalid-email"
        @email_field.valid?(:update)
        expect(@email_field.errors[:value]).to include("must be a valid email address")

        @email_field.value = "user@example.com"
        @email_field.valid?(:update)
        expect(@email_field.errors[:value]).to be_empty

        @email_field.value = "user.name+tag@example-domain.co.uk"
        @email_field.valid?(:update)
        expect(@email_field.errors[:value]).to be_empty
      end

      it "allows blank values when not required" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @section = @form.sections.first
        @email_field = @section.field_values.create! type: "Documents::EmailValue", name: "email", description: "Email Address", required: false

        @email_field.value = ""
        @email_field.valid?(:update)
        expect(@email_field.errors[:value]).to be_empty
      end
    end

    describe "default values" do
      it "inherits default value functionality from TextValue" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @section = @form.sections.first
        @email_field = @section.field_values.create! type: "Documents::EmailValue", name: "email", description: "Email Address", default_value: "default@example.com"

        expect(@email_field.value).to eq "default@example.com"
      end
    end
  end
end
