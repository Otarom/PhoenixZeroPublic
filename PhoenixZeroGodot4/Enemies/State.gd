extends Node3D
class_name State

var StateMachine : StateMachine
var state_name = ""
var MainNode : Node3D
signal changed(state : State, new_state_name : String)

func enter():
	pass

func exit():
	pass

func update(delta):
	pass
	
func physics_update(delta):
	pass
