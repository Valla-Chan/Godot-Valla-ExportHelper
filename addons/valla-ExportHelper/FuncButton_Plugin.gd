tool
extends EditorPlugin

var plugin 

func _enter_tree():
	plugin = preload("./FuncButton_InspectorPlugin.gd").new()
	add_inspector_plugin(plugin)

func _exit_tree():
	remove_inspector_plugin(plugin)

func rescan_filesystem():
	var filesys = get_editor_interface().get_resource_filesystem()
	filesys.update_script_classes()
	filesys.scan_sources()
	filesys.scan()
