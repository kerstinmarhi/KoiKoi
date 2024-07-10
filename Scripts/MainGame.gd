class_name Game
extends Node2D

enum Turn { PLAYER, ENEMY }
var current_turn: Turn = Turn.PLAYER

var table_cards = []
@onready var players: Array[Node]= [$Player , $Enemy]
@onready var player = $Player
@onready var enemy = $Enemy

@onready var DeckRes = preload("res://CustomResources/card_deck.tres")
@onready var CardScene = preload("res://Scenes/Card.tscn")
@onready var PoolCardScene = preload("res://Scenes/Pool_Card.tscn")
@onready var PlayedCardScene = preload("res://Scenes/CardPlayed.tscn")


@onready var played_cards_display=$PlayerPlayedCards/ColorRect/GridContainer
@onready var enemy_played_cards_display=$EnemyPlayedCards/ColorRect/GridContainer
@onready var drawn_card_display=$DrawnCardBox
@onready var player_hand_container=$PlayerHand/Hand
@onready var pool_card_container=$CardPool/CardPool/GridContainer
var deck

@onready var popup_window = $WinningCondition

#-----SETUP---------------------------------------------------------------
func _ready():
	BackGroundMusic.play_bg_music()
	start_new_game()
	
func _input(event):
	if get_tree().paused:
		return

func start_new_game():
	current_turn = Turn.PLAYER
	popup_window.hide()
	deck = DeckRes.duplicate() as CardPile
	deck.shuffle()
	deal_initial_cards()
	drawn_card_display.hide()
	start_round()

func deal_initial_cards():
	player.hand.clear()
	player.played_cards.clear()
	table_cards.clear()
	enemy.hand.clear()
	enemy.played_cards.clear()
	for i in range(8):
		player.hand.append(deck.draw_card())
		table_cards.append(deck.draw_card())
		enemy.hand.append(deck.draw_card())
	
	update()
	
func poolcard_instantiate(card_res:CardRes) -> PoolCard:
	var card_instance = PoolCardScene.instantiate()
	card_instance.set_card_data(card_res)
	return card_instance
	
func card_instantiate(card_res:CardRes) -> Card:
	var card_instance = CardScene.instantiate()
	card_instance.set_card_data(card_res)
	return card_instance
	
func played_card_instantiate(card_res:CardRes) -> PlayedCard:
	var card_instance = PlayedCardScene.instantiate()
	card_instance.set_card_data(card_res)
	return card_instance

#------UPDATE--------------------------------------------------------------------
func update():
	update_player_hand_ui()
	update_pool_ui()
	update_played_cards_displays()

func update_player_hand_ui():
	clear_container(player_hand_container)
	for card in player.hand:
		player_hand_container.add_child(card_instantiate(card))
		#card_instance.parent = player_hand_container
		
func update_pool_ui():
	
	clear_container(pool_card_container)
	for card in table_cards:
		pool_card_container.add_child(poolcard_instantiate(card))

func update_played_cards_displays():
	#update display for played cards of player
	clear_container(played_cards_display)
	for card in player.played_cards:
		played_cards_display.add_child(played_card_instantiate(card))
		
	#update display for played cards of enemy
	clear_container(enemy_played_cards_display)
	for card in enemy.played_cards:
		enemy_played_cards_display.add_child(played_card_instantiate(card))
	
func clear_container(container):
	for child in container.get_children():
		container.remove_child(child)
		child.queue_free()

func remove_cards(card:Card, child:PoolCard):
	var count = 0
	#count how many cards with same month are displayed in the pool
	for poolchild:PoolCard in pool_card_container.get_children():
		if poolchild.card_data.month == card.card_data.month:
			count+=1
		
	player.played_cards.append(card.card_data)
	
	#if 3 cards of the same month then player gets all three cards of pool 
	#else only selected
	if count == 3:
		for poolchild:PoolCard in pool_card_container.get_children():
			if poolchild.card_data.month == card.card_data.month:
				player.played_cards.append(poolchild.card_data)
				table_cards.remove_at(poolchild.get_index())
				print("Removed %s from pool" % poolchild.card_data.month)
	else: 
		player.played_cards.append(child.card_data)
		table_cards.remove_at(child.get_index())
		print("Removed %s from pool" % child.card_data.month)
	
	if card.get_parent() == drawn_card_display:
		drawn_card_display.remove_child(card)
		drawn_card_display.hide()
	else:
		player.hand.remove_at(card.get_index())
		
	
	card.queue_free()
	child.queue_free()
	
	print("Player Match found.")
	
	update()
	
func remove_enemy_cards(card:CardRes, poolchild:CardRes):
	
	enemy.played_cards.append(poolchild)
	enemy.played_cards.append(card)
	enemy.hand.erase(card)
	for child:PoolCard in pool_card_container.get_children():
		if child.card_data.id == poolchild.id:
			table_cards.remove_at(child.get_index())
	
	print("Enemy Match found")
	
	update()

func place_card(card:Card):
	
	if drawn_card_display.get_child(0) as Card == card:
		drawn_card_display.remove_child(card)
	else:
		player_hand_container.remove_child(card)
		
	pool_card_container.add_child(poolcard_instantiate(card.card_data))

func reparent_card(card_res:CardRes):
	table_cards.append(card_res)
	if player.hand.has(card_res):
		player.hand.erase(card_res)
	elif enemy.hand.has(card_res):
		enemy.hand.has(card_res)
	else :
		drawn_card_display.hide()
	
	update()
	
#------GAME LOGIC---------------------------------------------------------------------------
func start_round():
	print("Starting a new round")
	#round_effect.execute(players)
	current_turn=Turn.PLAYER

func draw_and_play_card():
	if deck.cards.size() <= 0:
		pass
		
	clear_container(drawn_card_display)
	var drawn_card = deck.draw_card()
	print("Player drew a card: ", drawn_card)
	drawn_card_display.add_child(card_instantiate(drawn_card))
	drawn_card_display.show()
		
func end_turn():
	update()
	drawn_card_display.hide()
	var count = check_winning_conditions()
	if current_turn == Turn.PLAYER:
		if count - player.stored_points > 0:
			player.stored_points = count
			get_tree().paused = true
			on_popup_show()
		player_hand_container.set_process(false)
		current_turn = Turn.ENEMY
		enemy_play_turn()
	else:
		if count - enemy.stored_points > 0:
			enemy.stored_points = count
			get_tree().paused = true
			on_popup_show()
		player_hand_container.set_process(true)
		current_turn = Turn.PLAYER
	
	if player.hand.size() == 0 and enemy.hand.size() == 0:
		start_new_game()

func enemy_play_turn():
	if current_turn == Turn.PLAYER:
		pass
	if enemy.hand.size() <= 0:
		pass
	if get_tree().paused:
		return
	
	var removed_a_card = false
	for child in enemy.hand:
		if removed_a_card:
			break
		for poolchild in table_cards:
			if child.month == poolchild.month:
				await get_tree().create_timer(3.0).timeout
				remove_enemy_cards(child,poolchild)
				removed_a_card = true
				break
	
	if not removed_a_card:
		reparent_card(enemy.hand[0])
		await get_tree().create_timer(3.0).timeout
	enemy_draw_and_play_card()

func enemy_draw_and_play_card():
	if deck.cards.size() <= 0:
		pass
	
	if get_tree().paused:
		return
	
	clear_container(drawn_card_display)
	var drawn_card = deck.draw_card()
	var found_card = false
	print("Enemy drew a card: ", drawn_card)
	drawn_card_display.add_child(card_instantiate(drawn_card))
	drawn_card_display.show()
	await get_tree().create_timer(3.0).timeout
	for poolchild in table_cards:
		if drawn_card.month == poolchild.month:
			remove_enemy_cards(drawn_card,poolchild)
			found_card = true
	if not found_card:
		reparent_card(drawn_card)
		
	end_turn()

func _on_round_ended():
	print("Round ended")
	start_round()  
	
func is_card_in_container(card: Node) -> String:
	
	if card == drawn_card_display.get_child(0):
		return "drawn_card_display"
	
	for child in player_hand_container.get_children():
		if child == card:
			return "player_hand_container"
	
	return "none"
	

#------WINNING CONDITIONS CHECK---------------------------------------------
func check_winning_conditions() -> int:
	var count = 0
	count += check_if_ten_chaff()
	count += check_for_cards_of_month()
	count += check_moon_sake()
	count += check_sakura_sake()
	count += check_ribbons()
	count += check_animals()
	count += check_boar_deer_butterfly()
	count += check_brights()
	return count

#10 chaff cards = 1 point. Each new added chaff +1
func check_if_ten_chaff() -> int:
	var count = 0
	if current_turn == Turn.PLAYER:
		for card in player.played_cards:
			if card.type == CardRes.Type.CHAFF:
				count+=1
	else:
		for card in enemy.played_cards:
			if card.type == CardRes.Type.CHAFF:
				count+=1
	if count >= 10:
		return count-9
	return 0

#4 cards of the same month
func check_for_cards_of_month() ->int:
	var count = 0
	var played_cards: Array[CardRes]
	if current_turn == Turn.PLAYER:
		played_cards = player.played_cards
	else :
		played_cards = enemy.played_cards
		
	played_cards.sort_custom(func(a,b): return a.id < b.id)
	
	if played_cards.size() >=4:
		for i in range(played_cards.size()-3):
			if played_cards[0+i].month==played_cards[1+i].month \
			and played_cards[0+i].month==played_cards[2+i].month \
			and played_cards[0+i].month==played_cards[3+i].month:
				count+=4
				i+=3
			else:
				i+=1
	return count

func check_moon_sake() ->int:
	var played_cards: Array[CardRes]
	if current_turn == Turn.PLAYER:
		played_cards = player.played_cards
	else:
		played_cards = enemy.played_cards
		
	for card in played_cards:
		if card.subtype == CardRes.Subtype.SAKE:
			for card2 in played_cards:
				if card.subtype == CardRes.Subtype.MOON:
					return 5
	return 0

func check_sakura_sake()->int:
	var played_cards: Array[CardRes]
	if current_turn == Turn.PLAYER:
		played_cards = player.played_cards
	else:
		played_cards = enemy.played_cards
		
	for card in played_cards:
		if card.subtype == CardRes.Subtype.SAKE:
			for card2 in played_cards:
				if card.subtype == CardRes.Subtype.FLOWERS:
					return 5
	return 0
	
func check_ribbons() -> int:
	var count=0
	var blue=0
	var poetry=0
	var ribbons=0
	var played_cards: Array[CardRes]
	if current_turn == Turn.PLAYER:
		played_cards = player.played_cards
	else:
		played_cards = enemy.played_cards
		
	for card in played_cards:
		if card.type == CardRes.Type.RIBBON:
			if card.subtype == CardRes.Subtype.POETRY:
				poetry+=1
			elif card.subtype == CardRes.Subtype.BLUE:
				blue+=1
			ribbons+=1
	
	if ribbons >= 5:
		count += ribbons -4
	if poetry >=3:
		count+= 5 + poetry-3
	if blue >= 3:
		count+= 5 + blue-3
	 
	return count
	
func check_boar_deer_butterfly()->int:
	var played_cards: Array[CardRes]
	if current_turn == Turn.PLAYER:
		played_cards=player.played_cards
	else:
		played_cards=player.played_cards
		
	var has_boar = false
	var has_deer = false
	var has_butterfly = false
	
	for card in played_cards:
		if card.subtype == CardRes.Subtype.DEER:
			has_deer = true
		if card.subtype == CardRes.Subtype.BOAR:
			has_boar = true
		if card.subtype == CardRes.Subtype.BUTTERFLY:
			has_butterfly = true
	
	if has_boar and has_butterfly and has_deer:
		return 5
	
	return 0
	
func check_animals() -> int:
	var played_cards: Array[CardRes]
	if current_turn == Turn.PLAYER:
		played_cards=player.played_cards
	else:
		played_cards=player.played_cards
	
	var count=0
	for card in played_cards:
		if card.type == CardRes.Type.ANIMAL:
			count+=1
	if count >= 5:
		return 1 + count - 5
	
	return 0
	
func check_brights() -> int:
	var played_cards: Array[CardRes]
	if current_turn == Turn.PLAYER:
		played_cards=player.played_cards
	else:
		played_cards=player.played_cards
	
	var count=0
	var is_rain_man = false
	for card in played_cards:
		if card.type == CardRes.Type.BRIGHT:
			count+=1
			if card.subtype == CardRes.Subtype.RAIN:
				is_rain_man = true
	
	if count == 3 and not is_rain_man:
		return 6
	elif count == 4 and not is_rain_man:
		return 8
	elif count == 4 and is_rain_man:
		return 7
	elif count == 5:
		return 10
	
	return 0


func on_popup_show():
	popup_window.show()
	

func _on_shobu_pressed():
	popup_window.hide()
	get_tree().paused = false

func _on_koi_koi_pressed():
	if current_turn == Turn.ENEMY:
		enemy.take_damage(player.stored_points)
	else:
		player.take_damage(enemy.stored_points)
	
	get_tree().paused = false
	start_new_game()
