use <common.scad>
use <../common.scad>
use <../roundedcube.scad>

CREW_WIDTH = 60;
CREW_DEPTH = 95;
CREW_HEIGHT = 25;

CARGO_WIDTH = 60;
CARGO_DEPTH = 95;
CARGO_HEIGHT = 25;

BATTERY_WIDTH = 60;
BATTERY_DEPTH = 40;
BATTERY_HEIGHT = 12;

first_row = [CREW_DEPTH, CARGO_DEPTH];
first_row_depth = max(first_row);

min_width = CREW_WIDTH + CARGO_WIDTH + wall_width() * 3;
min_depth = first_row_depth + BATTERY_DEPTH + wall_width() * 3;

total_width = ceil(min_width / base_tile_size()) * base_tile_size();
total_depth = ceil(min_depth / base_tile_size()) * base_tile_size();
total_height = box_height() - box_clearence();

x_spread = (total_width - CREW_WIDTH - CARGO_WIDTH) / 3;

function slotOffset(depth) = total_height - depth;
function rowSpacing(first_row_entity) = (total_depth - first_row_entity - BATTERY_DEPTH) / 3;

module holder(slot, x_offset, y_offset, z_offset) {
    translate([x_offset, y_offset, z_offset])
    roundedcube(slot, false, 10);
}

module crew_holder() {
    slot = [
        CREW_WIDTH,
        CREW_DEPTH,
        CREW_HEIGHT * 2 // Doubled to then cut in half
    ];

    x_offset = x_spread;
    y_offset = rowSpacing(CREW_DEPTH);
    z_offset = slotOffset(CREW_HEIGHT);

    holder(slot, x_offset, y_offset, z_offset);
}

module cargo_holder() {
    slot = [
        CARGO_WIDTH,
        CARGO_DEPTH,
        CARGO_HEIGHT * 2 // Double to then cut in half
    ];

    x_offset = x_spread * 2 + CREW_WIDTH;
    y_offset = rowSpacing(CARGO_DEPTH);
    z_offset = slotOffset(CARGO_HEIGHT);

    holder(slot, x_offset, y_offset, z_offset);
}

module battery_holder() {
    slot = [
        BATTERY_WIDTH,
        BATTERY_DEPTH,
        BATTERY_HEIGHT * 2 // Double to then cut in half
    ];

    x_offset = (total_width - BATTERY_WIDTH) / 2;
    y_offset = rowSpacing(first_row_depth) * 2 + first_row_depth;
    z_offset = slotOffset(BATTERY_HEIGHT);

    holder(slot, x_offset, y_offset, z_offset);
}

difference() {
    base_block(total_width, total_depth, total_height);
    crew_holder();
    cargo_holder();
    battery_holder();
}