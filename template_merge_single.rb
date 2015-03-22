class TemplateMergeSingle

  attr_reader :list

  def initialize(template_path, csv_path)
    @template = load_template(template_path)
    @csv_rows = load_csv(csv_path)
    @list     = build_list(@csv_rows)
  end

  def render
    @template.result(binding)
  rescue SyntaxError => exc
    MotiaTools.logger.error("Syntax error encountered in the template. Details below.\n#{exc.message}")
  rescue NoMethodError => exc
    method_name = exc.message.match(/^undefined method `(?<method_name>\w+)'/)[:method_name]
    MotiaTools.logger.error("NoMethodError while merging data into template. The problem was with '#{method_name}'.\nCheck that the loaded header names match the '#{method_name}' code in the template.\nTechnical details:\n#{exc.message}")
  end

  def render_to_file(output_path)
    return log_errors unless valid?
    File.open(output_path, "w") do |outfile|
      outfile << render
    end
    MotiaTools.logger.info("\nSUCCESS!\nTemplate and data merged into the file '#{output_path}'.")
  end

  def valid?
    @valid ||= errors.empty?
  end

  def errors
    @errors ||= []
  end

  def log_errors
    MotiaTools.logger.error("Problems with TemplateMergeSingle. Details below.\n- #{errors.join("\n- ")}")
    :error
  end

private ########################################################################

  def load_template(template_path)
    file_contents = open(template_path, 'r').read
    ERB.new(file_contents)
  rescue Errno::ENOENT => exc
    errors << "Template file at '#{template_path}' not found."
    :not_found
  end

  def load_csv(csv_path)
    csv_loader  = EncodingPriorityCSV.new
    case (result = csv_loader.open_csv(csv_path))
    when :not_found
      errors << "CSV file at '#{csv_path}' not found."
    when :no_encoding_selected
      errors << "Could not read CSV file '#{csv_path}' with common encodings. Are you sure it is a CSV?"
    else
      log_headers(result)
      result
    end
  end

  def build_list(rows)
    rows.map do |row|
      row_struct(row).new(*row.to_h.values)
    end
  rescue ArgumentError, NameError => exc
    errors << "Could not build list. Maybe an issue with csv headers?"
    :error
  end

  def row_struct(row)
    @row_struct ||=
      Struct.new(*row.headers.map { |header| header.to_sym })
  end

  def log_headers(csv)
    headers = csv.readline.to_h.keys
    csv.rewind
    MotiaTools.logger.info("CSV opened with #{headers.count} headers:\n#{headers.join(', ')}")
  end

end
