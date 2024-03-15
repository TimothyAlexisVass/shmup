class_name CollisionShapeGenerator extends Node

static func generate(target, image):
	var bitmap = BitMap.new()
	target.find_child("Sprite").texture = ImageTexture.create_from_image(image)
	bitmap.create_from_image_alpha(image)
	var polys = bitmap.opaque_to_polygons(Rect2(Vector2.ZERO, bitmap.get_size()), 5)

	for poly in polys:
		var collision_polygon = CollisionPolygon2D.new()
		collision_polygon.polygon = poly
		collision_polygon.position -= bitmap.get_size()/2.0
		target.add_child(collision_polygon)
