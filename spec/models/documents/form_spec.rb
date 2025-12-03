require "rails_helper"

module Documents
  RSpec.describe Form, type: :model do
    describe "initialization" do
      it "creates the first section automatically" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"

        expect(@form.sections.count).to eq 1
        expect(@form.sections.first.position).to eq 1
      end

      it "stores field template when created via load_elements_from" do
        @container = OrderForm.create!

        configuration = {
          "title" => "Order Form",
          "elements" => [
            {
              "element" => "form",
              "section_type" => "repeating",
              "display_type" => "form",
              "description" => "Order Items",
              "fields" => [
                {
                  "name" => "item",
                  "description" => "Item Name",
                  "field_type" => "Documents::TextValue",
                  "required" => true
                },
                {
                  "name" => "quantity",
                  "description" => "Quantity",
                  "field_type" => "Documents::NumberValue",
                  "required" => true,
                  "default_value" => "1"
                }
              ]
            }
          ]
        }

        @container.load_elements_from(configuration)
        @form = @container.elements.where(type: "Documents::Form").first

        expect(@form.field_templates).to eq configuration["elements"][0]["fields"]
        expect(@form.sections.first.field_values.count).to eq 2
      end
    end

    describe "section management" do
      context "repeating forms" do
        describe "#add_section" do
          it "creates new section with correct field structure" do
            @container = OrderForm.create!
            @form = @container.elements.create!(
              type: "Documents::Form",
              description: "Test Form",
              section_type: "repeating",
              field_templates: [
                {
                  "name" => "item",
                  "description" => "Item Name",
                  "field_type" => "Documents::TextValue",
                  "required" => true
                },
                {
                  "name" => "quantity",
                  "description" => "Quantity",
                  "field_type" => "Documents::NumberValue",
                  "required" => false,
                  "default_value" => "1"
                }
              ]
            )

            initial_section_count = @form.sections.count
            new_section = @form.add_section

            expect(@form.sections.count).to eq(initial_section_count + 1)
            expect(new_section).to be_a(FormSection)
            expect(new_section.field_values.count).to eq 2

            text_field = new_section.field_values.find_by(name: "item")
            number_field = new_section.field_values.find_by(name: "quantity")

            expect(text_field.type).to eq "Documents::TextValue"
            expect(text_field.description).to eq "Item Name"
            expect(text_field.required).to be true

            expect(number_field.type).to eq "Documents::NumberValue"
            expect(number_field.description).to eq "Quantity"
            expect(number_field.required).to be false
            expect(number_field.default_value).to eq "1"
          end

          it "positions new section at the end" do
            @container = OrderForm.create!
            @form = @container.elements.create!(
              type: "Documents::Form",
              description: "Test Form",
              section_type: "repeating",
              field_templates: [{"name" => "test", "description" => "Test", "field_type" => "Documents::TextValue", "required" => false}]
            )

            @form.add_section
            new_section = @form.add_section

            expect(new_section.position).to eq 3
            expect(@form.sections.last).to eq new_section
          end

          it "returns the new section on success" do
            @container = OrderForm.create!
            @form = @container.elements.create!(
              type: "Documents::Form",
              description: "Test Form",
              section_type: "repeating",
              field_templates: [{"name" => "test", "description" => "Test", "field_type" => "Documents::TextValue", "required" => false}]
            )

            result = @form.add_section

            expect(result).to be_a(FormSection)
            expect(result.form).to eq @form
          end

          it "handles forms with complex field configurations" do
            @container = OrderForm.create!
            @form = @container.elements.create!(
              type: "Documents::Form",
              description: "Test Form",
              section_type: "repeating",
              field_templates: [
                {
                  "name" => "category",
                  "description" => "Category",
                  "field_type" => "Documents::SelectValue",
                  "required" => true,
                  "options" => {"electronics" => "Electronics", "books" => "Books"}
                },
                {
                  "name" => "tags",
                  "description" => "Tags",
                  "field_type" => "Documents::MultiSelectValue",
                  "required" => false,
                  "options" => {"new" => "New", "sale" => "On Sale", "featured" => "Featured"}
                }
              ]
            )

            new_section = @form.add_section

            select_field = new_section.field_values.find_by(name: "category")
            multi_select_field = new_section.field_values.find_by(name: "tags")

            expect(select_field.type).to eq "Documents::SelectValue"
            expect(select_field.keys).to eq ["electronics", "books"]
            expect(select_field.values).to eq ["Electronics", "Books"]

            expect(multi_select_field.type).to eq "Documents::MultiSelectValue"
            expect(multi_select_field.options).to eq({"new" => "New", "sale" => "On Sale", "featured" => "Featured"})
          end
        end

        describe "#remove_section" do
          it "removes the last section when multiple sections exist" do
            @container = OrderForm.create!
            @form = @container.elements.create!(
              type: "Documents::Form",
              description: "Test Form",
              section_type: "repeating",
              field_templates: [{"name" => "test", "description" => "Test", "field_type" => "Documents::TextValue", "required" => false}]
            )

            @form.add_section
            @form.add_section
            initial_count = @form.sections.count

            @form.remove_section

            expect(@form.sections.count).to eq(initial_count - 1)
          end

          it "prevents removing the last remaining section" do
            @container = OrderForm.create!
            @form = @container.elements.create!(
              type: "Documents::Form",
              description: "Test Form",
              section_type: "repeating"
            )

            expect(@form.sections.count).to eq 1

            @form.remove_section

            expect(@form.sections.count).to eq 1
          end

          it "destroys associated field_values when removing section" do
            @container = OrderForm.create!
            @form = @container.elements.create!(
              type: "Documents::Form",
              description: "Test Form",
              section_type: "repeating",
              field_templates: [
                {"name" => "item", "description" => "Item", "field_type" => "Documents::TextValue", "required" => true},
                {"name" => "price", "description" => "Price", "field_type" => "Documents::DecimalValue", "required" => true}
              ]
            )

            new_section = @form.add_section
            section_field_ids = new_section.field_values.pluck(:id)

            @form.remove_section

            section_field_ids.each do |field_id|
              expect { FieldValue.find(field_id) }.to raise_error(ActiveRecord::RecordNotFound)
            end
          end
        end
      end

      context "static forms" do
        describe "#add_section" do
          it "returns false and does not create section" do
            @container = OrderForm.create!
            @form = @container.elements.create!(
              type: "Documents::Form",
              description: "Test Form",
              section_type: "static",
              field_templates: [{"name" => "test", "description" => "Test", "field_type" => "Documents::TextValue", "required" => false}]
            )

            initial_count = @form.sections.count

            result = @form.add_section

            expect(result).to be_nil
            expect(@form.sections.count).to eq initial_count
          end
        end

        describe "#remove_section" do
          it "returns nil and does not remove section" do
            @container = OrderForm.create!
            @form = @container.elements.create!(
              type: "Documents::Form",
              description: "Test Form",
              section_type: "static"
            )

            initial_count = @form.sections.count

            result = @form.remove_section

            expect(result).to be_nil
            expect(@form.sections.count).to eq initial_count
          end
        end
      end
    end

    describe "field template storage" do
      it "defaults to empty array" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"

        expect(@form.field_templates).to eq []
      end

      it "persists field template configuration" do
        @container = OrderForm.create!

        template = [
          {
            "name" => "email",
            "description" => "Email Address",
            "field_type" => "Documents::EmailValue",
            "required" => true
          }
        ]

        @form = @container.elements.create!(
          type: "Documents::Form",
          description: "Contact Form",
          field_templates: template
        )

        @form.reload
        expect(@form.field_templates).to eq template
      end
    end
  end
end
