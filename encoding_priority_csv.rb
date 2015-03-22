class EncodingPriorityCSV
  ENCODING_PRIORITIES = ['windows-1250', 'utf-8', 'iso-8859-1']

  StripConversion = ->(str) {
    str.nil? ? nil : str.strip
  }

  ParameterizeConversion = ->(str) {
    return nil if str.nil?
    str.strip.downcase
      .gsub(/\s+|\W+/, '_')
      .gsub(/\_+/, '_')
      .gsub(/^_|_$/, '')
  }

  attr_reader :encoding_priorities


  def initialize(encoding_priorities = ENCODING_PRIORITIES)
    @encoding_priorities = encoding_priorities
  end


  def csv_defaults
    { headers: true,
      header_converters: ParameterizeConversion,
      converters: StripConversion
    }
  end


  def open_csv(csv_path, **csv_options)
    csv_options = csv_defaults.merge(csv_options)
    file_with_encoding(csv_path, csv_options)
  rescue Errno::ENOENT => exc
    :not_found
  end


  # Try reading the entirety of the file with a particular encoding as a CSV
  # and choose the first one that doesn't break.
  def file_with_encoding(url, csv_options)
    valid_encoding = encoding_priorities.find do |encoding|
      begin
        CSV.new(open(url, "r:#{encoding}")).read
      rescue
        false
      end
    end
    if valid_encoding
      CSV.new(open(url, "r:#{valid_encoding}"), csv_options)
    else
      :no_encoding_selected
    end
  end

end
