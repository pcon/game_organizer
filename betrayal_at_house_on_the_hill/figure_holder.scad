use <../common.scad>
use <common.scad>

FIGURE_BASE_DIAMETER = 28.5;
FIGURE_HEIGHT = 46;
FIGURE_BASE_HEIGHT = 7;

FIGURE_ROW = 2;
FIGURE_COL = 3;

render_helper = 1;

figure_space = FIGURE_BASE_DIAMETER + wall_width();

min_depth = FIGURE_ROW * figure_space + wall_width();
min_width = FIGURE_COL *  figure_space + wall_width();

total_width = ceil(min_width / base_tile_size()) * base_tile_size();
total_depth = ceil(min_depth / base_tile_size()) * base_tile_size();
total_height = box_height() - box_clearence();

module all_figures() {
    translate([
        -render_helper,
        -render_helper,
        total_height - FIGURE_HEIGHT + FIGURE_BASE_HEIGHT
    ])
    cube([
        total_width + render_helper * 2,
        total_depth + render_helper * 2,
        FIGURE_HEIGHT
    ]);
}

module figure_holder() {
    difference() {
        base_block(total_width, total_depth, total_height);
        all_figures();
    }
}

figure_holder();