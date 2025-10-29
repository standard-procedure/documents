module Documents
  class FieldValue < ApplicationRecord
    include HasAttributes
    include HasTasks
    include FieldValueExtensions

    scope :with_name, ->(name) { where(name: name) }

    serialize :data, type: Hash, coder: JSON
    belongs_to :section, class_name: "FormSection"
    delegate :container, to: :section
    positioned on: :section
    has_attribute :default_value, :string
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

    def allow_extras? = allow_attachments? || allow_comments? || allow_tasks?

    def has_extras? = allow_extras? && (!comments.to_plain_text.blank? || files.attachments.any?)
  end
end
