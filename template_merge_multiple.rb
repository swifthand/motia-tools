class TemplateMergeMultiple < TemplateMerge

  def render_to_file(&fetch_filename)
    MotiaTools.logger.info("\nAttempting to merge template and csv data...")
    return log_errors unless valid?
    @list.each.with_index do |row, idx|
      output_path = fetch_filename.call(row, idx + 2)
      File.open(output_path, "w") do |outfile|
        outfile << RowWrapper.new(row).render(@template)
      end
    end
    MotiaTools.logger.info("SUCCESS!\nTemplate and data merged into #{@list.count} files.")
  end


private ########################################################################

  class RowWrapper < Struct.new(:row)
    def render(template)
      template.result(binding)
    rescue SyntaxError => exc
      MotiaTools.logger.error(
        "Syntax error encountered in the template. Details below.\n"\
        "#{exc.message}")
    rescue NoMethodError => exc
      method_name = exc.message.match(/^undefined method `(?<method_name>\w+)'/)[:method_name]
      MotiaTools.logger.error(
        "NoMethodError while merging data into template. "\
        "The problem was with '#{method_name}'.\n"\
        "Check that the loaded header names match the '#{method_name}' code in the template.\n"\
        "Technical details:\n"\
        "#{exc.message}")
    end
  end

end
