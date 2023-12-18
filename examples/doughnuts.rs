use bevy::{
    prelude::*, 
    render::render_resource::{AsBindGroup, ShaderRef},
    pbr::{ExtendedMaterial, MaterialExtension}, window::WindowResolution, core_pipeline::prepass::{NormalPrepass, DepthPrepass, MotionVectorPrepass}
};
use perlin_noise::{
    PerlinPlugin, 
    camera_controller_plugin::{CameraControllerPlugin, CameraController}};

fn main() {
    App::new()
        .add_plugins((
            DefaultPlugins.set(
                WindowPlugin {
                    primary_window: Some(Window {
                        resolution: WindowResolution::new(320.0, 240.0),
                        title: "Doughnuts".to_string(),
                        ..default()
                    }),
                    ..default()
                }
            ), 
            PerlinPlugin, 
            CameraControllerPlugin,
            MaterialPlugin::<DoughnutMaterial>::default()
        ))
        .add_systems(Startup, setup)
        .run();
}

fn setup(
    mut commands: Commands, 
    mut meshes: ResMut<Assets<Mesh>>, 
    mut materials: ResMut<Assets<DoughnutMaterial>>
) {
    commands.spawn(MaterialMeshBundle {
        mesh: meshes.add(shape::Torus::default().into()),
        material: materials.add(DoughnutMaterial {
            base: default(),
            extension: DoughnutExtension { 
                mode: 0
            },
        }),
        ..default()
    });

    commands.spawn((
        Camera3dBundle::default(),
        CameraController::default(),
        NormalPrepass,
        DepthPrepass,
        MotionVectorPrepass
    ));

    commands.spawn(PointLightBundle {
        transform: Transform::from_translation((0.0, 10.0, 0.0).into()),
        ..default()
    });
}

type DoughnutMaterial = ExtendedMaterial<StandardMaterial, DoughnutExtension>;

#[derive(Asset, TypePath, AsBindGroup, Debug, Clone)]
pub struct DoughnutExtension {
    #[uniform(100)]
    /// Valid doughnut modes:
    /// 
    /// 0. Spotted
    /// 1. Bumpy
    /// 2. Stucco
    /// 3. Disgusting
    /// 4. Bozo
    /// 5. Wrinkled
    mode: u32
}

impl MaterialExtension for DoughnutExtension {
    fn fragment_shader() -> ShaderRef {
        "shaders/doughnut_material.wgsl".into()
    }

    fn deferred_fragment_shader() -> ShaderRef {
        "shaders/doughnut_material.wgsl".into()
    }
}