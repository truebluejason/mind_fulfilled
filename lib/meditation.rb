require 'yaml'
require 'base_screen.rb'
require 'log.rb'
require 'constants.rb'
include Constants

class Meditation < BaseScreen

	def initialize
		userdata = File.join(DATA_PATH,"userdata.yml")
		@loaded_data = YAML.load_file(userdata)
	end

	def start!
		setup
		meditate
		reflect
		save_data
	end

	def setup
		# Setup before the action session – sets duration, displays instruction
		# and confirms the start of the session
		proceed = false
		until proceed do
			blank 2
			line
			pretty_puts 'Desired Length of Meditation (minutes): '
			blank
			action = get_action.to_i # CHANGE TO MINUTES by * 60
			blank SCREEN_GAP
			if action > 0
				@duration = action * DURATION_MODIFIER
				proceed = true
			else
				invalid_input
			end 
		end
		proceed = false

		bindings = @loaded_data['options']['binding']
		until proceed do
			blank 2
			line
			title_puts 'Instructions'
			blank
			pretty_puts '1. Type "Y" to start the meditation session.'
			pretty_puts '2. Once the session begins and you notice that you have been distracted,'
			pretty_puts "1. Type \"1\" to indicate that you have been distracted by #{bindings[0]}.", true
			pretty_puts "2. Type \"2\" to indicate that you have been distracted by #{bindings[1]}.", true
			pretty_puts "3. Type \"3\" to indicate that you have been distracted by #{bindings[2]}.", true
			pretty_puts "4. Type \"4\" to indicate that you have been distracted by #{bindings[3]}.", true
			pretty_puts "5. Type \"5\" to indicate that you have been distracted by #{bindings[4]}.", true
			pretty_puts '6. Type "Quit" to quit the session any time. All stats will be saved.', true
			pretty_puts "3. When the session ends, there will be an 
						optional note that can be used to  record the meditation session's details."
			pretty_puts "4. Data from step 2 and 3 will be saved to be displayed in \"Stats\" section
						 of the app for your viewing later."
			blank
			action = get_action
			blank SCREEN_GAP
			if action == 'y'
				proceed = true
			else
				invalid_input
			end
		end
	end

	def meditate
		# Meditation session thread that keeps looping
		session = Thread.new do
			# screen for meditation
			simple_on = @loaded_data['options']['simple'] == 'true'
			dm = @loaded_data['options']['dm']
			@distractions = @loaded_data['options']['binding']
			@distract_counts = [0,0,0,0,0]
			top_distraction = ''

			# Set start time in the beginning
			start_time = Time.now
			min_delta = 0
			last_action = 0
			top_distraction = "________"
			curr_distraction = "________"
			invalid_flag = false

			# Until curr_time = start_time + duration, loop
			until min_delta >= @duration do
				# update the screen
				blank SCREEN_GAP
				line
				blank
				if simple_on 
					blank
				else 
					title_puts dm
				end
				blank 14
				if simple_on
					blank 2
				else
					pretty_puts "Watch for #{top_distraction} today."
					pretty_puts "Regained awareness from #{curr_distraction}!"
				end
				if invalid_flag
					invalid_input
					invalid_flag = false
				else
					blank 3
				end
				line
				last_action = get_action.to_i

				#handles user input
				case last_action
				when 1
					@distract_counts[0]+=1
					curr_distraction = @distractions[0]
				when 2
					@distract_counts[1]+=1
					curr_distraction = @distractions[1]
				when 3
					@distract_counts[2]+=1
					curr_distraction = @distractions[2]
				when 4
					@distract_counts[3]+=1
					curr_distraction = @distractions[3]
				when 5
					@distract_counts[4]+=1
					curr_distraction = @distractions[4]
				else
					invalid_flag = true
				end
				# update top distraction
				d_index = 0
				for i in 0...@distract_counts.length do
					if @distract_counts[d_index] < @distract_counts[i]
						d_index = i
					end
				end
				top_distraction = @distractions[d_index]

				# update elapsed time
				min_delta = ((Time.now - start_time)/60).to_i
			end
		end

		# Timer thread to end the meditation session
		timer = Thread.new do
			sleep @duration # *60
			session.kill
			blank SCREEN_GAP
			blank 11
			title_puts "Your #{@duration} minute session has finished."
			title_puts "Continue walking the path to enlightenment."
			blank 11
			sleep 5
			blank SCREEN_GAP
		end

		timer.join
	end

	def reflect
		# Acquire reflection notes from the user
		line
		title_puts "Optional Reflection Notes"
		line
		blank 17
		pretty_puts 'Describe in detail the most prominent distraction for this session.'
		pretty_puts 'Type the enter key to skip this question.'
		blank
		@q1 = get_action

		line
		title_puts "Optional Reflection Notes"
		line
		blank 17
		pretty_puts 'Describe your mind\'s predominant reaction upon being distracted.'
		pretty_puts 'Type the enter key to skip this question.'
		blank
		@q2 = get_action

		line
		title_puts "Optional Reflection Notes"
		line
		blank 17
		pretty_puts 'Describe any other relevant details you\'d like to note.'
		pretty_puts 'Type the enter key to skip this question.'
		blank
		@q3 = get_action

		blank SCREEN_GAP
	end

	def save_data
		# If doesn't exist, add title / count for a source of distraction to a hash
		stats_hash = @loaded_data['data']['contents']
		for i in 0...@distract_counts.length do
			key = @distractions[i]
			if stats_hash.has_key? key
				stats_hash[key] += @distract_counts[i]
			else
				stats_hash[key] = @distract_counts[i]
			end
		end
		# Add @duration to min_meditated and update streak
		@loaded_data['min_meditated'] += @duration
		last_used_date = @loaded_data['data']['last_used']
		streak_refresh = @loaded_data['data']['streak_refresh']
		today = Time.local(Time.now.year, Time.now.month, Time.now.day)
		if today - last_used_date < 60*60*24*2 && today >= streak_refresh
			@loaded_data['streak'] += 1
			@loaded_data['data']['streak_refresh'] += 60*60*24
			@loaded_data['data']['last_used'] = today
		end
		@loaded_data['data']['last_used'] = today
		# Create a Log item based on the session's details and convert the hash generated to YAML
		log = Log.new(@duration, @distractions, @distract_counts, @q1, @q2, @q3)
		@loaded_data['data']['session_info'] << log.to_hash
		# Convert hash to YAML and write the file
		File.open(File.join(DATA_PATH,"userdata.yml"), 'w') do |f|
			f.puts @loaded_data.to_yaml
		end
	end
end