require "rails_helper"

module Documents
  RSpec.describe TimeValue, type: :model do
    describe "validations" do
      it "requires a value when the field is required" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @section = @form.sections.first
        @time_field = @section.field_values.create! type: "Documents::TimeValue", name: "appointment_time", description: "Appointment Time", required: true

        @time_field.value = nil
        @time_field.valid?(:update)
        expect(@time_field.errors[:value]).to include("can't be blank")

        @time_field.value = Time.new(2024, 1, 15, 14, 30, 0)
        @time_field.valid?(:update)
        expect(@time_field.errors[:value]).to be_empty
      end

      it "does not require a value when the field is not required" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @section = @form.sections.first
        @time_field = @section.field_values.create! type: "Documents::TimeValue", name: "optional_time", description: "Optional Time", required: false

        @time_field.value = nil
        @time_field.valid?(:update)
        expect(@time_field.errors[:value]).to be_empty
      end
    end

    describe "default values" do
      it "uses the default value when no value is provided" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @section = @form.sections.first
        @time_field = @section.field_values.create! type: "Documents::TimeValue", name: "appointment_time", description: "Appointment Time", default_value: "2024-01-01 14:30:00"

        expect(@time_field.value).to eq Time.parse("2024-01-01 14:30:00")
      end

      it "overrides the default value when a value is provided" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @section = @form.sections.first
        @time_field = @section.field_values.create! type: "Documents::TimeValue", name: "appointment_time", description: "Appointment Time", default_value: "2024-01-01 14:30:00", value: Time.new(2024, 12, 25, 9, 0, 0)

        expect(@time_field.value).to eq Time.new(2024, 12, 25, 9, 0, 0)
      end

      it "handles nil default value" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @section = @form.sections.first
        @time_field = @section.field_values.create! type: "Documents::TimeValue", name: "appointment_time", description: "Appointment Time", default_value: nil

        expect(@time_field.value).to be_nil
      end

      it "uses current time when default_value is 'now'" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @section = @form.sections.first
        @time_field = @section.field_values.create! type: "Documents::TimeValue", name: "created_at", description: "Created At", default_value: "now"

        # Use a small tolerance since Time.current might differ slightly between creation and test
        expect(@time_field.value).to be_within(1.second).of(Time.current)
      end
    end
  end
end
