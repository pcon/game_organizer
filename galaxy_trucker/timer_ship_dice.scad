use <common.scad>
use <../common.scad>
use <../roundedcube.scad>

DICE_WIDTH = 16;

dice_hole_width = DICE_WIDTH * 2;
dice_hole_depth = DICE_WIDTH * 2;

TIMER_LENGTH = 93;
TIMER_DIAMETER = 21;

SHIP_WIDTH = 32;
SHIP_DEPTH = 70;
SHIP_HEIGHT = 20;

min_depth = max(TIMER_LENGTH + wall_width() * 2, DICE_WIDTH * 2 + SHIP_DEPTH + wall_width() * 3);
min_width = max(SHIP_WIDTH, DICE_WIDTH * 2) + TIMER_DIAMETER + wall_width() * 3;

total_width = ceil(min_width / base_tile_size()) * base_tile_size();
total_depth = ceil(min_depth / base_tile_size()) * base_tile_size();
total_height = box_height() - box_clearance();

dice_ship_padding = (total_depth - SHIP_DEPTH - dice_hole_depth) / 3;

function cutoutLength(depth) = depth / 2;
function cutoutOffset(depth, length) = (depth - length) / 2;

module timer_holder() {
    depth_offset = (total_depth - TIMER_LENGTH) / 2;
    translate([0, depth_offset, total_height - TIMER_DIAMETER])
    union() {
        // Timer cutout
        translate([wall_width(), 0, 0])
        cube([TIMER_DIAMETER, TIMER_LENGTH, TIMER_DIAMETER]);

        // Finger cutout
        cutout_length = cutoutLength(TIMER_LENGTH);
        cutout_offset = cutoutOffset(TIMER_LENGTH, cutout_length);
        translate([0, cutout_offset, 0])
        cube([wall_width(), cutout_length, TIMER_DIAMETER]);
    }
}


module dice_holder() {
    width_offset = total_width - dice_hole_width - wall_width();
    depth_offset = dice_ship_padding;
    translate([width_offset, depth_offset, total_height - DICE_WIDTH])
    union() {
        // Dice cutout
        cube([dice_hole_width, dice_hole_depth, DICE_WIDTH]);

        cutout_length = cutoutLength(dice_hole_depth);
        cutout_offset = cutoutOffset(dice_hole_depth, cutout_length);

        // Finger cutout
        translate([dice_hole_width, cutout_offset, wall_width()])
        cube([wall_width(), cutout_length, DICE_WIDTH - wall_width()]);
    }
}

module ship_holder() {
    width_offset = total_width - SHIP_WIDTH - wall_width();
    depth_offset = dice_ship_padding * 2 + dice_hole_depth;
    translate([width_offset, depth_offset, total_height - SHIP_HEIGHT])
    roundedcube([SHIP_WIDTH, SHIP_DEPTH, SHIP_HEIGHT * 2], false, 10);
}

module ship_and_dice_holder() {
    union() {
        dice_holder();
        ship_holder();
    }
}

difference() {
    base_block(total_width, total_depth, total_height);
    timer_holder();
    ship_and_dice_holder();
}