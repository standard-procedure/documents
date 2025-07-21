module Documents
  class Form < Element
    enum :section_type, {static: 0, repeating: 1}, prefix: true
    enum :display_type, {form: 0, table: 1}, prefix: true
    enum :form_submission_status, draft: 0, submitted: 1, cancelled: -1

    has_many :sections, -> { order :position }, class_name: "FormSection", dependent: :destroy
    after_save :create_first_section, if: -> { sections.empty? }

    private def create_first_section = sections.create!
  end
end
