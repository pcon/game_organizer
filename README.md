# Gaming Organizer

The `.scad` files in the root can be used to generate your own organizational files.  An example of how they can be used can be found in the `galaxy_trucker` directory.  Optionally, the `.stl` files can be downloaded and used instead.

## Games

- [Betrayal: At House on the Hill](/betrayal_at_house_on_the_hill/)
- [Codenames](/codenames/)
- [Galaxy Trucker](/galaxy_trucker)
- [Mr Jack Pocket](/mr_jack_pocket)
- [One Deck Dungeon](/one_deck_dungeon/)
- [Oriflamme Ablaze](/oriflamme_ablaze)
- [Rumpelstiltskin](/rumpelstiltskin/)

## Utilities

### common.scad

This is the root file that sets up many of the common methods and dimensions.  In this file, `base_block` and `embossed_text` are the most likely be used in the organizer files

### colors.scad

This is a helpful file for generating unique part colors by referencing different colors available.  `displayColor` and `offsetColor` can be used to get colors.

### parts.scad

This file comes from [traverseda](https://github.com/traverseda) to help generate multiple parts in a single scad file.  This is used by various `build` scripts.

### roundedcube.scad

This file allows for cubes with rounded corners and is great for part holding since it makes it easier to scoop out of the bottom

### grid_base.scad

This generates the grid base that goes in the bottom of the box.

### chip_holder.scad

This generates a holder for standard square cards and tokens.  Using `generate_holder` you can generate a holder for these items.  Useful parameters are `hollow_bottom` that will generate an "X" pattern at the bottom.  This can reduce overall filament usage if you want to maintain the same infill percentage.  This also have the ability to put embossed text on the holder

#### Embossed text example

```scad
generate_holder(
    tile_columns = 1,
    tile_rows = 1,
    tile_width = CARD_WIDTH,
    tile_depth = CARD_DEPTH,
    tile_count = 1,
    tile_height = CARD_HEIGHT
) {
    embossed_text(
        "CARDS",
        h = 1,
        size = 8
    );
}
```
