extends Control

const NAME_GROUP_BUTTON := "button"
const NAME_GROUP_DISPLAY := "display"
const NAME_SIGNAL_BUTTON_PRESSED := "pressed"
const NAME_FUNC_BUTTON_PRESSED := "_button_pressed"

var display: Label

enum IdNumber { First, Second}
var id_current_number := IdNumber.First

var list_number: Array[String] = ["0", "0"]

func _add_digit(digit: String) -> void:
	if(list_number[id_current_number] == "0"):
		list_number[id_current_number] = digit
	else:
		list_number[id_current_number] = list_number[id_current_number] + digit

func _delete_digit() -> void:
	list_number[id_current_number] = list_number[id_current_number].left(-1)
	if(list_number[id_current_number].is_empty()):
		list_number[id_current_number] = "0"

func _add_point() -> void:
	if !list_number[id_current_number].contains("."):
		list_number[id_current_number] = list_number[id_current_number] + "."
		

func _button_pressed(button_name: String) -> void:
	match button_name:
		"0", "1", "2", "3", "4", "5", "6", "7", "8", "9":
			_add_digit(button_name)
		"Backspace":
			_delete_digit()
		"Ponto":
			_add_point()

func _ready() -> void:
	display = get_tree().get_first_node_in_group(NAME_GROUP_DISPLAY)
	for button in get_tree().get_nodes_in_group(NAME_GROUP_BUTTON):
		var callable := Callable(self, NAME_FUNC_BUTTON_PRESSED).bind(button.name)
		button.connect(NAME_SIGNAL_BUTTON_PRESSED, callable)

func _process(delta) -> void:
	display.text = list_number[id_current_number]
