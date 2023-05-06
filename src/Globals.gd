extends Node

enum GameLogLevel {INFO, WARNING, ALERT}

var master_volume:float = 100
var music_volume:float = 100
var sfx_volume:float = 100

const GameDataPath = "user://conf.cfg"
var config:ConfigFile

var debug_build := false
var music

enum Commands {LEFT, UP, RIGHT, DOWN}

func _ready():
	_init_logger()	
	Logger.info("Init complete.")	

#	music = AudioStreamPlayer.new()
#	music.stream = load ("res://assets/music/WGJ Main menu mp3.mp3")
#	music.volume_db=-10
#	music.play()
#	music.bus="Music"
#	add_child(music)

func _init_logger():
	Logger.set_logger_level(Logger.LOG_LEVEL_INFO)
	Logger.set_logger_format(Logger.LOG_FORMAT_MORE)
	var console_appender:Appender = Logger.add_appender(ConsoleAppender.new())
	console_appender.logger_format=Logger.LOG_FORMAT_FULL
	console_appender.logger_level = Logger.LOG_LEVEL_DEBUG
	var file_appender:Appender = Logger.add_appender(FileAppender.new("res://debug.log"))
	file_appender.logger_format=Logger.LOG_FORMAT_FULL
	file_appender.logger_level = Logger.LOG_LEVEL_DEBUG

	
#
#func load_data():
#	var password = OS.get_unique_id() # works only on this computer
#	config = ConfigFile.new()
#	if not File.new().file_exists(GameDataPath):
#		Logger.info("Config file does not exist. A new one will be saved.")
#		return config
#
#
#	config.load_encrypted_pass(GameDataPath, password)	
#
#	return config
#
#func save_data():
#	var password = OS.get_unique_id() # works only on this computer
#
#
#	config.save_encrypted_pass(GameDataPath, password)
#	config.save("user://SaveFile_unencrypted.cfg") # for testing	
#
#	Logger.info("Config saved.")
#
#func _exit_tree():
#	save_data()

