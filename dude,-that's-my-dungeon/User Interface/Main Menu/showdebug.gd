extends Button

# The sequence of keys to type (case-insensitive)
const SECRET_WORD = "debug"
var typed_string = ""

func _ready():
	hide() 

func _input(event):
	if event is InputEventKey and event.pressed and not event.is_echo():
		# Only process if the key has a valid, printable unicode value
		if event.unicode >= 32: 
			var key_typed = char(event.unicode).to_lower()
			typed_string += key_typed
			
			if typed_string.ends_with(SECRET_WORD):
				_activate_button()
			
			# Maintain buffer size
			if typed_string.length() > SECRET_WORD.length() * 2:
				typed_string = typed_string.right(SECRET_WORD.length())
		else:
			# Optional: Clear buffer on "Enter" or "Escape" to reset the attempt
			if event.keycode == KEY_ENTER or event.keycode == KEY_ESCAPE:
				typed_string = ""

func _activate_button():
	show()
	grab_focus()
