#!/bin/sh

for modname in super_sam integration_test
do
    sh -c "cd mods/${modname} && luacheck ."
done