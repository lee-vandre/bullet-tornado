extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const mesh_count = 10
const radius = 5
var isinrange = false
var _body :CharacterBody3D

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
func teleport_execution(body: CharacterBody3D):
	for i in range(mesh_count):
	# Calculate the angle for each mesh
		var angle = (i * 2 * PI) / mesh_count
		
		# Calculate the position along the circle using trigonometry
		var x = body.position.x + radius * cos(angle)
		var z = body.position.z + radius * sin(angle)
		print(x, ",@ ", z)
		
		# If you want to rotate them on the Y-axis to face the player, you can adjust here
		var spawning_position = Vector3(x, body.position.y, z)
		print(body.position)
		var newmesh =MeshInstance3D.new()
		newmesh.position = spawning_position
		newmesh.mesh = CapsuleMesh.new()
		body.add_child(newmesh) 
		

func _process(delta: float) -> void:
	if isinrange ==true and Input.is_action_just_pressed("teleport"):
		teleport_execution(_body)
		
		
func get_circumference() -> int:
	var circumference = 2*3.14159*5
	return circumference


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body != self and is_instance_of(body,CharacterBody3D):
		_body =body
		isinrange = true
	pass # Replace with function body.


func _on_area_3d_body_exited(body: Node3D) -> void:
	isinrange = false
	pass # Replace with function body.
