#import perlin_noise::perlin::noise_3d
#import bevy_pbr::{
    pbr_fragment::pbr_input_from_standard_material,
    pbr_functions::alpha_discard,
}
#ifdef PREPASS_PIPELINE
#import bevy_pbr::{
    prepass_io::{VertexOutput, FragmentOutput},
    pbr_deferred_functions::deferred_output,
}
#else
#import bevy_pbr::{
    forward_io::{VertexOutput, FragmentOutput},
    pbr_functions::{apply_pbr_lighting, main_pass_post_lighting_processing},
}
#endif

@group(0) @binding(100) 
var<uniform> mode: u32;

@fragment
fn fragment(
    in: VertexOutput, 
    @builtin(front_facing) 
    is_front: bool
) -> FragmentOutput {

    var pbr_input = pbr_input_from_standard_material(in, is_front);
    var v: f32;

    switch 4 { //mode {
        // Spotted
        case 0: {
            let v = noise_3d(in.world_position.xyz, 0.04);

            pbr_input.material.base_color = vec4(vec3(v), 1.0);
        }
        // Bumpy
        case 1: {

        }
        // Stucco
        case 2: {

        }
        // Disgusting
        case 3: {

        }
        // Bozo
        case 4: {
            let v = noise_3d(in.world_position.xyz, 0.15);

            if v < 0.3 {
                pbr_input.material.base_color = vec4(0.8f, 0.2f, 0.2f, 1.0f);
            }
            else if v < 0.45 {
                pbr_input.material.base_color = vec4(0.2f, 0.8f, 0.2f, 1.0f);
            }
            else if v < 0.6 {
                pbr_input.material.base_color = vec4(0.95f, 0.95f, 0.70f, 1.0f);
            }
            else if v < 0.8 {
                pbr_input.material.base_color = vec4(0.2f, 0.15f, 0.3f, 1.0f);
            }
            else {
                pbr_input.material.base_color = vec4(0.63f, 0.924f, 0.233f, 1.0f);
            }
        }
        // Wrinkled
        case 5: {

        }
        default: {}
    }
    
#ifdef PREPASS_PIPELINE
    let out = deferred_output(in, pbr_input);
#else
    var out: FragmentOutput;
    out.color = apply_pbr_lighting(pbr_input);
    out.color = main_pass_post_lighting_processing(pbr_input, out.color);
#endif

    return out;
}