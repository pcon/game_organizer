TILE_HEIGHT = 1.5;

BOX_WIDTH = 103;
BOX_DEPTH = 103;
BOX_HEIGHT = 31.5;

BOOK_HEIGHT = 3;
WALL_WIDTH = 5;
SLOT_WIDTH = 15;

function tile_h(count) = count * TILE_HEIGHT;
base_height = BOX_HEIGHT - BOOK_HEIGHT;
area_edge = BOX_WIDTH - WALL_WIDTH;

AREA_WIDTH = 84.5;
AREA_DEPTH = 84.5;
AREA_COUNT = 9;
AREA_HEIGHT = tile_h(AREA_COUNT);

token_top = base_height - AREA_HEIGHT;

ACTION_TOKEN_DIAMETER = 40.5;
ACTION_TOKEN_RADIUS = ACTION_TOKEN_DIAMETER / 2;
ACTION_TOKEN_COUNT = 4;
ACTION_TOKEN_HEIGHT = tile_h(ACTION_TOKEN_COUNT);
ACTION_TOKEN_OFFSET_X = area_edge - AREA_WIDTH + ACTION_TOKEN_RADIUS - (ACTION_TOKEN_DIAMETER - SLOT_WIDTH) / 2;

DETECTIVE_TOKEN_DIAMETER = 32.5;
DETECTIVE_TOKEN_RADIUS = DETECTIVE_TOKEN_DIAMETER / 2;
DETECTIVE_TOKEN_COUNT = 3;
DETECTIVE_TOKEN_HEIGHT = tile_h(DETECTIVE_TOKEN_COUNT);

TIME_TOKEN_DIAMETER = 26.5;
TIME_TOKEN_RADIUS = TIME_TOKEN_DIAMETER / 2;
TIME_TOKEN_COUNT = 8;
TIME_TOKEN_HEIGHT = tile_h(TIME_TOKEN_COUNT);

ALIBI_WIDTH = 84.5;
ALIBI_DEPTH = 50.5;
ALIBI_COUNT = 9;
ALIBI_HEIGHT = tile_h(ALIBI_COUNT);

alibi_edge = BOX_DEPTH - WALL_WIDTH - ALIBI_DEPTH;

module detective_tokens() {
    half_radius = DETECTIVE_TOKEN_RADIUS / 2;
    offset_x = ACTION_TOKEN_OFFSET_X;
    offset_y = alibi_edge - DETECTIVE_TOKEN_RADIUS;
    offset_z = token_top - DETECTIVE_TOKEN_HEIGHT - ACTION_TOKEN_HEIGHT;
    
    translate([offset_x, offset_y, offset_z])
    union() {
        translate([-half_radius, half_radius, 0])
        cube([DETECTIVE_TOKEN_RADIUS, SLOT_WIDTH, DETECTIVE_TOKEN_HEIGHT]);
        cylinder(h = DETECTIVE_TOKEN_HEIGHT, d = DETECTIVE_TOKEN_DIAMETER);
    }
}

module time_tokens() {
    half_radius = TIME_TOKEN_RADIUS / 2;
    offset_x = area_edge - DETECTIVE_TOKEN_RADIUS - 2;
    offset_y = alibi_edge - TIME_TOKEN_RADIUS;
    offset_z = token_top - TIME_TOKEN_HEIGHT;
    
    translate([offset_x, offset_y, offset_z])
    union() {
        translate([-half_radius, half_radius, 0])
        cube([TIME_TOKEN_RADIUS, SLOT_WIDTH, TIME_TOKEN_HEIGHT]);
        cylinder(h = TIME_TOKEN_HEIGHT, d = TIME_TOKEN_DIAMETER);
    }
}

module action_tokens() {
    half_radius = ACTION_TOKEN_RADIUS / 2;
    offset_y = alibi_edge - ACTION_TOKEN_RADIUS;
    offset_z = token_top - ACTION_TOKEN_HEIGHT;
    
    translate([ACTION_TOKEN_OFFSET_X, offset_y, offset_z])
    union() {
        translate([-half_radius, half_radius, 0])
        cube([ACTION_TOKEN_RADIUS, SLOT_WIDTH, ACTION_TOKEN_HEIGHT + 30]);
        cylinder(h = ACTION_TOKEN_HEIGHT + 30, d = ACTION_TOKEN_DIAMETER);
    }
}

module token_slots() {
    union() {
        detective_tokens();
        time_tokens();
        action_tokens();
    }
}

module alibi_block() {
    offset_x = WALL_WIDTH ;
    offset_y = BOX_DEPTH - ALIBI_DEPTH - WALL_WIDTH;
    offset_z = base_height - AREA_HEIGHT - ALIBI_HEIGHT;
    
    translate([offset_x, offset_y, offset_z])
    union() {
        translate([(ALIBI_WIDTH - SLOT_WIDTH) / 2 + 5, -SLOT_WIDTH, 0])
        cube([SLOT_WIDTH, ALIBI_DEPTH, BOX_HEIGHT]);
        cube([ALIBI_WIDTH, ALIBI_DEPTH, BOX_HEIGHT]);
    }
}

module area_block() {
    offset = BOX_WIDTH - AREA_WIDTH - WALL_WIDTH;
    translate([offset, WALL_WIDTH, base_height - AREA_HEIGHT])
    cube([AREA_WIDTH, AREA_DEPTH, AREA_HEIGHT]);
}

module base_block() {
    cube([BOX_WIDTH, BOX_DEPTH, base_height]);
}

difference() {
    base_block();
    union() {
        token_slots();
        alibi_block();
        area_block();
    }
}