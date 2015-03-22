class TemplateMergeSingle < TemplateMerge

  def render_to_file(output_path)
    MotiaTools.logger.info("\nAttempting to merge template and csv data...")
    return log_errors unless valid?
    File.open(output_path, "w") do |outfile|
      outfile << render
    end
    MotiaTools.logger.info("SUCCESS!\nTemplate and data merged into the file '#{output_path}'.")
  end


private ########################################################################


  def render
    @template.result(binding)
  rescue SyntaxError => exc
    MotiaTools.logger.error("Syntax error encountered in the template. Details below.\n#{exc.message}")
  rescue NoMethodError => exc
    method_name = exc.message.match(/^undefined method `(?<method_name>\w+)'/)[:method_name]
    MotiaTools.logger.error("NoMethodError while merging data into template. The problem was with '#{method_name}'.\nCheck that the loaded header names match the '#{method_name}' code in the template.\nTechnical details:\n#{exc.message}")
  end

end
