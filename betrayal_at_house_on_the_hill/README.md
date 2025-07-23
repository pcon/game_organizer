> [!WARNING]
> This is a partially finished design.  It is still a work in progress and not all the holders are complete

## Using `basemodifier` files

Some of the blocks are large and empty.  This is on purpose to fill up the space to keep the tokens or parts from falling out if the box is rotated.  However, this is a huge waste of filament to print.  To combat this, you can choose a very sparse adaptive infill like Lightning to make most of the part hollow.  However, by default the slicer can leave the bottom "nubbins" very unsupported and this can make it not particularly ridged.  To fix this, you can add modifiers to the parts in your slicer to change the infill.  As an example, with the `dice_and_character_holder.stl` you can use Lightning infill for the main part and then attach a modifier to change the infill for the base.  The modifier can be a STL file.  So by using the `dice_and_character_basemodifier.stl` you can have a more ridgid infill like Grid for the "nubbins" and still have the majority of the holder be empty.

![Prusa modifier settings](assets/modifier_settings.png)
![Infill example with modifier settings](assets/modifier_infill.png)

![Grid only infill](assets/modifier_output_gridonly.png)
Sliced info for full grid infill.

![Lightning only infill](assets/modifier_output_lightningonly.png)
Sliced info for full lightning infill.

![Combination infill](assets/modifier_output_gridandlightning.png)
Sliced info using `basemodifier` with a grid infill and lightning infill for the rest.
