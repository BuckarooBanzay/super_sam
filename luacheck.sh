#!/bin/sh

for modname in spawn skybox
do
    sh -c "cd mods/${modname} && luacheck ."
done