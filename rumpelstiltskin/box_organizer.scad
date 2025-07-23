use <../roundedcube.scad>

BOX_DEPTH = 93;
BOX_WIDTH = 134;
BOX_HEIGHT = 34;

CARD_DEPTH = 89;
CARD_WIDTH = 63;
CARD_HEIGHT = 7.5;

TOKEN_DEPTH = 25;
TOKEN_WIDTH = 25;
TOKEN_HEIGHT = 10;
TOKEN_ROUND = 3;

THUMB_WIDTH = 30;

WALL_WIDTH = 1;

card_holder_total_width = CARD_WIDTH + THUMB_WIDTH + WALL_WIDTH * 2;

render_helper = 1; // Helps the quick render not have a "skin" on top of the hole

module token_cutout() {
    offset_x = (BOX_WIDTH - card_holder_total_width - TOKEN_WIDTH) / 2;
    offset_y = (BOX_DEPTH - TOKEN_DEPTH) / 2;
    offset_z = BOX_HEIGHT - TOKEN_HEIGHT - TOKEN_ROUND;
    
    translate([offset_x, offset_y, offset_z])
    roundedcube(
        [TOKEN_WIDTH, TOKEN_DEPTH, TOKEN_HEIGHT + TOKEN_ROUND * 2],
        radius = TOKEN_ROUND
    );
}

module card_cutout() {
    offset_x = BOX_WIDTH - CARD_WIDTH - WALL_WIDTH - THUMB_WIDTH / 2;
    offset_y = (BOX_DEPTH - CARD_DEPTH) / 2;
    offset_z = BOX_HEIGHT - CARD_HEIGHT;
    
    thumb_y = CARD_DEPTH / 2;
    thumb_z = CARD_HEIGHT;
    
    translate([offset_x, offset_y, offset_z])
    union() {
        cube([CARD_WIDTH, CARD_DEPTH, CARD_HEIGHT + render_helper]);
        
        translate([0, thumb_y, thumb_z])
        sphere(d = THUMB_WIDTH);
        
        translate([CARD_WIDTH, thumb_y, thumb_z])
        sphere(d = THUMB_WIDTH);
    }
}

module base_block() {
    cube([BOX_WIDTH, BOX_DEPTH, BOX_HEIGHT]);
}

difference() {
    base_block();
    card_cutout();
    token_cutout();
}