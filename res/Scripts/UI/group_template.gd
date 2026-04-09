extends Control

signal buy(nm: String)

@export var song: bool = false

@export var owned_texture : Texture2D
@export var normal_texture : Texture2D

func rename_group(id: String):
	name = id + "_group"
	get_child(0).name = "PlaceHolder_" + id
	get_child(1).name = id + "_b"
	get_child(2).name = id + "_Price"

func _set_palette(id: String):
	if !song:
		##Skins
		if id in SkinControl.colors_set.keys():
			##Set texture
			get_child(1).texture_normal = SkinControl.textures_set[SkinControl.colors_set.keys().find(id)] ##Position in list
			get_child(1).texture_pressed = SkinControl.textures_set[SkinControl.colors_set.keys().find(id)] ##Position in list
			get_child(1).texture_hover = SkinControl.textures_set[SkinControl.colors_set.keys().find(id)] ##Position in list
			
			##Set colors
			get_child(1).material.set_shader_parameter("WhiteColor", SkinControl.colors_set[id])
			get_child(1).material.set_shader_parameter("BlackColor", SkinControl.colors_set[id].inverted())
			if SkinControl.skins_dic[id][1] == false:
				get_child(1).material.set_shader_parameter("Locked", true)
				get_child(0).texture = normal_texture
			else:
				get_child(2).hide()
				get_child(0).texture = owned_texture
				get_child(1).material.set_shader_parameter("Locked", false)
			
			##Set Price
			get_child(2).get_node("Coins").text = str(SkinControl.skins_dic[id][0])
	else:
		##Songs
		if id in SongsControl.songs_textures.keys():
			##Set texture
			get_child(1).texture_normal = SongsControl.songs_textures[id]
			get_child(1).texture_pressed = SongsControl.songs_textures[id]
			get_child(1).texture_hover = SongsControl.songs_textures[id]
			
			##Set colors
			if SongsControl.songs_dic[id][1] == false:
				get_child(1).modulate = Color(0.384, 0.384, 0.384)
				get_child(0).texture = normal_texture
			else:
				get_child(1).modulate = Color.WHITE
				get_child(2).hide()
				get_child(0).texture = owned_texture
			
			##Set Price
			get_child(2).get_node("Coins").text = str(SongsControl.songs_dic[id][0])
			
			##Set name
			get_child(3).text = id

func _on__b_pressed() -> void:
	emit_signal("buy", name.trim_suffix("_group"))
