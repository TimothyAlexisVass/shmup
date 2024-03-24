class_name Shot extends Area2D

var acceleration = 0
var source

var hit_effect_scenes = {
	"plasma": preload("res://scenes/hit_effects/plasma.tscn")
}
var hit_effects = {
	"plasma": hit_effect_scenes.plasma
}
var shot_types = {
	"plasma": preload("res://assets/sprites/shots/plasma.png")
}

@onready var direction = Vector2.UP.rotated(rotation)
@onready var game = get_node('/root/Game')
@onready var speed = source.shot_speed

func initialize(_source):
	source = _source

func _ready():
	$Sprite.modulate = source.shot_color
	$Sprite.texture = shot_types[source.shot_type]

func _physics_process(delta):
	translate(direction * speed * delta)
	speed += speed * acceleration * delta

func hit(target):
	var hit_effect = hit_effects[source.shot_type].instantiate()
	hit_effect.modulate = source.shot_color * 2
	hit_effect.position = (self.global_position - target.global_position) - (self.global_position - target.global_position)/3.0
	hit_effect.rotation = Game.ANGLE_DOWN + self.global_position.angle_to_point(target.global_position)
	hit_effect.emitting = true
	target.add_child(hit_effect)
	queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
