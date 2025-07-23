use <common.scad>

TILE_COLUMNS=7;
TILE_ROWS=8;

render_helper = 1;

function grid_offset(slots) = base_tile_size() * slots;

module grid_shift(x, y) {
    translate([grid_offset(x), grid_offset(y), 0]) {
        children();
    }
}

module grid_rotate(offset) {
    translate([grid_offset(offset), 0, 0])
    rotate([0, 0, 90]) {
        children();
    }
}

module grid_base(columns, rows) {
    total_width = base_tile_size() * columns;
    total_depth = base_tile_size() * rows;

    module perimeter() {
        union() {
            // front
            translate([-render_helper, -tri_mid(), -render_helper])
            cube([total_width + render_helper * 2, tri_mid(), peak_height() + render_helper]);

            // back
            translate([-render_helper, total_depth, -render_helper])
            cube([total_width + render_helper * 2, tri_mid(), peak_height() + render_helper]);

            // left
            rotate([0, 0, 90])
            translate([-render_helper, 0, -render_helper])
            cube([total_depth + render_helper * 2, tri_mid(), peak_height() + render_helper]);

            // right
            rotate([0, 0, 90])
            translate([-render_helper, -(total_width + tri_mid()), -render_helper])
            cube([total_depth + render_helper * 2, tri_mid(), peak_height() + render_helper]);
        }
    }

    difference() {
        grid_slots(total_width, total_depth);
        perimeter();
    }
}