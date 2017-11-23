#Path Constants
APP_ROOT = File.dirname(__FILE__)
LIB_PATH = File.join(APP_ROOT, 'lib')

# File / Requirements Setup
$:.unshift(LIB_PATH)
require 'menu.rb'

# Start menu code with userdata.yml
menu = Menu.new
menu.start!