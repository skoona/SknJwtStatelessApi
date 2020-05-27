# Code Coverage

  SimpleCov.start do
    merge_timeout 1500
    minimum_coverage 50

    add_filter '/bin/'
    add_filter '/coverage/'
    add_filter '/spec/'
    add_filter '/vendor/'
    add_filter '/target/'

    add_group 'Main Application' do |src_file|
      ['mains'].any? do |item|
        src_file.filename.include? item
      end
    end
    add_group 'Configuration' do |src_file|
      ['config'].any? do |item|
        src_file.filename.include? item
      end
    end
  end
