class CreateDocumentsElements < ActiveRecord::Migration[8.0]
  def change
    create_table :documents_elements do |t|
      t.string :type
      t.belongs_to :container, polymorphic: true, index: true
      t.integer :position, null: false
      t.text :description
      t.text :html
      t.string :url
      t.integer :columns, default: 0, null: false
      t.integer :section_type, default: 0, null: false
      t.integer :display_type, default: 0, null: false
      t.integer :form_submission_status, default: 0, null: false
      t.text :data
      t.timestamps
      t.index [:container_type, :container_id, :position], unique: true
    end
  end
end
