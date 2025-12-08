module Documents
  class FieldValue < ApplicationRecord
    include HasAttributes
    include HasTasks
    include FieldValueExtensions

    scope :with_name, ->(name) { where(name: name) }

    validates :name, presence: true
    validates :description, presence: true
    serialize :data, type: Hash, coder: JSON
    belongs_to :section, class_name: "FormSection"
    delegate :form, to: :section
    delegate :container, to: :form
    positioned on: :section
    has_attribute :default_value, :string
    has_attribute :display_style, :string
    has_attribute :options, :json, default: {}
    has_attribute :option_values, :json, default: []
    has_attribute :configuration, :json, default: {}
    before_save :copy_option_values, if: -> { option_values.empty? && configuration["option_values"].present? }
    has_many_attached :files do |file|
      ImageDefaults.for file
    end
    has_many_attached :attachments do |attachment|
      ImageDefaults.for attachment
    end
    has_rich_text :comments

    def has_value? = value.present?

    def path = [section.path, name.to_s].join("/")

    def to_s = value.to_s

    def score = 0.0

    def allow_extras? = allow_attachments? || allow_comments? || allow_tasks?

    def has_extras? = allow_extras? && (!comments.to_plain_text.blank? || files.attachments.any?)

    def copy_option_values
      self.option_values = configuration.delete("option_values")
    end
  end
end
