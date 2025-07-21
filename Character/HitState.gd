extends State

class_name HitState

@export var damageable : Damageable
@export var dead_state : State
@export var dead_animation_node : String = "dead"
@export var knockback_speed : float = 100.0
@export var return_state : State

@onready var timer : Timer = $Timer

var is_knocking_back = false 

func _ready() -> void:
	damageable.connect("on_hit", on_damageable_hit)
	timer.one_shot = true
	if not timer.is_connected("timeout", _on_timer_timeout):
		timer.connect("timeout", _on_timer_timeout)

func on_enter():
	is_knocking_back = false 
	timer.stop() 

func on_damageable_hit(node : Node, damage_amount : int, knockback_direction : Vector2):
	if damageable.health > 0:
		if not is_knocking_back:
			is_knocking_back = true
			character.velocity = knockback_speed * knockback_direction
			timer.start()
			emit_signal("interrupt_state", self)
	else:
		emit_signal("interrupt_state", dead_state)
		playback.travel(dead_animation_node)

func on_exit():
	character.velocity = Vector2.ZERO 
	is_knocking_back = false 
	timer.stop()

func _on_timer_timeout():
	character.velocity.x = 0 
	next_state = return_state
