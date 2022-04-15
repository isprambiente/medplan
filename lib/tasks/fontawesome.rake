# frozen_string_literal: true

# MAINTAINER Francesco Loreti <francesco.loreti@isprambiente.it>
# use: rails fontawesome:unused

namespace :fontawesome do
  desc 'All unused fontawesome icons'
  task unused: :environment do

    # Convert Fontawesome string into downcase string
    # separated with minus
    # For example: faExpandArrowsAlt --> fa-expand-arrows-alt)
    def convert(word, remove_text = '')
      word = word.gsub(/::/, '/')
      word = word.gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2')
      word = word.gsub(/([a-z\d])([A-Z])/,'\1_\2')
      word = word.tr("_", "-")
      word = word.tr(",", "")
      word = word.downcase
      word = word.gsub(remove_text, '')
      word = word.strip
      word
    end

    # Initialize variables
    fontawesome_file = Rails.root.join('app', 'javascript', 'awesome.js')
    removable_fonts = []
    open_stack = false
    start_line_text = "library.add("
    end_line_text = ")"
    remove_text = 'fa-'
    folders = [
      Rails.root.join('app', 'controllers', "*/*"),
      Rails.root.join('app', 'helpers', "*/*"),
      Rails.root.join('app', 'jobs', "*/*"),
      Rails.root.join('app', 'mailers', "*/*"),
      Rails.root.join('app', 'models', "*/*"),
      Rails.root.join('app', 'views', "*/*")
    ]

    # Check if fontawesome_file exist
    if File.exist?(fontawesome_file)
      # Open and read fontawesome_file
      File.foreach(fontawesome_file) do |line|
        # Check if line contain exit text
        # If has exit text, exit from procedure
        break if open_stack == true && line.include?(end_line_text)

        # Check if open_stack is true
        if open_stack
          # convert font into correct format
          # and remove text if necessary
          font = convert(line, remove_text)
          if font.present?
            # reinitialize bool variable every line
            font_exist = false
            Dir.glob(folders).reject {|f| File.directory?(f)}.each do |f|
              # set font_exist = true only if find icon into file
              font_exist = true if File.readlines(f).any?{|row| row.include?(font)}
            end
            # write icon only if not has found it into any files
            removable_fonts << line.tr(",", "").strip unless font_exist
          end
        end
        # Check if line contain first text
        # If has first text, set open_stack = true and
        # next line the procedure get value
        open_stack = true if line.include?(start_line_text)
      end
    end
    # write variable into terminal with unused fonts
    puts removable_fonts.uniq.sort
  end
end
