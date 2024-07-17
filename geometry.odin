package imgui

ivec2 :: [2]int

Rect :: struct {
	using pos: ivec2,
	w, h: int,
}

rect_valid :: proc(r: Rect) -> bool {
	return r.w > 0 && r.h > 0
}

rect_intersect :: proc(a, b: Rect) -> Rect {
	i := Rect {
		pos = {
			max(a.x, b.x),
			max(a.y, b.y),
		},
	}
	i.w = min(a.x + a.w, b.x + b.w) - i.x
	i.h = min(a.y + a.h, b.y + b.h) - i.y
	return i
}

rect_union :: proc(a, b: Rect) -> Rect {
	u := Rect {
		pos = {
			min(a.x, b.x),
			min(a.y, b.y),
		},
	}

	u.w = max(a.x + a.w, b.x + b.w) - u.x
	u.h = max(a.y + a.h, b.y + b.h) - u.y
	return u
}

rect_contains_point :: proc(r: Rect, p: ivec2) -> bool {
	return (p.x >= r.x && p.x <= (r.x + r.w)) &&
		   (p.y >= r.y && p.y <= (r.y + r.h))
}

// Resize rectangle by `amount` pixels while preserving its center point
rect_resize :: proc(r: Rect, amount: int) -> Rect {
	e := r
	e.h += amount * 2
	e.w += amount * 2
	e.pos -= amount
	return e
}
