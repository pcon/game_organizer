use <../common.scad>
use <common.scad>
use <../chip_holder.scad>

HOLLOW_BOTTOM = true;

module room_holder(hollow_bottom = true) {
    generate_holder(
        tile_columns = 1,
        tile_rows = 1,
        tile_width = 77,
        tile_depth = 77,
        tile_count = 22,
        tile_height = 1.5,
        wall_width = wall_width(),
        box_height = box_height(),
        box_clearence = box_clearence(),
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

room_holder(HOLLOW_BOTTOM);