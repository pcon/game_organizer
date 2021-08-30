use <../chip_holder.scad>

generate_holder(
    tile_columns = 5,
    tile_rows = 1,
    tile_width = 22,
    tile_depth = 44,
    tile_count = 18,
    tile_height = 1.75,
    wall_width = 3,
    rount_to_full_base = true,
    fit_to_box_height = true,
    hollow_bottom = true
);