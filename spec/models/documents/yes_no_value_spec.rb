require "rails_helper"

module Documents
  RSpec.describe YesNoValue, type: :model do
    describe "validations" do
      it "defaults to not allowing an N/A value" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @section = @form.sections.first
        @yes_no_field = @section.field_values.create! type: "Documents::YesNoValue", name: "terms_accepted", description: "Terms Accepted", required: true, configuration: {}

        expect(@yes_no_field.allows_na?).to be false
      end

      it "requires a y or n value when the field is required and allows_na is false" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @section = @form.sections.first
        @yes_no_field = @section.field_values.create! type: "Documents::YesNoValue", name: "terms_accepted", description: "Terms Accepted", required: true, configuration: {allows_na: false}

        @yes_no_field.value = nil
        @yes_no_field.validate
        expect(@yes_no_field.errors).to include :value

        @yes_no_field.value = "y"
        @yes_no_field.validate
        expect(@yes_no_field.errors[:value]).to be_empty

        @yes_no_field.value = "n"
        @yes_no_field.validate
        expect(@yes_no_field.errors[:value]).to be_empty
      end

      it "requires a y, n or na value when the field is required and allows_na is true" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @section = @form.sections.first
        @yes_no_field = @section.field_values.create! type: "Documents::YesNoValue", name: "terms_accepted", description: "Terms Accepted", required: true, configuration: {allows_na: true}

        @yes_no_field.value = nil
        @yes_no_field.validate
        expect(@yes_no_field.errors).to include :value

        @yes_no_field.value = "na"
        @yes_no_field.validate
        expect(@yes_no_field.errors[:value]).to be_empty

        @yes_no_field.value = "y"
        @yes_no_field.validate
        expect(@yes_no_field.errors[:value]).to be_empty

        @yes_no_field.value = "n"
        @yes_no_field.validate
        expect(@yes_no_field.errors[:value]).to be_empty
      end

      it "does not require a value when the field is not required" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @section = @form.sections.first
        @yes_no_field = @section.field_values.create! type: "Documents::YesNoValue", name: "newsletter", description: "Subscribe to Newsletter", required: false

        @yes_no_field.value = nil
        @yes_no_field.valid?(:update)
        expect(@yes_no_field.errors[:value]).to be_empty
      end
    end

    describe "values" do
      it "accepts boolean values" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @section = @form.sections.first
        @yes_no_field = @section.field_values.create! type: "Documents::YesNoValue", name: "active", description: "Active", required: true, configuration: {allows_na: true}

        @yes_no_field.value = true
        expect(@yes_no_field).to be_valid
        expect(@yes_no_field.value).to eq "y"

        @yes_no_field.value = false
        expect(@yes_no_field).to be_valid
        expect(@yes_no_field.value).to eq "n"

        @yes_no_field.value = "na"
        expect(@yes_no_field).to be_valid
        expect(@yes_no_field.value).to eq "na"
      end

      it "converts form parameter values" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @section = @form.sections.first
        @yes_no_field = @section.field_values.create! type: "Documents::YesNoValue", name: "active", description: "Active", configuration: {allows_na: true}

        @yes_no_field.value = "1"
        expect(@yes_no_field).to be_valid
        expect(@yes_no_field.value).to eq "y"

        @yes_no_field.value = "0"
        expect(@yes_no_field).to be_valid
        expect(@yes_no_field.value).to eq "n"

        @yes_no_field.value = "true"
        expect(@yes_no_field).to be_valid
        expect(@yes_no_field.value).to eq "y"

        @yes_no_field.value = "false"
        expect(@yes_no_field).to be_valid
        expect(@yes_no_field.value).to eq "n"

        @yes_no_field.value = "t"
        expect(@yes_no_field).to be_valid
        expect(@yes_no_field.value).to eq "y"

        @yes_no_field.value = "f"
        expect(@yes_no_field).to be_valid
        expect(@yes_no_field.value).to eq "n"

        @yes_no_field.value = "na"
        expect(@yes_no_field).to be_valid
        expect(@yes_no_field.value).to eq "na"
      end
    end

    describe "default values" do
      it "uses string default value when no value is provided" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @section = @form.sections.first
        @yes_no_field = @section.field_values.create! type: "Documents::YesNoValue", name: "active", description: "Active", default_value: "y"

        expect(@yes_no_field.value).to eq "y"
      end

      it "handles form parameter default values" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @section = @form.sections.first

        @true_field = @section.field_values.create! type: "Documents::YesNoValue", name: "true_field", description: "True Field", default_value: "true"
        @true_field.validate
        expect(@true_field.value).to eq "y"

        @false_field = @section.field_values.create! type: "Documents::YesNoValue", name: "false_field", description: "False Field", default_value: "false"
        @false_field.validate
        expect(@false_field.value).to eq "n"

        @one_field = @section.field_values.create! type: "Documents::YesNoValue", name: "one_field", description: "One Field", default_value: "1"
        @one_field.validate
        expect(@one_field.value).to eq "y"

        @zero_field = @section.field_values.create! type: "Documents::YesNoValue", name: "zero_field", description: "Zero Field", default_value: "0"
        @zero_field.validate
        expect(@zero_field.value).to eq "n"
      end

      it "overrides the default value when a value is provided" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @section = @form.sections.first
        @yes_no_field = @section.field_values.create! type: "Documents::YesNoValue", name: "active", description: "Active", default_value: "true", value: "n"

        @yes_no_field.validate
        expect(@yes_no_field.value).to eq "n"
      end

      it "handles nil default value" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @section = @form.sections.first
        @yes_no_field = @section.field_values.create! type: "Documents::YesNoValue", name: "active", description: "Active", default_value: nil

        @yes_no_field.validate
        expect(@yes_no_field.value).to be_nil
      end

      it "has an option for inverting colours" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @section = @form.sections.first
        @yes_no_field = @section.field_values.create! type: "Documents::YesNoValue", name: "terms_accepted", description: "Terms Accepted", required: true, configuration: {invert_colours: true}

        expect(@yes_no_field.invert_colours?).to be true
      end

      it "defaults to invert_colours being false" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @section = @form.sections.first
        @yes_no_field = @section.field_values.create! type: "Documents::YesNoValue", name: "terms_accepted", description: "Terms Accepted", required: true, configuration: {}

        expect(@yes_no_field.invert_colours?).to be false
      end
    end

    describe "scoring" do
      it "has a score of 1 for yes" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @section = @form.sections.first
        @field = @section.field_values.create! type: "Documents::YesNoValue", name: "terms_accepted", description: "Terms Accepted", required: true, configuration: {invert_colours: true}, value: "y"

        expect(@field.score).to eq 1
      end

      it "has a score of 0 for no" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @section = @form.sections.first
        @field = @section.field_values.create! type: "Documents::YesNoValue", name: "terms_accepted", description: "Terms Accepted", required: true, configuration: {invert_colours: true}, value: "n"

        expect(@field.score).to eq 0
      end

      it "has a score of 0 for n/a" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @section = @form.sections.first
        @field = @section.field_values.create! type: "Documents::YesNoValue", name: "terms_accepted", description: "Terms Accepted", required: true, configuration: {invert_colours: true, allows_na: true}, value: "na"

        expect(@field.score).to eq 0
      end
    end
  end
end
