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
  end
end
