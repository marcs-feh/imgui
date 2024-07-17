package imgui

import "core:mem"
import "core:fmt"
import rl "vendor:raylib"

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

	for !rl.WindowShouldClose(){
		defer free_all(context.temp_allocator)

		render: {
			rl.BeginDrawing()
			defer rl.EndDrawing()
			rl.ClearBackground({50, 50, 110, 255})

			draw_rect(rd, Rect{{30, 30}, 300, 200}, auto_cast rl.BLACK)
		}
	}
}

