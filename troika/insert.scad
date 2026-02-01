BOX_WIDTH = 59;
BOX_DEPTH = 104;
BOX_HEIGHT = 34;

SCORE_CHIP_HEIGHT = 2.25;
SCORE_CHIP_TRIANGLE_COUNT = 8;
SCORE_CHIP_TRIANGLE_SIDE = 38;
score_chip_triangle_side_height = (SCORE_CHIP_TRIANGLE_SIDE * sqrt(3)) / 2;
score_chip_triangle_height = SCORE_CHIP_HEIGHT * SCORE_CHIP_TRIANGLE_COUNT;
SCORE_CHIP_TRIANGLE_CORNER_SIDE = 4;
score_chip_triangle_corner_side_height = (SCORE_CHIP_TRIANGLE_CORNER_SIDE * sqrt(3)) / 2;
function triangle_offset_x(height) = height / 3;
function triangle_radius(side) = side / sqrt(3);

SCORE_CHIP_ROUND_COUNT = 6;
SCORE_CHIP_ROUND_DIAMETER = 25.5;
score_chip_round_radius = SCORE_CHIP_ROUND_DIAMETER / 2;
score_chip_round_height = SCORE_CHIP_HEIGHT * SCORE_CHIP_ROUND_COUNT;

STONE_TILE_SIDE = 21;
stone_tile_side_height = 1.9 * STONE_TILE_SIDE;
stone_tile_side_width = 1.94 * STONE_TILE_SIDE;
STONE_TILE_MAX_COUNT = 21;
STONE_TILE_HEIGHT_INDIVIDUAL = 1.70;
function stone_tile_height(count) = STONE_TILE_HEIGHT_INDIVIDUAL * count;

render_helper = 1;

module stone_tile_cutout(count) {
    offset_x = STONE_TILE_SIDE * 0.901;
    offset_y = (STONE_TILE_SIDE * 1.95) / 2;
    translate([offset_x, offset_y, 0])
    cylinder(r = STONE_TILE_SIDE, h = stone_tile_height(count) + render_helper, $fn = 7);
}

module score_chip_triangle_cutout() {
    radius = triangle_radius(SCORE_CHIP_TRIANGLE_SIDE);
    corner_radius = triangle_radius(SCORE_CHIP_TRIANGLE_CORNER_SIDE);
    height = BOX_HEIGHT + render_helper * 2;
    
    linear_extrude(height)
    polygon([
        [
            score_chip_triangle_corner_side_height,
            SCORE_CHIP_TRIANGLE_CORNER_SIDE / 2
        ],
        [
            score_chip_triangle_side_height - score_chip_triangle_corner_side_height,
            SCORE_CHIP_TRIANGLE_SIDE / 2 - SCORE_CHIP_TRIANGLE_CORNER_SIDE / 2
        ],
        [
            score_chip_triangle_side_height - score_chip_triangle_corner_side_height,
            SCORE_CHIP_TRIANGLE_SIDE / 2 + SCORE_CHIP_TRIANGLE_CORNER_SIDE / 2
        ],
        [
            score_chip_triangle_corner_side_height,
            SCORE_CHIP_TRIANGLE_SIDE - SCORE_CHIP_TRIANGLE_CORNER_SIDE / 2
        ],
        [
            0,
            SCORE_CHIP_TRIANGLE_SIDE - SCORE_CHIP_TRIANGLE_CORNER_SIDE
        ],
        [
            0,
            SCORE_CHIP_TRIANGLE_CORNER_SIDE
        ]
    ]);
}

module score_chip_round_cutout() {
    union() {
        translate([0, score_chip_round_radius, score_chip_round_radius])
        rotate([0, 90, 0])
        cylinder(h = score_chip_round_height, d = SCORE_CHIP_ROUND_DIAMETER);
        
        translate([0, 0, score_chip_round_radius])
        cube([
            score_chip_round_height,
            SCORE_CHIP_ROUND_DIAMETER,
            score_chip_round_radius + render_helper
        ]);
    }
}

module base() {
    cube([
        BOX_WIDTH,
        BOX_DEPTH,
        BOX_HEIGHT
    ]);
}

module insert() {
    difference() {
        base();
        
        translate([
            BOX_WIDTH - score_chip_triangle_side_height + score_chip_triangle_corner_side_height - .5,
            (BOX_DEPTH - SCORE_CHIP_TRIANGLE_SIDE) / 2,
            -render_helper
        ])
        score_chip_triangle_cutout();
        
        translate([
            BOX_WIDTH - stone_tile_side_height - 0.5,
            (BOX_DEPTH - stone_tile_side_width) / 2,
            BOX_HEIGHT - stone_tile_height(10)
        ])
        stone_tile_cutout(10);
        
        translate([
            0.5,
            0.5,
            -render_helper
        ])
        stone_tile_cutout(STONE_TILE_MAX_COUNT);
        
        translate([
            0.5,
            BOX_DEPTH - stone_tile_side_width - 0.5,
            -render_helper
        ])
        stone_tile_cutout(STONE_TILE_MAX_COUNT);
        
        offset_x_round_chip = BOX_WIDTH - score_chip_round_height - (BOX_WIDTH - stone_tile_side_height - score_chip_round_height) / 2;
        offset_y_round_chip_partial = (stone_tile_side_width + 0.25) / 2 - score_chip_round_radius;
        
        translate([
            offset_x_round_chip,
            offset_y_round_chip_partial,
            BOX_HEIGHT - SCORE_CHIP_ROUND_DIAMETER
        ])
        score_chip_round_cutout();
        
        translate([
            offset_x_round_chip,
            BOX_DEPTH - offset_y_round_chip_partial - SCORE_CHIP_ROUND_DIAMETER,
            BOX_HEIGHT - SCORE_CHIP_ROUND_DIAMETER
        ])
        score_chip_round_cutout();
    }
}

insert();
