extends Resource

class_name Locale

export var type := "builtins:translation"
export var lang_id := "en_US"
export var lang_name := "English (US)"
export var keys := {
	"builtins:ts_load_game_button": "Load Save",
	"builtins:ts_load_game_dialog_title": "Load Save",
	"builtins:ts_save_game_button": "Create Save",
	"builtins:ts_save_game_dialog_title": "Create Save",
	"builtins:ts_settings": "Settings",
	"builtins:ts_credits": "Credits",
	"builtins:ts_changelogs": "Changelogs",
	"builtins:ts_made_by": "Made by [url=https://twitter.com/RenderRenderRen]Ettu[/url]",
	"builtins:ts_welcome_message": "Hello",
	"builtins:ts_welcome_message_evening": "Evening",
	"builtins:ts_mod_singular": "Mod Loaded",
	"builtins:ts_mod_plural": "Mods Loaded",
	"builtins:ts_namespace_singular": "Namespace",
	"builtins:ts_namespace_plural": "Namespaces",
	"builtins:ts_resources_singular": "Resource",
	"builtins:ts_resources_plural": "Resources",
	"builtins:credits_exit": "Exit",
	"builtins:credits_text": """[b]Art:[/b] RenSert
[b]Coding:[/b] RenSert
[b]Testing:[/b] RenSert

[b]Special Thanks[/b]
- [url=https://andromeda-coders.ru/]Andromeda Coders[/url] for making their game [url=https://play.google.com/store/apps/details?id=com.andromeda.factory&hl=en&gl=US]Factory Simulator[/url], the inspiration for this game.
- Roblox [url=https://www.roblox.com/groups/10634825/Gaming-Glove-Studios#!/about]Gaming Glove Studio[/url]'s [url=https://www.roblox.com/games/6769764667/SPRING-2X-Factory-Simulator]Factory Simulator[/url] for also inspiring me into making this""",
	"builtins:changelogs_text": "Changelogs"
}

func _load(path: String):
	print(path)
	if ResourceLoader.exists(path):
		return ResourceLoader.load(path)
