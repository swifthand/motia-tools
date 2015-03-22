# MOTIA Tools

A short collection of scripts originally built to assist the [Houston Mayor's Office of Trade and International Affairs](http://houstontx.gov/motia).

## Simple ERB and CSV Merge Tools

Merge data into a common template to avoid manual content generation and save time. The motivating use case was merging data from a CSV file with an HTML template to avoid tedious data input via a CMS system (i.e. internal Drupal).

### Notes on CSV Headers

It is assumed that the CSV file has headers. Headers will be made available as method calls on the various `row` objects available to a template.

Because of the restrictions on punctuation and spaces in method names, the headers will be converted via the following process:

- Leading and trailing spaces are removed.
- Letters converted to lower case.
- All interior whitespace and punctuation compacted into a single underscore.

Examples:

- "First Name" will become `first_name`
- "E-mail" will become `e_mail`
- "E - mail" will also become `e_mail`
- "Email" will become `email`
- "City, State, Zipcode" will become `city_state_zipcode`

The user is notified of the names of the headers found in a given CSV, after conversion.
Beginning a header with punctuation or a number may cause an error.

### TemplateMergeSingle
The `TemplateMergeSingle` class will provide a template with a `list` variable containing all the CSV rows, and render the output to a single file.

### TemplateMergeMultiple
The `TemplateMergeMultiple` class will render the template multiple times, and produce a new output file each time. Specifically, one render per row in the CSV. The data in a given row is provided via a `row` variable to the template.

Unlike `TemplateMergeSingle`, the method `render_to_file` does not take a single file path as an argument, but instead requires a block, which must return a unique filename for each row. The block is given the row number and row data itself to allow flexibility in naming. 

Examples:

```ruby
template    = 'test/test_multiple_template.html.erb'
data_source = 'test/test_multiple_data.csv'
merge       = TemplateMergeMultiple.new(template, data_source)

# Naming output files with a prefix and the row number:
merge.render_to_file do |row, row_number|
  "result_number_#{row_number}.html"
end

# Naming output files with some data from the row itself:
merge.render_to_file do |row, row_number|
  "#{row.title}_contact_page.html"
end
```
