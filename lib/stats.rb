require 'yaml'
require 'base_screen.rb'
require 'constants.rb'
include Constants

class Stats < BaseScreen

	def initialize
		userdata = File.join(DATA_PATH,"userdata.yml")
		@loaded_data = YAML.load_file(userdata)
	end

	def start!
		invalid_flag = false

		quit = false
		until quit do
			action = stats_action invalid_flag
			case action
			when "distractions"
				blank SCREEN_GAP
				distractions
			when "logs"
				blank SCREEN_GAP
				logs
			when "q1"
				blank SCREEN_GAP
				display_q 1
			when "q2"
				blank SCREEN_GAP
				display_q 2
			when "q3"
				blank SCREEN_GAP
				display_q 3
			when "menu"
				quit = true
			else
				invalid_flag = true
			end
			blank SCREEN_GAP
		end
	end

	def distractions
		line
		title_puts "List of Distractions"
		line
		blank
		contents = @loaded_data['data']['contents']
		contents.each do |key,value|
			pretty_puts key + ": " + value.to_s
		end
		blank 3
		pretty_puts 'Type "Back" to return to the main menu.'
		blank
		quit = false
		until quit do
			if get_action == "back"
				quit = true
			else
				invalid_input
			end
		end
	end

	def stats_action invalid_flag
		if invalid_flag
			invalid_input
			invalid_flag = false
		else
			blank 3
		end
		line
		pretty_puts 'Type any of the following keywords to proceed.'
		pretty_puts '1. "Distractions" to view a list of phenomenons that have distracted you.'
		pretty_puts '2. "Logs" to view your past meditation logs.'
		pretty_puts '3. "Q1", "Q2", or "Q3" to view your past responses to a question.'
		pretty_puts '4. "Menu" to return to the main menu.'
		blank
		action = get_action
	end
end