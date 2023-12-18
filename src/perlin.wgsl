#define_import_path perlin_noise::perlin

// Pseudo-random algorithm from https://thebookofshaders.com/10/
// I've seen this in a couple places, it seems to be "common knowledge".
fn random(seed: f32) -> f32 {
    return fract(100000.0f*sin(seed));
}

fn random_2d(seed: vec2<f32>) -> f32 {
    return fract(43758.5453123f*sin(dot(seed, vec2(12f, 78.233f))));
}

fn random_3d(seed: vec3<f32>) -> f32 {
    return fract(52342.9843672f*sin(dot(seed, vec3(39f, 154.236f, 66.2996f))));
}

fn random_4d(seed: vec4<f32>) -> f32 {
    return fract(39276.3149586f*sin(dot(seed, vec4(49f, 69.3725f, 91.4303f, 155.5934f))));
}

fn noise(pixel: f32, unit: f32) -> f32 {
    let pos = pixel/unit;
    let lattice = floor(pos);
    let t = pos - lattice;

    let l = random(lattice);
    let r = random(lattice + 1.0f);
    return mix(l, r, t);
}

fn noise_2d(pixel: vec2<f32>, unit: f32) -> f32 {
    let pos = pixel/unit;
    let lattice = floor(pos);
    let t = pos - lattice;


    let ll = random_2d(lattice);
    let rl = random_2d(lattice + vec2(1.0f, 0.0f));
    let lr = random_2d(lattice + vec2(0.0f, 1.0f));
    let rr = random_2d(lattice + vec2(1.0f, 1.0f));

    let xl = mix(ll, rl, t.x);
    let xr = mix(lr, rr, t.x);

    return mix(xl, xr, t.y);
}

fn noise_3d(pixel: vec3<f32>, unit: f32) -> f32 {
    let pos = pixel/unit;
    let lattice = floor(pos);
    let t = pos - lattice;
    
    let lll = random_3d(lattice);
    let rll = random_3d(lattice + vec3(1.0f, 0.0f, 0.0f));
    let lrl = random_3d(lattice + vec3(0.0f, 1.0f, 0.0f));
    let rrl = random_3d(lattice + vec3(1.0f, 1.0f, 0.0f));
    let llr = random_3d(lattice + vec3(0.0f, 0.0f, 1.0f));
    let rlr = random_3d(lattice + vec3(1.0f, 0.0f, 1.0f));
    let lrr = random_3d(lattice + vec3(0.0f, 1.0f, 1.0f));
    let rrr = random_3d(lattice + vec3(1.0f, 1.0f, 1.0f));

    let xll = mix(lll, rll, t.x);
    let xrl = mix(lrl, rrl, t.x);
    let xlr = mix(llr, rlr, t.x);
    let xrr = mix(lrr, rrr, t.x);

    let xyl = mix(xll, xrl, t.y);
    let xyr = mix(xlr, xrr, t.y);

    return mix(xyl, xyr, t.z);
}

fn noise_4d(pixel: vec4<f32>, unit: f32) -> f32 {
    let pos = pixel/unit;
    let lattice = floor(pos);
    let t = pos - lattice;

    let llll = random_4d(lattice);
    let lllr = random_4d(lattice + vec4(0.0f, 0.0f, 0.0f, 1.0f));
    let llr1 = random_4d(lattice + vec4(0.0f, 0.0f, 1.0f, 0.0f));
    let llrr = random_4d(lattice + vec4(0.0f, 0.0f, 1.0f, 1.0f));
    let lrll = random_4d(lattice + vec4(0.0f, 1.0f, 0.0f, 0.0f));
    let lrlr = random_4d(lattice + vec4(0.0f, 1.0f, 0.0f, 1.0f));
    let lrrl = random_4d(lattice + vec4(0.0f, 1.0f, 1.0f, 0.0f));
    let lrrr = random_4d(lattice + vec4(0.0f, 1.0f, 1.0f, 1.0f));
    let rlll = random_4d(lattice + vec4(1.0f, 0.0f, 0.0f, 0.0f));
    let rllr = random_4d(lattice + vec4(1.0f, 0.0f, 0.0f, 1.0f));
    let rlr1 = random_4d(lattice + vec4(1.0f, 0.0f, 1.0f, 0.0f));
    let rlrr = random_4d(lattice + vec4(1.0f, 0.0f, 1.0f, 1.0f));
    let rrll = random_4d(lattice + vec4(1.0f, 1.0f, 0.0f, 0.0f));
    let rrlr = random_4d(lattice + vec4(1.0f, 1.0f, 0.0f, 1.0f));
    let rrrl = random_4d(lattice + vec4(1.0f, 1.0f, 1.0f, 0.0f));
    let rrrr = random_4d(lattice + vec4(1.0f, 1.0f, 1.0f, 1.0f));

    let xlll = mix(llll, rlll, t.x);
    let xllr = mix(lllr, rllr, t.x);
    let xlrl = mix(llr1, rlr1, t.x);
    let xlrr = mix(llrr, rlrr, t.x);
    let xrll = mix(lrll, rrll, t.x);
    let xrlr = mix(lrlr, rrlr, t.x);
    let xrrl = mix(lrrl, rrrl, t.x);
    let xrrr = mix(lrrr, rrrr, t.x);

    let xyll = mix(xlll, xrll, t.y);
    let xyrl = mix(xlrl, xrrl, t.y);
    let xylr = mix(xllr, xrlr, t.y);
    let xyrr = mix(xlrr, xrrr, t.y);

    let xyzl = mix(xyll, xyrl, t.z);
    let xyzr = mix(xylr, xyrr, t.z);

    return mix(xyzl, xyzr, t.w);
}