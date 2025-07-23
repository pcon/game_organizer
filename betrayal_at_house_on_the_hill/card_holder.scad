use <../common.scad>
use <common.scad>
use <../chip_holder.scad>

CARD_WIDTH = 109;
CARD_DEPTH = 57.5;
CARD_HEIGHT = 31;

HOLLOW_BOTTOM = true;

render_helper = 1;

module card_holder(hollow_bottom = true) {
    generate_holder(
        tile_columns = 1,
        tile_rows = 1,
        tile_width = CARD_WIDTH,
        tile_depth = CARD_DEPTH,
        tile_count = 1,
        tile_height = CARD_HEIGHT,
        wall_width = wall_width(),
        box_height = box_height(),
        box_clearence = 0,
        round_to_full_base = true,
        fit_to_box_height = true,
        hollow_bottom = hollow_bottom
    ) {
        embossed_text(
            "CARDS",
            h = font_depth(),
            size = font_size()
        );
    }
}

card_holder(HOLLOW_BOTTOM);