extends Node

@export var coin_scene : PackedScene
@export var powerup_scene : PackedScene
@export var cactus_scene : PackedScene
@export var playtime = 30

var level = 1
var score = 0
var time_left = 0
var screensize = Vector2.ZERO
var playing = false

func _ready():
	screensize = get_viewport().get_visible_rect().size
	$Player.screensize = screensize
	$Player.hide()  # 게임 시작 전에는 플레이어 숨김
	$Cactus.hide()
	#new_game() ## TODO: for test. delete later

func new_game():
	playing = true
	level = 1
	score = 0
	time_left = playtime
	$Player.start()
	$Player.show()
	$GameTimer.start()
	spawn_coins()
	spawn_cactus()
	$HUD.update_score(score)
	$HUD.update_timer(time_left)
	
func spawn_coins():
	$LevelSound.play()
	for i in level + 4:
		var coin = coin_scene.instantiate()
		add_child(coin)
		coin.screensize = screensize
		coin.position = Vector2(randi_range(0, screensize.x),
			randi_range(0, screensize.y))
			
func spawn_cactus():
	var cactus = cactus_scene.instantiate()
	add_child(cactus)
	cactus.position = Vector2(randi_range(0, screensize.x),
		randi_range(0, screensize.y))
			
func _process(delta):
	if playing and get_tree().get_nodes_in_group("coins").size() == 0:
		level += 1
		time_left += 3
		spawn_coins()
		spawn_cactus()
		$PowerupTimer.wait_time = randf_range(2, 6)  # powerup 아이템이 나타나는 타이밍 조
		$PowerupTimer.start()
		
func game_over():
	$EndSound.play()
	playing = false
	$GameTimer.stop()
	get_tree().call_group("coins", "queue_free")
	get_tree().call_group("obstacles", "queue_free")
	$HUD.show_game_over()
	$Player.die()
	
func _on_hud_start_game():
	new_game()
	
func _on_game_timer_timeout():
	time_left -= 1
	$HUD.update_timer(time_left)
	if time_left <= 0:
		game_over()
		
func _on_player_pickup(type):
	match type:
		"coin":
			$CoinSound.play()
			score += 1
			$HUD.update_score(score)
		"powerup":
			$PowerupSound.play()
			time_left += 5
			$HUD.update_timer(time_left)
			
func _on_player_hurt():
	game_over()
	
func _on_powerup_timer_timeout():
	var powerup = powerup_scene.instantiate()
	add_child(powerup)
	powerup.screensize = screensize
	powerup.position = Vector2(randi_range(0, screensize.x),
		randi_range(0, screensize.y))
