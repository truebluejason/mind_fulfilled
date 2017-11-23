require 'constants.rb'
include Constants

class BaseScreen

	def get_action
		# Displays line through yield and adds "Type Here: "
		print "Type Here: "
		input = gets.chomp.downcase
	end

	def blank num=1
		# Insert num numbers of newline characters
		num.times do
			puts "\n"
		end
	end

	def line num=1
		# Insert num numbers of dashes
		num.times do
			puts "-"*SCREEN_SIZE
		end	
	end

	def pretty_puts(string, indent=false)
		# Formats the text input to fit the horizontal character size of SCREEN_SIZE
		string.tr!("\n","")
		string.tr!("\t","")
		length = string.length
		indent_space = indent ? '  ' : ''
		until length <= SCREEN_SIZE do
			beginning = string[0,SCREEN_SIZE-1]
			last_space_index = beginning.rindex(' ')
			if last_space_index != nil
				puts indent_space + string[0,last_space_index]
				string = string[(last_space_index + 1)..length]
			else
				puts indent_space + string[0,SCREEN_SIZE-1]
				string = string[SCREEN_SIZE..length]
			end
			length = string.length
		end
		puts indent_space + string if length > 0
	end

	def title_puts string
		# Centers a short text
		length = string.length
		if length > 0 && length <= SCREEN_SIZE
			space = " "*((SCREEN_SIZE-length)/2)
			message = length%2 == 0 ? space + string + space : space + string + space + " "
			puts message
		end
	end

	def invalid_input
		line
		pretty_puts "That is not a valid input! Please try again."
		line
	end
end