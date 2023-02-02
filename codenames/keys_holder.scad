use <common.scad>
use <../chip_holder.scad>

generate_holder(
    tile_columns = 1,
    tile_rows = 1,
    tile_width = 67.5,
    tile_depth = 67.5,
    tile_count = 1,
    tile_height = 12.5,
    wall_width = wall_width(),
    box_height = box_height(),
    box_clearence = box_clearence(),
    rount_to_full_base = true,
    fit_to_box_height = true,
    hollow_bottom = hollow_bottom()
);