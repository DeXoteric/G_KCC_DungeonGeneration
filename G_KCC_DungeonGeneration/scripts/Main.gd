extends Node2D

export var tile_size: int
export var num_rooms: int
export var min_size: int
export var max_size: int
export var horizontal_spread: int

var cull := 0.5
var room = preload("res://scenes/Room.tscn")


func _ready():
	randomize()
	make_rooms()

func _process(delta):
	update()

func _draw():
	for room in $Rooms.get_children():
		draw_rect(Rect2(room.position - room.size, room.size * 2), Color(32, 228, 0), false)

func _input(event):
	if event.is_action_pressed("ui_select"):
		for n in $Rooms.get_children():
			n.queue_free()
		make_rooms()

func make_rooms():
	for i in range(num_rooms):
		var position = Vector2(rand_range(-horizontal_spread, horizontal_spread), 0)
		var new_room = room.instance()
		var width = min_size + randi() % (max_size - min_size)
		var height = min_size + randi() % (max_size - min_size)
		new_room.make_room(position, Vector2(width, height) * tile_size)
		$Rooms.add_child(new_room)
	yield(get_tree().create_timer(1.1), "timeout")
	for room in $Rooms.get_children():
		if randf() < cull:
			room.queue_free()
		else:
			room.mode = RigidBody2D.MODE_STATIC


