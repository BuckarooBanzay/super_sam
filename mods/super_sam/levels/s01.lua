
super_sam.register_level("s01e01", {
    time = 90,
    start = { x=22.5, y=9.5, z=19.5 },
    finish = {
        ["s01e02"] = { x=125.5, y=9.5, z=17.5 }
    },
    bounds = {
        { x=11, y=0, z=37 },
        { x=125, y=26, z=0 }
    }
})

super_sam.register_level("s01e02", {
    time = 90,
    start = { x=0, y=0, z=0 },
    finish = {
        ["eof"] = { x=0, y=0, z=0 }
    },
    bounds = {
        { x=0, y=0, z=0 },
        { x=0, y=0, z=0 }
    }
})