// WORK IN PROGRESS

TILE_HEIGHT = 2.5;

BOX_WIDTH = 122.5;
BOX_DEPTH = 169.5;
BOX_HEIGHT = 36;

BOOK_HEIGHT = 3;
WALL_WIDTH = 5;
SLOT_WIDTH = 15;

function tile_h(count) = count * TILE_HEIGHT;
area_edge = BOX_WIDTH - WALL_WIDTH;

INFLUENCE_DIAMETER = 20.5;
INFLUENCE_COUNT = 11; // One fourth of the total tokens (41 total)
INFLUENCE_HEIGHT = INFLUENCE_COUNT * TILE_HEIGHT;

INFLUENCE_5_DIAMETER = 22.5;
INFLUENCE_5_COUNT = 11; // Half of the total tokens (22 total)
INFLUENCE_5_HEIGHT = INFLUENCE_5_COUNT * TILE_HEIGHT;

module cards() {
}

module influence_tokens_5() {
}

module influence_tokens_1() {
}

module influence_tokens() {
}

module first_player_tile() {}

module resolution_direction_tile() {}

module bribery_tokens() {}

module base_block() {
    cube([BOX_WIDTH, BOX_DEPTH, BOX_HEIGHT]);
}

difference() {
    base_block();
    union() {
        cards();
        influence_tokens();
        first_player_tile();
        resolution_direction_tile();
        bribery_tokens();
    }
}