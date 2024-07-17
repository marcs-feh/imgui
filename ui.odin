package imgui

import "core:hash"

Id :: distinct i32

Window :: struct {
	id: Id,
	body: Rect,
	layouts: []Layout,
}

Control :: struct {
	id: Id,
	bounds: Rect,
}

Layout :: struct {
	id: Id,
	controls: []Control,
}

UIContext :: struct {
	mouse: MouseInput,
	keyboard: KeyboardInput,
	font: Font,

	windows: [dynamic]Window,
	layouts: [dynamic]Layout,
	controls: [dynamic]Control,

	retained_info: struct {
		windows: [dynamic]Window_Retained_Info,
		layouts: [dynamic]Layout_Retained_Info,
		mouse: MouseInput,
		keyboard: KeyboardInput,
	},


	renderer: Renderer,
	_internal_flags: bit_set[enum {
		Window_Being_Built,
	}; i32]
}

Window_Retained_Info :: struct {
	id: Id,
	body: Rect,
}

Layout_Retained_Info :: struct {
	id: Id,
}

ui_make :: proc(allocator := context.allocator) -> UIContext {
	ui: UIContext
	ui.windows = make([dynamic]Window, allocator = allocator)
	ui.layouts = make([dynamic]Layout, allocator = allocator)
	ui.controls = make([dynamic]Control, allocator = allocator)

	ui.retained_info.windows = make([dynamic]Window_Retained_Info, allocator = allocator)
	ui.retained_info.layouts = make([dynamic]Layout_Retained_Info, allocator = allocator)

	return ui
}

ui_begin :: proc(ui: ^UIContext){
	clear(&ui.windows)
	clear(&ui.layouts)
	clear(&ui.controls)
}

ui_end :: proc(ui: ^UIContext){
	ui._internal_flags = {}
}

window_begin :: proc(ui: ^UIContext, title: string, initial_body := WINDEFAULTBODY) -> (win: Window){
	assert(.Window_Being_Built not_in ui._internal_flags, "Windows cannot be nested.")
	win.id = gen_window_id(ui, title)
	retained, found := search_id(ui.retained_info.windows[:], win.id)
	if found {
		win.body = retained.body
	}
	else {
		append(&ui.retained_info.windows, Window_Retained_Info {
			id = win.id,
			body = initial_body,
		})
	}

	append(&ui.windows, win)

	ui._internal_flags += {.Window_Being_Built}
	return
}

window_end :: proc(ui: ^UIContext){
	assert(.Window_Being_Built in ui._internal_flags, "Cannot end a non-active window")
	ui._internal_flags -= {.Window_Being_Built}
}

WINBORDER :: 2
WINBG :: Color{30, 30, 30, 0xff}
WINDEFAULTBODY :: Rect {{40,40}, 200, 200}

ui_render :: proc(ui: ^UIContext){
	for win in ui.windows {
		draw_box(ui.renderer, win.body, WINBORDER, WINBG, rgb(0))
		for layout in win.layouts {
			for control in layout.controls {
			}
		}
	}
}

gen_window_id :: proc(ui: ^UIContext, title: string) -> Id {
	last_win, ok := last(ui.windows)
	seed := transmute(u32)last_win.id if ok else u32(0x811c9dc5)
	id := Id(hash.fnv32a(transmute([]byte)title, seed))
	return id
}

