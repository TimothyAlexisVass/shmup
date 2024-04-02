extends Node2D

const LIGHT_HEIGHT_MIN = 0.6
const LIGHT_HEIGHT_SPAN = 0.1
const LIGHT_HEIGHT_FREQ = 22.2

const LIGHT_ROTATION_MIN = deg_to_rad(-115.0)
const LIGHT_ROTATION_SPAN = deg_to_rad(50)
const LIGHT_ROTATION_FREQ = 30.0

const LIGHT_ENERGY_MIN = 0.4
const LIGHT_ENERGY_SPAN = 0.2
const LIGHT_ENERGY_FREQ = 33.2

var time = 0.0

var second = 0.0

func _process(delta):
	time += delta
	second += delta

	var height_offset = sin(time * TAU / LIGHT_HEIGHT_FREQ) * LIGHT_HEIGHT_SPAN / 2.0
	$DirectionalLight2D.height = LIGHT_HEIGHT_MIN + height_offset

	var rotation_offset = sin(time * TAU / LIGHT_ROTATION_FREQ) * LIGHT_ROTATION_SPAN / 2.0
	$DirectionalLight2D.rotation = LIGHT_ROTATION_MIN + rotation_offset

	var energy_offset = sin(time * TAU / LIGHT_ENERGY_FREQ) * LIGHT_ENERGY_SPAN / 2.0
	$DirectionalLight2D.energy = LIGHT_ENERGY_MIN + energy_offset
