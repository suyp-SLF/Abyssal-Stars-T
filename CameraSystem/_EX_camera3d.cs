using Godot;
using System;

public partial class _EX_camera3d : Camera3D
{
	[Signal]
	delegate void CameraEventHandler();
\
	// when node enter, 
	public override void _EnterTree()
	{
		G_Environment
	}

	public override void _ExitTree()
	{
		base._ExitTree();
	}  
}
