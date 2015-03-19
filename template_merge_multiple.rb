class TemplateMergeMultiple

  attr_reader :list

  def initialize(template_path, csv_path)
    @template = load_template(template_path)
    @csv_rows = load_csv(csv_path)
    @list     = build_list(@csv_rows)
  end

  def render_to_file(&fetch_filename)
    @list.each.with_index do |row, idx|
      output_path = fetch_filename.call(row, idx + 2)
      File.open(output_path, "w") do |outfile|
        outfile << RowWrapper.new(row).render(@template)
      end
    end
  end


private ########################################################################


  def load_template(template_path)
    file_contents = open(template_path, 'r').read
    ERB.new(file_contents)
  end

  def load_csv(csv_path)
    csv_loader = EncodingPriorityCSV.new
    csv_loader.open_csv(csv_path)
  end

  def build_list(rows)
    rows.map do |row|
      row_struct(row).new(*row.to_h.values)
    end
  end

  def row_struct(row)
    @row_struct ||=
      Struct.new(*row.headers.map { |header| header.to_sym })
  end

  class RowWrapper < Struct.new(:row)
    def render(template)
      template.result(binding)
    end
  end

end
