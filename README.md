# Documents
Configurable documents

## Usage

### Creating a document from a configuration file 

Build a document using a JSON or YAML file.

This uses [dry-validation](https://dry-rb.org/gems/dry-validation/1.10/) to ensure the schema is valid.

```yaml
title: Order Form
elements:
  - element: paragraph
    html: <h1>Order Form</h1>
  - element: paragraph
    html: <p>Place details of your order below</p>
  - element: form
    section_type: static
    display_type: form
    fields:
      - name: company
        description: Company
        field_type: "Documents::TextValue"
        required: true
      - name: order_date
        description: Date
        field_type: "Documents::DateValue"
        required: true
        default_value: Date.now 
  - element: form
    section_type: repeating
    display_type: table
    fields:
      - name: item
        description: Item
        field_type: "Documents::TextValue"
        required: true
      - name: quantity
        description: Quantity
        field_type: "Documents::NumberValue"
        required: true
        default_value: 1
  - element: form
    section_type: static
    display_type: form
    fields:
      - name: ordered_by
        description: Your name
        field_type: "Documents::TextValue"
        required: true
      - name: signature
        description: Signed
        field_type: "Documents::SignatureValue"
        required: true
```

Create a "container" - a record within your application that will hold this order form.  Then load your configuration to create the elements and form values.

```ruby
@order_form = OrderForm.create!
expect(@order_form).to be_kind_of(Documents::Container)

@configuration = YAML.load(File.read("order_form.yml"))
@order_form.load_elements_from(@configuration)

expect(@order_form.elements.first).to be_kind_of(Documents::Paragraph)
expect(@order_form.elements.last).to be_kind_of(Documents::Form)
expect(@order_form.elements.last.fields.last).to be_kind_of(Documents::SignatureValue)
```

### Document Elements

Documents are built out of an ordered list of Elements.  

Elements can be content, such as Paragraphs, Images, Tables and Forms (although currently only Paragraphs and Forms can be loaded from a configuration file).

### Configuring Forms

Forms are split into two types - static and repeating - and repeating forms can be displayed as a form or a table.  

A static form consists of an ordered list of FieldValues, each with a type, such as `TextValue`, `NumberValue`, `SelectValue` and so on. A repeating form also has an ordered list of FieldValues but the end-user can choose to repeat that group multiple times - for example, in an order form, you may wish to place multiple items on a single form.  

FieldValues can be marked as `required`, `allow_comments` (so the end-user can add arbitrary text to their answer), `allow_attachments` (so the end-user can upload and attach files, photos and other documents to support their answer).  They can also specify a `default_value` (the meaning of which varies according to the field type) and select and multi-select values also have `options` - key/value pairs that they can pick in the user-interface.  

Finally, FieldValues can also be marked as `allow_tasks` - which means that a follow-up task system can be used alongside the form itself (for example, if performing a safety inspection, noting something that is not compliant and therefore assigning a fix to another person).  

## Installation
Add this line to your application's Gemfile:

```ruby
gem "standard_procedure_documents"
```

And then execute:
```bash
$ bundle
```
Then copy the migrations to your Rails application:
```bash
bin/rails standard_procedure_documents:migrations:install db:migrate db:test:prepare
```

## Contributing
Contributions welcome - but be nice.  

## License
The gem is available as open source under the terms of the [LGPL License](/LICENCE).
