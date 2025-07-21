# Documents
Configurable documents

## Usage
Build a template using a JSON or YAML file (using [dry-validation](https://dry-rb.org/gems/dry-validation/1.10/) to ensure the schema is valid):

```yaml
title: Order Form
elements:
  - element: paragraph
    html: <h1>Order Form</h1>
  - element: paragraph
    html: <p>Place details of your order below
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
        field_type: "Documents::IntegerValue"
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

Create a "container" - a record within your application that will hold this order form.  Then use the `Document::ElementBuilder` to add it: 

```ruby
@order_form = OrderForm.create!
expect(@order_form).to be_kind_of(Documents::Container)

@configuration = YAML.load(File.read("order_form.yml"))
@order_form.load_elements_from(@configuration)

expect(@order_form.elements.first).to be_kind_of(Documents::Paragraph)
expect(@order_form.elements.last).to be_kind_of(Documents::Form)
expect(@order_form.elements.last.fields.last).to be_kind_of(Documents::SignatureValue)

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
Contributions welcome

## License
The gem is available as open source under the terms of the [LGPL License](/LICENCE).
