class_name DropItem extends Node2D

var auto_pickup = false

var category_name: String
var item_name: String
var tier: int = 1
var amount: float = 1.0

var recipient = null

const SPEED = 100

func _ready():
	$Sprite/RarityGlow.rarity = G.rarity(tier)
	$Sprite/RarityGlow.texture = $Sprite.texture

func _physics_process(delta):
	if is_instance_valid(recipient) && recipient.is_playing:
		var magnet_direction = recipient.global_position - global_position
		var magnet_effect = min(27, (1000 * DataManager.player_data.commander.magnet_multiplier /  magnet_direction.length()))
		translate(delta * (Vector2.DOWN * SPEED + magnet_direction.normalized() * magnet_effect ** 2))

func _on_area_entered(area):
	if area == recipient:
		pick_up()

func pick_up():
	DataManager.add(category_name, item_name, amount)
	amount = 0
	clear()

func clear():
	queue_free()
