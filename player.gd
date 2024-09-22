extends Area2D

signal pickup ## 동전에 닿았을 때 보낼 시그널
signal hurt ## 장애물에 닿았을 때 보낼 시그널

@export var speed = 350
var velocity = Vector2.ZERO
var screensize = Vector2(480, 720)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#1. 키보드 입력, 2. 방향으로 이동. 3. 애니메이션 재생
	velocity = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	position += velocity * speed * delta
	
	# 화면 밖으로 벗어나지 못하게 막는
	position.x = clamp(position.x, 0, screensize.x)
	position.y = clamp(position.y, 0, screensize.y)
	
	# 어떤 애니메이션 보여줄 지 결
	if velocity.length() > 0:
		$AnimatedSprite2D.animation = "run"
	else:
		$AnimatedSprite2D.animation = "idle"
	# 방향 이동에 따라 수평 뒤집기
	if velocity.x != 0:
		$AnimatedSprite2D.flip_h = velocity.x < 0
	
func start():
	set_process(true)
	position = screensize / 2
	$AnimatedSprite2D.animation = "idle"
	
func die():
	$AnimatedSprite2D.animation = "hurt"
	set_process(false)

func _on_area_entered(area):
	if area.is_in_group("coins"):
		area.pickup()
		pickup.emit("coin")
	if area.is_in_group("powerups"):
		area.pickup()
		pickup.emit("powerup")
	if area.is_in_group("obstacles"):
		hurt.emit()
		die()
