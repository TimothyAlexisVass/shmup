class_name Shot extends Area2D

const IMPACT_AREA_SCENE = preload("res://node_classes/shot/impact_area.tscn")
const DOT_EFFECT_SCENE = preload("res://node_classes/shot/dot_effect.tscn")

@export var hit_effect_scene = preload("res://scenes/hit_effects/plasma.tscn")
var direction
var source
var power
var speed
var duration
var shot_spread
var homing_amount
var homing_priority
var penetration_chance
var penetration_count
var ricochet_count
var falloff_rate
var area_of_impact
var perfect_chance
var perfect_multiplier
var dot_effect
var dot_duration

# Internal variables for handling effects
var time_elapsed = 0
var penetrations = 0
var ricochets = 0

func _ready():
	rotation += randf_range(-1, 1) * shot_spread / 2.0
	direction = Vector2.DOWN.rotated(rotation).normalized()

	if perfect_chance > 0 and randf() < perfect_chance:
		power *= perfect_multiplier

	if get_node_or_null("PointLight2D"):
		$PointLight2D.color = G.colored_light(modulate)
		modulate = G.glow(modulate, 2)

	if source is Player:
		set_collision_layer_value(G.COLLISION_LAYERS.PLAYERSTUFF, true)
		set_collision_mask_value(G.COLLISION_LAYERS.NONPLAYER, true)
	else:
		set_collision_layer_value(G.COLLISION_LAYERS.NONPLAYERSTUFF, true)
		set_collision_mask_value(G.COLLISION_LAYERS.PLAYER, true)

func _physics_process(delta):
	translate(direction * speed * delta)
	time_elapsed += delta

	if time_elapsed >= duration:
		area_impact()
		queue_free()

	if homing_amount > 0:
		var target = get_homing_target()
		if target:
			G.rotate_towards_target(self, target.global_position, homing_amount * delta, G.ANGLE_UP)
			direction = Vector2.DOWN.rotated(rotation).normalized()

func get_homing_target():
	var targets = get_tree().get_nodes_in_group("Ships")
	if targets.size() == 0:
		return null

	match homing_priority:
		Cannon.HOMING_PRIORITY.RANDOM:
			targets = [targets.pick_random()]
		Cannon.HOMING_PRIORITY.CLOSEST:
			targets.sort_custom(closest)
		Cannon.HOMING_PRIORITY.LEASTHP:
			targets.sort_custom(least_hp)
		Cannon.HOMING_PRIORITY.MOSTHP:
			targets.sort_custom(most_hp)
		Cannon.HOMING_PRIORITY.LEASTPOWER:
			targets.sort_custom(least_power)
		Cannon.HOMING_PRIORITY.MOSTPOWER:
			targets.sort_custom(most_power)
	
	return targets[0] if targets.size() > 0 else null

func closest(a, b):
	return a.global_position.distance_to(global_position) < b.global_position.distance_to(global_position)

func most_hp(a, b):
	return a.current_health > b.current_health

func least_hp(a, b):
	return a.current_health < b.current_health

func least_power(a, b):
	return a.power_per_second < b.power_per_second

func most_power(a, b):
	return a.power_per_second > b.power_per_second

func add_hit_effect(target):
	var hit_effect = hit_effect_scene.instantiate()
	hit_effect.modulate = modulate
	hit_effect.global_position = global_position
	hit_effect.rotation = rotation if target == self else G.ANGLE_DOWN + global_position.angle_to_point(target.global_position)
	hit_effect.emitting = true
	G.player_layer.add_child(hit_effect)

func hit(target):
	add_hit_effect(target)
	
	if dot_effect != Cannon.DOT_EFFECT.NONE:
		apply_dot_effect(target)
	
	# Handle penetration
	if (penetration_count + ricochet_count) <= 0 or (penetration_chance > 0 and randf() > penetration_chance):
		queue_free()
	else:
		if penetration_count > 0:
			penetration_count -= 1
		if ricochet_count > 0:
			ricochet_count -= 1
			rotation += PI + randf_range(-1, 1) * randf_range(G.DEG_45, PI / 2.0)
			direction = Vector2.DOWN.rotated(rotation).normalized()
		power *= falloff_rate

func apply_dot_effect(target):
	var dot_effect_power
	if dot_effect == Cannon.DOT_EFFECT.RADIATION:
		dot_effect_power = power * 0.1
	elif dot_effect == Cannon.DOT_EFFECT.BURN:
		dot_effect_power = power * 10
	var dot_effect_instance = DOT_EFFECT_SCENE.instantiate()
	dot_effect_instance.duration = dot_duration
	dot_effect_instance.power = dot_effect_power
	dot_effect_instance.effect = dot_effect
	target.add_child(dot_effect_instance)

func area_impact():
	add_hit_effect(self)
	var ships = get_tree().get_nodes_in_group("Ships")
	for ship in ships:
		if ship.global_position.distance_to(global_position) < area_of_impact:
			ship.handle_hit(self)

func _on_target_hit(target):
	if not target is Player:
		if area_of_impact > 0:
			area_impact()
		else:
			target.owner.handle_hit(self)
