shader_type canvas_item;
render_mode blend_premul_alpha;  // 使用预乘alpha混合

uniform vec4 ring_color : source_color = vec4(1.0, 0.0, 0.0, 0.5);
uniform float inner_radius = 0.45;
uniform float outer_radius = 0.5;

void fragment() {
    float dist = distance(UV, vec2(0.5));
    float ring = smoothstep(inner_radius, inner_radius + 0.01, dist) *
                (1.0 - smoothstep(outer_radius - 0.01, outer_radius, dist));

    COLOR = ring_color * ring;
    COLOR.a *= ring;  // 确保边缘透明
}