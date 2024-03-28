class_name CollisionShapeGenerator extends Node

static func generate(image):
	var bitmap = BitMap.new()
	bitmap.create_from_image_alpha(image)
	var polys = bitmap.opaque_to_polygons(Rect2(Vector2.ZERO, bitmap.get_size()), 8.0)

	for poly in polys:
		var collision_polygon = CollisionPolygon2D.new()
		collision_polygon.polygon = poly
		collision_polygon.position -= bitmap.get_size()/2.0
		return collision_polygon
