#!/bin/sh

for modname in spawn skybox super_sam
do
    sh -c "cd mods/${modname} && luacheck ."
done