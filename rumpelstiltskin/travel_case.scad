use <../parts.scad>

CARD_DEPTH = 63;
CARD_WIDTH = 89;
CARD_HEIGHT = 7.5;

TOKEN_DEPTH = 9;
TOKEN_WIDTH = 9;
TOKEN_HEIGHT = 9;

PULL_WIDTH = 15;

WALL_WIDTH = 1;
CLEARANCE = .5;

render_helper = 1; // Helps the quick render not have a "skin" on top of the hole

sled_width = WALL_WIDTH * 2 + CARD_WIDTH + PULL_WIDTH;
sled_depth = WALL_WIDTH * 2 + CARD_DEPTH;
sled_height = WALL_WIDTH + TOKEN_HEIGHT;

module card_sled() {
    card_x = WALL_WIDTH * 2 + TOKEN_WIDTH;
    card_y = WALL_WIDTH;
    card_z = sled_height - CARD_HEIGHT;
    
    token_x = 0;
    token_y = 0;
    token_z = 0;
    
    translate([0, 0, WALL_WIDTH + CLEARANCE])
    difference() {
        cube([sled_width, sled_depth, sled_height]);
        
        translate([card_x, card_y, card_z])
        cube([CARD_WIDTH, CARD_DEPTH, CARD_HEIGHT + render_helper]);
        
        translate([token_x, token_y, token_z]);
    }
}

part("card_sled.stl", c = "red") {
    card_sled();
}