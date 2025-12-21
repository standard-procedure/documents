require "rails_helper"

module Documents
  RSpec.describe Container do
    it "builds a document from a valid configuration" do
      @configuration = YAML.load_file(Rails.root.join("spec", "fixtures", "files", "order_form.yml"))
      @order_form = OrderForm.create!

      @order_form.load_elements_from(@configuration)

      expect(@order_form.elements.size).to eq 9

      expect(@order_form.elements[0]).to be_kind_of Documents::Paragraph
      expect(@order_form.elements[1]).to be_kind_of Documents::Paragraph
      expect(@order_form.elements[2]).to be_kind_of Documents::Form
      expect(@order_form.elements[3]).to be_kind_of Documents::Form
      expect(@order_form.elements[4]).to be_kind_of Documents::Form
      expect(@order_form.elements[5]).to be_kind_of Documents::Pdf
      expect(@order_form.elements[6]).to be_kind_of Documents::Image
      expect(@order_form.elements[7]).to be_kind_of Documents::Download

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
      expect(@section.field_values.third).to be_kind_of(Documents::SelectValue)
      select_value = @section.field_values.third
      expect(select_value.option_values.size).to eq 3
      expect(select_value.option_values.first["key"]).to eq "whenever"
      expect(select_value.option_values.second["key"]).to eq "soon"
      expect(select_value.option_values.third["key"]).to eq "now"

      @form = @order_form.elements[4]
      expect(@form).to be_section_type_static
      expect(@form).to be_display_type_form
      @section = @form.sections.first
      expect(@section.field_values.first).to be_kind_of(Documents::TextValue)
      expect(@section.field_values.second).to be_kind_of(Documents::YesNoValue)
      expect(@section.field_values.third).to be_kind_of(Documents::SignatureValue)
      @yes_no_value = @section.field_values.second
      expect(@yes_no_value.allows_na?).to be false
      expect(@yes_no_value.invert_colours?).to be true

      @pdf = @order_form.elements[5]
      expect(@pdf.url).to eq "https://example.com/pdf"
      expect(@pdf.filename).to eq "document.pdf"

      @image = @order_form.elements[6]
      expect(@image.url).to eq "https://example.com/image"
      expect(@image.filename).to eq "image.jpg"

      @download = @order_form.elements[7]
      expect(@download.url).to eq "https://example.com/download"
      expect(@download.filename).to eq "document.pdf"

      @video = @order_form.elements[8]
      expect(@video.url).to eq "https://example.com/video"
    end

    it "knows which forms and field values it contains" do
      @configuration = YAML.load_file(Rails.root.join("spec", "fixtures", "files", "order_form.yml"))

      @order_form = OrderForm.create!

      @order_form.load_elements_from(@configuration)

      expect(@order_form.forms.size).to eq 3
      expect(@order_form.field_values.size).to eq 8
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

    it "can eager load the elements, including forms and their values" do
      @configuration = YAML.load_file(Rails.root.join("spec", "fixtures", "files", "order_form.yml"))
      @order_form = OrderForm.create!
      @order_form.load_elements_from(@configuration)

      @eager_loaded_form = OrderForm.eager_load(elements: {sections: :field_values}).find @order_form.id

      expect(@eager_loaded_form.elements.size).to eq 9
    end
  end
end
