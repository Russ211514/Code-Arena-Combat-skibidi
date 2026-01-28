extends Control

# Ability types
enum Ability { ATTACK, MAGIC, DEFEND, ULTIMATE }

# Player and enemy stats
var player_hp: int = 150
var enemy_hp: int = 150
var player_defending: bool = false
var enemy_defending: bool = false
var player_turn: bool = true



# Separate question pools for each ability
var attack_questions = [
    {"question": "What is 5 * 2?", "choices": ["7", "10", "12", "25"], "answer": "10"},
    {"question": "Which operator is used for subtraction in Python?", "choices": ["-", "+", "*", "/"], "answer": "-"}
]
var magic_questions = [
    {"question": "What is the result of 2 ** 3 in Python?", "choices": ["6", "8", "9", "12"], "answer": "8"},
    {"question": "Which keyword is used to import a module in Python?", "choices": ["require", "import", "include", "using"], "answer": "import"}
]
var defend_questions = [
    {"question": "What is the output of bool(0) in Python?", "choices": ["True", "False", "0", "None"], "answer": "False"},
    {"question": "Which symbol is used for comments in Python?", "choices": ["#", "//", "<!--", "--"], "answer": "#"}
]
var ultimate_questions = [
    {"question": "What is the output of print('A' + 'B')?", "choices": ["AB", "A B", "Error", "BA"], "answer": "AB"},
    {"question": "Which HTML tag is used for images?", "choices": ["img", "image", "src", "pic"], "answer": "img"}
]

var current_question = null
var current_ability = null


@onready var options: WindowDefault = $BattleLayout/Battle/Options
@onready var options_menu: Menu = $BattleLayout/Battle/Options/Options
@onready var question_panel: Panel = $Question/QuestionPanel
@onready var question_label: Label = $Question/QuestionPanel/Question
@onready var question_buttons: VBoxContainer = $QuestionButtons
@onready var choice_a: Button = $QuestionButtons/A
@onready var choice_b: Button = $QuestionButtons/B
@onready var choice_c: Button = $QuestionButtons/C
@onready var choice_d: Button = $QuestionButtons/D

func _ready() -> void:
    options_menu.button_focus(0)
    update_ui()
    hide_question_panel()
    # Connect answer buttons
    choice_a.pressed.connect(_on_choice_pressed.bind(0))
    choice_b.pressed.connect(_on_choice_pressed.bind(1))
    choice_c.pressed.connect(_on_choice_pressed.bind(2))
    choice_d.pressed.connect(_on_choice_pressed.bind(3))

func _on_options_button_focused(_button: BaseButton) -> void:
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
    var pool = []
    match ability_type:
        Ability.ATTACK:
            pool = attack_questions
        Ability.MAGIC:
            pool = magic_questions
        Ability.DEFEND:
            pool = defend_questions
        Ability.ULTIMATE:
            pool = ultimate_questions
    if pool.size() == 0:
        show_feedback("No questions for this ability!")
        return
    current_question = pool[randi() % pool.size()]
    current_ability = ability_type
    show_question_panel(current_question)


# Called when a choice button is pressed
func _on_choice_pressed(choice_idx: int) -> void:
    if current_question == null:
        return
    var answer = current_question["choices"][choice_idx]
    hide_question_panel()
    if answer.strip_edges().to_lower() == current_question["answer"].to_lower():
        apply_ability(current_ability)
    else:
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


# Show the question panel with choices
func show_question_panel(q):
    question_panel.visible = true
    question_buttons.visible = true
    question_label.text = q["question"]
    var choices = q["choices"]
    choice_a.text = choices[0]
    choice_b.text = choices[1]
    choice_c.text = choices[2]
    choice_d.text = choices[3]
    choice_a.disabled = false
    choice_b.disabled = false
    choice_c.disabled = false
    choice_d.disabled = false

func hide_question_panel():
    question_panel.hide()
    question_buttons.hide()

func show_feedback(text: String):
       # Implement your feedback UI here
       print(text)
