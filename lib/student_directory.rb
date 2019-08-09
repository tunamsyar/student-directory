require 'colorize'

@students = []

def welcome_msg
  puts 'Welcome to HELL'.red
end

def input_name_and_sin
  @students << { name: name_input, sin: sin_input }
  puts "Now we have #{@students.length} students"
end

def add_names_and_sin_msg
  input_name_and_sin

  return list_students unless confirmation_input.downcase == 'y'

  add_names_and_sin_msg
end

def write_to_file(filename)
  return puts "No students in list".red unless @students.any?

  headers = ['Name', 'Sin']
  File.open(filename, 'w') do |file|
    file.puts headers.join(',')

    @students.each do |student|
      file.puts [student[:name], student[:sin]].join(',')
    end
  end
  puts "#{filename} exported".green
end

def load_from_file(filename)
  return puts 'File not found' unless File.exists?(filename)

  File.open(filename, 'r') do |file|
    data = file.readlines
    data.each do |d|
      next if d.include?('Name')
      arr = d.strip.split(',')
      @students << { name: arr[0], sin: arr[1] }
    end
  end
  puts "#{filename} imported".green
  list_students
end

def list_students
  return puts "No students in Hell".red unless @students.any?

  puts 'BURN BABY BURN'.yellow
  @students.each_with_index do |student, i|
    puts "#{i+1}. #{student[:name]} guilty of #{student[:sin]}"
  end
end

def clear_student_list
  @students.clear
  puts 'Student list cleared'.yellow
end

def print_menu_selection
  puts "\n1. Input students"
  puts '2. List Students'
  puts '3. Export to file'
  puts '4. Import from file'
  puts '5. Clear list'
  puts '9. Bye Felicia'
end

def menu_selection(menu_number)
  case menu_number
  when '1'
    add_names_and_sin_msg
  when '2'
    list_students
  when '3'
    write_to_file(file_input)
  when '4'
    load_from_file(file_input)
  when '5'
    clear_student_list
  when '9'
    exit
  else
    puts 'No selection made'
  end
end

def user_input
  print '>> '
  gets.chomp
end

def name_input
  puts "\nPlease enter the names and sin"
  puts "Please Enter Name:"
  name = user_input
  return name unless name.strip == ''

  puts "Cannot be blank!!".red
  name_input
end

def sin_input
  puts "Please Enter Sin:"
  sin = user_input
  return sin unless sin.strip == ''

  puts "Cannot be blank!!".red
  sin_input
end

def confirmation_input
  puts 'Would you like to add more?'
  confirmation = user_input
  return confirmation unless confirmation.strip == ''

  puts "Cannot be blank!!".red
  confirmation_input
end

def file_input
  puts "\nPlease Enter File Name: "
  filename = user_input
  return filename unless filename.strip == ''

  puts "Cannot be blank!!".red
  file_input
end

def show_menu
  load_from_file('full_list.csv')
  loop do
    print_menu_selection
    menu_selection(user_input)
  end
end

show_menu
