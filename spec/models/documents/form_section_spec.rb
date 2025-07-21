require "rails_helper"

module Documents
  RSpec.describe FormSection, type: :model do
    describe "path" do
      it "generates correct path based on form path and section position" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @additional_section = @form.sections.create!

        expect(@additional_section.path).to eq "1/2"
      end

      it "handles first section position" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @existing_section = @form.sections.first # Created automatically by Form after_save

        expect(@existing_section.path).to eq "1/1"
      end

      it "updates path when form position changes" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        expect(@form.position).to eq 1

        # Create another form to test different form positions
        @form2 = @container.elements.create! type: "Documents::Form", position: :last, description: "Second form"
        @section = @form2.sections.first

        # The second form should have position 2
        expect(@form2.position).to eq 2
        expect(@section.path).to eq "2/1"
      end
    end
  end
end
