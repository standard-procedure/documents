module Documents
  class LocationValue < FieldValue
    has_attribute :latitude, :float
    validates :latitude, presence: true, on: :update, if: -> { required? }
    has_attribute :longitude, :float
    validates :longitude, presence: true, on: :update, if: -> { required? }

    def value = {longitude: longitude, latitude: latitude}
  end
end
