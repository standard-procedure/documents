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
      file.variant :tiny, resize_to_limit: [64, 64]
      file.variant :thumb, resize_to_limit: [128, 128]
      file.variant :small, resize_to_limit: [256, 256]
      file.variant :medium, resize_to_limit: [512, 512]
      file.variant :large, resize_to_limit: [1024, 1024]
      file.variant :xlarge, resize_to_limit: [4096, 4096]
    end
    has_many_attached :attachments do |attachment|
      attachment.variant :tiny, resize_to_limit: [64, 64]
      attachment.variant :thumb, resize_to_limit: [128, 128]
      attachment.variant :small, resize_to_limit: [256, 256]
      attachment.variant :medium, resize_to_limit: [512, 512]
      attachment.variant :large, resize_to_limit: [1024, 1024]
      attachment.variant :xlarge, resize_to_limit: [4096, 4096]
    end

    has_rich_text :comments

    def has_value? = value.present?

    def path = [section.path, name.to_s].join("/")

    def to_s = value.to_s

    def allow_extras? = allow_attachments? || allow_comments? || allow_tasks?

    def has_extras? = allow_extras? && (!comments.to_plain_text.blank? || files.attachments.any?)
  end
end
