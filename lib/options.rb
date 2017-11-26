require 'yaml'
require 'base_screen.rb'
require 'constants.rb'
include Constants

class Options < BaseScreen

	def initialize
		userdata = File.join(DATA_PATH,"userdata.yml")
		@loaded_data = YAML.load_file(userdata)
	end

	def start!
		invalid_flag = false

		quit = false
		until quit do
			action = options_action invalid_flag
			case
			when action[0..2] == "dm "
				blank SCREEN_GAP
				handle_dm action
			when action[0..6] == "simple " && (action[7...action.length] == 'true' || action[7...action.length] == 'false')
				blank SCREEN_GAP
				handle_sm action
			when (valid_edit action) == true
				blank SCREEN_GAP
				handle_edit action
			when action[0..3] == "menu"
				quit = true
			else
				invalid_flag = true
			end
			blank SCREEN_GAP
		end

		save_data
	end

	def save_data
		File.open(File.join(DATA_PATH,"userdata.yml"), 'w') do |f|
			f.puts @loaded_data.to_yaml
		end
	end

	def handle_dm cmd
		msg = cmd[3...cmd.length]
		@loaded_data['options']['dm'] = msg
	end

	def handle_sm cmd
		msg = cmd[7...cmd.length]
		@loaded_data['options']['simple'] = msg
	end

	def handle_edit cmd
		puts "at handle_edit"
		msg = cmd[7...cmd.length] # edit 1 aye
		case cmd[5]
		when '1'
			@loaded_data['options']['binding'][0] = msg
		when '2'
			@loaded_data['options']['binding'][1] = msg
		when '3'
			@loaded_data['options']['binding'][2] = msg
		when '4'
			@loaded_data['options']['binding'][3] = msg
		else
			@loaded_data['options']['binding'][4] = msg
		end
	end

	def valid_edit action
		if action[0...5] == 'edit '
			if action[5...7] == '1 ' ||  action[5...7] == '2 ' || action[5...7] == '3 ' ||  action[5...7] == '4 ' ||  action[5...7] == '5 '
				return true
			end
		end
		return false
	end

	def options_action invalid_flag
		if invalid_flag
			invalid_input
			invalid_flag = false
		else
			blank 3
		end
		line
		pretty_puts "Default Message: #{@loaded_data['options']['dm']}"
		pretty_puts "Simple Mode: #{@loaded_data['options']['simple']}"
		pretty_puts "Current Distraction Contents:"
		@loaded_data['options']['binding'].each do |d|
			pretty_puts "- " + d
		end
		blank 3
		pretty_puts 'Type any of the following keywords to proceed.'
		pretty_puts '1. "dm your_custom_msg" to set Default Message to your message.'
		pretty_puts '2. "simple true" or "simple false" to turn Simple Mode on/off.'
		pretty_puts '3. "edit 1_to_5 your_custom_distraction" to edit your distraction contents shown during meditation.'
		pretty_puts '4. "Menu" to return to the main menu.'
		blank

		print "Type Here: " # Shouldn't downcase everything for this
		input = gets.chomp
		input[0] = input[0].downcase
		input
	end
end