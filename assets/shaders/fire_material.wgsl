#import perlin_noise::perlin::{noise_3d, dnoise_3d}
#import bevy_pbr::mesh_functions::{get_model_matrix, mesh_position_local_to_clip}
#import bevy_pbr::mesh_view_bindings::globals

@group(1) @binding(0) var<uniform> unit: f32;
@group(1) @binding(1) var<uniform> speed: f32;
@group(1) @binding(2) var<uniform> warble: f32;
@group(1) @binding(3) var<uniform> warble_unit: f32;
@group(1) @binding(4) var<uniform> warble_speed: f32;
@group(1) @binding(5) var<uniform> height: f32;
@group(1) @binding(6) var<uniform> exponent: f32;

const TAU: f32 = 6.2831853071;

struct Vertex {
    @location(0) position: vec3<f32>,
};

struct VertexOutput {
    @builtin(position) clip_position: vec4<f32>,
    
    @location(0) color: vec4<f32>,
};

@vertex
fn vertex(vertex: Vertex) -> VertexOutput {
    var position = vertex.position;
    let t = globals.time*speed;
    
    let sample_warble = dnoise_3d(vec3(vertex.position.xz, globals.time*10.0), warble_unit) * warble;
    var sample_height = 0.0;
    for (var i = 1.0; i < 4.001; i += 1.5) {
        sample_height += pow(noise_3d(vec3(vertex.position.xz, t), unit/i), exponent/(0.75*i))*height/i;
    }
    position.x += sample_warble.x;
    position.y += sample_height;
    position.z += sample_warble.z;

    var out: VertexOutput;
    out.clip_position = mesh_position_local_to_clip(
        get_model_matrix(0u),
        vec4<f32>(position, 1.0)
    );

    out.color = mix(vec4(1.0, 0.0, 0.0, 1.0), vec4(1.0, 1.0, 0.0, 1.0), position.y/3.0);
    return out;
}

@fragment
fn fragment(in: VertexOutput) -> @location(0) vec4<f32> {
    return in.color;
}