class_name CardRes
extends Resource

enum Month {JANUARY, FEBRUARY,MARCH,APRIL,MAY,JUNE,JULY,AUGUST,
			SEPTEMBER,OCTOBER,NOVEMBER,DECEMBER}
enum Type {BRIGHT,ANIMAL,RIBBON,CHAFF}
enum Subtype {NONE, MOON, FLOWERS, RAIN, SAKE, DEER, BOAR, BUTTERFLY, POETRY, BLUE}

@export_group("Card Attributes")
@export var id: String
@export var month: Month
@export var type: Type
@export var subtype: Subtype
@export var sprite: Texture

func play(targets: Array[Node], char_stats: Stats):
	Events.card_played.emit(self)
	apply_effects(targets)

func apply_effects(_targets: Array[Node]):
	pass
	
