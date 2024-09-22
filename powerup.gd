extends Area2D

var screensize = Vector2.ZERO

func pickup():
	$CollisionShape2D.set_deferred("disabled", true)  # disabled 처리
	var tween = create_tween().set_parallel().set_trans(Tween.TRANS_QUAD)  # 트윈 오브젝트 생성
	
	# 트위닝 설정. (대상 오브젝트, 변경할 속성, 종료값, 지속시)
	tween.tween_property(self, "scale", scale * 3, 0.3)
	tween.tween_property(self, "modulate:a", 0.0, 0.3)
	
	await tween.finished
	queue_free() # 노드를 제거
	
func _on_lifetime_timeout():
	queue_free()
	
func _on_area_entered(area):
	if area.is_in_group("obstacles"):
		position = Vector2(randi_range(0, screensize.x), randi_range(0, screensize.y))
