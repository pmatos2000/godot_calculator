extends Control

const NAME_GROUP_BUTTON := "button";

func _ready():
	for button in get_tree().get_nodes_in_group(NAME_GROUP_BUTTON):
		print(button.name)
