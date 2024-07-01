class_name Game
extends Node2D

enum Turn { PLAYER, ENEMY }
var current_turn: Turn = Turn.PLAYER

var player_hand = []
var player_played_cards = []
var enemy_hand = []
var enemy_played_cards = []
var table_cards = []
@onready var players: Array[Node]= [$Player , $Enemy]



@onready var round_effect = preload("res://CustomResources/round_effect.gd").new()
@onready var DeckRes = preload("res://CustomResources/card_deck.tres")
@onready var CardScene = preload("res://Scenes/Card.tscn")
@onready var PoolCardScene = preload("res://Scenes/Pool_Card.tscn")
@onready var PlayedCardScene = preload("res://Scenes/CardPlayed.tscn")


@onready var played_cards_display=$PlayerPlayedCards/ColorRect/GridContainer
@onready var drawn_card_display=$DrawnCardBox
var deck


#-----SETUP---------------------------------------------------------------
func _ready():
	BackGroundMusic.play_bg_music()
	deck = DeckRes.duplicate() as CardPile
	start_new_game()


func start_new_game():
	deck.shuffle()
	deal_initial_cards()
	drawn_card_display.hide()
	start_round()

func deal_initial_cards():
	for i in range(8):
		player_hand.append(deck.draw_card())
		table_cards.append(deck.draw_card())
		enemy_hand.append(deck.draw_card())
	
	update_player_hand_ui(player_hand, $PlayerHand/Hand)
	update_pool_ui(table_cards, $CardPool/CardPool/GridContainer)
	

#------UPDATE--------------------------------------------------------------------
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
		#card_instance.parent= played_cards_display

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
		
func remove_cards(card:Card, child:PoolCard):
	player_played_cards.append(child.card_data)
	player_played_cards.append(card.card_data)
	player_hand.remove_at(card.get_index())
	table_cards.remove_at(child.get_index())
	
	card.queue_free()
	child.queue_free()
	
	print("Match found: Card played and removed from hand and pool.")
	
	player_hand.append(deck.draw_card())
	table_cards.append(deck.draw_card())
	update_player_hand_ui(player_hand, $PlayerHand/Hand)
	update_pool_ui(table_cards, $CardPool/CardPool/GridContainer)
	
	draw_and_play_card()

#------GAME LOGIC---------------------------------------------------------------------------
func start_round():
	print("Starting a new round")
	round_effect.execute(players)
	current_turn=Turn.PLAYER

func draw_and_play_card():
	if deck.cards.size() > 0:
		clear_container(drawn_card_display)
		var drawn_card = deck.draw_card()
		print("Player drew a card: ", drawn_card)
		var card_instance = CardScene.instantiate()
		card_instance.set_card_data(drawn_card)
		drawn_card_display.add_child(card_instance)
		card_instance.parent = drawn_card_display
		drawn_card_display.show()

func _on_round_ended():
	print("Round ended")
	start_round()  
	
