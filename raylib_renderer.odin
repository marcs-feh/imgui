package imgui

import intr "base:intrinsics"
import "core:strings"
import rl "vendor:raylib"

raylib_renderer :: proc() -> Renderer {
	return Renderer {
		data = nil,
		procedure = raylib_render_proc,
	}
}

raylib_render_proc :: proc(
	_: rawptr,
	cmd: Render_Command,
	rect: Rect,
	text: string,
	font: Font,
	size: int,
	color: Color,
){
	switch cmd {
	case .Draw_Rect:
		rl.DrawRectangle(i32(rect.pos.x), i32(rect.pos.y), i32(rect.w), i32(rect.h), auto_cast color)
	case .Draw_Text:
		cs := strings.clone_to_cstring(text, allocator = context.temp_allocator)
		rl.DrawTextEx(raylib_font(font)^, cs, {f32(rect.x), f32(rect.y)}, f32(size), 0, auto_cast color)
	case .Set_Clip:
		assert(!scissor_mode, "Scissor mode must be inactive.")
		rl.BeginScissorMode(i32(rect.x), i32(rect.y), i32(rect.w), i32(rect.h))
		scissor_mode = true
	case .Reset_Clip:
		assert(scissor_mode, "Scissor mode must be active.")
		rl.EndScissorMode()
		scissor_mode = false
	}
}

@private
raylib_font :: proc(f: Font) -> ^rl.Font {
	return transmute(^rl.Font)f
}

@private
scissor_mode := false
