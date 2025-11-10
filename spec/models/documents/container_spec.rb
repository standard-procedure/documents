require "rails_helper"

module Documents
  RSpec.describe Container do
    before do
      # Mock out HTTP calls
      allow(Net::HTTP).to receive(:get).with("http://example.com/pdf").and_return(File.open(File.join("spec", "fixtures", "files", "document.pdf")))
    end

    it "builds a document from a valid configuration" do
      @configuration = YAML.load_file(Rails.root.join("spec", "fixtures", "files", "order_form.yml"))
      @order_form = OrderForm.create!

      @order_form.load_elements_from(@configuration)

      expect(@order_form.elements.size).to eq 6

      expect(@order_form.elements[0]).to be_kind_of Documents::Paragraph
      expect(@order_form.elements[1]).to be_kind_of Documents::Paragraph
      expect(@order_form.elements[2]).to be_kind_of Documents::Form
      expect(@order_form.elements[3]).to be_kind_of Documents::Form
      expect(@order_form.elements[4]).to be_kind_of Documents::Form
      expect(@order_form.elements[5]).to be_kind_of Documents::Pdf

      @form = @order_form.elements[2]
      expect(@form).to be_section_type_static
      expect(@form).to be_display_type_form
      @section = @form.sections.first
      expect(@section.field_values.first).to be_kind_of(Documents::TextValue)
      expect(@section.field_values.second).to be_kind_of(Documents::DateValue)

      @form = @order_form.elements[3]
      expect(@form).to be_section_type_repeating
      expect(@form).to be_display_type_table
      @section = @form.sections.first
      expect(@section.field_values.first).to be_kind_of(Documents::TextValue)
      expect(@section.field_values.second).to be_kind_of(Documents::NumberValue)

      @form = @order_form.elements[4]
      expect(@form).to be_section_type_static
      expect(@form).to be_display_type_form
      @section = @form.sections.first
      expect(@section.field_values.first).to be_kind_of(Documents::TextValue)
      expect(@section.field_values.second).to be_kind_of(Documents::YesNoValue)
      expect(@section.field_values.third).to be_kind_of(Documents::SignatureValue)
    end

    it "knows which forms and field values it contains" do
      @configuration = YAML.load_file(Rails.root.join("spec", "fixtures", "files", "order_form.yml"))

      @order_form = OrderForm.create!

      @order_form.load_elements_from(@configuration)

      expect(@order_form.forms.size).to eq 3
      expect(@order_form.field_values.size).to eq 7
    end

    it "fails if given an invalid configuration" do
      @configuration = {title: "Invalid", elements: [{element: "potato"}]}

      @order_form = OrderForm.create!

      expect { @order_form.load_elements_from(@configuration) }.to raise_error(ArgumentError)
    end

    it "is invalid if an element is invalid" do
      @configuration = YAML.load_file(Rails.root.join("spec", "fixtures", "files", "order_form.yml"))

      @order_form = OrderForm.create!

      @order_form.load_elements_from(@configuration)

      @field_value = @order_form.elements.third.sections.first.field_values.first
      @field_value.value = ""
      @field_value.save
      expect(@field_value).to_not be_valid
      expect(@field_value.section).to_not be_valid
      expect(@field_value.section.form).to_not be_valid
      expect(@field_value.section.form.container).to_not be_valid
      expect(@order_form).to_not be_valid

      expect(@order_form.invalid_field_values).to include @field_value
    end
  end
end
