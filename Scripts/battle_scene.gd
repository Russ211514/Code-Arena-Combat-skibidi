extends Control

@onready var options: WindowDefault = $BattleLayout/Battle/Options
@onready var options_menu: Menu = $BattleLayout/Battle/Options/Options

func _ready() -> void:
	options_menu.button_focus(0)

func _on_options_button_focused(button: BaseButton) -> void:
	pass # Replace with function body.

func _on_options_button_pressed(button: BaseButton) -> void:
	print(button.text)
