# LPCAnimatedSprite2D [![Discord](https://img.shields.io/discord/717501929642655804?label=Discord)](https://discord.gg/9s4STu4QEH)
With this addon you simply add a LPC spritesheet to a character and it automaticly generates the animations for the Godot4 sprites



## Install

To install this plugin, go to [Releases](https://github.com/alextrevisan/LPCAnimatedSprite2D/releases) and download the latest version.

Extract the zip file inside it your Godot Project folder.

![image](https://raw.githubusercontent.com/alextrevisan/LPCAnimatedSprite2D/main/addons-tree.png)

## Getting Started

### Activate the plugin

- Open your project in Godot Editor
- Go to Project > Project Settings... > Plugins
- You should see LPCAnimatedSprite Plugin. On the right side, check the "Enable" box

![image](https://raw.githubusercontent.com/alextrevisan/LPCAnimatedSprite2D/main/plugin.png)

## Use the plugin functions

You now have access to a new Node called `LPCAnimatedSprite2D`, which you can use
Add it to the scene tree

![image](https://raw.githubusercontent.com/alextrevisan/LPCAnimatedSprite2D/main/new%20node.png)

Then add your spritesheet with the names:

![image](https://raw.githubusercontent.com/alextrevisan/LPCAnimatedSprite2D/main/create_lpc.gif)

On the parent node you can call the animations:

```GDScript
extends Node2D

@onready var player = $LPCAnimatedSprite2D as LPCAnimatedSprite2D

func _ready():
	player.play(LPCAnimatedSprite2D.LPCAnimation.WALK_UP)
```

## Support for Oversized Weapons
Just select the appropriate Sprite Type

If using component sprites rather than a a pre-built spritesheet, pay attention to the order in which they are configured as it will influence visibility.

## Version number

I choose this type of version to match the Godot version plus the release version number of the plugin:

4.0.3.1 -> Godot version 4.0.3 + Release version 1

## Contributing

Contributions are very welcome.

## License

Distributed under the terms of the MIT license, "LPCAnimatedSprite" is free and open source software
