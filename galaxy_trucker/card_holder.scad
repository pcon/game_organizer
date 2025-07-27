use <common.scad>
use <../chip_holder.scad>

generate_holder(
    tile_columns = 1,
    tile_rows = 1,
    tile_width = 87,
    tile_depth = 57,
    tile_count = 1,
    tile_height = 20.5,
    wall_width = wall_width(),
    box_height = box_height(),
    box_clearance = box_clearance(),
    round_to_full_base = true,
    fit_to_box_height = true,
    hollow_bottom = true
);