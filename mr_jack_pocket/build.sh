#!/bin/bash

FOLDER="models"
SCAD_FILE="box_organizer.scad"

objects=("card_holder.stl" "part_holder.stl")

for object in ${objects[@]}
do
	echo "RENDERING - ${object}"
	openscad -o "${FOLDER}/${object}" ${SCAD_FILE} -D "multiPartOutput=\"${object}\""
done