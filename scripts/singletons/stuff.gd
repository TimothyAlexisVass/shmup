extends Node

enum CANNON {Ballistic, Plasma}
var cannons = [
	{
		"name": "Ballistic",
		"resource": load("res://resources/cannons/Ballistic.tres")
	},
	{
		"name": "Plasma",
		"resource": load("res://resources/cannons/Plasma.tres")
	}
]

enum DEVICE {Shield}
var devices: Array

enum CHEST {Gems, Metals}
var chests: Array
