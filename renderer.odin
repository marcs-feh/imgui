package imgui

Font :: distinct rawptr

Color :: [4]u8

Render_Command :: enum {
	Draw_Rect,
	Draw_Text,

	Set_Clip,
	Reset_Clip,
}

Render_Proc :: #type proc(
	impl: rawptr,
	cmd: Render_Command,
	rect: Rect,
	msg: string,
	font: Font,
	size: int,
	color: Color,
)

Renderer :: struct {
	data: rawptr,
	procedure: Render_Proc,
}

draw_rect :: proc(rd: Renderer, rect: Rect, color: Color){
	rd.procedure(rd.data, .Draw_Rect, rect, "", nil, 0, color)
}

draw_text :: proc(rd: Renderer, msg: string, pos: ivec2, font: Font, size: int, color: Color){
	rd.procedure(rd.data, .Draw_Text, Rect{ pos = pos}, msg, font, size, color)
}

draw_box :: proc(rd: Renderer, rect: Rect, border: int, color: Color, border_color: Color){
	inner := rect_resize(rect, -abs(border))
	draw_rect(rd, rect, border_color)
	draw_rect(rd, inner, color)
}

set_clip :: proc(rd: Renderer, w, h: int){
	rd.procedure(rd.data, .Set_Clip, Rect{ w = w, h = h }, "", nil, 0, {})
}

reset_clip :: proc(rd: Renderer){
	rd.procedure(rd.data, .Reset_Clip, {}, "", nil, 0, {})
}

