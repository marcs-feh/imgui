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

	ui := ui_make()
	ui.renderer = raylib_renderer()

	ui.font = load_font(FONT, 16)
	defer unload_font(ui.font)

	for !rl.WindowShouldClose(){
		defer free_all(context.temp_allocator)

		build_ui: {
			ui_begin(&ui)
			defer ui_end(&ui)

			window_begin(&ui, "Hiii")
		}

		render: {
			rl.BeginDrawing()
			defer rl.EndDrawing()
			rl.ClearBackground(auto_cast rgb(45, 20, 45))

			ui_render(&ui)

			draw_text(ui.renderer, fmt.tprintf(
					"FPS: %v | Resolution %vx%v | Mouse (%d, %d) | Objects W:%v L:%v C:%v",
					rl.GetFPS(),
					rl.GetScreenWidth(), rl.GetScreenHeight(),
					rl.GetMouseX(),
					rl.GetMouseY(),
					len(ui.windows), len(ui.layouts), len(ui.controls),
				), {8, 8}, ui.font, 16, rgb(50, 210, 50))
		}
	}
}

