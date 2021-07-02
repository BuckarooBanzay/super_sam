#!/bin/sh

for modname in spawn skybox builtin_disable
do
    sh -c "cd mods/${modname} && luacheck ."
done