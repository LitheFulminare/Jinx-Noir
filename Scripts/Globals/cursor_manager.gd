## Script para poder guardar os cursores que vão ser usados no jogo dependendo do que o mouse está fazendo
extends Node

const PATA = preload("uid://cl6ilmdnp7gho")
const PATAHOVER = preload("uid://cae16dlsdgnw5")
const PATACLICK = preload("uid://bpvo640vi054l")

## Configurações necessárias do mouse para visualização bonita do notebook puzzle
func _ready() -> void:
	Input.set_custom_mouse_cursor(PATA, Input.CURSOR_ARROW)
	#Input.set_custom_mouse_cursor(PATACLICK, Input.CURSOR_POINTING_HAND)
	Input.set_custom_mouse_cursor(PATACLICK, Input.CURSOR_FORBIDDEN)
	Input.set_custom_mouse_cursor(PATACLICK, Input.CURSOR_CAN_DROP)
	Input.set_custom_mouse_cursor(PATACLICK, Input.CURSOR_DRAG)
