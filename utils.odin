//+private
package imgui

import "base:runtime"

search_id :: proc(pool: $S/[]$T, key: Id) -> (T, bool) {
	for x in pool {
		if x.id == key {
			return x, true
		}
	}
	return T{}, false
}

search_id_pointer :: proc(pool: $S/[]$T, key: Id) -> (^T, bool) {
	for x in pool {
		if x.id == key {
			return &x, true
		}
	}
	return nil, false
}

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

grow_slice :: proc(s: []$T, n: int) -> []T {
	raw := runtime.Raw_Slice {
		data = raw_data(s),
		len = len(s) + n,
	}
	return transmute([]T)raw
}

last :: proc {
	last_slice, last_dyn_arr, last_arr,
}

@(private="file")
last_slice :: proc(e: []$T) -> (T, bool) {
	if len(e) == 0 { return T{}, false }
	return e[len(e) - 1], true
}

@(private="file")
last_dyn_arr :: proc(e: [dynamic]$T) -> (T, bool) {
	return last_slice(e[:])
}

@(private="file")
last_arr :: proc(e: [$N]$T) -> (T, bool) {
	return last_slice(e[:])
}

@(private="file")
last_pointer_slice :: proc(e: []$T) -> (^T, bool) {
	if len(e) == 0 { return nil, false }
	return &e[len(e) - 1], true
}

@(private="file")
last_pointer_dyn_arr :: proc(e: [dynamic]$T) -> (^T, bool) {
	return last_pointer_slice(e[:])
}

@(private="file")
last_pointer_arr :: proc(e: [$N]$T) -> (^T, bool) {
	return last_pointer_slice(e[:])
}
