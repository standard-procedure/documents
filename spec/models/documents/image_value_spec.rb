require "rails_helper"

module Documents
  RSpec.describe ImageValue, type: :model do
    describe "validations" do
      it "requires files when the field is required" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @section = @form.sections.first
        @image_field = @section.field_values.create! type: "Documents::ImageValue", name: "photo", description: "Required Photo", required: true

        @image_field.valid?(:update)
        expect(@image_field.errors[:files]).to include("can't be blank")

        image = fixture_file_upload("spec/test_app/spec/fixtures/files/hello.jpg", "image/jpeg")
        @image_field.files.attach(image)
        @image_field.valid?(:update)
        expect(@image_field.errors[:files]).to be_empty
      end

      it "validates that attached files are images" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @section = @form.sections.first
        @image_field = @section.field_values.create! type: "Documents::ImageValue", name: "photo", description: "Photo Upload"

        # Attach a non-image file
        text_file = fixture_file_upload("spec/test_app/spec/fixtures/files/example.txt", "text/plain")
        @image_field.files.attach(text_file)
        @image_field.valid?
        expect(@image_field.errors).to include :files

        # Clear and attach an image file
        @image_field.files.purge
        image = fixture_file_upload("spec/test_app/spec/fixtures/files/hello.jpg", "image/jpeg")
        @image_field.files.attach(image)
        @image_field.valid?
        expect(@image_field.errors[:files]).to be_empty
      end

      it "allows multiple image files to be attached" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @section = @form.sections.first
        @image_field = @section.field_values.create! type: "Documents::ImageValue", name: "gallery", description: "Photo Gallery"

        image1 = fixture_file_upload("spec/test_app/spec/fixtures/files/hello.jpg", "image/jpeg")
        image2 = fixture_file_upload("spec/test_app/spec/fixtures/files/bubble.jpg", "image/jpeg")

        @image_field.files.attach([image1, image2])
        expect(@image_field.files.count).to eq 2
        expect(@image_field.has_value?).to be true
        @image_field.valid?
        expect(@image_field.errors[:files]).to be_empty
      end

      it "validates all attached files are images when multiple files are attached" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @section = @form.sections.first
        @image_field = @section.field_values.create! type: "Documents::ImageValue", name: "gallery", description: "Photo Gallery"

        image = fixture_file_upload("spec/test_app/spec/fixtures/files/hello.jpg", "image/jpeg")
        text_file = fixture_file_upload("spec/test_app/spec/fixtures/files/example.txt", "text/plain")

        @image_field.files.attach([image, text_file])
        @image_field.valid?
        expect(@image_field.errors).to include :files
      end

      it "does not validate image format when no files are attached" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @section = @form.sections.first
        @image_field = @section.field_values.create! type: "Documents::ImageValue", name: "photo", description: "Optional Photo", required: false

        @image_field.valid?
        expect(@image_field.errors[:files]).to be_empty
      end
    end

    describe "inheritance" do
      it "inherits behavior from FileValue" do
        @container = OrderForm.create!
        @form = @container.elements.create! type: "Documents::Form", description: "Test Form"
        @section = @form.sections.first
        @image_field = @section.field_values.create! type: "Documents::ImageValue", name: "photo", description: "Photo Upload"

        image = fixture_file_upload("spec/test_app/spec/fixtures/files/hello.jpg", "image/jpeg")
        @image_field.files.attach(image)

        expect(@image_field.value).to eq @image_field.files
        expect(@image_field.has_value?).to be true
        expect(@image_field.to_s).to eq "hello.jpg"
      end
    end
  end
end
