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
	end
end