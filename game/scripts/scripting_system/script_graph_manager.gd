class_name ScriptGraphManager extends Node2D

var interacted_element: StaticBody2D = null

func _physics_process(delta):
	get_global_mouse_position()
	
	var mouse_position = get_viewport().get_mouse_position()
	
	# check if we can interact with an element
	if interacted_element == null and Input.is_action_just_pressed("left_click"):
		var element = get_element_at_position(mouse_position)
		if element:
			print(element.name)
			interacted_element = element
			#interacted_element.is_in_group("")
	
	# check if we stopped interacting with the currently interacted element 
	if interacted_element != null and Input.is_action_just_released("left_click"):
		interacted_element = null
	
	# move the currently dragged element
	if interacted_element != null:
		move_element(mouse_position)

func get_element_at_position(pos: Vector2) -> StaticBody2D:
	var query = PhysicsPointQueryParameters2D.new()
	query.position = pos
	var results = get_world_2d().direct_space_state.intersect_point(query)
	if results.size() > 0:
		var highest_z_index: int = 0
		var selected_element: StaticBody2D = results[0].collider as StaticBody2D
		for r in results:
			var element = r.collider as StaticBody2D
			if element.z_index > highest_z_index:
				highest_z_index = element.z_index
				selected_element = element
		return selected_element
	return null

func move_element(target_pos: Vector2):
	interacted_element.global_position = target_pos
