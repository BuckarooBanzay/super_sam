#!/bin/sh

for modname in spawn skybox builtin_disable powerups super_sam integration_test
do
    sh -c "cd mods/${modname} && luacheck ."
done