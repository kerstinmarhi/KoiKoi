extends Node2D

var player_hand = []
var enemy_hand = []
var table_cards = []

@onready var players: Array[Node]= [$Player , $Enemy]

var player_played_cards = []
var enemy_played_cards = []

@onready var round_effect = preload("res://CustomResources/round_effect.gd").new()
@onready var DeckRes = preload("res://CustomResources/card_deck.tres")
@onready var CardScene = preload("res://Scenes/Card.tscn")
@onready var PoolCardScene = preload("res://Scenes/Pool_Card.tscn")

var deck

func _ready():
	# Instanziiere das Deck
	deck = DeckRes.duplicate() as CardPile
	deck.shuffle()
	deal_initial_cards()
	start_round()
	
# Karten ziehen
func draw_cards(num_cards: int) -> Array:
	var cards = []
	for i in range(num_cards):
		if not deck.empty():
			cards.append(deck.draw_card())
	return cards

# Teile die Anfangskarten aus
func deal_initial_cards():
	player_hand = draw_cards(8)
	table_cards = draw_cards(8)
	
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
	start_round()  
	
func play_card(card: CardRes, player: Player):
	# Hier wird die Logik implementiert, wenn eine Karte gespielt wird
	# Zum Beispiel:
	if player == $Player:
		player_played_cards.append(card)
	else:
		enemy_played_cards.append(card)

	# Weitere Spiellogik hier hinzufügen
	check_for_matches(card)
	update_scores()
	check_for_game_end()

func check_for_matches(card: CardRes):
	# Überprüfe, ob die gespielte Karte mit einer auf dem Tisch übereinstimmt
	for pool_card in table_cards:
		if pool_card.month == card.month:
			# Logik für das Match
			print("Match found!")
			table_cards.erase(pool_card)
			table_cards.append(card)  # Beispiel für das Hinzufügen der gespielten Karte

func update_scores():
	# Logik zur Aktualisierung der Punktestände
	pass

func check_for_game_end():
	# Überprüfe, ob das Spiel zu Ende ist
	if deck.empty() and player_hand.empty() and enemy_hand.empty():
		print("Game Over!")
		# Weitere Logik für das Spielende
