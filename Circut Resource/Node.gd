extends Node

var shape = null
var draggable = false
var gold_amount = 300
var money_amount = 100

onready var drill = preload("res://Drill.tscn")
onready var timer = preload("res://PayDayTimer.tscn")
onready var machine = preload("res://Machine.tscn")
onready var box = preload("res://Box.tscn")
onready var coopervalue = get_node("CooperValue")
onready var moneyvalue = get_node("MoneyValue")
onready var Drill = get_node("SideBar/Drill")
onready var Machine = get_node("SideBar/Machine")
# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(true)
	pass
	
func _process(delta):
	coopervalue.set_text(str(gold_amount))
	moneyvalue.set_text(str(money_amount))
	var GoldNode = null
	var RejectNodes = []
	for node in get_node("GoldNodes").get_children():
		if Drill.overlaps_area(node):
			GoldNode = node
		else:
			RejectNodes.append(node)
	if draggable == false and GoldNode != null and Drill.overlaps_area(GoldNode) and money_amount > 99:
		for x in RejectNodes:
			if not Drill.overlaps_area(x):
				var d = drill.instance()
				get_node("SideBar").add_child(d)
				d.set_position(Vector2(GoldNode.get_position().x+30, GoldNode.get_position().y))
				money_amount -= 100
				break
	elif draggable == false and GoldNode != null and Drill.overlaps_area(GoldNode) and money_amount < 99:
		print("You do not have enough money")
	RejectNodes = []
	GoldNode = null
	
func _on_Drill_selected(node):
	if draggable:
		shape = node

func _on_Machine_machineselected(node):
	if draggable:
		shape = node
	
func _input(event):
	if event is InputEventMouseButton:
		var pointer = get_node("Pointer")
		if event.is_pressed():
			pointer.set_position(event.position)
			draggable = true
		elif shape != null:
			draggable = false
			if shape == Machine and draggable == false and gold_amount > 299:
				var m = machine.instance()
				get_node("SideBar").add_child(m)
				m.set_position(event.position) 
				m.set_scale(Vector2(2, 2))
				gold_amount -= 300
			elif shape == Machine and draggable == false and gold_amount < 299:
				print("Not Enough Gold")
			Drill.set_position(Vector2(954, 107))
			pointer.set_position(Vector2(0, 0))
			Machine.set_position(Vector2(950, 199))
			shape = null
			
	elif event is InputEventMouseMotion and shape != null:
		shape.translate(event.get_relative())



func _on_PayDayTimer_timeout():
	for x in get_node("SideBar").get_children():
		for y in get_node("GoldNodes").get_children():
			if x.overlaps_area(y):
				gold_amount += 30


func _on_MoneyDayTimer_timeout():
	for a in get_node("SideBar").get_children():
		if a == Machine:
			money_amount += 10
		#if a == Machine:
			#var b = box.instance()
			#get_node("SideBar").add_child(b)
			#b.set_position(Vector2(a.get_position().x + 5, a.get_position().y + 9))
			
func _on_Box_moneybox(node):
	money_amount += 50
	node.queue_free()
