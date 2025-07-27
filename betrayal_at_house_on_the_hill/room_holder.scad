use <../common.scad>
use <../grid_base.scad>
use <../chip_holder.scad>
use <../parts.scad>
use <common.scad>

HOLLOW_BOTTOM = true;
ROOM_WIDTH = 77;
ROOM_DEPTH = 77;
ROOM_COUNT = 22;

module room_holder(hollow_bottom = true) {
    generate_holder(
        tile_columns = 1,
        tile_rows = 1,
        tile_width = ROOM_WIDTH,
        tile_depth = ROOM_DEPTH,
        tile_count = ROOM_COUNT,
        tile_height = 1.5,
        wall_width = wall_width(),
        box_height = box_height(),
        box_clearance = box_clearance(),
        round_to_full_base = true,
        fit_to_box_height = true,
        hollow_bottom = hollow_bottom
    ) {
        embossed_text(
            "ROOMS",
            h = font_depth(),
            size = font_size() - 2
        );
    }
}

module room_holder_double(hollow_bottom = true) {
    difference() {
        generate_holder(
            tile_columns = 1,
            tile_rows = 2,
            tile_width = ROOM_WIDTH,
            tile_depth = ROOM_DEPTH,
            tile_count = ROOM_COUNT,
            tile_height = 1.5,
            wall_width = wall_width(),
            box_height = box_height(),
            box_clearance = box_clearance(),
            round_to_full_base = true,
            fit_to_box_height = true,
            hollow_bottom = hollow_bottom
        );
        
        translate([
            gridSize(5) / 2,
            gridSize(9) / 2,
            box_height() - box_clearance()
        ])
        embossed_text(
            "ROOMS",
            h = font_depth(),
            size = font_size() - 2
        );
    }
}

part("room_holder.stl") {
    room_holder(HOLLOW_BOTTOM);
}

part("room_holder_basemodifier.stl") {
    base_modifier_grid(5, 5);
}

grid_shift(6, 0)
part("room_holder_double.stl") {
    room_holder_double(HOLLOW_BOTTOM);
}

grid_shift(6, 0)
part("room_holder_double_basemodifier.stl") {
    base_modifier_grid(5, 9);
}