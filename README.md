# Perlin Noise Playground

For my final project in my Geometric Modelling course, I explore the art of using Perlin noise for procedural generation, 
and use this as an opportunity to play with WGSL shaders in [Bevy](https://bevyengine.org/).

## Example: `perlin`

<img src="./assets/readme/perlin.png" width="25%" height="25%"></img>

A simple example which displays 3d perlin noise changing over time via a `Material2d`.
This was mostly for debugging purposes. The algorithm for pseudo-random is from [The Book of Shaders](https://thebookofshaders.com/10/), and I've seen this method used in a couple other places.
The noise functions are defined in `src/perlin.wgsl`, while the material shader is defined in `assets/shaders/merlin_material_2d.wgsl`.

To see this example, run `cargo run --example perlin`.

## Example: `donuts`

<img src="./assets/readme/donuts.png" width="50%" height="50%"></img>

This example is recreated from Ken Perlin's [An image synthesizer](https://dl.acm.org/doi/pdf/10.1145/325165.325247), and extend Bevy's `StandardMaterial`.
The stucco/disgusting donut examples don't match that of the paper—I couldn't get them to work—but the other 4 match the paper's quite closely.
The example runs super slow on my device, but it runs about as fast as the official Bevy example for material extensions, so I'm gonna guess that the issue is my laptop.

This example (and all following examples) use the `CameraControllerPlugin` from [this Bevy example](https://github.com/bevyengine/bevy/blob/v0.12.1/examples/tools/scene_viewer/camera_controller_plugin.rs).
To navigate, press `W` and `S` to move forward/backward, `A` and `D` to move left and right, and left-click/drag to look around.

To see this example, run `cargo run --example donuts`. 

## Example: `terrain`

<img src="./assets/readme/terrain.png" width="50%" height="50%"></img>

This example demonstrates procedural generation of terrain, and offers some UI to show how it works.
The three parameters that are available are `unit` (units of world position to one integer lattice over), `height` (how tall the terrain is), and `exponent` (what exponent the texture is raised to).
The `exponent` parameter is a useful control to change how steep the mountains are, and `unit` changes how spread out they are.

To see this example, run `cargo run --example terrain`.
