# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Rails engine gem called `standard_procedure_documents` that provides configurable document templates. The gem allows creating structured documents with elements like paragraphs and forms, where forms can contain various field types for user input.

## Development Commands

### Running Tests
```bash
# Run all specs
bundle exec rake spec

# Run specific spec file
bundle exec rspec spec/models/documents/element_spec.rb
```

### Database Setup
```bash
# Prepare test database (required before running specs)
bundle exec rake app:db:test:prepare

# Install migrations in host application
bin/rails standard_procedure_documents:migrations:install db:migrate db:test:prepare
```

### Code Quality
- Uses `bundle exec standardrb --fix` for code formatting

## Architecture

### Coding Style

- Use the ternary operator instead of `if`, where possible, to keep methods short
- Use ruby's endless methods to reduce the number of lines in class definitions
- In specs, avoid `let` statements and define variables within the example, so it is easy to see the exact data being tested

### Core Models Hierarchy

**Documents::Element** (STI base class)
- `Documents::Paragraph` - Static HTML content
- `Documents::Form` - Interactive forms with fields
- `Documents::Video`, `Documents::Image`, `Documents::Download`, `Documents::Table`, `Documents::PageBreak` - Other content types

**Documents::FieldValue** (STI base class) 
- Expected subclasses (currently missing): `TextValue`, `DateValue`, `NumberValue`, `SignatureValue`, `CheckboxValue`, `EmailValue`, `FileValue`, etc.

### Key Concepts

**Container Pattern**: Models that include `Documents::Container` concern can hold document elements:
- Provides `elements` association (ordered by position)
- Provides `load_elements_from(configuration)` method for building documents from YAML/JSON templates

**Element Structure**:
- Elements belong to a container (polymorphic)
- Forms have `section_type` (static/repeating) and `display_type` (form/table)
- Forms contain FormSections, which contain FieldValues
- Uses `positioning` gem for ordered associations

**Template System**: 
- Uses `dry-validation` for schema validation
- Template configurations define document structure with elements and fields
- See `lib/documents/document_definition.rb` and example in README.md

### File Organization

**Engine Structure**:
- `lib/documents/` - Core business logic, validation schemas
- `app/models/documents/` - ActiveRecord models  
- `spec/test_app/` - Test Rails application for integration testing
- Database migrations in `db/migrate/`

**Validation Schemas**:
- `DocumentDefinitionSchema` - Validates overall template structure
- `ElementDefinitionSchema` - Validates individual elements (paragraph/form)  
- `FieldDefinitionSchema` - Validates field definitions within forms

### Dependencies

- Rails 7.1.3+
- `dry-validation` for schema validation
- `standard_procedure_has_attributes` for storing attributes in a JSON field
- `positioning` for ordered associations

### Test App Setup

The `spec/test_app/` directory contains a full Rails application used for testing:
- Includes `OrderForm` model as example container
- Database configured with SQLite
- Fixtures in `spec/test_app/spec/fixtures/files/`

### Known Gaps

**Missing Field Value Classes**: The codebase references many field value subclasses (`Documents::TextValue`, `Documents::DateValue`, etc.) that are not yet implemented but are expected by tests and validation schemas.

**Missing ElementBuilder**: README mentions `Documents::ElementBuilder.call()` but this functionality appears to be in the `load_elements_from` method on containers instead.