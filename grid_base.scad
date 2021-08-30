use <common.scad>

TILE_COLUMNS=7;
TILE_ROWS=8;

module grid_base(columns, rows) {
    total_width = base_tile_size() * columns;
    total_depth = base_tile_size() * rows;

    module perimeter() {
        union() {
            // front
            translate([0, -tri_mid(), 0])
            cube([total_width, tri_mid(), peak_height()]);

            // back
            translate([0, total_depth, 0])
            cube([total_width, tri_mid(), peak_height()]);

            // left
            rotate([0, 0, 90])
            cube([total_depth, tri_mid(), peak_height()]);

            // right
            rotate([0, 0, 90])
            translate([0, -(total_width + tri_mid()), 0])
            cube([total_depth, tri_mid(), peak_height()]);
        }
    }

    difference() {
        grid_slots(total_width, total_depth);
        perimeter();
    }
}