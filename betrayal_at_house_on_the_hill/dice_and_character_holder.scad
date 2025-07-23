use <../common.scad>
use <common.scad>
use <../roundedcube.scad>
use <../parts.scad>

// Petagon math - https://calcresource.com/geom-pentagon.html

DICE_WIDTH = 16.5;
CHARACTER_CARD_HEIGHT = 102;
CHARACTER_CARD_SIDE_LENGTH = 67;
CHARACTER_CARD_STACK_HEIGHT = 10.5;
THUMB_WIDTH = 15;
PICKUP_HELPER = 2;

half_thumb = THUMB_WIDTH / 2;
render_helper = 1;

dice_column = 4;
dice_row = 2;
dice_hole_width = DICE_WIDTH * dice_column;
dice_hole_depth = DICE_WIDTH * dice_row;
dice_hole_height = DICE_WIDTH;

tracker_hole_width = dice_hole_width;
tracker_hole_depth = dice_hole_depth;
tracker_hole_height = dice_hole_height;

double_wall = wall_width() * 2;

ch = CHARACTER_CARD_SIDE_LENGTH * 1.539;
cw = CHARACTER_CARD_SIDE_LENGTH * 1.618;

min_depth = ch + double_wall;
min_width = cw + double_wall;

total_width = ceil(min_width / base_tile_size()) * base_tile_size();
total_depth = ceil(min_depth / base_tile_size()) * base_tile_size();
total_height = box_height() - box_clearence();

character_offset_y = (total_depth - ch) / 2;
tracker_offset_y = character_offset_y + dice_hole_depth + wall_width() * 4;

tracker_hole_radius = 10;

BASE_MODIFIER_HEIGHT = 2;

module character_cutout() {
    rc = 0.851 * CHARACTER_CARD_SIDE_LENGTH;
    ri = 0.688 * CHARACTER_CARD_SIDE_LENGTH;
    
    translate([
        0,
        character_offset_y,
        total_height - CHARACTER_CARD_STACK_HEIGHT
    ])
    translate([total_width / 2, ri, 0])
    rotate([0, 0, 90])
    cylinder(r = rc, h = CHARACTER_CARD_STACK_HEIGHT + render_helper, center = false, $fn = 5);
}

module character_thumb_cutout() {
    translate([
        (total_width - THUMB_WIDTH) / 2,
        -render_helper,
        total_height - CHARACTER_CARD_STACK_HEIGHT - PICKUP_HELPER
    ])
    cube([
        THUMB_WIDTH,
        total_depth + render_helper * 2,
        CHARACTER_CARD_STACK_HEIGHT + PICKUP_HELPER + render_helper
    ]);
}

module character_text_emboss() {
    translate([
        wall_width(),
        total_depth - 6,
        total_height
    ])
    embossed_text("CHARACTERS", h = font_depth(), size = 5.5, halign="left");
}

module dice_cutout() {
    translate([
        (total_width - dice_hole_width) / 2,
        character_offset_y + wall_width(),
        total_height - CHARACTER_CARD_STACK_HEIGHT - dice_hole_height
    ])
    cube([
        dice_hole_width,
        dice_hole_depth,
        dice_hole_height + render_helper
    ]);
}

module dice_thumb_cutout() {
    cutout_depth = dice_hole_depth + character_offset_y + render_helper + wall_width();
    
    translate([
        (total_width - THUMB_WIDTH) / 2,
        -render_helper,
        total_height - CHARACTER_CARD_STACK_HEIGHT - dice_hole_height
    ])
    union() {
        cube([
            THUMB_WIDTH,
            cutout_depth,
            dice_hole_height
        ]);
        
        end_of_cutout = [
            half_thumb,
            cutout_depth,
            half_thumb,
        ];
        
        translate(end_of_cutout)
        sphere(d = THUMB_WIDTH);
        
        translate(end_of_cutout)
        cylinder(d = THUMB_WIDTH, h = DICE_WIDTH / 2 + render_helper);
    }
}

module dice_text_emboss() {
    translate([
        total_width / 2,
        character_offset_y + wall_width() + dice_hole_depth / 2,
        total_height - CHARACTER_CARD_STACK_HEIGHT - dice_hole_height
    ])
    embossed_text("DICE", h = font_depth(), size = font_size());
}

module tracker_cutout() {
    translate([
        (total_width - tracker_hole_width) / 2,
        tracker_offset_y,
        total_height - CHARACTER_CARD_STACK_HEIGHT - tracker_hole_height
    ])
    roundedcube(
        [
            tracker_hole_width,
            tracker_hole_depth,
            tracker_hole_height + render_helper
        ],
        radius = tracker_hole_radius,
        apply_to = "zmax"
    );
}

module tracker_text_emboss() {
    translate([
        total_width / 2,
        tracker_offset_y + tracker_hole_depth / 2,
        total_height - CHARACTER_CARD_STACK_HEIGHT - tracker_hole_height - 2.5
    ])
    embossed_text("CLIPS", h = font_depth(), size = font_size() - 1);
}

module dice_and_character_holder() {
    difference() {
        base_block(total_width, total_depth, total_height);
        
        character_cutout();
        character_thumb_cutout();
        character_text_emboss();
        
        dice_cutout();
        dice_thumb_cutout();
        dice_text_emboss();
        
        tracker_cutout();
        tracker_text_emboss();
    }
}

module base_modifier() {
    base_block(total_width, total_depth, peak_height() + BASE_MODIFIER_HEIGHT);
}

part("dice_and_character_holder.stl", c = "red") {
    dice_and_character_holder();
}

part("dice_and_character_holder_basemodifier.stl", c = "blue") {
    base_modifier();
}