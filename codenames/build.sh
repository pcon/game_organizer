#!/bin/bash

MODELS=("agents_holder" "codenames_holder" "keys_holder" "timer_holder")

for model in ${MODELS[@]}; do
scad="${model}.scad"
hollow="models/${model}_hollow_bottom.stl"
normal="models/${model}.stl"

echo "Outputting ${scad} to ${hollow}"
openscad -o ${hollow} -D 'HOLLOW_BOTTOM=true' ${scad}

echo "Outputting ${scad} to ${normal}"
openscad -o ${normal} -D 'HOLLOW_BOTTOM=false' ${scad}
done