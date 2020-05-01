extends Area2D

signal selected(node)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Drill_area_entered(area):
	if area.get_name() == "Pointer":
		emit_signal("selected", self)