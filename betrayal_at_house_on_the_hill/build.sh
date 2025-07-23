#!/bin/bash

FOLDER="models"

GRID_BASE="grid_base.scad"
objects=("grid_1.stl" "grid_2.stl" "grid_3.stl" "grid_4.stl")

BASE_MODIFIERS=("dice_and_character_holder")
BASE_MODIFIER_EXT="basemodifier"

FILES=("card_holder" "figure_holder" "room_holder")
HOLLOW_BOTTOMS=("room_holder" "card_holder")

for object in ${objects[@]}
do
	echo "RENDERING - ${object}"
	openscad -q -o "${FOLDER}/${object}" ${GRID_BASE} -D "multiPartOutput=\"${object}\""
done

for file in ${BASE_MODIFIERS[@]}
do
	stl_file="${file}.stl"
	modifier_stl_file="${file}_${BASE_MODIFIER_EXT}.stl"
	scad_file="${file}.scad"

	echo "RENDERING - ${stl_file}"
	openscad -q -o "${FOLDER}/${stl_file}" ${scad_file} -D "multiPartOutput=\"${stl_file}\""

	echo "RENDERING - ${modifier_stl_file}"
	openscad -q -o "${FOLDER}/${modifier_stl_file}" ${scad_file} -D "multiPartOutput=\"${modifier_stl_file}\""
done

for file in ${FILES[@]}
do
	stl_file="${file}.stl"
	solid_stl_file="${file}_solid.stl"
	scad_file="${file}.scad"

	echo "RENDERING - ${stl_file}"
	openscad -q -o "${FOLDER}/${stl_file}" "${scad_file}"

	if [[ ${HOLLOW_BOTTOMS[@]} =~ ${file} ]]
	then
		echo "RENDERING - ${solid_stl_file}"
		openscad -q -D "HOLLOW_BOTTOM=false" -o "${FOLDER}/${solid_stl_file}" "${scad_file}"
	fi
done
