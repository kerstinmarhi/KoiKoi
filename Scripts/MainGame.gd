class_name Game
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
@onready var PlayedCardScene = preload("res://Scenes/CardPlayed.tscn")


@onready var played_cards_display=$PlayerPlayedCards/ColorRect/GridContainer
var deck

func _ready():
	# Instanziiere das Deck
	deck = DeckRes.duplicate() as CardPile
	deck.shuffle()
	deal_initial_cards()
	

# Teile die Anfangskarten aus
func deal_initial_cards():
	for i in range(8):
		player_hand.append(deck.draw_card())
		table_cards.append(deck.draw_card())
		enemy_hand.append(deck.draw_card())
	
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
		
	clear_container(played_cards_display)
	for card in player_played_cards:
		var card_instance = PlayedCardScene.instantiate()
		card_instance.set_card_data(card)
		played_cards_display.add_child(card_instance)
		card_instance.parent= played_cards_display

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
	
