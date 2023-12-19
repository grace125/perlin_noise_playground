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
            MaterialPlugin::<FireMaterial>::default(),
        ))
        .add_systems(Startup, setup)
        .add_systems(Update, ui)
        .run()
}

#[derive(Resource)]
struct MainMaterialHandle(Handle<FireMaterial>);

fn setup(
    mut commands: Commands, 
    mut meshes: ResMut<Assets<Mesh>>, 
    mut materials: ResMut<Assets<FireMaterial>>
) {
    let material = materials.add(FireMaterial { 
        unit: 5.0, 
        speed: 15.0,
        warble: 40.0,
        warble_unit: 1.1,
        warble_speed: 10.0,
        height: 10.0,
        exponent: 6.0,
    });

    commands.insert_resource(MainMaterialHandle(material.clone()));

    commands.spawn(MaterialMeshBundle {
        mesh: meshes.add(shape::Plane { size: 10.0, subdivisions: 20 }.into()),
        material,
        ..default()
    });

    commands.spawn((
        Camera3dBundle {
            transform: Transform::from_xyz(0.0, 15.0, -15.0).looking_at(Vec3::ZERO, Vec3::Y),
            ..default()
        },
        CameraController::default()
    ));
}

fn ui(
    mut contexts: EguiContexts,
    mut materials: ResMut<Assets<FireMaterial>>,
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
        ui.add(egui::Slider::new(&mut material.speed, 0.1..=30.0).text("Speed"));
        ui.add(egui::Slider::new(&mut material.warble, 0.0..=100.0).text("Warble"));
        ui.add(egui::Slider::new(&mut material.warble_unit, 2.0..=10.0).text("Warble Unit"));
        ui.add(egui::Slider::new(&mut material.warble_speed, 0.1..=30.0).text("Warble Speed"));
        ui.add(egui::Slider::new(&mut material.height, 0.0..=20.0).text("Height"));
        ui.add(egui::Slider::new(&mut material.exponent, 1.0..=20.0).text("Exponent"));

        ui.allocate_rect(ui.available_rect_before_wrap(), egui::Sense::hover());
    });
}

#[derive(Asset, TypePath, AsBindGroup, Debug, Clone)]
pub struct FireMaterial {
    #[uniform(0)]
    unit: f32,
    #[uniform(1)]
    speed: f32,
    #[uniform(2)]
    warble: f32,
    #[uniform(3)]
    warble_unit: f32,
    #[uniform(4)]
    warble_speed: f32,
    #[uniform(5)]
    height: f32,
    #[uniform(6)]
    exponent: f32,
}

impl Material for FireMaterial {
    
    fn vertex_shader() -> ShaderRef {
        "shaders/fire_material.wgsl".into()
    }

    fn fragment_shader() -> ShaderRef {
        "shaders/fire_material.wgsl".into()
    }
}