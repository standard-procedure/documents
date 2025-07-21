require "rails_helper"

module Documents
  RSpec.describe DataValue, type: :model do
    describe "validation" do
      it "requires a value when field is required" do
        container = OrderForm.create!
        form = container.elements.create!(type: "Documents::Form", description: "Test Form")
        section = form.sections.first
        field = section.field_values.create!(type: "Documents::DataValue", name: "person", description: "Associated Person", required: true)

        field.value = nil
        field.valid?(:update)

        expect(field.errors[:value]).to include("can't be blank")
      end

      it "does not require a value when field is not required" do
        container = OrderForm.create!
        form = container.elements.create!(type: "Documents::Form", description: "Test Form")
        section = form.sections.first
        field = section.field_values.create!(type: "Documents::DataValue", name: "person", description: "Optional Person", required: false)

        field.value = nil
        field.valid?(:update)

        expect(field.errors[:value]).to be_empty
      end

      it "accepts valid ActiveRecord model" do
        person = Person.create!(name: "John Doe")
        container = OrderForm.create!
        form = container.elements.create!(type: "Documents::Form", description: "Test Form")
        section = form.sections.first
        field = section.field_values.create!(type: "Documents::DataValue", name: "person", description: "Associated Person", required: true)

        field.value = person
        field.valid?(:update)

        expect(field.errors[:value]).to be_empty
      end
    end

    describe "data_class validation" do
      it "accepts model of correct class when data_class is specified" do
        person = Person.create!(name: "John Doe")
        container = OrderForm.create!
        form = container.elements.create!(type: "Documents::Form", description: "Test Form")
        section = form.sections.first
        field = section.field_values.create!(type: "Documents::DataValue", name: "person", description: "Associated Person", data_class: "Person")

        field.value = person
        field.valid?(:update)

        expect(field.errors[:value]).to be_empty
      end

      it "rejects model of incorrect class when data_class is specified" do
        document = Document.create!(name: "Test Document")
        container = OrderForm.create!
        form = container.elements.create!(type: "Documents::Form", description: "Test Form")
        section = form.sections.first
        field = section.field_values.create!(type: "Documents::DataValue", name: "person", description: "Associated Person", data_class: "Person")

        field.value = document
        field.valid?(:update)

        expect(field.errors[:value]).to include("Invalid data class")
      end

      it "accepts any model when data_class is not specified" do
        document = Document.create!(name: "Test Document")
        container = OrderForm.create!
        form = container.elements.create!(type: "Documents::Form", description: "Test Form")
        section = form.sections.first
        field = section.field_values.create!(type: "Documents::DataValue", name: "record", description: "Associated Record")

        field.value = document
        field.valid?(:update)

        expect(field.errors[:value]).to be_empty
      end

      it "accepts any model when data_class is empty string" do
        person = Person.create!(name: "Jane Doe")
        container = OrderForm.create!
        form = container.elements.create!(type: "Documents::Form", description: "Test Form")
        section = form.sections.first
        field = section.field_values.create!(type: "Documents::DataValue", name: "record", description: "Associated Record", data_class: "")

        field.value = person
        field.valid?(:update)

        expect(field.errors[:value]).to be_empty
      end
    end

    describe "GlobalID functionality" do
      it "persists and retrieves ActiveRecord models using GlobalID" do
        person = Person.create!(name: "Alice Smith")
        container = OrderForm.create!
        form = container.elements.create!(type: "Documents::Form", description: "Test Form")
        section = form.sections.first
        field = section.field_values.create!(type: "Documents::DataValue", name: "person", description: "Associated Person")

        field.value = person
        field.save!
        field.reload

        expect(field.value).to eq(person)
        expect(field.value.name).to eq("Alice Smith")
      end
    end
  end
end
