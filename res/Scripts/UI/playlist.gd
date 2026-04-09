extends Control

@export var songs_res: Array

var songs_order: Array = [
	"Dashcore", "Glass",
	"Kobra", "Lectron",
	"Riuka", "Shutdown",
	"Smartwatch", "Cthulhu",
	"Sunkin", "Graveyard",
	"Snowball", "Maladiff"
]

func playing():
	var song_stats = songs_res[songs_order.find(SongsControl.new_song)]
	%IMG.texture = song_stats.playing_nail
	%Name.text = song_stats.song_name
	%Name.label_settings.font_color = song_stats.custom_color
	%Author.text = song_stats.song_author
	$Anim.play("Show")
