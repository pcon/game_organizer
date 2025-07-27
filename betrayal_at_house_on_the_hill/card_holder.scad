use <../common.scad>
use <../grid_base.scad>
use <../chip_holder.scad>
use <../parts.scad>
use <../roundedcube.scad>
use <common.scad>

render_helper = 1;

CARD_WIDTH = 109;
CARD_DEPTH = 57.5;
CARD_HEIGHT = 31;

MONSTER_CUTOUT_OFFSET = 3;
MONSTER_CUTOUT_HEIGHT = 35;
MONSTER_CUTOUT_RADIUS = 10;
monster_width = CARD_WIDTH - MONSTER_CUTOUT_OFFSET * 2;
monster_depth = CARD_DEPTH - MONSTER_CUTOUT_OFFSET * 2;
monster_height = MONSTER_CUTOUT_HEIGHT + render_helper;

module monsterCutout() {
    roundedcube(
        [
            monster_width,
            monster_depth,
            monster_height
        ],
        radius = MONSTER_CUTOUT_RADIUS,
        apply_to="zmin"
    );
}

module card_holder(hollow_bottom = true) {
    difference() {
        generate_holder(
            tile_columns = 1,
            tile_rows = 1,
            tile_width = CARD_WIDTH,
            tile_depth = CARD_DEPTH,
            tile_count = 1,
            tile_height = CARD_HEIGHT,
            wall_width = wall_width(),
            box_height = box_height(),
            box_clearance = 0,
            round_to_full_base = true,
            fit_to_box_height = true,
            hollow_bottom = false
        ) {
            embossed_text(
                "CARDS",
                h = font_depth(),
                size = font_size()
            );
        }

        monster_offset_z = -CARD_HEIGHT - MONSTER_CUTOUT_HEIGHT;
        translate([
            (gridSize(6) - monster_width) / 2,
            (gridSize(4) - monster_depth) / 2,
            box_height() + MONSTER_CUTOUT_RADIUS + monster_offset_z
        ])
        monsterCutout();

        echo(monster_offset_z=monster_offset_z);
        translate([gridSize(6) / 2, gridSize(4) / 2, box_height() + monster_offset_z + MONSTER_CUTOUT_RADIUS])
        embossed_text("MONSTERS", h = font_depth(), size = font_size());
    }
}
part("card_holder.stl") {
    card_holder();
}

part("card_holder_basemodifier.stl") {
    base_modifier_grid(6, 4);
}