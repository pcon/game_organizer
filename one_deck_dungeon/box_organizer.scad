use <../parts.scad>
use <../roundedcube.scad>

THUMB_WIDTH = 30;
WALL_WIDTH = 2;

BOX_HEIGHT = 43.5;
BOX_WIDTH = 93.5;
BOX_DEPTH = 130;

CARD_HEIGHT = 19.5;
CARD_WIDTH = 89.75;
CARD_DEPTH = 65;

POTION_HEIGHT = 20;
POTION_WIDTH = CARD_WIDTH / 2;
POTION_DEPTH = CARD_DEPTH - THUMB_WIDTH - WALL_WIDTH * 2;

DICE_HEIGHT = 30;

DAMAGE_HEIGHT = 15;
DAMAGE_WIDTH = 35;

BOOK_HEIGHT = 9.5;

render_helper = 1; // Helps the quick render not have a "skin" on top of the hole
token_hole_radius = 10;

working_height = BOX_HEIGHT - BOOK_HEIGHT;
card_holder_depth = CARD_DEPTH + WALL_WIDTH * 2;
card_holder_width_offset = (BOX_WIDTH - CARD_WIDTH) / 2;
part_holder_depth = BOX_DEPTH - card_holder_depth;
part_holder_height = working_height;

module card_holder_body() {
    cube([BOX_WIDTH, card_holder_depth, working_height]);
}

module card_holder_slot() {
    offset_x = card_holder_width_offset;
    offset_y = WALL_WIDTH;
    offset_z = working_height - CARD_HEIGHT + render_helper;
    
    translate([offset_x, offset_y, offset_z])
    cube([CARD_WIDTH, CARD_DEPTH, CARD_HEIGHT + render_helper]);
}

module card_holder_thumb() {
    offset_x = (BOX_WIDTH - THUMB_WIDTH) / 2;
    offset_y = -render_helper;
    offset_z = working_height - CARD_HEIGHT + render_helper;
    depth = card_holder_depth + render_helper * 2;

    translate([offset_x, offset_y, offset_z])
    union() {
        translate([THUMB_WIDTH / 2, depth, 0])
        sphere(d = THUMB_WIDTH);
        cube([THUMB_WIDTH, depth, CARD_HEIGHT + render_helper]);
    }
}

module potion_token() {
    offset_x = (BOX_WIDTH - POTION_WIDTH) / 2;
    offset_y = card_holder_width_offset + POTION_DEPTH / 2;
    offset_z = working_height - POTION_HEIGHT + token_hole_radius - CARD_HEIGHT;
    
    translate([offset_x, offset_y, offset_z])
    roundedcube(
        [POTION_WIDTH, POTION_DEPTH, POTION_HEIGHT + token_hole_radius],
        radius = token_hole_radius
    );
}

module card_holder() {
    difference() {
        card_holder_body();
        union() {
            card_holder_slot();
            card_holder_thumb();
            potion_token();
        }
    }
}

module part_holder_body() {
    cube([BOX_WIDTH, part_holder_depth, part_holder_height]);
}

module dice() {
    width = BOX_WIDTH - WALL_WIDTH * 3 - DAMAGE_WIDTH;
    depth = part_holder_depth - WALL_WIDTH * 2;
    height = part_holder_height - WALL_WIDTH + render_helper;
    
    translate([WALL_WIDTH, WALL_WIDTH, WALL_WIDTH])
    cube([width, depth, height]);
}

module damage_tokens() {
    offset_x = BOX_WIDTH - WALL_WIDTH - DAMAGE_WIDTH;
    offset_y = WALL_WIDTH;
    offset_z = part_holder_height - DAMAGE_HEIGHT;
    
    depth = part_holder_depth - WALL_WIDTH * 2;
    
    translate([offset_x, offset_y, offset_z])
    roundedcube(
        [DAMAGE_WIDTH, depth, DAMAGE_HEIGHT + token_hole_radius],
        radius = token_hole_radius
    );
}

module part_holder() {
    difference() {
        part_holder_body();
        union() {
            dice();
            damage_tokens();
        }
    }
}

part("card_holder.stl", c = "red") {
    card_holder();
}

part_holder_offset_z = working_height - part_holder_height;

translate([0, card_holder_depth, part_holder_offset_z])
part("part_holder.stl", c = "blue") {
    part_holder();
}