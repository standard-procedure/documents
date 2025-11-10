require "rails_helper"

module Documents
  RSpec.describe DateTimeValue, type: :model do
    include ActiveSupport::Testing::TimeHelpers

    describe "validations" do
      it "requires a value when the field is required" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @section = @form.sections.first
        @time_field = @section.field_values.create! type: "Documents::DateTimeValue", name: "appointment_time", description: "Appointment Time", required: true

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
        @time_field = @section.field_values.create! type: "Documents::DateTimeValue", name: "optional_time", description: "Optional Time", required: false

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
        @time_field = @section.field_values.create! type: "Documents::DateTimeValue", name: "appointment_time", description: "Appointment Time", default_value: "2024-01-01 14:30:00"

        expect(@time_field.value).to eq Time.parse("2024-01-01 14:30:00")
      end

      it "overrides the default value when a value is provided" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @section = @form.sections.first
        @time_field = @section.field_values.create! type: "Documents::DateTimeValue", name: "appointment_time", description: "Appointment Time", default_value: "2024-01-01 14:30:00", value: Time.new(2024, 12, 25, 9, 0, 0)

        expect(@time_field.value).to eq Time.new(2024, 12, 25, 9, 0, 0)
      end

      it "handles nil default value" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @section = @form.sections.first
        @time_field = @section.field_values.create! type: "Documents::DateTimeValue", name: "appointment_time", description: "Appointment Time", default_value: nil

        expect(@time_field.value).to be_nil
      end

      it "parses the default value to find the time" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @section = @form.sections.first

        freeze_time do
          @time_field = @section.field_values.create! type: "Documents::DateTimeValue", name: "created_at", description: "Created At", default_value: "now"
          # Use a small tolerance since Time.current might differ slightly between creation and test
          expect(@time_field.value).to be_within(1.second).of(Time.current)
          @time_field = @section.field_values.create! type: "Documents::DateTimeValue", name: "created_at", description: "Created At", default_value: "in 3 hours"
          # Use a small tolerance since Time.current might differ slightly between creation and test
          expect(@time_field.value).to be_within(1.second).of(3.hours.from_now)
          @time_field = @section.field_values.create! type: "Documents::DateTimeValue", name: "created_at", description: "Created At", default_value: "yesterday at 9am"
          # Use a small tolerance since Time.current might differ slightly between creation and test
          expect(@time_field.value).to be_within(1.second).of(1.day.ago.change(hour: 9, min: 0, sec: 0))
          @time_field = @section.field_values.create! type: "Documents::DateTimeValue", name: "created_at", description: "Created At", default_value: "tomorrow at 5pm"
          # Use a small tolerance since Time.current might differ slightly between creation and test
          expect(@time_field.value).to be_within(1.second).of(1.day.from_now.change(hour: 17, min: 0, sec: 0))
          @time_field = @section.field_values.create! type: "Documents::DateTimeValue", name: "created_at", description: "Created At", default_value: "25th November 1998 at 11am"
          # Use a small tolerance since Time.current might differ slightly between creation and test
          expect(@time_field.value).to be_within(1.second).of(Time.new(1998, 11, 25, 11))
          @time_field = @section.field_values.create! type: "Documents::DateTimeValue", name: "created_at", description: "Created At", default_value: "7 days from now"
          # Use a small tolerance since Time.current might differ slightly between creation and test
          expect(@time_field.value).to be_within(1.second).of(7.days.from_now)
          @time_field = @section.field_values.create! type: "Documents::DateTimeValue", name: "created_at", description: "Created At", default_value: "90 days ago"
          # Use a small tolerance since Time.current might differ slightly between creation and test
          expect(@time_field.value).to be_within(1.second).of(90.days.ago)
          @time_field = @section.field_values.create! type: "Documents::DateTimeValue", name: "created_at", description: "Created At", default_value: "next tuesday at 12pm"
          # Use a small tolerance since Time.current might differ slightly between creation and test
          expected = Date.current.next_week(:tuesday).to_datetime.change(hour: 12, min: 0, sec: 0)
          # If today is monday, subtract 7 days to the expected date because the next tuesday is this week
          expected -= 7.days if Date.current.wday == 1
          expect(@time_field.value).to be_within(1.second).of(expected)
        end
      end
    end
  end
end
