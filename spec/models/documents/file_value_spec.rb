require "rails_helper"

module Documents
  RSpec.describe FileValue, type: :model do
    describe "validations" do
      it "requires files when the field is required" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @section = @form.sections.first
        @file_field = @section.field_values.create! type: "Documents::FileValue", name: "attachment", description: "Required Attachment", required: true

        @file_field.valid?(:update)
        expect(@file_field.errors[:files]).to include("can't be blank")

        file = fixture_file_upload("spec/test_app/spec/fixtures/files/example.txt", "text/plain")
        @file_field.files.attach(file)
        @file_field.valid?(:update)
        expect(@file_field.errors[:files]).to be_empty
      end

      it "does not require files when the field is not required" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @section = @form.sections.first
        @file_field = @section.field_values.create! type: "Documents::FileValue", name: "optional_attachment", description: "Optional Attachment", required: false

        @file_field.valid?(:update)
        expect(@file_field.errors[:files]).to be_empty
      end

      it "allows multiple files to be attached" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @section = @form.sections.first
        @file_field = @section.field_values.create! type: "Documents::FileValue", name: "attachments", description: "Multiple Attachments"

        file1 = fixture_file_upload("spec/test_app/spec/fixtures/files/example.txt", "text/plain")
        file2 = fixture_file_upload("spec/test_app/spec/fixtures/files/example.docx", "application/vnd.openxmlformats-officedocument.wordprocessingml.document")

        @file_field.files.attach([file1, file2])
        expect(@file_field.files.count).to eq 2
        expect(@file_field.has_value?).to be true
      end
    end

    describe "#value" do
      it "returns the attached files" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @section = @form.sections.first
        @file_field = @section.field_values.create! type: "Documents::FileValue", name: "attachment", description: "File Attachment"

        file = fixture_file_upload("spec/test_app/spec/fixtures/files/example.txt", "text/plain")
        @file_field.files.attach(file)

        expect(@file_field.value).to eq @file_field.files
      end
    end

    describe "#has_value?" do
      it "returns true when files are attached" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @section = @form.sections.first
        @file_field = @section.field_values.create! type: "Documents::FileValue", name: "attachment", description: "File Attachment"

        expect(@file_field.has_value?).to be false

        file = fixture_file_upload("spec/test_app/spec/fixtures/files/example.txt", "text/plain")
        @file_field.files.attach(file)
        expect(@file_field.has_value?).to be true
      end
    end

    describe "#to_s" do
      it "returns comma-separated list of file names" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @section = @form.sections.first
        @file_field = @section.field_values.create! type: "Documents::FileValue", name: "attachments", description: "Multiple Attachments"

        file1 = fixture_file_upload("spec/test_app/spec/fixtures/files/example.txt", "text/plain")
        file2 = fixture_file_upload("spec/test_app/spec/fixtures/files/example.docx", "application/vnd.openxmlformats-officedocument.wordprocessingml.document")

        @file_field.files.attach([file1, file2])
        expect(@file_field.to_s).to eq "example.txt, example.docx"
      end

      it "returns empty string when no files attached" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @section = @form.sections.first
        @file_field = @section.field_values.create! type: "Documents::FileValue", name: "attachment", description: "File Attachment"

        expect(@file_field.to_s).to eq ""
      end
    end
  end
end
