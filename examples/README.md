# Examples

Examples are to be stored here.

Each example should be it's own project, and should be runnable on it's own, *as well* as from the snippets explorer

To this end:

- scenes must be saved as `xml`
- after saving, xml must be edited, and external resources made relative (remove `res://`)
- the snippet script file *must* have the same name as the directory (case matters)
- an `engine.cfg` file must be present, containing, at least, the project's name and entry point
- you can add an `author` field to the engine.cfg file

Feel free to copy the [_template](../utils/_template) directory found in [/utils](../utils) and use it as a basis

## List of available snippets


 - [custom_error](./custom_error)
 - [custom_signals](./custom_signals)
 - [directory_reader](./directory_reader)
 - [json_parser](./json_parser)
 - [mouse_pos](./mouse_pos)
 - [scene_loader](./scene_loader)
