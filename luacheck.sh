#!/bin/sh

for modname in spawn skybox builtin_disable powerups
do
    sh -c "cd mods/${modname} && luacheck ."
done