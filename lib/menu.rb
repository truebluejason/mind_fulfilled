require 'yaml'
require 'base_screen.rb'
require 'meditation.rb'
require 'constants.rb'
include Constants

class Menu < BaseScreen

	def initialize
		# Create user.yaml at data if it does not exist 
		# and initialize paths / @userdata yaml file
		@userdata = File.join(DATA_PATH,"userdata.yml")
		if !File.exists? @userdata
			userdata_hash = {
				'min_meditated' => 0,
				'streak'	 	=> 0,
				'options' 		=> {
					'dm'		=> "Stay Mindful",
					'simple'	=> "off",
					'binding'	=> ["a bodily sensation",
									"an emotion",
									"a thought",
									"a thought about thinking",
									"a strong desire"
									]
				},
				'data'			=> {
					'contents'	=> {
						
					},
					'notes' 	=> {
						'q1'	=> "",
						'q2'	=> "",
						'q3'	=> ""
					},
					'last_used' 	=> Time.local(Time.now.year, Time.now.month, Time.now.day),
					'streak_refresh'=> Time.local(Time.now.year, Time.now.month, Time.now.day)
				}
			}
			File.open(File.join(DATA_PATH,"userdata.yml"), 'w') do |f|
				f.puts userdata_hash.to_yaml
			end
		end
	end

	def start!
		menu_screen
		conclusion
	end

	def update_data
		# Updates setting and streak status
		@loaded_data = YAML.load_file(@userdata)

		last_used_date = @loaded_data['data']['last_used']
		streak_refresh = @loaded_data['data']['streak_refresh']
		today = Time.local(Time.now.year, Time.now.month, Time.now.day)

		if today-last_used_date >= 60*60*24*2
			@loaded_data['streak'] = 0
			@loaded_data['data']['streak_refresh'] = today
		end

		File.open(File.join(DATA_PATH,"userdata.yml"), 'w') do |f|
			f.puts @loaded_data.to_yaml
		end
	end

	def introduction
		line
		blank
		title_puts "Welcome to Mind Fulfilled!"
		blank
		line
		blank
		pretty_puts 'This is an interactive meditation app that aims
					 to enhance your mindfulness through illuminating
					 the triggers of your distraction. This should allow you
					 to be more aware of your personal distraction
					 triggers over time.'
	end

	def menu_screen
		# Portal method to different screens
		invalid_flag = false

		blank SCREEN_GAP
		quit = false
		until quit do
			# Reload @loaded_data after every cycle
			update_data
			action = menu_action invalid_flag
			blank SCREEN_GAP
			case action
			when "begin"
				session = Meditation.new
				session.start!
			when "stats"
			when "options"
			when "quit"
				quit = true
			else
				invalid_flag = true
			end
		end
	end

	def menu_action invalid_flag
		introduction
		blank 2
		pretty_puts 'Total Time Spent Meditating: ' + @loaded_data['min_meditated'].to_s + ' minutes'
		pretty_puts 'Streak: ' + @loaded_data['streak'].to_s + ' days'
		blank
		if invalid_flag
			invalid_input
			invalid_flag = false
		else
			blank 3
		end
		pretty_puts 'Type any of the following keywords to proceed.'
		pretty_puts '1. "Begin" to start meditating'
		pretty_puts '2. "Stats" to view past statistics'
		pretty_puts '3. "Options" to adjust program settings'
		pretty_puts '4. "Quit" to exit the program'
		blank
		action = get_action
	end

	def conclusion
		line
		title_puts 'I sincerely wish you happiness, whomever you are.'
		title_puts 'See you next time.'
		line
	end
end