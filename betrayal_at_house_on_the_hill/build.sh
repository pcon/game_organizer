#!/bin/bash

dir_name=${PWD##*/}
npm run build "${dir_name}"
