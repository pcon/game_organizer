use <common.scad>
use <../common.scad>

PLAYER_TOKEN_LENGTH = 52;
PLAYER_TOKEN_WIDTH = 32;
PLAYER_TOKEN_COUNT = 4;

total_width = base_tile_size() * 4;
total_depth = base_tile_size() * 3;
total_height = box_height() - box_clearance();

module ellipse(width, height) {
  scale([1, height / width, 1]) circle(r = width / 2);
}

module player_holder() {
    x_offset = total_width / 2;
    y_offset = total_depth / 2;
    hole_height = PLAYER_TOKEN_COUNT * tile_height();
    translate([x_offset, y_offset, total_height - hole_height])
    union() {
        linear_extrude(hole_height)
        ellipse(PLAYER_TOKEN_LENGTH, PLAYER_TOKEN_WIDTH);
        translate([-PLAYER_TOKEN_LENGTH / 4, 0, 0])
        cube([PLAYER_TOKEN_LENGTH / 2, total_depth / 2, hole_height]);
    }
}

difference() {
    base_block(total_width, total_depth, total_height);
    player_holder();
}