
## Events

```lua
super_sam.on_event(name, fn)
super_sam.emit_event(name, ...)
```

* `mode_change` player mode-change (player, edit|play)
* `timeout` Level-timeout (player)
* `level_finished` Player finished a level (player, highscore_name, score, rank)