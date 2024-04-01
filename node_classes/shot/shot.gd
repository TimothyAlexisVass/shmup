class_name Shot extends Area2D

var acceleration = 0
var source

var hit_effect_scenes = {
	"plasma": preload("res://scenes/hit_effects/plasma.tscn")
}
var shot_types = {
	0: {
		"type": "plasma",
		"texture": preload("res://assets/sprites/shots/plasma.png"),
		"offset": Vector2(0, 22),
		"hit_effect": hit_effect_scenes.plasma
	}
}

@onready var direction = Vector2.UP.rotated(rotation)
@onready var game = get_node('/root/Game')
@onready var speed = source.shot_speed

func initialize(_source):
	source = _source

func _ready():
	$Sprite.modulate = source.shot_color
	$PointLight2D.color = source.shot_color
	$Sprite.texture = shot_types[source.shot_type].texture

func _physics_process(delta):
	translate(direction * speed * delta)
	var angle = abs(direction.angle_to(Vector2.UP))
	var direction_to = Vector2.UP if angle < 1 else Vector2.DOWN
	direction = direction.lerp(direction_to, angle / 150)
	speed += speed * acceleration * delta
	rotation = G.ANGLE_DOWN + direction.angle()

func hit(target):
	var hit_effect = shot_types[source.shot_type].hit_effect.instantiate()
	hit_effect.modulate = source.shot_color * 2
	hit_effect.position = (self.global_position - target.global_position) - (self.global_position - target.global_position)/3.0
	hit_effect.rotation = G.ANGLE_DOWN + self.global_position.angle_to_point(target.global_position)
	hit_effect.emitting = true
	target.add_child(hit_effect)
	queue_free()
