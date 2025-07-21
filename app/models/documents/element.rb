module Documents
  class Element < ApplicationRecord
    include HasAttributes
    belongs_to :container, polymorphic: true
    validate :container_is_legal
    positioned on: :container
    attribute :description, :string, default: ""
    has_one_attached :file

    def copy_to(target_container, copy_as_template: false) = nil

    private def container_is_legal
      errors.add :container, :invalid unless container.is_a? Documents::Container
    end
  end
end
