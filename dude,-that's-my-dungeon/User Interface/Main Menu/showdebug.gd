extends Button

# The sequence of keys to type (case-insensitive)
const SECRET_WORD = "debug"
var typed_string = ""

func _ready():
	hide() 

func _input(event):
	if event is InputEventKey and event.pressed and not event.is_echo():
		var key_typed = char(event.unicode).to_lower()
		
		if key_typed.length() > 0:
			typed_string += key_typed
			
			if typed_string.ends_with(SECRET_WORD):
				_activate_button()
			
			# Keep the buffer small to prevent memory bloat
			if typed_string.length() > 20:
				typed_string = typed_string.right(10)

func _activate_button():
	show()
	grab_focus()
	print("Debug button revealed!")
