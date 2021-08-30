use <../chip_holder.scad>

generate_holder(
    tile_columns = 4,
    tile_rows = 2,
    tile_width = 33,
    tile_depth = 33,
    tile_count = 20,
    tile_height = 1.75,
    wall_width = 3,
    rount_to_full_base = true,
    fit_to_box_height = true
);