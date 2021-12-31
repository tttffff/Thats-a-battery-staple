#!/usr/bin/env ruby

require 'optparse'

options = {}
OptionParser.new do |opt|
  opt.banner = "\nProvides random words from a list of words. For example, it can be used to generate passwords.\n\nUsage .\\main.rb [options]"
  opt.on('-f', '--word_file FILENAME', 'Set the word file to one of those that is included with this software') { |o| options[:word_file_name] = o }
  opt.on('-F', '--custom_word_file FILENAME', 'Sets the word file to a custom one on the user\'s system. Requires the full path'){ |o| options[:custom_word_file] = o}
  opt.on('-j', '--join STRING', 'Sets the string that joins the words'){ |o| options[:join_string] = o}
  opt.on('-l', '--list_word_files', 'Lists the word files that are included with this software') { |o| options[:list_files] = true }
  opt.on('-n', '--number NUMBER', Integer, 'Sets how many random words to generate') { |o| options[:number_of_words_to_give] = o }
  opt.on('-N', '--new_lines NUMBER', Integer, 'Sets how many new lines to print in-between words') { |o| options[:new_lines] = o }
  opt.on('-c', '--case CASE', 'Sets the case of each word. original|upper|lower|capitalise') { |o| options[:case] = o }
end.parse!

def print_random_words(options={})
    # Open a word file. Could have used /usr/share/dict/words, but not everyone has a dictionary installed and some people use Windows.
    word_file_directory = "word_lists/"
    word_file_name = options[:word_file_name] || "common-3000"
    word_file_path = options[:custom_word_file] || word_file_directory + word_file_name
    # To do - find a better way to get the size of the file that doesn't include opening it all in memory. Can't use wc as people might be using Windows.
    number_of_words_to_choose_from = File.open(word_file_path).readlines.size
    number_of_words_to_give = options[:number_of_words_to_give] || 5
    # If the user would like a string inbetween the words, then add that in. If not then provide no spaces.
    join_string = options[:join_string] || ""
    # How many new lines to use. To do - Make this better, look into better ways of taking command line argument first.
    new_lines = ""
    new_lines = "\n" * options[:new_lines] if options[:new_lines]
    # Probably not the best way to do this. See `if word_case != "original"` below.
    word_case = options[:case] || "original"

    # To hold the random words
    answer = []
    # Array of random line numbers to pull the random words from
    random_word_line_numbers = number_of_words_to_give.times.map{ Random.rand(number_of_words_to_choose_from) }.sort
    # Get the random words into the array
    next_word_line_number = random_word_line_numbers.shift()
    File.foreach(word_file_path).with_index do |line, line_number|
        if line_number == next_word_line_number
            answer.push(line.chomp)
            break if random_word_line_numbers.empty?
            next_word_line_number = random_word_line_numbers.shift()
        end
    end

    # Sets the case of each word. To do - It's likely that there is a better way to do this. 
    if word_case != "original"
        answer.map! do |word|
            if word_case == "upper"
                word.upcase
            elsif word_case == "lower"
                word.downcase
            elsif word_case == "capitalise"
                word.downcase.capitalize
            else
                abort "Wrong case passed as argument. Options are: original|upper|lower|capitalise ABORTING"
            end
        end
    end
    puts answer.join(join_string + new_lines)
end

def print_word_lists
    Dir.glob('word_lists/*').each do |file_path|
        puts file_path["word_lists/".length..-1]
    end
end

options[:list_files] ? print_word_lists : print_random_words(options)
