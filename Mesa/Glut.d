
	/*******************************************************************************
	*  Файл генерирован автоматически с помощью либпроцессора Динрус               *
	*  Дата:18.1.2015                                           Время: 19 ч. 38 мин.

	*******************************************************************************/


	module lib.Dinrus.Glut;
	import stdrus;
	
	/////glut

enum: бцел
{
/*
 * The freeglut and GLUT API versions
 */
FREEGLUT				= 1,
GLUT_API_VERSION			= 4,
FREEGLUT_VERSION_2_0		= 1,
GLUT_XLIB_IMPLEMENTATION		= 13,

/*
 * GLUT API: коды специальных клавиш
 */
КЛ_Ф1			= 0x0001,
КЛ_Ф2			= 0x0002,
КЛ_Ф3			= 0x0003,
КЛ_Ф4			= 0x0004,
КЛ_Ф5			= 0x0005,
КЛ_Ф6			= 0x0006,
КЛ_Ф7			= 0x0007,
КЛ_Ф8			= 0x0008,
КЛ_Ф9			= 0x0009,
КЛ_Ф10			= 0x000A,
КЛ_Ф11			= 0x000B,
КЛ_Ф12			= 0x000C,
КЛ_ЛЕВАЯ			= 0x0064,
КЛ_ВВЕРХУ			= 0x0065,
КЛ_ПРАВАЯ			= 0x0066,
КЛ_ВНИЗУ			= 0x0067,
КЛ_СТР_ВВЕРХ			= 0x0068,
КЛ_СТР_ВНИЗ			= 0x0069,
КЛ_ДОМ			= 0x006A,
КЛ_КОНЕЦ			= 0x006B,
КЛ_ВСТАВИТЬ		= 0x006C,

/*
 * GLUT API: определения состояний мыши
 */

МЫШЬ_ЛЕВАЯ			= 0x0000,
МЫШЬ_СРЕДНЯЯ			= 0x0001,
МЫШЬ_ПРАВАЯ			= 0x0002,
МЫШЬ_ВНИЗУ				= 0x0000,
МЫШЬ_ВВЕРХУ				= 0x0001,
МЫШЬ_ВЫШЛА				= 0x0000,
МЫШЬ_ВОШЛА			= 0x0001,

/*
 * GLUT API macro definitions -- the display mode definitions
 */
GLUT_RGB				= 0x0000,
GLUT_RGBA				= 0x0000,
GLUT_INDEX				= 0x0001,
GLUT_SINGLE			= 0x0000,
GLUT_DOUBLE			= 0x0002,
GLUT_ACCUM				= 0x0004,
GLUT_ALPHA				= 0x0008,
GLUT_DEPTH				= 0x0010,
GLUT_STENCIL			= 0x0020,
GLUT_MULTISAMPLE			= 0x0080,
GLUT_STEREO			= 0x0100,
GLUT_LUMINANCE			= 0x0200,

/*
 * GLUT API macro definitions -- windows and menu related definitions
 */
GLUT_MENU_NOT_IN_USE		= 0x0000,
GLUT_MENU_IN_USE			= 0x0001,
GLUT_NOT_VISIBLE			= 0x0000,
GLUT_VISIBLE			= 0x0001,
GLUT_HIDDEN			= 0x0000,
GLUT_FULLY_RETAINED		= 0x0001,
GLUT_PARTIALLY_RETAINED		= 0x0002,
GLUT_FULLY_COVERED			= 0x0003,
}
/*
 * GLUT API macro definitions
 * Steve Baker suggested to make it binary compatible with GLUT:
 */
version (Windows) {
	const ук GLUT_STROKE_ROMAN		= cast(ук)0x0000;
	const ук GLUT_STROKE_MONO_ROMAN	= cast(ук)0x0001;
	const ук GLUT_BITMAP_9_BY_15	= cast(ук)0x0002;
	const ук GLUT_BITMAP_8_BY_13	= cast(ук)0x0003;
	const ук GLUT_BITMAP_TIMES_ROMAN_10= cast(ук)0x0004;
	const ук GLUT_BITMAP_TIMES_ROMAN_24= cast(ук)0x0005;
	const ук GLUT_BITMAP_HELVETICA_10	= cast(ук)0x0006;
	const ук GLUT_BITMAP_HELVETICA_12	= cast(ук)0x0007;
	const ук GLUT_BITMAP_HELVETICA_18	= cast(ук)0x0008;

}

enum: бцел
{
// GLUT API macro definitions -- the glutGet parameters
GLUT_WINDOW_X			= 0x0064,
GLUT_WINDOW_Y			= 0x0065,
GLUT_WINDOW_WIDTH			= 0x0066,
GLUT_WINDOW_HEIGHT			= 0x0067,
GLUT_WINDOW_BUFFER_SIZE		= 0x0068,
GLUT_WINDOW_STENCIL_SIZE		= 0x0069,
GLUT_WINDOW_DEPTH_SIZE		= 0x006A,
GLUT_WINDOW_RED_SIZE		= 0x006B,
GLUT_WINDOW_GREEN_SIZE		= 0x006C,
GLUT_WINDOW_BLUE_SIZE		= 0x006D,
GLUT_WINDOW_ALPHA_SIZE		= 0x006E,
GLUT_WINDOW_ACCUM_RED_SIZE		= 0x006F,
GLUT_WINDOW_ACCUM_GREEN_SIZE	= 0x0070,
GLUT_WINDOW_ACCUM_BLUE_SIZE	= 0x0071,
GLUT_WINDOW_ACCUM_ALPHA_SIZE	= 0x0072,
GLUT_WINDOW_DOUBLEBUFFER		= 0x0073,
GLUT_WINDOW_RGBA			= 0x0074,
GLUT_WINDOW_PARENT			= 0x0075,
GLUT_WINDOW_NUM_CHILDREN		= 0x0076,
GLUT_WINDOW_COLORMAP_SIZE		= 0x0077,
GLUT_WINDOW_NUM_SAMPLES		= 0x0078,
GLUT_WINDOW_STEREO			= 0x0079,
GLUT_WINDOW_CURSOR			= 0x007A,

GLUT_SCREEN_WIDTH			= 0x00C8,
GLUT_SCREEN_HEIGHT			= 0x00C9,
GLUT_SCREEN_WIDTH_MM		= 0x00CA,
GLUT_SCREEN_HEIGHT_MM		= 0x00CB,
GLUT_MENU_NUM_ITEMS		= 0x012C,
GLUT_DISPLAY_MODE_POSSIBLE		= 0x0190,
GLUT_INIT_WINDOW_X			= 0x01F4,
GLUT_INIT_WINDOW_Y			= 0x01F5,
GLUT_INIT_WINDOW_WIDTH		= 0x01F6,
GLUT_INIT_WINDOW_HEIGHT		= 0x01F7,
GLUT_INIT_DISPLAY_MODE		= 0x01F8,
GLUT_ELAPSED_TIME			= 0x02BC,
GLUT_WINDOW_FORMAT_ID		= 0x007B,
GLUT_INIT_STATE			= 0x007C,

// GLUT API macro definitions -- the glutDeviceGet parameters
GLUT_HAS_KEYBOARD			= 0x0258,
GLUT_HAS_MOUSE			= 0x0259,
GLUT_HAS_SPACEBALL			= 0x025A,
GLUT_HAS_DIAL_AND_BUTTON_BOX	= 0x025B,
GLUT_HAS_TABLET			= 0x025C,
GLUT_NUM_MOUSE_BUTTONS		= 0x025D,
GLUT_NUM_SPACEBALL_BUTTONS		= 0x025E,
GLUT_NUM_BUTTON_BOX_BUTTONS	= 0x025F,
GLUT_NUM_DIALS			= 0x0260,
GLUT_NUM_TABLET_BUTTONS		= 0x0261,
GLUT_DEVICE_IGNORE_KEY_REPEAT	= 0x0262,
GLUT_DEVICE_KEY_REPEAT		= 0x0263,
GLUT_HAS_JOYSTICK			= 0x0264,
GLUT_OWNS_JOYSTICK			= 0x0265,
GLUT_JOYSTICK_BUTTONS		= 0x0266,
GLUT_JOYSTICK_AXES			= 0x0267,
GLUT_JOYSTICK_POLL_RATE		= 0x0268,

// GLUT API macro definitions -- the glutLayerGet parameters
GLUT_OVERLAY_POSSIBLE		= 0x0320,
GLUT_LAYER_IN_USE			= 0x0321,
GLUT_HAS_OVERLAY			= 0x0322,
GLUT_TRANSPARENT_INDEX		= 0x0323,
GLUT_NORMAL_DAMAGED		= 0x0324,
GLUT_OVERLAY_DAMAGED		= 0x0325,

// GLUT API macro definitions -- the glutVideoResizeGet parameters
GLUT_VIDEO_RESIZE_POSSIBLE		= 0x0384,
GLUT_VIDEO_RESIZE_IN_USE		= 0x0385,
GLUT_VIDEO_RESIZE_X_DELTA		= 0x0386,
GLUT_VIDEO_RESIZE_Y_DELTA		= 0x0387,
GLUT_VIDEO_RESIZE_WIDTH_DELTA	= 0x0388,
GLUT_VIDEO_RESIZE_HEIGHT_DELTA	= 0x0389,
GLUT_VIDEO_RESIZE_X		= 0x038A,
GLUT_VIDEO_RESIZE_Y		= 0x038B,
GLUT_VIDEO_RESIZE_WIDTH		= 0x038C,
GLUT_VIDEO_RESIZE_HEIGHT		= 0x038D,

// GLUT API macro definitions -- the glutUseLayer parameters
GLUT_NORMAL			= 0x0000,
GLUT_OVERLAY			= 0x0001,

// GLUT API macro definitions -- the glutGetModifiers parameters
GLUT_ACTIVE_ШИФТ			= 0x0001,
GLUT_ACTIVE_CTRL			= 0x0002,
GLUT_ACTIVE_ALT			= 0x0004,

// GLUT API macro definitions -- the glutSetCursor parameters
GLUT_CURSOR_RIGHT_ARROW		= 0x0000,
GLUT_CURSOR_LEFT_ARROW		= 0x0001,
GLUT_CURSOR_INFO			= 0x0002,
GLUT_CURSOR_DESTROY		= 0x0003,
GLUT_CURSOR_HELP			= 0x0004,
GLUT_CURSOR_CYCLE			= 0x0005,
GLUT_CURSOR_SPRAY			= 0x0006,
GLUT_CURSOR_WAIT			= 0x0007,
GLUT_CURSOR_TEXT			= 0x0008,
GLUT_CURSOR_CROSSHAIR		= 0x0009,
GLUT_CURSOR_UP_DOWN		= 0x000A,
GLUT_CURSOR_LEFT_RIGHT		= 0x000B,
GLUT_CURSOR_TOP_SIDE		= 0x000C,
GLUT_CURSOR_BOTTOM_SIDE		= 0x000D,
GLUT_CURSOR_LEFT_SIDE		= 0x000E,
GLUT_CURSOR_RIGHT_SIDE		= 0x000F,
GLUT_CURSOR_TOP_LEFT_CORNER	= 0x0010,
GLUT_CURSOR_TOP_RIGHT_CORNER	= 0x0011,
GLUT_CURSOR_BOTTOM_RIGHT_CORNER	= 0x0012,
GLUT_CURSOR_BOTTOM_LEFT_CORNER	= 0x0013,
GLUT_CURSOR_INHERIT		= 0x0064,
GLUT_CURSOR_NONE			= 0x0065,
GLUT_CURSOR_FULL_CROSSHAIR		= 0x0066,

// GLUT API macro definitions -- RGB color component specification definitions
GLUT_RED				= 0x0000,
GLUT_GREEN				= 0x0001,
GLUT_BLUE				= 0x0002,

// GLUT API macro definitions -- additional keyboard and joystick definitions
КЛ_REPEAT_OFF		= 0x0000,
КЛ_REPEAT_ON			= 0x0001,
КЛ_REPEAT_DEFAULT		= 0x0002,

GLUT_JOYSTICK_BUTTON_A		= 0x0001,
GLUT_JOYSTICK_BUTTON_B		= 0x0002,
GLUT_JOYSTICK_BUTTON_C		= 0x0004,
GLUT_JOYSTICK_BUTTON_D		= 0x0008,

// GLUT API macro definitions -- game mode definitions
GLUT_GAME_MODE_ACTIVE		= 0x0000,
GLUT_GAME_MODE_POSSIBLE		= 0x0001,
GLUT_GAME_MODE_WIDTH		= 0x0002,
GLUT_GAME_MODE_HEIGHT		= 0x0003,
GLUT_GAME_MODE_PIXEL_DEPTH		= 0x0004,
GLUT_GAME_MODE_REFRESH_RATE	= 0x0005,
GLUT_GAME_MODE_DISPLAY_CHANGED	= 0x0006,

// FreeGlut extra definitions

}
version(FREEGLUT_EXTRAS)
 {
 
 enum: бцел
	{
	/*
	 * GLUT API Extension macro definitions -- behaviour when the user clicks on an "x" to close a window
	 */
	GLUT_ACTION_EXIT		= 0,
	GLUT_ACTION_GLUTMAINLOOP_RETURNS= 1,
	GLUT_ACTION_CONTINUE_EXECUTION= 2,

	/*
	 * Create a new rendering context when the user opens a new window?
	 */
	GLUT_CREATE_NEW_CONTEXT	= 0,
	GLUT_USE_CURRENT_CONTEXT	= 1,

	/*
	 * Direct/Indirect rendering context options (has meaning only in Unix/X11)
	 */
	GLUT_FORCE_INDIRECT_CONTEXT= 0,
	GLUT_ALLOW_DIRECT_CONTEXT	= 1,
	GLUT_TRY_DIRECT_CONTEXT	= 2,
	GLUT_FORCE_DIRECT_CONTEXT	= 3,

	/*
	 * GLUT API Extension macro definitions -- the glutGet parameters
	 */
	GLUT_ACTION_ON_WINDOW_CLOSE= 0x01F9,
	GLUT_WINDOW_BORDER_WIDTH	= 0x01FA,
	GLUT_WINDOW_HEADER_HEIGHT	= 0x01FB,
	GLUT_VERSION		= 0x01FC,
	GLUT_RENDERING_CONTEXT	= 0x01FD,
	GLUT_DIRECT_RENDERING	= 0x01FE,

	/*
	 * New tokens for glutInitDisplayMode.
	 * Only one GLUT_AUXn bit may be used at a time.
	 * Value 0x0400 is defined in OpenGLUT.
	 */
	GLUT_AUX1			= 0x1000,
	GLUT_AUX2			= 0x2000,
	GLUT_AUX3			= 0x4000,
	GLUT_AUX4			= 0x8000,
	}


}

	проц грузи(Биб биб)
	{

	
		//вяжи(функция_1)("____glutGetFCB@4", биб);

		//вяжи(функция_2)("____glutSetFCB@8", биб);

		//вяжи(функция_3)("___glutCreateMenuWithExit", биб);

		//вяжи(функция_4)("___glutCreateWindowWithExit", биб);

		//вяжи(функция_5)("___glutInitWithExit", биб);

		//вяжи(функция_6)("__glutGetProcAddress@4", биб);

		//вяжи(функция_7)("_glutAddMenuEntry", биб);

		//вяжи(функция_8)("_glutAddSubMenu", биб);

		//вяжи(функция_9)("_glutAttachMenu", биб);

		//вяжи(функция_10)("_glutBitmap9By15", биб);

		//вяжи(функция_11)("_glutBitmapCharacter", биб);

		//вяжи(функция_12)("_glutBitmapHelvetica10", биб);

		//вяжи(функция_13)("_glutBitmapHelvetica18", биб);

		//вяжи(функция_14)("_glutBitmapLength", биб);

		//вяжи(функция_15)("_glutBitmapTimesRoman24", биб);

		//вяжи(функция_16)("_glutBitmapWidth", биб);

		//вяжи(функция_17)("_glutButtonBoxFunc", биб);

		//вяжи(функция_18)("_glutChangeToMenuEntry", биб);

		//вяжи(функция_19)("_glutChangeToSubMenu", биб);

		//вяжи(функция_20)("_glutCopyColormap", биб);

		//вяжи(функция_21)("_glutCreateMenu", биб);

		//вяжи(функция_22)("_glutCreateSubWindow", биб);

		//вяжи(функция_23)("_glutCreateWindow", биб);

		//вяжи(функция_24)("_glutDestroyMenu", биб);

		//вяжи(функция_25)("_glutDestroyWindow", биб);

		//вяжи(функция_26)("_glutDetachMenu", биб);

		//вяжи(функция_27)("_glutDeviceGet", биб);

		//вяжи(функция_28)("_glutDialsFunc", биб);

		//вяжи(функция_29)("_glutDisplayFunc", биб);

		//вяжи(функция_30)("_glutEnterGameMode", биб);

		//вяжи(функция_31)("_glutEntryFunc", биб);

		//вяжи(функция_32)("_glutEstablishOverlay", биб);

		//вяжи(функция_33)("_glutExtensionSupported", биб);

		//вяжи(функция_34)("_glutForceJoystickFunc", биб);

		//вяжи(функция_35)("_glutFullScreen", биб);

		//вяжи(функция_36)("_glutGameModeGet", биб);

		//вяжи(функция_37)("_glutGameModeString", биб);

		//вяжи(функция_38)("_glutGet", биб);

		//вяжи(функция_39)("_glutGetColor", биб);

		//вяжи(функция_40)("_glutGetMenu", биб);

		//вяжи(функция_41)("_glutGetModifiers", биб);

		//вяжи(функция_42)("_glutGetWindow", биб);

		//вяжи(функция_43)("_glutHideOverlay", биб);

		//вяжи(функция_44)("_glutHideWindow", биб);

		//вяжи(функция_45)("_glutIconifyWindow", биб);

		//вяжи(функция_46)("_glutIdleFunc", биб);

		//вяжи(функция_47)("_glutIgnoreKeyRepeat", биб);

		вяжи(глутИниц)("glutInit", биб);

		вяжи(глутИницРежимПоказа)("glutInitDisplayMode", биб);

		вяжи(глутИницТекстОкна)("glutInitDisplayString", биб);

		вяжи(глутИницПозОкна)("glutInitWindowPosition", биб);

		вяжи(глутИницРазмерОкна)("glutInitWindowSize", биб);

		//вяжи(функция_53)("_glutJoystickFunc", биб);

		//вяжи(функция_54)("_glutKeyboardFunc", биб);

		//вяжи(функция_55)("_glutKeyboardUpFunc", биб);

		//вяжи(функция_56)("_glutLayerGet", биб);

		//вяжи(функция_57)("_glutLeaveGameMode", биб);

		//вяжи(функция_58)("_glutMainLoop", биб);

		//вяжи(функция_59)("_glutMenuStateFunc", биб);

		//вяжи(функция_60)("_glutMenuStatusFunc", биб);

		//вяжи(функция_61)("_glutMotionFunc", биб);

		//вяжи(функция_62)("_glutMouseFunc", биб);

		//вяжи(функция_63)("_glutOverlayDisplayFunc", биб);

		//вяжи(функция_64)("_glutPassiveMotionFunc", биб);

		//вяжи(функция_65)("_glutPopWindow", биб);

		//вяжи(функция_66)("_glutPositionWindow", биб);

		//вяжи(функция_67)("_glutPostOverlayRedisplay", биб);

		//вяжи(функция_68)("_glutPostRedisplay", биб);

		//вяжи(функция_69)("_glutPostWindowOverlayRedisplay", биб);

		//вяжи(функция_70)("_glutPostWindowRedisplay", биб);

		//вяжи(функция_71)("_glutPushWindow", биб);

		//вяжи(функция_72)("_glutRemoveMenuItem", биб);

		//вяжи(функция_73)("_glutRemoveOverlay", биб);

		//вяжи(функция_74)("_glutReportErrors", биб);

		//вяжи(функция_75)("_glutReshapeFunc", биб);

		//вяжи(функция_76)("_glutReshapeWindow", биб);

		//вяжи(функция_77)("_glutSetColor", биб);

		//вяжи(функция_78)("_glutSetCursor", биб);

		//вяжи(функция_79)("_glutSetIconTitle", биб);

		//вяжи(функция_80)("_glutSetKeyRepeat", биб);

		//вяжи(функция_81)("_glutSetMenu", биб);

		//вяжи(функция_82)("_glutSetupVideoResizing", биб);

		//вяжи(функция_83)("_glutSetWindow", биб);

		//вяжи(функция_84)("_glutSetWindowTitle", биб);

		//вяжи(функция_85)("_glutShowOverlay", биб);

		//вяжи(функция_86)("_glutShowWindow", биб);

		//вяжи(функция_87)("_glutSolidCone", биб);

		//вяжи(функция_88)("_glutSolidCube", биб);

		//вяжи(функция_89)("_glutSolidDodecahedron", биб);

		//вяжи(функция_90)("_glutSolidIcosahedron", биб);

		//вяжи(функция_91)("_glutSolidOctahedron", биб);

		//вяжи(функция_92)("_glutSolidSphere", биб);

		//вяжи(функция_93)("_glutSolidTeapot", биб);

		//вяжи(функция_94)("_glutSolidTetrahedron", биб);

		//вяжи(функция_95)("_glutSolidTorus", биб);

		//вяжи(функция_96)("_glutSpaceballButtonFunc", биб);

		//вяжи(функция_97)("_glutSpaceballMotionFunc", биб);

		//вяжи(функция_98)("_glutSpaceballRotateFunc", биб);

		//вяжи(функция_99)("_glutSpecialFunc", биб);

		//вяжи(функция_100)("_glutSpecialUpFunc", биб);

		//вяжи(функция_101)("_glutStopVideoResizing", биб);

		//вяжи(функция_102)("_glutStrokeCharacter", биб);

		//вяжи(функция_103)("_glutStrokeLength", биб);

		//вяжи(функция_104)("_glutStrokeRoman", биб);

		//вяжи(функция_105)("_glutStrokeWidth", биб);

		//вяжи(функция_106)("_glutSwapBuffers", биб);

		//вяжи(функция_107)("_glutTabletButtonFunc", биб);

		//вяжи(функция_108)("_glutTabletMotionFunc", биб);

		//вяжи(функция_109)("_glutTimerFunc", биб);

		//вяжи(функция_110)("_glutUseLayer", биб);

		//вяжи(функция_111)("_glutVideoPan", биб);

		//вяжи(функция_112)("_glutVideoResize", биб);

		//вяжи(функция_113)("_glutVideoResizeGet", биб);

		//вяжи(функция_114)("_glutVisibilityFunc", биб);

		//вяжи(функция_115)("_glutWarpPointer", биб);

		//вяжи(функция_116)("_glutWindowStatusFunc", биб);

		//вяжи(функция_117)("_glutWireCone", биб);

		//вяжи(функция_118)("_glutWireCube", биб);

		//вяжи(функция_119)("_glutWireDodecahedron", биб);

		//вяжи(функция_120)("_glutWireIcosahedron", биб);

		//вяжи(функция_121)("_glutWireOctahedron", биб);

		//вяжи(функция_122)("_glutWireSphere", биб);

		//вяжи(функция_123)("_glutWireTeapot", биб);

		//вяжи(функция_124)("_glutWireTetrahedron", биб);

		//вяжи(функция_125)("_glutWireTorus", биб);

		//вяжи(функция_126)("____glutSetFCB@8", биб);

		//вяжи(функция_127)("___glutCreateMenuWithExit", биб);

		//вяжи(функция_128)("___glutCreateWindowWithExit", биб);

		//вяжи(функция_129)("___glutInitWithExit", биб);

		//вяжи(функция_130)("__glutGetProcAddress@4", биб);

		//вяжи(функция_131)("_glutAddMenuEntry", биб);

		//вяжи(функция_132)("_glutAddSubMenu", биб);

		//вяжи(функция_133)("_glutAttachMenu", биб);

		//вяжи(функция_134)("_glutBitmap9By15", биб);

		//вяжи(функция_135)("_glutBitmapCharacter", биб);

		//вяжи(функция_136)("_glutBitmapHelvetica10", биб);

		//вяжи(функция_137)("_glutBitmapHelvetica18", биб);

		//вяжи(функция_138)("_glutBitmapLength", биб);

		//вяжи(функция_139)("_glutBitmapTimesRoman24", биб);

		//вяжи(функция_140)("_glutBitmapWidth", биб);

		//вяжи(функция_141)("_glutButtonBoxFunc", биб);

		//вяжи(функция_142)("_glutChangeToMenuEntry", биб);

		//вяжи(функция_143)("_glutChangeToSubMenu", биб);

		//вяжи(функция_144)("_glutCopyColormap", биб);

		//вяжи(функция_145)("_glutCreateMenu", биб);

		//вяжи(функция_146)("_glutCreateSubWindow", биб);

		вяжи(глутСоздайОкно)("glutCreateWindow", биб);

		//вяжи(функция_148)("_glutDestroyMenu", биб);

		//вяжи(функция_149)("_glutDestroyWindow", биб);

		//вяжи(функция_150)("_glutDetachMenu", биб);

		//вяжи(функция_151)("_glutDeviceGet", биб);

		//вяжи(функция_152)("_glutDialsFunc", биб);

		//вяжи(функция_153)("_glutDisplayFunc", биб);

		//вяжи(функция_154)("_glutEnterGameMode", биб);

		//вяжи(функция_155)("_glutEntryFunc", биб);

		//вяжи(функция_156)("_glutEstablishOverlay", биб);

		//вяжи(функция_157)("_glutExtensionSupported", биб);

		//вяжи(функция_158)("_glutForceJoystickFunc", биб);

		//вяжи(функция_159)("_glutFullScreen", биб);

		//вяжи(функция_160)("_glutGameModeGet", биб);

		//вяжи(функция_161)("_glutGameModeString", биб);

		//вяжи(функция_162)("_glutGet", биб);

		//вяжи(функция_163)("_glutGetColor", биб);

		//вяжи(функция_164)("_glutGetMenu", биб);

		//вяжи(функция_165)("_glutGetModifiers", биб);

		//вяжи(функция_166)("_glutGetWindow", биб);

		//вяжи(функция_167)("_glutHideOverlay", биб);

		//вяжи(функция_168)("_glutHideWindow", биб);

		//вяжи(функция_169)("_glutIconifyWindow", биб);

		//вяжи(функция_170)("_glutIdleFunc", биб);

		//вяжи(функция_171)("_glutIgnoreKeyRepeat", биб);

		//вяжи(функция_172)("_glutInit", биб);

		//вяжи(функция_173)("_glutInitDisplayMode", биб);

		//вяжи(функция_174)("_glutInitDisplayString", биб);

		//вяжи(функция_175)("_glutInitWindowPosition", биб);

		//вяжи(функция_176)("_glutInitWindowSize", биб);

		//вяжи(функция_177)("_glutJoystickFunc", биб);

		//вяжи(функция_178)("_glutKeyboardFunc", биб);

		//вяжи(функция_179)("_glutKeyboardUpFunc", биб);

		//вяжи(функция_180)("_glutLayerGet", биб);

		//вяжи(функция_181)("_glutLeaveGameMode", биб);

		//вяжи(функция_182)("_glutMainLoop", биб);

		//вяжи(функция_183)("_glutMenuStateFunc", биб);

		//вяжи(функция_184)("_glutMenuStatusFunc", биб);

		//вяжи(функция_185)("_glutMotionFunc", биб);

		//вяжи(функция_186)("_glutMouseFunc", биб);

		//вяжи(функция_187)("_glutOverlayDisplayFunc", биб);

		//вяжи(функция_188)("_glutPassiveMotionFunc", биб);

		//вяжи(функция_189)("_glutPopWindow", биб);

		//вяжи(функция_190)("_glutPositionWindow", биб);

		//вяжи(функция_191)("_glutPostOverlayRedisplay", биб);

		//вяжи(функция_192)("_glutPostRedisplay", биб);

		//вяжи(функция_193)("_glutPostWindowOverlayRedisplay", биб);

		//вяжи(функция_194)("_glutPostWindowRedisplay", биб);

		//вяжи(функция_195)("_glutPushWindow", биб);

		//вяжи(функция_196)("_glutRemoveMenuItem", биб);

		//вяжи(функция_197)("_glutRemoveOverlay", биб);

		//вяжи(функция_198)("_glutReportErrors", биб);

		//вяжи(функция_199)("_glutReshapeFunc", биб);

		//вяжи(функция_200)("_glutReshapeWindow", биб);

		//вяжи(функция_201)("_glutSetColor", биб);

		//вяжи(функция_202)("_glutSetCursor", биб);

		//вяжи(функция_203)("_glutSetIconTitle", биб);

		//вяжи(функция_204)("_glutSetKeyRepeat", биб);

		//вяжи(функция_205)("_glutSetMenu", биб);

		//вяжи(функция_206)("_glutSetupVideoResizing", биб);

		//вяжи(функция_207)("_glutSetWindow", биб);

		//вяжи(функция_208)("_glutSetWindowTitle", биб);

		//вяжи(функция_209)("_glutShowOverlay", биб);

		//вяжи(функция_210)("_glutShowWindow", биб);

		//вяжи(функция_211)("_glutSolidCone", биб);

		//вяжи(функция_212)("_glutSolidCube", биб);

		//вяжи(функция_213)("_glutSolidDodecahedron", биб);

		//вяжи(функция_214)("_glutSolidIcosahedron", биб);

		//вяжи(функция_215)("_glutSolidOctahedron", биб);

		//вяжи(функция_216)("_glutSolidSphere", биб);

		//вяжи(функция_217)("_glutSolidTeapot", биб);

		//вяжи(функция_218)("_glutSolidTetrahedron", биб);

		//вяжи(функция_219)("_glutSolidTorus", биб);

		//вяжи(функция_220)("_glutSpaceballButtonFunc", биб);

		//вяжи(функция_221)("_glutSpaceballMotionFunc", биб);

		//вяжи(функция_222)("_glutSpaceballRotateFunc", биб);

		//вяжи(функция_223)("_glutSpecialFunc", биб);

		//вяжи(функция_224)("_glutSpecialUpFunc", биб);

		//вяжи(функция_225)("_glutStopVideoResizing", биб);

		//вяжи(функция_226)("_glutStrokeCharacter", биб);

		//вяжи(функция_227)("_glutStrokeLength", биб);

		//вяжи(функция_228)("_glutStrokeRoman", биб);

		//вяжи(функция_229)("_glutStrokeWidth", биб);

		//вяжи(функция_230)("_glutSwapBuffers", биб);

		//вяжи(функция_231)("_glutTabletButtonFunc", биб);

		//вяжи(функция_232)("_glutTabletMotionFunc", биб);

		//вяжи(функция_233)("_glutTimerFunc", биб);

		//вяжи(функция_234)("_glutUseLayer", биб);

		//вяжи(функция_235)("_glutVideoPan", биб);

		//вяжи(функция_236)("_glutVideoResize", биб);

		//вяжи(функция_237)("_glutVideoResizeGet", биб);

		//вяжи(функция_238)("_glutVisibilityFunc", биб);

		//вяжи(функция_239)("_glutWarpPointer", биб);

		//вяжи(функция_240)("_glutWindowStatusFunc", биб);

		//вяжи(функция_241)("_glutWireCone", биб);

		//вяжи(функция_242)("_glutWireCube", биб);

		//вяжи(функция_243)("_glutWireDodecahedron", биб);

		//вяжи(функция_244)("_glutWireIcosahedron", биб);

		//вяжи(функция_245)("_glutWireOctahedron", биб);

		//вяжи(функция_246)("_glutWireSphere", биб);

		//вяжи(функция_247)("_glutWireTeapot", биб);

	}

ЖанБибгр DINRUS_GLUT;

		static this()
		{
			DINRUS_GLUT.заряжай("Dinrus.Glut.dll", &грузи );
			DINRUS_GLUT.загружай();
		}

	extern(C)
	{


		//проц function(   ) функция_1; 

		//проц function(   ) функция_2; 

		//проц function(   ) функция_3; 

		//проц function(   ) функция_4; 

		//проц function(   ) функция_5; 

		//проц function(   ) функция_6; 

		//проц function(   ) функция_7; 

		//проц function(   ) функция_8; 

		//проц function(   ) функция_9; 

		//проц function(   ) функция_10; 

		//проц function(   ) функция_11; 

		//проц function(   ) функция_12; 

		//проц function(   ) функция_13; 

		//проц function(   ) функция_14; 

		//проц function(   ) функция_15; 

		//проц function(   ) функция_16; 

		//проц function(   ) функция_17; 

		//проц function(   ) функция_18; 

		//проц function(   ) функция_19; 

		//проц function(   ) функция_20; 

		//проц function(   ) функция_21; 

		//проц function(   ) функция_22; 

		//проц function(   ) функция_23; 

		//проц function(   ) функция_24; 

		//проц function(   ) функция_25; 

		//проц function(   ) функция_26; 

		//проц function(   ) функция_27; 

		//проц function(   ) функция_28; 

		//проц function(   ) функция_29; 

		//проц function(   ) функция_30; 

		//проц function(   ) функция_31; 

		//проц function(   ) функция_32; 

		//проц function(   ) функция_33; 

		//проц function(   ) функция_34; 

		//проц function(   ) функция_35; 

		//проц function(   ) функция_36; 

		//проц function(   ) функция_37; 

		//проц function(   ) функция_38; 

		//проц function(   ) функция_39; 

		//проц function(   ) функция_40; 

		//проц function(   ) функция_41; 

		//проц function(   ) функция_42; 

		//проц function(   ) функция_43; 

		//проц function(   ) функция_44; 

		//проц function(   ) функция_45; 

		//проц function(   ) функция_46; 

		//проц function(   ) функция_47; 

		проц function( цел* а= пусто, сим** б = пусто ) глутИниц; 

		проц function( бцел режим ) глутИницРежимПоказа; 

		проц function( сим* а ) глутИницТекстОкна; 

		проц function( цел а, цел б ) глутИницПозОкна; 

		проц function( цел а, цел б  ) глутИницРазмерОкна; 

		//проц function(   ) функция_53; 

		//проц function(   ) функция_54; 

		//проц function(   ) функция_55; 

		//проц function(   ) функция_56; 

		//проц function(   ) функция_57; 

		//проц function(   ) функция_58; 

		//проц function(   ) функция_59; 

		//проц function(   ) функция_60; 

		//проц function(   ) функция_61; 

		//проц function(   ) функция_62; 

		//проц function(   ) функция_63; 

		//проц function(   ) функция_64; 

		//проц function(   ) функция_65; 

		//проц function(   ) функция_66; 

		//проц function(   ) функция_67; 

		//проц function(   ) функция_68; 

		//проц function(   ) функция_69; 

		//проц function(   ) функция_70; 

		//проц function(   ) функция_71; 

		//проц function(   ) функция_72; 

		//проц function(   ) функция_73; 

		//проц function(   ) функция_74; 

		//проц function(   ) функция_75; 

		//проц function(   ) функция_76; 

		//проц function(   ) функция_77; 

		//проц function(   ) функция_78; 

		//проц function(   ) функция_79; 

		//проц function(   ) функция_80; 

		//проц function(   ) функция_81; 

		//проц function(   ) функция_82; 

		//проц function(   ) функция_83; 

		//проц function(   ) функция_84; 

		//проц function(   ) функция_85; 

		//проц function(   ) функция_86; 

		//проц function(   ) функция_87; 

		//проц function(   ) функция_88; 

		//проц function(   ) функция_89; 

		//проц function(   ) функция_90; 

		//проц function(   ) функция_91; 

		//проц function(   ) функция_92; 

		//проц function(   ) функция_93; 

		//проц function(   ) функция_94; 

		//проц function(   ) функция_95; 

		//проц function(   ) функция_96; 

		//проц function(   ) функция_97; 

		//проц function(   ) функция_98; 

		//проц function(   ) функция_99; 

		//проц function(   ) функция_100; 

		//проц function(   ) функция_101; 

		//проц function(   ) функция_102; 

		//проц function(   ) функция_103; 

		//проц function(   ) функция_104; 

		//проц function(   ) функция_105; 

		//проц function(   ) функция_106; 

		//проц function(   ) функция_107; 

		//проц function(   ) функция_108; 

		//проц function(   ) функция_109; 

		//проц function(   ) функция_110; 

		//проц function(   ) функция_111; 

		//проц function(   ) функция_112; 

		//проц function(   ) функция_113; 

		//проц function(   ) функция_114; 

		//проц function(   ) функция_115; 

		//проц function(   ) функция_116; 

		//проц function(   ) функция_117; 

		//проц function(   ) функция_118; 

		//проц function(   ) функция_119; 

		//проц function(   ) функция_120; 

		//проц function(   ) функция_121; 

		//проц function(   ) функция_122; 

		//проц function(   ) функция_123; 

		//проц function(   ) функция_124; 

		//проц function(   ) функция_125; 

		//проц function(   ) функция_126; 

		//проц function(   ) функция_127; 

		//проц function(   ) функция_128; 

		//проц function(   ) функция_129; 

		//проц function(   ) функция_130; 

		//проц function(   ) функция_131; 

		//проц function(   ) функция_132; 

		//проц function(   ) функция_133; 

		//проц function(   ) функция_134; 

		//проц function(   ) функция_135; 

		//проц function(   ) функция_136; 

		//проц function(   ) функция_137; 

		//проц function(   ) функция_138; 

		//проц function(   ) функция_139; 

		//проц function(   ) функция_140; 

		//проц function(   ) функция_141; 

		//проц function(   ) функция_142; 

		//проц function(   ) функция_143; 

		//проц function(   ) функция_144; 

		//проц function(   ) функция_145; 

		//проц function(   ) функция_146; 

		проц function(  сим* а ) глутСоздайОкно; 

		//проц function(   ) функция_148; 

		//проц function(   ) функция_149; 

		//проц function(   ) функция_150; 

		//проц function(   ) функция_151; 

		//проц function(   ) функция_152; 

		//проц function(   ) функция_153; 

		//проц function(   ) функция_154; 

		//проц function(   ) функция_155; 

		//проц function(   ) функция_156; 

		//проц function(   ) функция_157; 

		//проц function(   ) функция_158; 

		//проц function(   ) функция_159; 

		//проц function(   ) функция_160; 

		//проц function(   ) функция_161; 

		//проц function(   ) функция_162; 

		//проц function(   ) функция_163; 

		//проц function(   ) функция_164; 

		//проц function(   ) функция_165; 

		//проц function(   ) функция_166; 

		//проц function(   ) функция_167; 

		//проц function(   ) функция_168; 

		//проц function(   ) функция_169; 

		//проц function(   ) функция_170; 

		//проц function(   ) функция_171; 

		//проц function(   ) функция_172; 

		//проц function(   ) функция_173; 

		//проц function(   ) функция_174; 

		//проц function(   ) функция_175; 

		//проц function(   ) функция_176; 

		//проц function(   ) функция_177; 

		//проц function(   ) функция_178; 

		//проц function(   ) функция_179; 

		//проц function(   ) функция_180; 

		//проц function(   ) функция_181; 

		//проц function(   ) функция_182; 

		//проц function(   ) функция_183; 

		//проц function(   ) функция_184; 

		//проц function(   ) функция_185; 

		//проц function(   ) функция_186; 

		//проц function(   ) функция_187; 

		//проц function(   ) функция_188; 

		//проц function(   ) функция_189; 

		//проц function(   ) функция_190; 

		//проц function(   ) функция_191; 

		//проц function(   ) функция_192; 

		//проц function(   ) функция_193; 

		//проц function(   ) функция_194; 

		//проц function(   ) функция_195; 

		//проц function(   ) функция_196; 

		//проц function(   ) функция_197; 

		//проц function(   ) функция_198; 

		//проц function(   ) функция_199; 

		//проц function(   ) функция_200; 

		//проц function(   ) функция_201; 

		//проц function(   ) функция_202; 

		//проц function(   ) функция_203; 

		//проц function(   ) функция_204; 

		//проц function(   ) функция_205; 

		//проц function(   ) функция_206; 

		//проц function(   ) функция_207; 

		//проц function(   ) функция_208; 

		//проц function(   ) функция_209; 

		//проц function(   ) функция_210; 

		//проц function(   ) функция_211; 

		//проц function(   ) функция_212; 

		//проц function(   ) функция_213; 

		//проц function(   ) функция_214; 

		//проц function(   ) функция_215; 

		//проц function(   ) функция_216; 

		//проц function(   ) функция_217; 

		//проц function(   ) функция_218; 

		//проц function(   ) функция_219; 

		//проц function(   ) функция_220; 

		//проц function(   ) функция_221; 

		//проц function(   ) функция_222; 

		//проц function(   ) функция_223; 

		//проц function(   ) функция_224; 

		//проц function(   ) функция_225; 

		//проц function(   ) функция_226; 

		//проц function(   ) функция_227; 

		//проц function(   ) функция_228; 

		//проц function(   ) функция_229; 

		//проц function(   ) функция_230; 

		//проц function(   ) функция_231; 

		//проц function(   ) функция_232; 

		//проц function(   ) функция_233; 

		//проц function(   ) функция_234; 

		//проц function(   ) функция_235; 

		//проц function(   ) функция_236; 

		//проц function(   ) функция_237; 

		//проц function(   ) функция_238; 

		//проц function(   ) функция_239; 

		//проц function(   ) функция_240; 

		//проц function(   ) функция_241; 

		//проц function(   ) функция_242; 

		//проц function(   ) функция_243; 

		//проц function(   ) функция_244; 

		//проц function(   ) функция_245; 

		//проц function(   ) функция_246; 

		//проц function(   ) функция_247; 

	}

	void main()
	{
		глутИницРежимПоказа (GLUT_SINGLE | GLUT_INDEX);
		глутИницРазмерОкна (200, 200);
		глутСоздайОкно ("aaindex");
	}
	
	
