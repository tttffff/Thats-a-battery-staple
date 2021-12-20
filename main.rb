#!/usr/bin/env ruby
# Open a word file. Could have used /usr/share/dict/words, but not everyone has a dictionary installed, and some people use Windows.
# To do - Have a default file that can be changed with a command line argument
word_file = File.open("word_list/common3000.list.txt")
# To do - find a better way to get the size of the file that doesn't include opening it all in memory. Can't use wc as people might be using Windows.
number_of_words_to_choose_from = word_file.readlines.size
# To do - Allow users to select number of words to give using a command line argument
number_of_words_to_give = 4

answer = ""
random_word_line_numbers = number_of_words_to_give.times.map{ Random.rand(number_of_words_to_choose_from) }.sort
next_word = random_word_line_numbers.shift()
word_file.readlines.each_with_index do |line, line_number|
    if line_number == next_word
      answer += line
      next_word = random_word_line_numbers.shift()
    end
end

word_file.close
puts answer
