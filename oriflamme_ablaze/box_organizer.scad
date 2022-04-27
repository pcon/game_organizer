use <../roundedcube.scad>

TILE_HEIGHT = 3;

BOX_WIDTH = 122.5;
BOX_DEPTH = 169.5;
BOX_HEIGHT = 36;

BOOK_HEIGHT = 3;
WALL_WIDTH = 5;
SLOT_WIDTH = 15;

function tile_h(count) = count * TILE_HEIGHT;
area_edge = BOX_WIDTH - WALL_WIDTH;

INFLUENCE_LENGTH = 70;
INFLUENCE_WIDTH = 70;
INFLUENCE_HEIGHT = 30;

BRIBERY_LENGTH = 37.5;
BRIBERY_WIDTH = 22.5;
BRIBERY_RADIUS = BRIBERY_WIDTH / 2;
BRIBERY_COUNT = 4;
BRIBERY_HEIGHT = BRIBERY_COUNT * TILE_HEIGHT;

DIRECTION_LENGTH = 108;
DIRECTION_WIDTH = 26.5;
DIRECTION_HEIGHT = TILE_HEIGHT;

FIRST_PLAYER_LENGTH = 51.5;
FIRST_PLAYER_WIDTH = 44;
FIRST_PLAYER_HEIGHT = TILE_HEIGHT;

CARD_WIDTH = 62;
CARD_LENGTH = 113;
CARD_HEIGHT = 21;

module cards() {
    offset_x = (BOX_WIDTH - CARD_LENGTH) / 2;
    offset_y = WALL_WIDTH;
    offset_z = BOX_HEIGHT - CARD_HEIGHT;
    
    height_offset = 5 + TILE_HEIGHT * 2;
    
    slot_length = CARD_LENGTH / 2;
    
    translate([offset_x, offset_y, offset_z])
    union() {
        translate([slot_length / 2, CARD_WIDTH, - height_offset])
        cube([slot_length, SLOT_WIDTH, CARD_HEIGHT + height_offset]);
        
        cube([CARD_LENGTH, CARD_WIDTH, CARD_HEIGHT]);
    }
}

module finger_slot() {    
    length = BOX_WIDTH - WALL_WIDTH * 4;
    
    offset_x = WALL_WIDTH + (BRIBERY_WIDTH / 2);
    offset_y = BOX_DEPTH - WALL_WIDTH - BRIBERY_LENGTH + (SLOT_WIDTH / 2);
    offset_z = BOX_HEIGHT - BRIBERY_HEIGHT - 5;
    
    translate([offset_x, offset_y, offset_z])
    cube([SLOT_WIDTH * 1.5, SLOT_WIDTH, BRIBERY_HEIGHT + 5]);
}

module influence_tokens() {
    offset_x = BOX_WIDTH - WALL_WIDTH - INFLUENCE_WIDTH;
    offset_y = BOX_DEPTH - WALL_WIDTH - INFLUENCE_LENGTH;
    offset_z = BOX_HEIGHT - INFLUENCE_HEIGHT;
    
    translate([offset_x, offset_y, offset_z])
    roundedcube([INFLUENCE_WIDTH, INFLUENCE_LENGTH, INFLUENCE_HEIGHT * 2], false, 10);
}

module first_player_tile() {
    offset_x = (BOX_WIDTH - FIRST_PLAYER_WIDTH) / 2;
    offset_y = WALL_WIDTH + CARD_WIDTH - SLOT_WIDTH / 2 - FIRST_PLAYER_LENGTH;
    offset_z = BOX_HEIGHT - CARD_HEIGHT - DIRECTION_HEIGHT - FIRST_PLAYER_HEIGHT;
    
    translate([offset_x, offset_y, offset_z])
    union() {
        translate([FIRST_PLAYER_WIDTH / 2 - SLOT_WIDTH / 2, FIRST_PLAYER_LENGTH, 0])
        cube([SLOT_WIDTH, SLOT_WIDTH / 2, FIRST_PLAYER_HEIGHT + DIRECTION_HEIGHT]);
        cube([FIRST_PLAYER_WIDTH, FIRST_PLAYER_LENGTH, FIRST_PLAYER_HEIGHT + DIRECTION_HEIGHT]);
    }
}

module resolution_direction_tile() {
    offset_x = (BOX_WIDTH - DIRECTION_LENGTH) / 2;
    offset_y = WALL_WIDTH + CARD_WIDTH - DIRECTION_WIDTH;
    offset_z = BOX_HEIGHT - CARD_HEIGHT - DIRECTION_HEIGHT;
    
    translate([offset_x, offset_y, offset_z])
    cube([DIRECTION_LENGTH, DIRECTION_WIDTH, DIRECTION_HEIGHT]);
}

module bribery_tokens() {
    cube_length = BRIBERY_LENGTH - BRIBERY_RADIUS;
    offset_x = WALL_WIDTH;
    offset_y = BOX_DEPTH - WALL_WIDTH - BRIBERY_LENGTH;
    offset_z = BOX_HEIGHT - BRIBERY_HEIGHT;
    
    translate([offset_x, offset_y, offset_z])
    union() {
        translate([BRIBERY_RADIUS, cube_length, 0])
        cylinder(h = BRIBERY_HEIGHT, d = BRIBERY_WIDTH);
        cube([BRIBERY_WIDTH, cube_length, BRIBERY_HEIGHT]);
    }
}

module base_block() {
    cube([BOX_WIDTH, BOX_DEPTH, BOX_HEIGHT]);
}

difference() {
    base_block();
    union() {
        cards();
        finger_slot();
        influence_tokens();
        first_player_tile();
        resolution_direction_tile();
        bribery_tokens();
    }
}