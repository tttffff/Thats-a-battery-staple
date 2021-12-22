# Thats-a-battery-staple

Provides random words from a list of words. For example, it can be used to generate passwords.

Usage main.rb [options]
*    -f, --word_file FILENAME         Set the word file to one of those that is included with this software
*    -F, --custom_word_file FILENAME  Sets the word file to a custom one on the user's system. Requires the full path
*    -l, --list_word_files            Lists the word files that are included with this software
*    -n, --number NUMBER              Sets how many random words to generate

The directory "word_lists" includes word list files. But we can use any file of words with one word per line.
Using command line arguments, the user can select what word file [s]he would like to use, and the amount of random words to select.

e.g. `./main.rb -f rockyou-75 -n 20` will select 20 random words from the rockyou word file.
