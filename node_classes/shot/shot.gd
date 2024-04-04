class_name Shot extends Area2D

@onready var hit_effect_scene: PackedScene = preload("res://scenes/hit_effects/plasma.tscn")
var direction
var speed
var source

func _ready():
	direction = Vector2.DOWN.rotated(rotation).normalized()
	$PointLight2D.color = G.colored_light(modulate)
	modulate = G.glow(modulate, 2)
	if source is Player:
		set_collision_mask_value(G.COLLISION_LAYERS.NONPLAYER, true)
	else:
		set_collision_mask_value(G.COLLISION_LAYERS.PLAYER, true)

func _physics_process(delta):
	translate(direction * speed * delta)

func hit(target):
	var hit_effect = hit_effect_scene.instantiate()
	hit_effect.modulate = modulate
	hit_effect.position = (self.global_position - target.global_position) - (self.global_position - target.global_position)/3.0
	hit_effect.rotation = G.ANGLE_DOWN + self.global_position.angle_to_point(target.global_position)
	hit_effect.emitting = true
	target.add_child(hit_effect)
	queue_free()

func _on_target_hit(target):
	if target is Player:
		target.handle_hit(self)
	else:
		target.get_parent().handle_hit(self)
