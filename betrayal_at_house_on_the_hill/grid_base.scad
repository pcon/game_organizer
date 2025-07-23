use <../parts.scad>
use <../grid_base.scad>

// For prusa mini, need to print four different grids
module base() {
    part("grid_1.stl", c = "red") {
        grid_base(7, 7);
    }

    part("grid_2.stl", c = "blue") {
        grid_shift(7, 0)
        grid_base(6, 7);
    }

    part("grid_3.stl", c = "green") {
        grid_shift(0, 7)
        grid_base(7, 6);
    }

    part("grid_4.stl", c = "purple") {
        grid_shift(7, 7)
        grid_base(6, 6);
    }
}

base();