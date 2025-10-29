require "rails_helper"

module Documents
  RSpec.describe RichTextValue, type: :model do
    describe "inheritance" do
      it "behaves identically to TextValue" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @section = @form.sections.first
        @rich_text_field = @section.field_values.create! type: "Documents::RichTextValue", name: "content", description: "Rich Content", required: true

        @rich_text_field.value = ""
        @rich_text_field.valid?(:update)
        expect(@rich_text_field.errors[:value]).to include("can't be blank")

        @rich_text_field.value = "<p>Rich <strong>HTML</strong> content</p>"
        @rich_text_field.valid?(:update)
        expect(@rich_text_field.errors[:value]).to be_empty
      end

      it "inherits default value functionality from TextValue" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @section = @form.sections.first
        @rich_text_field = @section.field_values.create! type: "Documents::RichTextValue", name: "content", description: "Rich Content", default_value: "<p>Default content</p>"

        expect(@rich_text_field.value.to_plain_text).to eq "Default content"
      end
    end
  end
end
