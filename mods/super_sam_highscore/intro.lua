
super_sam.add_intro_formspec_handler(function(fs)
    return fs .. [[label[0,6.1;Current highscore top 5 (also available with /highscore)]
        ]] .. super_sam_highscore.get_highscore_formspec_fragment("total", 0, 7, 11.7, 6, 5)
end)