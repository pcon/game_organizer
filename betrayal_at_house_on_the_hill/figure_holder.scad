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
min_width = FIGURE_COL * figure_space + wall_width();

total_width = ceil(min_width / base_tile_size()) * base_tile_size();
total_depth = ceil(min_depth / base_tile_size()) * base_tile_size();
total_height = box_height() - box_clearance();

function getSplit(dimension, count) = (dimension - (count * FIGURE_BASE_DIAMETER)) / (count + 1);
function getSplitX() = getSplit(total_width, FIGURE_COL);
function getSplitY() = getSplit(total_depth, FIGURE_ROW);
function getOffset(split, i) = split * (i + 1) + (FIGURE_BASE_DIAMETER * i);
function getOffsetX(i) = getOffset(getSplitX(), i);
function getOffsetY(i) = getOffset(getSplitY(), i);

module figure_slots() {
    h = FIGURE_BASE_HEIGHT + render_helper;

    for (i = [0:FIGURE_COL - 1]) {
        for (j = [0:FIGURE_ROW - 1]) {
            translate([
                getOffsetX(i),
                getOffsetY(j),
                total_height - FIGURE_HEIGHT
            ])
            translate([
                FIGURE_BASE_DIAMETER / 2,
                FIGURE_BASE_DIAMETER / 2
            ])
            cylinder(
                h = h,
                d = FIGURE_BASE_DIAMETER,
                center = false
            );
        }
    }
}

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
        figure_slots();

        translate([
            total_width / 2,
            getSplitY() / 2,
            total_height - FIGURE_HEIGHT + FIGURE_BASE_HEIGHT
        ])
        embossed_text("FIGURES", h = font_depth(), size = font_size() - 2);
    }
}

figure_holder();