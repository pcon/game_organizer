BASE_TILE_SIZE=20;
BASE_WIDTH=5;
PEAK_HEIGHT=3;

BOX_HEIGHT = 69;
BOX_CLEARENCE = 15.75;

function box_height() = BOX_HEIGHT;
function box_clearence() = BOX_CLEARENCE;
function max_height() = BOX_HEIGHT - BOX_CLEARENCE;

function y_up() = [90, 0, 0];
function x_up() = [90, 0, 90];

function min_floor_offset(wall_width) = wall_width + PEAK_HEIGHT;
function tri_mid() = BASE_WIDTH / 2;
function triangle() = [[0, 0],[BASE_WIDTH, 0],[tri_mid(), PEAK_HEIGHT]];
function base_tile_size() = BASE_TILE_SIZE;
function peak_height() = PEAK_HEIGHT;

module grid(width, depth, direction) {
    length = (direction == "x") ? width : depth;
    slot_length = (direction == "x") ? depth : width;
    translate_z = (direction == "x") ? -slot_length : 0;
    rot = (direction == "x") ? y_up() : x_up();

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