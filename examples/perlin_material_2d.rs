//! A simple example displaying noise_3d on-screen for debugging

use bevy::{
    prelude::*,
    reflect::TypePath,
    render::render_resource::{AsBindGroup, ShaderRef},
    sprite::{Material2d, Material2dPlugin, MaterialMesh2dBundle},
};
use perlin_noise::PerlinPlugin;


fn main() {
    App::new()
        .add_plugins(DefaultPlugins)
        .add_plugins(PerlinPlugin)
        .add_plugins(Material2dPlugin::<PerlinMaterial>::default())
        .add_systems(Startup, setup)
        .run()
}

fn setup(
    mut commands: Commands,
    mut meshes: ResMut<Assets<Mesh>>,
    mut materials: ResMut<Assets<PerlinMaterial>>,
) {
    commands.spawn(Camera2dBundle::default());

    commands.spawn(MaterialMesh2dBundle {
        mesh: meshes.add(Mesh::from(shape::Quad::default())).into(),
        transform: Transform::default().with_scale(Vec3::splat(400.)),
        material: materials.add(PerlinMaterial {
            offset: (0.0, 0.0, 0.0).into(),
        }),
        ..default()
    });
}

#[derive(Asset, TypePath, AsBindGroup, Debug, Clone)]
pub struct PerlinMaterial {
    #[uniform(0)]
    offset: Vec3,
}

impl Material2d for PerlinMaterial {
    fn fragment_shader() -> ShaderRef {
        "shaders/perlin_material_2d.wgsl".into()
    }
}