extends Node2D

# --- Configurable ---
@export var tilemap_node_path := NodePath("../TileMap")  # Path to your TileMap Node2D
@export var tile_size := 16                             # Tile size in pixels
@export var radius := 5                                  # Radius in tiles from player
@export var highlight_color := Color(1, 1, 1, 0.25)     # Soft highlight color
@export var blocked_color := Color(1, 1, 1, 0.15)       # Slightly darker for blocked
@export var player_node_path := NodePath("../Player")   # Path to player Node2D

# --- Internal ---
var tilemap: Node2D
var sprite: Sprite2D
var player: Node2D
var blocked_tiles := []  # List of Vector2 positions representing blocked tiles

func _ready():
	tilemap = get_node(tilemap_node_path)
	if not tilemap:
		push_error("TileMap node not found! Check tilemap_node_path.")

	player = get_node(player_node_path)
	if not player:
		push_error("Player node not found! Check player_node_path.")

	sprite = $Sprite2D
	if not sprite:
		push_error("TileHighlighter requires a Sprite2D child.")

	sprite.centered = true
	sprite.modulate = highlight_color
	sprite.visible = false  # hide by default

func _process(delta):
	if not tilemap or not sprite or not player:
		return

	# Only show highlight if player is idle
	if "velocity" in player and player.velocity.length() > 0:
		sprite.visible = false
		return

	# Mouse position
	var mouse_world = get_global_mouse_position()
	var local_mouse = tilemap.to_local(mouse_world)

	# Tile under mouse
	var tile_x = int(floor(local_mouse.x / tile_size))
	var tile_y = int(floor(local_mouse.y / tile_size))
	var tile_pos = Vector2(tile_x, tile_y)

	# Player tile
	var player_local = tilemap.to_local(player.global_position)
	var player_tile = Vector2(int(floor(player_local.x / tile_size)),
							  int(floor(player_local.y / tile_size)))

	# Manhattan distance
	var distance = abs(tile_pos.x - player_tile.x) + abs(tile_pos.y - player_tile.y)

	# Only show highlight if within radius
	if distance <= radius:
		sprite.visible = true
		sprite.position = tilemap.to_global(tile_pos * tile_size + Vector2(tile_size/2, tile_size/2))
		# Color feedback for blocked tiles
		if tile_pos in blocked_tiles:
			sprite.modulate = blocked_color
		else:
			sprite.modulate = highlight_color
	else:
		sprite.visible = false
