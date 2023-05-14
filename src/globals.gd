extends Node

enum GameLogLevel {INFO, WARNING, ALERT}

var master_volume:float = 100
var music_volume:float = 100
var sfx_volume:float = 100

const GameDataPath = "user://conf.cfg"
var config:ConfigFile

var debug_build := false


const MENU_SCREEN = "res://src/menu/menu.tscn"
const MAIN_SCREEN = "res://src/main.tscn"
const GAMEOVER_SCREEN = "res://src/gameover/gameover.tscn"
const WIN_SCREEN = "res://src/win/win_screen.tscn"
const CHOOSE_PIECE = "res://src/choose_piece/choose_piece.tscn"

const TRANSITION_COLOR = Color("#009aff")

const START_DECK = preload("res://src/gui/deck/default_deck.tres")

var default_transition = {
	"pattern":"horizontal", 
	"wait_time":0,
	"color": TRANSITION_COLOR
}

var deck:
	get:
		return level_manager.current_deck
	
var player_in_turn:= false
var game_music_on := false
@onready var level_manager:LevelManager = $LevelManager
@onready var music:=$music

func _ready():
	_init_logger()
	Logger.info("Init complete.")
	if level_manager.current_deck.is_empty():
		level_manager.current_deck = START_DECK.generate()
	
#	music = AudioStreamPlayer.new()
#	music.stream = load ("res://assets/music/WGJ Main menu mp3.mp3")
#	music.volume_db=-10
#	music.play()
#	music.bus="Music"
#	add_child(music)

func start_game_music()->void:
	if not music.playing:
		music.volume_db=-80
		music.play()
		var tween:=create_tween().set_trans(Tween.TRANS_LINEAR)
		tween.tween_property(music, "volume_db",-15.0, 1)
		game_music_on = true


func stop_game_music()->void:
	music.stop()
	game_music_on = false
		
func _init_logger():
	Logger.set_logger_level(Logger.LOG_LEVEL_INFO)
	Logger.set_logger_format(Logger.LOG_FORMAT_MORE)
	var file_appender:Appender = Logger.add_appender(FileAppender.new("res://debug.log"))
	file_appender.logger_format=Logger.LOG_FORMAT_FULL
	file_appender.logger_level = Logger.LOG_LEVEL_DEBUG


func gameover():
	await get_tree().create_timer(2.5).timeout
	SceneManager.change_scene(GAMEOVER_SCREEN, default_transition)
	

func win():
	SceneManager.change_scene(WIN_SCREEN, default_transition)
	

func menu():
	SceneManager.change_scene(MENU_SCREEN, default_transition)
	

func can_continue() -> bool:
	return level_manager.current_level > 0
	

func tutorial():
	level_manager.tutorial_level()
	_main_screen()
	

func start():
	level_manager.reset_level()
	_main_screen()
	

func continue_game():
	_main_screen()
	

func next_level():
	if level_manager.is_last_level():
		menu()
	else:
		level_manager.next_level()
		
		if level_manager.is_tutorial():
			_main_screen()
		else:
			choose_piece()
	

func _main_screen():
	SceneManager.change_scene(MAIN_SCREEN, default_transition)
	start_game_music()
	

func choose_piece():
	SceneManager.change_scene(CHOOSE_PIECE, {
			"pattern_enter":"curtains", 
			"wait_time":0, 
			"color": TRANSITION_COLOR,
		})
	

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



func _on_music_finished():
	if game_music_on:
		start_game_music()
