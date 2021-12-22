#!/usr/bin/env ruby

require 'optparse'

options = {}
OptionParser.new do |opt|
  opt.banner = "\nProvides random words from a list of words. For example, it can be used to generate passwords.\n\nUsage main.rb [options]"
  opt.on('-f', '--word_file FILENAME', 'Set the word file to one of those that is included with this software') { |o| options[:word_file_name] = o }
  opt.on('-F', '--custom_word_file FILENAME', 'Sets the word file to a custom one on the user\'s system. Requires the full path'){ |o| options[:custom_word_file] = o}
  opt.on('-l', '--list_word_files', 'Lists the word files that are included with this software') { |o| options[:list_files] = true }
  opt.on('-n', '--number NUMBER', Integer, 'Sets how many random words to generate') { |o| options[:number_of_words_to_give] = o }
end.parse!

def print_random_words(options={})
    # Open a word file. Could have used /usr/share/dict/words, but not everyone has a dictionary installed, and some people use Windows.
    word_file_directory = "word_lists/"
    word_file_name = options[:word_file_name] || "common-3000"
    word_file_path = options[:custom_word_file] || word_file_directory + word_file_name
    # To do - find a better way to get the size of the file that doesn't include opening it all in memory. Can't use wc as people might be using Windows.
    number_of_words_to_choose_from = File.open(word_file_path).readlines.size
    number_of_words_to_give = options[:number_of_words_to_give] || 5

    answer = ""
    random_word_line_numbers = number_of_words_to_give.times.map{ Random.rand(number_of_words_to_choose_from) }.sort
    next_word_line_number = random_word_line_numbers.shift()
    File.foreach(word_file_path).with_index do |line, line_number|
        if line_number == next_word_line_number
        answer += line
        break if random_word_line_numbers.empty?
        next_word_line_number = random_word_line_numbers.shift()
        end
    end

    puts answer
end

def print_word_lists
    Dir.glob('word_lists/*').each do |file_path|
        puts file_path["word_lists/".length..-1]
    end
end

options[:list_files] ? print_word_lists : print_random_words(options)
