#!/bin/sh
set -e

for modname in super_sam super_sam_ambience super_sam_highscore super_sam_nodes super_sam_test
do
    sh -c "cd mods/${modname} && luacheck ."
done