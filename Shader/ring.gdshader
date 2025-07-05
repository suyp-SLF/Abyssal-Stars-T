shader_type canvas_item;

uniform vec2 map_center;
uniform float inner_radius;
uniform float outer_radius;
uniform vec4 ring_color: source_color;

// 等距投影参数
uniform vec2 tile_size = vec2(64.0, 32.0);

// 直角坐标转等距坐标
vec2 cart_to_iso(vec2 cart) {
    return vec2(
        (cart.x - cart.y) * tile_size.x / 2.0,
        (cart.x + cart.y) * tile_size.y / 2.0
    );
}

void fragment() {
	vec2 viewport_size = 1.0 / SCREEN_PIXEL_SIZE;
    // 将屏幕坐标转换为等距坐标
    vec2 iso_coord = cart_to_iso(SCREEN_UV * viewport_size / tile_size);

    // 计算距离
    float dist = distance(iso_coord, map_center);

    // 绘制环形
    if (dist > inner_radius && dist < outer_radius) {
        COLOR = ring_color;
    } else {
        discard;
    }
}