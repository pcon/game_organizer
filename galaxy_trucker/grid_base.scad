use <../grid_base.scad>
use <../colors.scad>

// For prusa mini, need to print four different grids
module base() {
    part("grid_1.stl", c = displayColor(10)) {
        grid_base(8, 8);
    }

    part("grid_2.stl", c = displayColor(11)) {
        grid_shift(8, 0)
        grid_base(8, 7);
    }

    part("grid_3.stl", c = displayColor(12)) {
        grid_shift(0, 8)
        grid_base(3, 8);
    }

    part("grid_4.stl", c = displayColor(13)) {
        grid_shift(8, 8)
        grid_base(3, 7);
    }
}

base();