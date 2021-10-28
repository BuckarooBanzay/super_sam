#!/bin/sh

for modname in super_sam
do
    sh -c "cd mods/${modname} && luacheck ."
done