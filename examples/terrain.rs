use bevy::{
    prelude::*,
    reflect::TypePath,
    render::render_resource::{AsBindGroup, ShaderRef},
};
use bevy_egui::{EguiPlugin, egui, EguiContexts};
use perlin_noise::{PerlinPlugin, camera_controller_plugin::{CameraController, CameraControllerPlugin}};


fn main() {
    App::new()
        .add_plugins((
            DefaultPlugins,
            PerlinPlugin,
            CameraControllerPlugin,
            EguiPlugin,
            MaterialPlugin::<TerrainMaterial>::default(),

        ))
        .add_systems(Startup, setup)
        .add_systems(Update, ui)
        .run()
}

#[derive(Resource)]
struct MainMaterialHandle(Handle<TerrainMaterial>);

fn setup(
    mut commands: Commands, 
    mut meshes: ResMut<Assets<Mesh>>, 
    mut materials: ResMut<Assets<TerrainMaterial>>
) {
    let material = materials.add(TerrainMaterial { 
        unit: 7.0, 
        color: Color::GRAY, 
        height: 10.0,
        exponent: 2.5, 
    });

    commands.insert_resource(MainMaterialHandle(material.clone()));

    commands.spawn(MaterialMeshBundle {
        mesh: meshes.add(shape::Plane { size: 100.0, subdivisions: 200 }.into()),
        material,
        ..default()
    });

    commands.spawn((
        Camera3dBundle {
            transform: Transform::from_xyz(0.0, 5.0, -5.0),
            ..default()
        },
        CameraController::default()
    ));
}

fn ui(
    mut contexts: EguiContexts,
    mut materials: ResMut<Assets<TerrainMaterial>>,
    handle: Res<MainMaterialHandle>,
) {
    let ctx = contexts.ctx_mut();

    let material = materials.get_mut(&handle.0).unwrap();

    egui::SidePanel::left("left_panel").show(ctx, |ui| {
        ui.label("");
        ui.label("CONTROLS");
        ui.label("W: forward");
        ui.label("A: left");
        ui.label("S: backward");
        ui.label("D: right");
        ui.label("Left Click: look around");
        ui.label("");
        ui.add(egui::Slider::new(&mut material.unit, 0.1..=10.0).text("Unit"));
        ui.add(egui::Slider::new(&mut material.height, 0.0..=10.0).text("Height"));
        ui.add(egui::Slider::new(&mut material.exponent, 1.0..=10.0).text("Exponent"));
        ui.allocate_rect(ui.available_rect_before_wrap(), egui::Sense::hover());
    });
}

#[derive(Asset, TypePath, AsBindGroup, Debug, Clone)]
pub struct TerrainMaterial {
    #[uniform(0)]
    unit: f32,
    #[uniform(1)]
    color: Color,
    #[uniform(2)]
    height: f32,
    #[uniform(3)]
    exponent: f32
}

impl Material for TerrainMaterial {
    
    fn vertex_shader() -> ShaderRef {
        "shaders/terrain_material.wgsl".into()
    }

    fn fragment_shader() -> ShaderRef {
        "shaders/terrain_material.wgsl".into()
    }
}