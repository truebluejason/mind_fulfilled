module Constants
	# Have SCREEN_GAP, paths to the program
	SCREEN_GAP = 64
	SCREEN_SIZE = 80

	APP_ROOT = File.expand_path('.')
	LIB_PATH = File.join(APP_ROOT, 'lib')
	DATA_PATH = File.join(APP_ROOT, 'data')
	HELPER_PATH = File.join(APP_ROOT, 'helper')
end