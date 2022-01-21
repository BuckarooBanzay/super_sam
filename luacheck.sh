#!/bin/sh

for modname in super_sam super_sam_test
do
    sh -c "cd mods/${modname} && luacheck ."
done