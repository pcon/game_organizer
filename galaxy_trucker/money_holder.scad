use <common.scad>
use <../chip_holder.scad>

module money_holder() {
    generate_holder(
        tile_columns = 5,
        tile_rows = 1,
        tile_width = 22,
        tile_depth = 44,
        tile_count = 18,
        tile_height = 1.75,
        wall_width = wall_width(),
        box_height = box_height(),
        box_clearance = box_clearance(),
        round_to_full_base = true,
        fit_to_box_height = true,
        hollow_bottom = false
    );
}

money_holder();