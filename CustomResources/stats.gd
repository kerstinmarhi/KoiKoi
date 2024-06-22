class_name Stats
extends Resource

signal stats_changed

@export var health := 10
@export var cards_per_turn: int
@export var draw_pile: CardPile
var discard: CardPile
var hand: CardPile

func set_health(value: int):
	health = clampi(value,0,10)
	stats_changed.emit()

func take_damage(damage: int):
	if damage <= 0:
		pass
		
	health -= damage
	stats_changed.emit()
	
func create_instance() -> Resource:
	var instance : Stats= self.duplicate()
	instance.health = 10
	instance.discard = CardPile.new()
	instance.hand=CardPile.new()
	return instance
