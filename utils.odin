package imgui

rgb :: proc {
	rgb1, rgb3,
}

rgb1 :: proc(v: u8) -> Color {
	return Color {
		v, v, v, 0xff,
	}
}

rgb3 :: proc(r, g, b: u8) -> Color {
	return Color {
		r, g, b, 0xff,
	}
}
