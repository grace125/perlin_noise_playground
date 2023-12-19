#import perlin_noise::perlin::{noise_2d}
#import bevy_pbr::mesh_functions::{get_model_matrix, mesh_position_local_to_clip}

@group(1) @binding(0) 
var<uniform> unit: f32;

@group(1) @binding(1) 
var<uniform> color: vec4<f32>;

@group(1) @binding(2) 
var<uniform> height: f32;

@group(1) @binding(3) 
var<uniform> exponent: f32;

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
    let sample = pow(noise_2d(vertex.position.xz, unit), exponent)*height/2.0;
    position.y += sample;

    var out: VertexOutput;
    out.clip_position = mesh_position_local_to_clip(
        get_model_matrix(0u),
        vec4<f32>(position, 1.0)
    );

    out.color = color * (0.5 * sample + 0.5);
    return out;
}

@fragment
fn fragment(in: VertexOutput) -> @location(0) vec4<f32> {
    return in.color;
}