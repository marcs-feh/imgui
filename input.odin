package imgui

KeyboardInput :: struct {
	sym: rune,
	mod_keys: ModKeysState,
}

MouseInput :: struct {
	pos: ivec2,
	buttons: MouseButtonsState,
	scroll: ScrollDirection,
}

MouseButton :: enum {
	Left = 1, Middle = 3, Right = 2,
}

ButtonState :: enum {
	Down = 0, Up, Pressed, Released,
}

MouseButtonsState :: [MouseButton]bit_set[ButtonState; u8]

ModKey :: enum {
	Alt, Control, Shift, Super,
}

ModKeysState :: [ModKey]bit_set[ButtonState; u8]

ScrollDirection :: enum {
	None = 0,
	Up   = +1,
	Down = -1,
}
