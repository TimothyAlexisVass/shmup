extends Node

var effect: Cannon.DOT_EFFECT
var duration
var power

var interval = 0.5
var next_effect_time = interval

func _physics_process(delta):
	if effect == Cannon.DOT_EFFECT.BURN:
		next_effect_time -= delta
		while next_effect_time <= 0:
			get_parent().take_damage(self)
			next_effect_time += interval
	elif effect == Cannon.DOT_EFFECT.RADIATION:
		get_parent().take_damage(self)

	duration -= delta
	if duration <= 0:
		clear_effect()

func clear_effect():
	set_physics_process(false)
	queue_free()
