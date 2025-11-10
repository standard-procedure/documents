require "rails_helper"

module Documents
  RSpec.describe Element, type: :model do
    describe "container" do
      it "must be a Documents::Container" do
        @valid_container = Documents::Table.new
        @invalid_container = Documents::Video.new

        @element = Documents::Element.new(container: @valid_container)

        @element.validate

        expect(@element.errors).to_not include :container

        @element.container = @invalid_conteiner

        @element.validate

        expect(@element.errors).to include :container
      end
    end

    it "loads the file based upon the supplied URL" do
      @container = OrderForm.create!
      @url = "https://example.com/document.pdf"
      allow(Net::HTTP).to receive(:get).with(URI(@url)).and_return(File.open("spec/fixtures/files/document.pdf"))

      @element = Documents::Element.new container: @container, url: @url, filename: "document.pdf"
      @element.save!
      expect(@element.file).to be_attached
      expect(@element.file.filename.to_s).to eq "document.pdf"
      expect(@element.file.content_type).to include "pdf"
    end
  end
end
