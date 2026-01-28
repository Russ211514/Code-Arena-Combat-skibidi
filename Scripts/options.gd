class_name Menu
extends Container

signal button_focused(button: BaseButton)
signal button_pressed(button: BaseButton)

@export var auto_wrap: bool = true

var index: int = 0

func _ready() -> void:
	
	for button in get_buttons():
		button.focused_entered.connect(on_button_focused.bind(button))
		button.pressed.connect(on_button_pressed.bind(button))
	
	# TODO Fix for grids (poss only issue with > 2 col grid)
	if !auto_wrap:
		return
	
	var _class: String = get_class()
	var buttons: Array = get_buttons()
	var use_this_on_grid_containers: bool = false
	
	if use_this_on_grid_containers and get("columns"):
		var top_row: Array = []
		var bottom_row: Array = []
		var cols: int = self.columns
		var rows: int = round(buttons.size() / cols)
		var btm_range: Array = [rows * cols - cols, rows * cols - 1]

	# Ability Menu for Combat
	class_name Menu
	extends Container

	signal ability_selected(ability: String)

	@export var auto_wrap: bool = true
	var index: int = 0

	func _ready() -> void:
	       for button in get_buttons():
		       button.focused_entered.connect(on_button_focused.bind(button))
		       button.pressed.connect(on_button_pressed.bind(button))

	func get_buttons() -> Array:
	       return get_children()

	func button_focus(n: int = index) -> void:
	       var button: BaseButton = get_buttons()[n]
	       button.grab_focus()

	func on_button_focused(button: BaseButton) -> void:
	       # Optionally highlight or show info about the ability
	       pass

	func on_button_pressed(button: BaseButton) -> void:
	       # Emit a signal with the selected ability name (button text)
	       emit_signal("ability_selected", button.text)
		# Repeat for left and right columns.
