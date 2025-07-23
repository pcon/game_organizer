use <../common.scad>
use <common.scad>
use <../roundedcube.scad>
use <../parts.scad>

BASE_THICKNESS = 2;
LIP_HEIGHT = 2;
LIP_WIDTH = 2;
SIDE_CLEARANCE = 3;
TEXT_CLEARANCE = 10;

LAYER_HEIGHTS = [
    9,
    9
];

LAYER_SLOT_COUNT = [
    3,
    2
];

SLOT_LABELS = [
    [
        "FOOD",
        "PORTALS",
        "OBSTACLES"
    ],
    [
        "FOO",
        "BAR"
    ]
];

render_helper = 1;

total_width = 7 * base_tile_size();
total_depth = 3 * base_tile_size();
total_height = box_height() - box_clearence();

slot_depth = total_depth - LIP_WIDTH * 2 - SIDE_CLEARANCE * 2 - TEXT_CLEARANCE;
slot_offset_y = LIP_WIDTH + SIDE_CLEARANCE;

function cumsum(v) = [for (a = v[0]-v[0], i = 0; i < len(v); a = a+v[i], i = i+1)
  a+v[i]];
function layerOffset(i) = peak_height() + BASE_THICKNESS * (i + 1) + cumsum(LAYER_HEIGHTS)[i];
function layerSlotWidth(i) = (total_width - LIP_WIDTH * 2 - SIDE_CLEARANCE * (1 + LAYER_SLOT_COUNT[i])) / LAYER_SLOT_COUNT[i];
function slotOffsetX(i, j) = slot_offset_y + layerSlotWidth(i) * j + SIDE_CLEARANCE * j;
function slotLabel(i, j) = SLOT_LABELS[i][j];

num_layers = len(LAYER_HEIGHTS);
total_layer_height = cumsum(LAYER_HEIGHTS)[num_layers - 1] + BASE_THICKNESS * num_layers;

working_height = total_height - peak_height();
lid_height = working_height - total_layer_height - LIP_HEIGHT;
echo(lid_height=peak_height() + BASE_THICKNESS);

module block_lip() {
    union() {        
        translate([LIP_WIDTH, 0, 0])
        rotate([0, 0, 90])
        prism(total_depth, LIP_WIDTH, LIP_WIDTH);
        
        translate([total_width, LIP_WIDTH, 0])
        rotate([0, 0, 180])
        prism(total_width, LIP_WIDTH, LIP_WIDTH);
        
        translate([total_width - LIP_WIDTH, total_depth, 0])
        rotate([0, 0, 270])
        prism(total_depth, LIP_WIDTH, LIP_WIDTH);
        
        translate([0, total_depth - LIP_WIDTH, 0])
        prism(total_width, LIP_WIDTH, LIP_WIDTH);
    }
}

module block_bottom() {
    bottom_depth = total_depth - LIP_WIDTH * 2;
    bottom_width = total_width - LIP_WIDTH * 2;
    
    translate([0, 0, -LIP_HEIGHT])
    union() {
        translate([LIP_WIDTH, LIP_WIDTH, 0])
        cube([bottom_width, bottom_depth, LIP_HEIGHT]);
        
        translate([total_width - LIP_WIDTH, LIP_WIDTH, 0])
        rotate([90, 0, 90])
        prism(bottom_depth, LIP_WIDTH, LIP_WIDTH);
        
        translate([bottom_width + LIP_WIDTH, total_depth - LIP_WIDTH, 0])
        rotate([90, 0, 180])
        prism(bottom_width, LIP_WIDTH, LIP_WIDTH);
        
        translate([LIP_WIDTH, bottom_depth + LIP_WIDTH, 0])
        rotate([90, 0, 270])
        prism(bottom_depth, LIP_WIDTH, LIP_WIDTH);

        translate([LIP_WIDTH, LIP_WIDTH, 0])
        rotate([90, 0, 0])
        prism(bottom_width, LIP_WIDTH, LIP_WIDTH);
        
        translate([LIP_WIDTH, LIP_WIDTH, LIP_WIDTH])
        rotate([180, 0, 0])
        pyramid(LIP_WIDTH);
        
        translate([bottom_width + LIP_WIDTH, LIP_WIDTH, LIP_WIDTH])
        rotate([180, 0, 0])
        pyramid(LIP_WIDTH);
        
        translate([bottom_width + LIP_WIDTH, bottom_depth + LIP_WIDTH, LIP_WIDTH])
        rotate([180, 0, 0])
        pyramid(LIP_WIDTH);
        
        translate([LIP_WIDTH, bottom_depth + LIP_WIDTH, LIP_WIDTH])
        rotate([180, 0, 0])
        pyramid(LIP_WIDTH);
    }
}

module slot(i, j) {
    translate([0, 0, layerOffset(i)])
    union () {
        translate([0, LIP_WIDTH + SIDE_CLEARANCE, 0])
        roundedcube(
            [
                layerSlotWidth(i),
                slot_depth,
                LAYER_HEIGHTS[i] + render_helper
            ],
            radius = 10,
            apply_to = "zmax"
        );
        
        translate([
            layerSlotWidth(i) / 2,
            slot_depth + TEXT_CLEARANCE,
            0
        ])
        embossed_text(slotLabel(i, j), h = font_depth(), size = font_size() - 3);
    }
}

module slots(i) {
    for (j = [0:LAYER_SLOT_COUNT[i] - 1]) {
        translate([slotOffsetX(i, j), 0, 0])
        slot(i, j);
    }
}

module layer_zero() {
    layer_height = peak_height() + BASE_THICKNESS + LAYER_HEIGHTS[0];
    difference() {
        union() {
            base_block(
                total_width,
                total_depth,
                layer_height
            );
            
            translate([0, 0, layer_height])
            block_lip();
        }
        slots(0);
    }
}

module layer_one() {
    layer_height = LAYER_HEIGHTS[1];
    difference() {
        union() {
            cube([
                total_width,
                total_depth,
                layer_height
            ]);
            
            translate([0, 0, layer_height])
            block_lip();
            block_bottom();
        }
        slots(1);
    }
}

module lid() {
    difference() {
        union() {
            cube([total_width, total_depth, lid_height]);
            block_bottom();
        }
        
        translate([total_width / 2, total_depth / 2, lid_height])
        embossed_text("TOKENS", h = font_depth(), size = font_size());
    }
}

module token_holder() {
    part("token_holder_1.stl", c = "red") {
        layer_zero();
    }    
    
    translate([0, 0, layerOffset(1) - LAYER_HEIGHTS[1]])
    part("token_holder_2.stl", c = "blue") {
        layer_one();
    }
    
    translate([0, 0, layerOffset(len(LAYER_HEIGHTS) - 1) + LIP_HEIGHT])
    part("token_holder_lid.stl", c = "purple") {
        lid();
    }
}

token_holder();