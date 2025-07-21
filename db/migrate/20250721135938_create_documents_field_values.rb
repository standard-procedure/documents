class CreateDocumentsFieldValues < ActiveRecord::Migration[8.0]
  def change
    create_table :documents_field_values do |t|
      t.belongs_to :section, foreign_key: {to_table: "documents_form_sections"}
      t.integer :position, null: false
      t.text :data
      t.string :name, null: false
      t.string :description, null: false
      t.string :type
      t.boolean :required, default: false, null: false
      t.boolean :allow_comments, default: false, null: false
      t.boolean :allow_attachments, default: false, null: false
      t.boolean :allow_tasks, default: false, null: false
      t.timestamps
      t.index [:section_id, :position], unique: true
    end
  end
end
