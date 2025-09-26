module Documents
  class FieldValue < ApplicationRecord
    include HasAttributes

    serialize :data, type: Hash, coder: JSON
    belongs_to :section, class_name: "FormSection"
    positioned on: :section
    has_attribute :default_value, :string
    has_many_attached :files
    has_many_attached :attachments
    has_rich_text :comments

    def has_value? = value.present?

    def path = [section.path, name.to_s].join("/")

    def to_s = value.to_s

    def allow_extras? = allow_attachments? || allow_comments? || allow_tasks?

    def has_extras? = allow_extras? && (!comments.to_plain_text.blank? || files.attachments.any?)
  end
end
