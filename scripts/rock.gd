extends StaticBody2D

var health: int

@export var data: RockData

@onready var sprite_2d : Sprite2D = $Sprite2D
#called when the node enters the scene tree for the first time.
func _ready() -> void:
	#pass #replace with function body
	health = data.max_health
	sprite_2d.textuer = data.texture
