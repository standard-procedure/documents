# Form Section Management Implementation Plan

## Overview
Add `add_section` and `remove_section` functionality to the `Documents::Form` class for repeating forms. This will allow dynamic management of form sections while maintaining data integrity and proper field structure.

## Current State Analysis

### Form Structure
- `Documents::Form` inherits from `Element`
- Has `section_type` enum: `static` (0) or `repeating` (1)
- Has many `FormSection` objects ordered by position
- Automatically creates first section via `after_save` callback
- Only `repeating` forms should support add/remove operations

### FormSection Structure
- Belongs to form with positioning support
- Has many `field_values` ordered by position
- Field values are created during form initialization via `Container#load_elements_from`
- Dependency: destroying section cascades to field_values (`dependent: :destroy`)

### Field Value Creation Pattern
- Field configs stored in YAML/JSON template under `fields` array
- Created with: `type`, `name`, `description`, `required`, `position`
- Additional attributes may include `default_value`, `options` (for select fields)

## Implementation Plan

### 1. Store Field Configuration Template

**Problem**: Currently, field configuration is only used during initial creation and not persisted for later use.

**Solution**: Modify `Container#load_elements_from` to store the field configuration in the Form's `data` attribute.

```ruby
# In Container concern (line 28-29)
form = elements.create!(
  type: "Documents::Form",
  position: :last,
  section_type: element_config["section_type"],
  display_type: element_config["display_type"],
  description: element_config["description"] || "",
  field_template: element_config["fields"] || []  # Store field config
)
```

### 2. Add Methods to Form Class

#### `add_section` Method
- **Precondition**: Only works for `repeating` forms
- **Action**: Creates new `FormSection` and populates with field_values from template
- **Positioning**: New section added at the end (`position: :last`)

```ruby
def add_section
  return false unless section_type_repeating?
  
  new_section = sections.create!(position: :last)
  populate_section_fields(new_section)
  new_section
end

private

def populate_section_fields(section)
  field_template.each do |field_config|
    section.field_values.create!(
      type: field_config["field_type"],
      name: field_config["name"],
      description: field_config["description"],
      required: field_config["required"] || false,
      default_value: field_config["default_value"],
      options: field_config["options"] || {},
      position: :last
    )
  end
end
```

#### `remove_section` Method  
- **Precondition**: Only works for `repeating` forms
- **Constraint**: Must maintain minimum of 1 section
- **Action**: Destroys the last section (cascade deletes field_values)

```ruby
def remove_section
  return false unless section_type_repeating?
  return false if sections.count <= 1
  
  sections.last.destroy
  true
end
```

### 3. Add Field Template Support

Add `has_attribute` to Form for storing field configuration:

```ruby
# In Documents::Form
has_attribute :field_template, :array, default: []
```

### 4. Comprehensive RSpec Tests

Create `/spec/models/documents/form_spec.rb` following existing patterns:

#### Test Structure
- **Validations/Setup**: Test form creation and initial state
- **add_section Method**:
  - Success case: repeating form adds section with correct fields
  - Failure case: static form cannot add sections
  - Field verification: new section has all expected field types and attributes
  - Positioning verification: new section positioned correctly
- **remove_section Method**:
  - Success case: repeating form with multiple sections removes last one
  - Failure case: static form cannot remove sections  
  - Constraint case: cannot remove last section (minimum 1 required)
  - Cascade verification: removing section deletes associated field_values

#### Sample Test Structure
```ruby
describe "section management" do
  context "repeating forms" do
    describe "#add_section" do
      it "creates new section with correct field structure"
      it "positions new section at the end"
      it "returns the new section"
    end
    
    describe "#remove_section" do  
      it "removes the last section"
      it "prevents removing the last remaining section"
      it "destroys associated field_values"
    end
  end
  
  context "static forms" do
    describe "#add_section" do
      it "returns false and does not create section"
    end
    
    describe "#remove_section" do
      it "returns false and does not remove section"  
    end
  end
end
```

## Implementation Steps

1. **Modify Container concern** to store field_template during form creation
2. **Add field_template attribute** to Form model  
3. **Implement add_section method** with field population logic
4. **Implement remove_section method** with validation constraints
5. **Write comprehensive RSpec tests** covering all scenarios
6. **Run test suite** to ensure no regressions

## Considerations

### Data Integrity
- Field template stored in form ensures consistency across all sections
- Positioning gem handles section ordering automatically
- Dependent destroy on FormSection handles field_value cleanup

### Security/Validation
- Only repeating forms can add/remove sections
- Minimum 1 section requirement prevents forms becoming empty
- Field types validated through existing FieldValue STI structure

### Performance
- Field creation uses same pattern as initial creation (efficient)
- No complex queries needed - uses existing associations
- Positioning changes handled by gem (optimized)

### Future Enhancements
- Could add `insert_section_at(position)` for non-terminal insertion
- Could add `remove_section_at(position)` for specific section removal
- Could add validation to prevent removing sections with data