use bevy::{
    prelude::*,
    asset::load_internal_asset
};

/// Camera controller, taken from the official Bevy repository 
/// [here](https://github.com/bevyengine/bevy/blob/v0.12.1/examples/tools/scene_viewer/camera_controller_plugin.rs)
pub mod camera_controller_plugin;

pub const PERLIN_SHADER_HANDLE: Handle<Shader> = Handle::weak_from_u128(21937621686767413941);

pub struct PerlinPlugin;

impl Plugin for PerlinPlugin {
    fn build(&self, _app: &mut App) {
        
    }
    
    fn finish(&self, app: &mut App) {
        load_internal_asset!(app, PERLIN_SHADER_HANDLE, "perlin.wgsl", Shader::from_wgsl);
    }
}