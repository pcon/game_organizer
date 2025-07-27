BASE_TILE_SIZE=20;
BASE_WIDTH=5;
PEAK_HEIGHT=3;

DEFAULT_FONT = "Ubuntu:style=Medium";
DEFAULT_FONT_DEPTH = 1;
DEFAULT_FONT_SIZE = 10;

render_helper_h = 1;

function y_up() = [90, 0, 0];
function x_up() = [90, 0, 90];

function min_floor_offset(wall_width) = wall_width + PEAK_HEIGHT;
function tri_mid() = BASE_WIDTH / 2;
function triangle() = [[0, 0],[BASE_WIDTH, 0],[tri_mid(), PEAK_HEIGHT]];
function base_tile_size() = BASE_TILE_SIZE;
function peak_height() = PEAK_HEIGHT;
function font_depth() = DEFAULT_FONT_DEPTH;
function font_size() = DEFAULT_FONT_SIZE;
function gridSize(x) = base_tile_size() * x;

function isX(direction) = (direction == "x");

module grid(width, depth, direction) {
    length = isX(direction) ? width : depth;
    slot_length = isX(direction) ? depth : width;
    translate_z = isX(direction) ? -slot_length : 0;
    rot = isX(direction) ? y_up() : x_up();

    // This is the total additional slots past the initial one
    total_slots = floor(length / BASE_TILE_SIZE);

    for (i = [0 : total_slots]) {
        offset = -tri_mid() + BASE_TILE_SIZE * i;
        rotate(rot)
        translate([offset, 0, translate_z])
        linear_extrude(height = slot_length)
        polygon(points=triangle());
    }
}

module grid_slots(width, depth) {
    grid(width, depth, "y");
    grid(width, depth, "x");
}

module base_block(width, depth, height, include_grid = true) {
    difference() {
        cube([width, depth, height]);

        if (include_grid) {
            grid_slots(width, depth);
        }
    }
}

module prism(l, w, h) {
    polyhedron(
        points=[ [0, 0, 0], [0, w, h], [l, w, h], [l, 0, 0], [0, w, 0], [l, w, 0] ],
        faces=[ [0, 1, 2, 3],
            [2, 1, 4, 5],
            [0, 3, 5, 4],
            [0, 4, 1],
            [3, 2, 5]
        ]
    );
}

module pyramid(w) {
    polyhedron(
        points=[ [w,w,0],[w,-w,0],[-w,-w,0],[-w,w,0], [0,0,w]  ],
        faces=[ [0,1,4],[1,2,4],[2,3,4],[3,0,4], [1,0,3],[2,1,3] ]
    );
}

module embossed_text(
    t,
    h = DEFAULT_FONT_DEPTH,
    font = DEFAULT_FONT,
    size = DEFAULT_FONT_SIZE,
    valign = "center",
    halign = "center",
    render_helper = true
) {
    extrude_h = (render_helper) ? h + render_helper_h : h;
    
    translate([0, 0, -h])
    linear_extrude(extrude_h)
    text(
        t,
        font = font,
        size = size,
        valign = valign,
        halign = halign
    );
}