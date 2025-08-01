use <common.scad>

MAX_THUMB_WIDTH = 30;
WAY_DEEP = 100;

render_helper = 1;

module generate_holder(
    tile_columns = 4,
    tile_rows = 2,
    tile_width = 33,
    tile_depth = 33,
    tile_count = 20,
    tile_height = 1.75,
    wall_width = 3,
    box_height = 69,
    box_clearance = 15.75,
    round_to_full_base = true,
    fit_to_box_height = true,
    hollow_bottom = false,
    include_grid = true
) {
    function getSize(count, tile_size) = count * (tile_size + wall_width) + wall_width;
    function roundFullBase(count, tile_size) = (round_to_full_base) ? ceil(getSize(count, tile_size) / base_tile_size()) * base_tile_size() : getSize(count, tile_size);
    function max_height() = box_height - box_clearance;

    slot_height = tile_count * tile_height;
    min_floor_offset = min_floor_offset(wall_width);
    min_height = slot_height + min_floor_offset;
    total_height = (fit_to_box_height) ? max(max_height(), min_height) : min_height;
    inside_height = (hollow_bottom) ? total_height - min_floor_offset : slot_height;
    floor_offset = (fit_to_box_height) ? max_height() - inside_height : min_floor_offset;

    total_width = roundFullBase(tile_columns, tile_width);
    total_depth = roundFullBase(tile_rows, tile_depth);

    row_width = tile_depth * tile_rows;
    col_width = tile_width * tile_columns;
    outside_walls = wall_width * 2;

    col_spread = (tile_columns > 1) ? (total_width - col_width - outside_walls) / (tile_columns - 1) : 0;
    row_spread = (tile_rows > 1) ? (total_depth - row_width - outside_walls) / (tile_rows - 1) : 0;

    thumb_width = min(tile_width - (wall_width * 2), MAX_THUMB_WIDTH);

    function colOffset(i) = (tile_columns == 1) ?
        (total_width - tile_width) / 2 :
        wall_width + ((tile_width + col_spread) * i);
    function rowOffset(i) = (tile_rows == 1) ?
        (total_depth - tile_depth) / 2 :
        wall_width + ((tile_depth + row_spread) * i);

    module tile_slot() {
        translate([0, 0, 0])
        square([tile_width, tile_depth]);
    }

    module thumb_slot_front() {
        width = thumb_width;
        side_offset = (tile_width - width) / 2;
        translate([side_offset, -WAY_DEEP, 0])
        square([width, WAY_DEEP]);
    }

    module thumb_slot_back() {
        width = thumb_width;
        side_offset = (tile_width - width) / 2;
        translate([side_offset, tile_depth, 0])
        square([width, WAY_DEEP]);
    }

    module tile_hole(slot_type = "none") {
        box_bottom = floor_offset;
        translate([0, 0, box_bottom])
        linear_extrude(height = inside_height + render_helper)
        union() {
            tile_slot();
            if (slot_type == "front" || slot_type == "both") {
                thumb_slot_front();
            }

            if (slot_type == "back" || slot_type == "both") {
                thumb_slot_back();
            }
        }
    }

    module tile_holes() {
        for (i = [0 : tile_rows - 1]) {
            for (j = [0 : tile_columns - 1]) {
                slot_type = (tile_rows == 1) ? "both" : (i == 0) ? "front" : (i == tile_rows - 1) ? "back" : "none";
                col_offset = colOffset(j);
                row_offset = rowOffset(i);

                translate([col_offset, row_offset, 0])
                tile_hole(slot_type = slot_type);
            }
        }
    }

    module bottom_x() {
        if (hollow_bottom) {
            for (i = [0 : tile_rows - 1]) {
                for (j = [0 : tile_columns - 1]) {
                    length = sqrt(pow(tile_width, 2) + pow(tile_depth, 2));
                    rot = acos(tile_depth / length);
                    x_height = inside_height - slot_height;
                    z_offset = min_floor_offset(wall_width);

                    col_offset = colOffset(j);
                    row_offset = rowOffset(i);

                    translate([col_offset - wall_width / 2, row_offset + wall_width / 2, z_offset])
                    rotate([0, 0, -rot])
                    cube([wall_width, length + wall_width, x_height]);

                    translate([col_offset + tile_width, row_offset - wall_width / 2, z_offset])
                    rotate([0, 0, rot])
                    cube([wall_width, length + wall_width, x_height]);
                }
            }
        }
    }

    difference() {
        union() {
            difference() {
                base_block(total_width, total_depth, total_height, include_grid = include_grid);
                tile_holes();
            }
            bottom_x();
        }

        if ($children) {
            text_offset_x = (colOffset(0) + (tile_width - thumb_width) / 2) / 2;
            text_offset_y = rowOffset(0) / 2;

            translate([text_offset_x, text_offset_y, total_height])
            children(0);
        }
    }
}