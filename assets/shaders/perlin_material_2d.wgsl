#import perlin_noise::perlin::{noise_2d, noise_3d}
#import bevy_pbr::forward_io::VertexOutput
#import bevy_render::globals::Globals

@group(0) @binding(0) var<uniform> offset: vec2<f32>;
@group(0) @binding(1) var<uniform> globals: Globals;

@fragment
fn fragment(mesh: VertexOutput) -> @location(0) vec4<f32> {

    let v = noise_3d(vec3(offset + mesh.world_position.xy, globals.time*15.0), 10.0);

    // Uncomment this to use/check noise_2d:
    // let v = noise_2d(mesh.world_position.xy, 10.0);

    return vec4(vec3(v), 1.0);
}