module Documents
  class Form < Element
    enum :section_type, static: 0, repeating: 1
    enum :display_type, form: 0, table: 1
    enum :form_submission_status, draft: 0, submitted: 1, cancelled: -1

    has_many :sections, -> { order :position }, class_name: "FormSection", dependent: :destroy
  end
end
