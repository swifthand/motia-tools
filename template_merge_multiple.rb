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
    end
  end

end
