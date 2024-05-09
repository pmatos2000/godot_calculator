extends Control

const NAME_GROUP_BUTTON := "button"
const NAME_GROUP_DISPLAY := "display"
const NAME_SIGNAL_BUTTON_PRESSED := "pressed"
const NAME_FUNC_BUTTON_PRESSED := "button_pressed"
const NUMBER_ZERO := "0"

var display: Label

enum IdNumber { First, Second}
var id_current_number := IdNumber.First

var list_number: Array[String] = [NUMBER_ZERO, NUMBER_ZERO]

func _add_digit(digit: String) -> void:
	if(list_number[id_current_number] == NUMBER_ZERO):
		list_number[id_current_number] = digit
	else:
		list_number[id_current_number] = list_number[id_current_number] + digit

func button_pressed(button_name: String) -> void:
	match button_name:
		"0", "1", "2", "3", "4", "5", "6", "7", "8", "9":
			_add_digit(button_name)

func _ready() -> void:
	display = get_tree().get_first_node_in_group(NAME_GROUP_DISPLAY)
	for button in get_tree().get_nodes_in_group(NAME_GROUP_BUTTON):
		var callable := Callable(self, NAME_FUNC_BUTTON_PRESSED).bind(button.name)
		button.connect(NAME_SIGNAL_BUTTON_PRESSED, callable)

func _process(delta) -> void:
	display.text = list_number[id_current_number]
