module Documents::Container
  extend ActiveSupport::Concern

  included do
    has_many :elements, -> { order :position }, class_name: "Documents::Element", dependent: :destroy
  end
end
