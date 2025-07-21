class CreateDocumentsFormSections < ActiveRecord::Migration[8.0]
  def change
    create_table :documents_form_sections do |t|
      t.belongs_to :form, foreign_key: {to_table: "documents_elements"}
      t.integer :position, null: false
      t.timestamps
      t.index [:form_id, :position], unique: true
    end
  end
end
