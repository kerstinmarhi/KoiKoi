class_name CardPile
extends Resource

signal card_pile_size_changed(cards_amount)
@export var cards: Array[CardRes] = []
var cards_copy = cards

func empty() -> bool:
	return cards.is_empty()

func draw_card() -> CardRes:
	var card = cards.pop_front()
	card_pile_size_changed.emit(cards.size())
	return card

func add_card(card: CardRes):
	cards.append(card)
	card_pile_size_changed.emit(cards.size())

func shuffle():
	cards.shuffle()

func clear():
	cards.clear()
	card_pile_size_changed.emit(cards.size())

func reset_cards():
	cards = cards_copy
