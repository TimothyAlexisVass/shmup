class_name Shot extends Area2D

# TODO: Fix shot_duration, area of impact, and such instead of queue_free()
# TODO: Fix homing
# TODO: Fix add_dot_effect to actually add a DotEffect instance to the target, if it doesn't already have one
# TODO: Review the code to make sure everything is in place as it should be

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
	
	# Handle shot duration
	if time_elapsed >= duration:
		queue_free()
	
	# Handle homing
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

func hit(target):
	var hit_effect = hit_effect_scene.instantiate()
	hit_effect.modulate = modulate
	hit_effect.global_position = self.global_position
	hit_effect.rotation = G.ANGLE_DOWN + self.global_position.angle_to_point(target.global_position)
	hit_effect.emitting = true
	G.player_layer.add_child(hit_effect)
	
	if dot_effect != Cannon.DOT_EFFECT.NONE:
		apply_dot_effect(target)
	
	# Handle penetration
	if (penetration_count + ricochet_count) <= 0 and randf() > penetration_chance:
		queue_free()
	else:
		if penetration_count > 0:
			penetration_count -= 1
		if ricochet_count > 0:
			ricochet_count -= 1
			rotation += PI + randf_range(-1, 1) * randf_range(Cannon.DEG_20, Cannon.DEG_60)
		power *= falloff_rate

func apply_dot_effect(target):
	if dot_effect == Cannon.DOT_EFFECT.RADIATION:
		target.add_dot_effect("radiation", dot_duration, power * 0.01)
	elif dot_effect == Cannon.DOT_EFFECT.BURN:
		target.add_dot_effect("burn", dot_duration, power * 0.3)

func _on_target_hit(target):
	if not target is Player:
		if area_of_impact > 0:
			apply_area_impact()
		else:
			target.owner.handle_hit(self)

func apply_area_impact():
	var impact_area = CircleShape2D.new()
	impact_area.radius = area_of_impact
	var area2d = Area2D.new()
	area2d.set_shape(impact_area)
	add_child(area2d)
	for target in area2d.get_overlapping_areas():
		if not target is Player:
			target.owner.handle_hit(self)
