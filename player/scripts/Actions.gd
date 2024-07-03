extends Node
class_name Actions

var action_buffer: Array[Action] = []
var _mirror_action_buffer: Array[Action] = []

class Action:
	var move: float = 0
	var jump: bool = false
	var push: bool = false
	var grab: bool = false
	
func init_capture_input():
	return Action.new()

func capture_input(action: Action):
	action_buffer.append(action)
	
func pop_buffer_action() -> Action:
	var current_action = action_buffer.pop_front()
	_mirror_action_buffer.append(current_action)
	if current_action == null:
		action_buffer = _mirror_action_buffer
	return current_action
