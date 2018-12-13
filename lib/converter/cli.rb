require 'pry'
class CLI
  def run
    set_dir
    get_convert_file
    get_write_file
    convert
  end

  def set_dir
    Dir.chdir(Dir.home + '/documents')
  end

  def get_convert_file
    puts "Enter the file path to convert".colorize(:light_magenta)
    print 'Documents/'
    @read_path = gets.strip
    if File.exists?(@read_path)
      return
    else
      puts 'Invalid Input, Please Try Again.'.colorize(:light_red)
      get_convert_file
    end
  end

  def get_write_file
    puts "Enter the file path to write to".colorize(:light_magenta)
    print 'Documents/'
    @write_path = gets.strip
    if File.exists?(@write_path)
      return
    else
      print 'File does not exist, would you like to create it? [Y/N]'.colorize(:light_red)
      create_file = gets.strip
      if create_file[0].downcase === 'y'
        File.new(@write_path, 'w')
        puts "created a name file named #{File.basename(@write_path)}".colorize(:light_green)
      else
        get_write_file
      end
    end
  end

  def convert
    puts "Extracting data from #{File.basename(@read_path)}".colorize(:light_green)
    extracted_data = CSV.table(@read_path)

    transformed_data = extracted_data.map { |row| row.to_hash }

    puts "Converting data to JSON".colorize(:light_green)
    File.open(@write_path, 'w') do |file|
      file.puts JSON.pretty_generate(transformed_data)
    end
    puts "JSON is ready in #{File.basename(@write_path)}".colorize(:light_green)
    puts "Enjoy!".colorize(:light_blue)
  end
end
