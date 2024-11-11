extends Node3D
class_name StateMachine

@export var initial_state : State
@export var model : Node
@export var MainNode : Node3D
var current_state : State
var states : Dictionary = {}
signal state_changed(old_state:State, new_state:State)

func start():
	
	for child in get_children():
		if child is State:
			states[child.state_name] = child
			child.StateMachine = self
			child.MainNode = MainNode
			child.changed.connect(on_child_changed)
			
	initial_state.enter()
	current_state = initial_state

func _process(delta):
	if current_state:
		current_state.update(delta)
			

func _physics_process(delta):
	if current_state:
		current_state.physics_update(delta)

func on_child_changed(state: State, new_state_name : String):
	if state != current_state:
		return
	
	var new_state = states.get(new_state_name)
	if !new_state:
		return
	
	current_state.exit()
	new_state.enter()
	emit_signal("state_changed", current_state, new_state)
	
	current_state=new_state
			
