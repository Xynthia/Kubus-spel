class_name UI
extends Control

const DRAGON_STUDIO_SINGLE_KEY_PRESS_393908 = preload("uid://bx5efqfy2i2kx")
const LIGHTNINGBULB_SPACEBAR_CLICK_KEYBOARD_199448 = preload("uid://dkimiv2nocm0o")


@onready var button: Button = $Control/VBoxContainer/Button
@onready var start_race: Button = $Control/VBoxContainer/start_race

@onready var label: Label = $Control2/Label
@onready var label_race_won: Label = $Control3/Label

enum number {zero, one, two, three}
var current_number : number = number.three
@onready var timer: Timer = $Timer

func _physics_process(delta: float) -> void:
	if GameManager.finished_race:
		label_race_won.text = GameManager.won_race_name + " has won!"
		label_race_won.visible = true

func _on_button_pressed() -> void:
	if GameManager.player.in_transformation_modus:
		GameManager.player.exit_transformation_mode()
	
	if GameManager.current_scene == GameManager.WORLD:
		GameManager.start_race_area()
		start_race.visible = true
		button.text = "world"
		
		GameManager.cpu.visible = true
	elif GameManager.current_scene == GameManager.RACE:
		GameManager.start_testing_area()
		start_race.visible = false
		button.text = "race"
		
		label_race_won.visible = false
		GameManager.started_race = false
		GameManager.finished_race = false
		GameManager.cpu.visible = false


func _on_start_race_pressed() -> void:
	start_race.visible = false
	label.visible = true
	GameManager.RACE.play_intro_animation()
	GameManager.player.racing_sfx.play()
	timer.start()

func count_down() -> void:
	match current_number:
		number.three:
			label.text = "2"
			GameManager.player.racing_sfx.play()
			current_number = number.two
			timer.start()
		number.two:
			label.text = "1"
			GameManager.player.racing_sfx.play()
			current_number = number.one
			timer.start()
		number.one:
			label.text = "GO!"
			GameManager.player.racing_sfx.stream = DRAGON_STUDIO_SINGLE_KEY_PRESS_393908
			GameManager.player.racing_sfx.play()
			current_number = number.zero
			GameManager.started_race = true
			timer.start()
		number.zero:
			label.visible = false
			GameManager.player.racing_sfx.stream = LIGHTNINGBULB_SPACEBAR_CLICK_KEYBOARD_199448
			label.text = "3"
			current_number = number.three
	
	


func _on_timer_timeout() -> void:
	count_down()
