load 'environment.rb'

## Example: Merging csv data as a list of rows into a single template.
def run_test_single
  template    = 'test/test_single_template.html.erb'
  data_source = 'test/test_single_data.csv'
  output_file = 'test/test_single_output_flag.html'
  merge       = TemplateMergeSingle.new(template, data_source)
  merge.render_to_file(output_file)
end

## Example: Merging each row in a csv with a template as its own file.
def run_test_multiple
  template    = 'test/test_multiple_template.html.erb'
  data_source = 'test/test_multiple_data.csv'
  merge       = TemplateMergeMultiple.new(template, data_source)
  merge.render_to_file do |row, row_number|
    "test/#{row.country}.html"
  end
end

run_test_multiple
