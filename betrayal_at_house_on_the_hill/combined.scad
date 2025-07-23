use <../grid_base.scad>
use <grid_base.scad>
use <card_holder.scad>
use <room_holder.scad>
use <figure_holder.scad>
use <dice_and_character_holder.scad>
use <token_holder.scad>

HOLLOW_BOTTOMS = false;

base();

grid_shift(0, 0)
room_holder(HOLLOW_BOTTOMS);

grid_shift(0, 5)
room_holder(HOLLOW_BOTTOMS);

grid_shift(9, 0)
grid_rotate(4)
card_holder();

grid_shift(5, 0)
grid_rotate(4)
figure_holder();

grid_shift(7, 6)
dice_and_character_holder();

grid_shift(0, 10)
token_holder();