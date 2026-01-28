class_name Menu
extends Container

signal button_focused(button: BaseButton)
signal button_pressed(button: BaseButton)
signal ability_selected(ability: String)

@export var auto_wrap: bool = true
var index: int = 0

func _ready() -> void:
	for button in get_buttons():
		button.focus_entered.connect(on_button_focused.bind(button))
		button.pressed.connect(on_button_pressed.bind(button))

func get_buttons() -> Array:
	return get_children()

func button_focus(n: int = index) -> void:
	var button: BaseButton = get_buttons()[n]
	button.grab_focus()

func on_button_focused(button: BaseButton) -> void:
	emit_signal("button_focused", button)

func on_button_pressed(button: BaseButton) -> void:
	emit_signal("button_pressed", button)
	emit_signal("ability_selected", button.text)
