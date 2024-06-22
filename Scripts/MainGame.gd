extends Node2D

var player_hand = []
var enemy_hand = []
var table_cards = []

@onready var players: Array[Node]= [$Player , $Enemy]

var player_played_cards = []
var enemy_played_cards = []

@onready var round_effect = preload("res://CustomResources/round_effect.gd").new()
@onready var DeckScene = preload("res://Scenes/Deck.tscn")
@onready var CardScene = preload("res://Scenes/Card.tscn")
@onready var PoolCardScene = preload("res://Scenes/Pool_Card.tscn")

var deck

func _ready():
	# Instanziiere das Deck
	deck = DeckScene.instantiate()
	add_child(deck)
	deck.initialize_deck()
	deck.shuffle_deck()
	deal_initial_cards()

# Teile die Anfangskarten aus
func deal_initial_cards():
	player_hand = deck.deal_cards(8)
	table_cards = deck.deal_cards(8)
	
	update_player_hand_ui(player_hand, $PlayerHand/Hand)
	update_pool_ui(table_cards, $CardPool/CardPool/GridContainer)
# Aktualisiere die UI mit den ausgeteilten Karten
func update_player_hand_ui(hand, container: Container):
	clear_container(container)
	for card in hand:
		var card_instance = CardScene.instantiate()
		card_instance.set_card_data(card)
		container.add_child(card_instance)
		card_instance.parent = container

# Aktualisiere die UI mit den ausgeteilten Karten
func update_pool_ui(hand, container: Container):
	clear_container(container)
	for card in hand:
		var card_instance = PoolCardScene.instantiate()
		card_instance.set_card_data(card)
		container.add_child(card_instance)

func clear_container(container):
	for child in container.get_children():
		container.remove_child(child)
		child.queue_free()


func start_round():
	print("Starting a new round")
	round_effect.execute(players)

func _on_round_ended():
	print("Round ended")
	# Logik zum Handhaben des Endes der Runde
	# Z.B. Punkte berechnen, nächste Runde starten, usw.
	start_round()  # Beispiel: Nächste Runde starten
