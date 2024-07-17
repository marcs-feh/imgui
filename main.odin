package imgui

import "core:mem"
import "core:fmt"
import rl "vendor:raylib"

FONT :: #load("assets/inconsolata.ttf", []byte)

main :: proc(){
	rl.InitWindow(1000, 650, "demo")
	rl.SetWindowState({.WINDOW_TOPMOST})
	defer rl.CloseWindow()
	rl.SetTargetFPS(60)

	@(static) temp_arena_buf : [32 * mem.Megabyte]byte
	temp_arena : mem.Arena
	mem.arena_init(&temp_arena, temp_arena_buf[:])
	context.temp_allocator = mem.arena_allocator(&temp_arena)

	rd := raylib_renderer()
	font := load_font(FONT, 16)
	defer unload_font(font)

	for !rl.WindowShouldClose(){
		defer free_all(context.temp_allocator)

		render: {
			rl.BeginDrawing()
			defer rl.EndDrawing()
			rl.ClearBackground(auto_cast rgb(45, 20, 45))

			draw_rect(rd, Rect{{30, 30}, 300, 200}, rgb(120, 80, 40))
			draw_text(rd, "Poggers", {40, 40}, font, 16, rgb(200, 200, 200))
		}
	}
}

