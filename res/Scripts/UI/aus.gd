extends Node

var client = HTTPClient.new()
const url_submit = "https://docs.google.com/forms/u/0/d/e/1FAIpQLSeH-4q4E5_ZG8yDf-CthCJX20_J5z0Zp9eOD9_ZinzsNTyaaQ/formResponse"
const url_data = "https://opensheet.elk.sh/1j5LWaBE9mZj-MPMzO2iX06y_R419EYRKGCkCPw9sfUI/Data"
const headers = ["Content-Type: application/x-www-form-urlencoded"]
var http

var uri_phone: String = "https://drive.google.com/file/d/1G2TKchgTziNkwdhsM-v4a2dTpiDG8jod/view?usp=sharing"
var uri_pc: String = "https://drive.google.com/file/d/1ZSE7RECWFM5LdZ9IWl3NVFih-DQZzplq/view?usp=sharing"

##Internal Changesd
var actual_version = 29

func check_any_update():
	http = HTTPRequest.new()
	http.connect("request_completed", verify)
	add_child(http)
	
	var err = http.request(url_data, headers, HTTPClient.METHOD_GET)
	if err:
		http.queue_free()

func verify(_result, _response_codem, _headers, body):
	http.queue_free()
	if !_result:
		var data = JSON.parse_string(body.get_string_from_utf8())
		for n in data:
			if n["Version"] != str(actual_version):
				get_parent().valid_update = false
				%AnimationPlayer.stop()
				popup_show()

func popup_show():
	%Popup.get_node("CanvasLayer").show()

func _on_cancel_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/loading.tscn")

func _on_accept_pressed() -> void:
	OS.shell_open(uri_phone)
