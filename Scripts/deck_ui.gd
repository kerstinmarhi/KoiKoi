extends Node2D

# Definition einer Karte
class CardType:
	var month: int
	var type: int

	func _init(month, type):
		self.month = month
		self.type = type

# Erstelle das Hanafuda-Deck
var deck = []

func _ready():
	initialize_deck()
	shuffle_deck()

# Initialisiere das Deck mit 48 Karten
func initialize_deck():
	deck.clear()
	for month in range(1, 13):
		for type in range(4):
			deck.append(CardType.new(month, type))

# Mische das Deck
func shuffle_deck():
	var n = deck.size()
	while n > 1:
		n -= 1
		var k = randi() % (n + 1)
		var temp = deck[n]
		deck[n] = deck[k]
		deck[k] = temp

# Teile Karten aus
func deal_cards(num_cards: int) -> Array:
	var dealt_cards = []
	for i in range(num_cards):
		if deck.size() > 0:
			dealt_cards.append(deck.pop_back())
	return dealt_cards

# Prüfe, ob das Deck leer ist
func is_deck_empty() -> bool:
	return deck.size() == 0


