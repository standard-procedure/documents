require "rails_helper"

module Documents
  RSpec.describe LocationValue, type: :model do
    describe "validation" do
      it "requires latitude and longitude when field is required" do
        container = OrderForm.create!
        form = container.elements.create!(type: "Documents::Form", description: "Test Form")
        section = form.sections.first
        field = section.field_values.create!(type: "Documents::LocationValue", name: "location", description: "User Location", required: true)

        field.latitude = nil
        field.longitude = nil
        field.valid?(:update)

        expect(field.errors[:latitude]).to include("can't be blank")
        expect(field.errors[:longitude]).to include("can't be blank")
      end

      it "does not require latitude and longitude when field is not required" do
        container = OrderForm.create!
        form = container.elements.create!(type: "Documents::Form", description: "Test Form")
        section = form.sections.first
        field = section.field_values.create!(type: "Documents::LocationValue", name: "location", description: "Optional Location", required: false)

        field.latitude = nil
        field.longitude = nil
        field.valid?(:update)

        expect(field.errors[:latitude]).to be_empty
        expect(field.errors[:longitude]).to be_empty
      end

      it "accepts valid latitude and longitude values" do
        container = OrderForm.create!
        form = container.elements.create!(type: "Documents::Form", description: "Test Form")
        section = form.sections.first
        field = section.field_values.create!(type: "Documents::LocationValue", name: "location", description: "User Location", required: true)

        field.latitude = 37.7749
        field.longitude = -122.4194
        field.valid?(:update)

        expect(field.errors[:latitude]).to be_empty
        expect(field.errors[:longitude]).to be_empty
      end
    end

    describe "value method" do
      it "returns hash with latitude and longitude" do
        container = OrderForm.create!
        form = container.elements.create!(type: "Documents::Form", description: "Test Form")
        section = form.sections.first
        field = section.field_values.create!(type: "Documents::LocationValue", name: "location", description: "User Location")

        field.latitude = 37.7749
        field.longitude = -122.4194

        expect(field.value).to eq({longitude: -122.4194, latitude: 37.7749})
      end

      it "returns hash with nil values when coordinates not set" do
        container = OrderForm.create!
        form = container.elements.create!(type: "Documents::Form", description: "Test Form")
        section = form.sections.first
        field = section.field_values.create!(type: "Documents::LocationValue", name: "location", description: "User Location")

        expect(field.value).to eq({longitude: nil, latitude: nil})
      end
    end
  end
end
