extends Control

# Ability types
enum Ability { ATTACK, MAGIC, DEFEND, ULTIMATE }

# Player and enemy stats
var player_hp: int = 100
var enemy_hp: int = 100
var player_defending: bool = false
var enemy_defending: bool = false
var player_turn: bool = true

# Coding questions (example pool)
var questions = [
       {"question": "What is the output of print(2 + 2)?", "answer": "4"},
       {"question": "What keyword defines a function in Python?", "answer": "def"},
       {"question": "What symbol starts a comment in Java?", "answer": "//"},
       {"question": "What is the HTML tag for a link?", "answer": "a"}
]
var current_question = null

@onready var options: WindowDefault = $BattleLayout/Battle/Options
@onready var options_menu: Menu = $BattleLayout/Battle/Options/Options

func _ready() -> void:
       options_menu.button_focus(0)
       update_ui()

func _on_options_button_focused(button: BaseButton) -> void:
       # Optionally highlight or show info about the ability
       pass

func _on_options_button_pressed(button: BaseButton) -> void:
       if not player_turn:
	       return
       var ability = button.text.to_lower()
       match ability:
	       "attack":
		       ask_question(Ability.ATTACK)
	       "magic":
		       ask_question(Ability.MAGIC)
	       "defend":
		       ask_question(Ability.DEFEND)
	       "ultimate":
		       ask_question(Ability.ULTIMATE)

func ask_question(ability_type):
       current_question = questions[randi() % questions.size()]
       # Show the question to the player (replace with your UI logic)
       show_question_popup(current_question["question"], ability_type)

# Example: Call this when the player submits an answer
func on_player_answer_submitted(answer: String, ability_type):
       if answer.strip_edges().to_lower() == current_question["answer"].to_lower():
	       apply_ability(ability_type)
       else:
	       # Wrong answer, lose turn
	       show_feedback("Wrong! You lose your turn.")
	       end_player_turn()

func apply_ability(ability_type):
       match ability_type:
	       Ability.ATTACK:
		       var dmg = 20
		       if enemy_defending:
			       dmg /= 2
		       enemy_hp -= dmg
		       show_feedback("Attack successful! Dealt %d damage." % dmg)
	       Ability.MAGIC:
		       var dmg = 30
		       if enemy_defending:
			       dmg /= 2
		       enemy_hp -= dmg
		       show_feedback("Magic successful! Dealt %d damage." % dmg)
	       Ability.DEFEND:
		       player_defending = true
		       show_feedback("You brace for the next attack!")
	       Ability.ULTIMATE:
		       var dmg = 50
		       if enemy_defending:
			       dmg /= 2
		       enemy_hp -= dmg
		       show_feedback("Ultimate move! Dealt %d damage." % dmg)
       end_player_turn()

func end_player_turn():
       player_turn = false
       player_defending = false
       update_ui()
       await get_tree().create_timer(1.0).timeout
       enemy_action()

func enemy_action():
       # Simple AI: random action
       var action = randi() % 3
       match action:
	       0:
		       var dmg = 15
		       if player_defending:
			       dmg /= 2
		       player_hp -= dmg
		       show_feedback("Enemy attacks! You take %d damage." % dmg)
	       1:
		       enemy_defending = true
		       show_feedback("Enemy is defending!")
	       2:
		       var dmg = 25
		       if player_defending:
			       dmg /= 2
		       player_hp -= dmg
		       show_feedback("Enemy uses magic! You take %d damage." % dmg)
       end_enemy_turn()

func end_enemy_turn():
       enemy_defending = false
       player_turn = true
       update_ui()

func update_ui():
       # Update HP bars, turn indicators, etc.
       pass

func show_question_popup(question: String, ability_type):
       # Implement your popup logic here
       print("QUESTION:", question)
       # Simulate answer for demo: call on_player_answer_submitted("answer", ability_type)
       pass

func show_feedback(text: String):
       # Implement your feedback UI here
       print(text)
