extends Node
class_name BaseStats

# Holds the Base Stats for all objects so that the StatHandler can recover this values
# on refresh functions. Also is a way to visually separate the values on editor

################## WARNING ###################
# 	  DO NOT CHANGE THE VALUES ON CODE
#      USE THE EDITOR TO CHANGE VALUES
#         FOR EACH OBJECT LOCALLY
@export var speed = 5
@export var armour = 0
@export var damage = 20
@export var max_health = 100.0
@export var max_energy = 100.0
