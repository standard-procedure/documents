module Documents
  class Element < ApplicationRecord
    include HasAttributes

    serialize :data, type: Hash, coder: JSON
    belongs_to :container, polymorphic: true
    validate :container_is_legal
    positioned on: :container
    has_rich_text :contents
    has_one_attached :file
    attribute :description, :string, default: ""

    def copy_to(target_container, copy_as_template: false) = nil

    def path = position.to_s

    private def container_is_legal
      errors.add :container, :invalid unless container.is_a? Documents::Container
    end
  end
end
