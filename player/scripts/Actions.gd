extends Node
class_name Actions

var action_buffer: Array = []
var elapsed_time: float = 0

class Action:
	var action: String
	var elapsed_time: float
	var delta: float



func capture_input(action: String, delta: float):
	elapsed_time += delta
	
	var new_action = Action.new()
	new_action.action = action
	new_action.elapsed_time = elapsed_time * delta
	new_action.delta = delta
	action_buffer.append(new_action)

