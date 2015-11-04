module lib.mesa;
import stdrus, cidrus;



alias uint      GLenum;
alias ubyte     GLboolean;
alias uint      GLbitfield;
alias void      GLvoid;
alias byte      GLbyte;
alias short     GLshort;
alias int       GLint;
alias ubyte     GLubyte;
alias ushort    GLushort;
alias uint      GLuint;
alias int       GLsizei;
alias float     GLfloat;
alias float     GLclampf;
alias double    GLdouble;
alias double    GLclampd;
alias char      GLchar;
alias ptrdiff_t GLintptr;
alias ptrdiff_t GLsizeiptr;


alias бцел      Гперечень;
alias ббайт     Гбул;
alias бцел      Гбитполе;
alias цел       Гцразм;
alias плав     Гклампп;
alias дво    Гклампд;
alias т_дельтаук Гцелук;
alias т_дельтаук Гцразмук;


struct GLUnurbs { }
alias GLUnurbs Нурб;
struct GLUquadric { }
alias GLUquadric Квадр;
struct GLUtesselator { }
alias GLUtesselator Тесс;

typedef GLUnurbs GLUnurbsObj;
typedef GLUquadric GLUquadricObj;
typedef GLUtesselator GLUtesselatorObj;
typedef GLUtesselator GLUtriangulatorObj;


// Булевы значения
enum : Гбул
{
    г_нет    = 0x0,
    г_да    = 0x1,
	GL_FALSE = 0x0,
	GL_TRUE = 0x1,
}



enum : Гперечень
{
	
    // Типы данных
	
    БАЙТ                                = 0x1400,
    ББАЙТ                       = 0x1401,
    КРАТ                               = 0x1402,
    БКРАТ                      = 0x1403,
    ЦЕЛ                                 = 0x1404,
    БЦЕЛ                        = 0x1405,
    ПЛАВ                               = 0x1406,
    ДВО                              = 0x140A,
    ДВА_БАЙТА                             = 0x1407,
    ТРИ_БАЙТА                             = 0x1408,
    ЧЕТЫРЕ_БАЙТА                             = 0x1409,
	//English
	GL_BYTE				= 0x1400,
	GL_UNSIGNED_BYTE			= 0x1401,
	GL_SHORT				= 0x1402,
	GL_UNSIGNED_SHORT			= 0x1403,
	GL_INT				= 0x1404,
	GL_UNSIGNED_INT			= 0x1405,
	GL_FLOAT				= 0x1406,
	GL_DOUBLE				= 0x140A,
	GL_2_BYTES				= 0x1407,
	GL_3_BYTES				= 0x1408,
	GL_4_BYTES         = 0x1409,

    // Простые фигуры
    ТОЧКИ                              = 0x0000,
    ЛИНИИ                               = 0x0001,
    ПЕТЛЯ                           = 0x0002,
    СВЯЗКА_ЛИНИЙ                          = 0x0003,
    ТРЕУГОЛЬНИКИ                           = 0x0004,
    СВЯЗКА_ТРЕУГОЛЬНИКОВ                      = 0x0005,
    ВЕЕР_ТРЕУГОЛЬНИКОВ                        = 0x0006,
    КВАДРАТЫ                               = 0x0007,
    СВЯЗКА_КВАДРАТОВ                          = 0x0008,
    МНОГОУГОЛЬНИК                             = 0x0009,
	//English
	GL_POINTS				= 0x0000,
	GL_LINES				= 0x0001,
	GL_LINE_LOOP			= 0x0002,
	GL_LINE_STRIP			= 0x0003,
	GL_TRIANGLES			= 0x0004,
	GL_TRIANGLE_STRIP			= 0x0005,
	GL_TRIANGLE_FAN			= 0x0006,
	GL_QUADS				= 0x0007,
	GL_QUAD_STRIP			= 0x0008,
	GL_POLYGON				= 0x0009,

    // Массивы вершин
    МАССИВ_ВЕРШИН                        = 0x8074,
    МАССИВ_НОРМАЛЕЙ                        = 0x8075,
    МАССИВ_ЦВЕТОВ                         = 0x8076,
    МАССИВ_ИНДЕКСОВ                         = 0x8077,
    МАССИВ_КООРДИНАТ_ТЕКСТУР                 = 0x8078,
    МАССИВ_ФЛАГОВ_КРАЯ                     = 0x8079,
    РАЗМЕР_МАССИВА_ВЕРШИН                   = 0x807A,
    ТИП_МАССИВА_ВЕРШИН                   = 0x807B,
    ШАГ_МАССИВА_ВЕРШИН                 = 0x807C,
    ТИП_МАССИВА_НОРМАЛЕЙ                   = 0x807E,
    ШАГ_МАССИВА_НОРМАЛЕЙ                 = 0x807F,
    РАЗМЕР_МАССИВА_ЦВЕТА                    = 0x8081,
    ТИП_МАССИВА_ЦВЕТА                    = 0x8082,
    ШАГ_МАССИВА_ЦВЕТОВ                  = 0x8083,
    ТИП_МАССИВА_ИНДЕКСОВ                    = 0x8085,
    ШАГ_МАССИВА_ИНДЕКСОВ                  = 0x8086,
    РАЗМЕР_МАССИВА_КООРД_ТЕКСТУРЫ            = 0x8088,
    ТИП_МАССИВА_КООРД_ТЕКСТУРЫ            = 0x8089,
    ШАГ_МАССИВА_КООРД_ТЕКСТУР          = 0x808A,
    ШАГ_МАССИВА_ФЛАГОВ_КРАЯ              = 0x808C,
    УК_НА_МАССИВ_ВЕРШИН                = 0x808E,
    УК_НА_МАССИВ_НОРМАЛЕЙ                = 0x808F,
   УК_НА_МАССИВ_ЦВЕТА                 = 0x8090,
    УК_НА_МАССИВ_ИНДЕКСОВ                 = 0x8091,
    УК_НА_МАССИВ_КООРД_ТЕКСТУРЫ         = 0x8092,
    УК_НА_МАССИВ_ФЛАГОВ_КРАЯ             = 0x8093,
    V2F                                 = 0x2A20,
    V3F                                 = 0x2A21,
    C4UB_V2F                            = 0x2A22,
    C4UB_V3F                            = 0x2A23,
    C3F_V3F                             = 0x2A24,
    N3F_V3F                             = 0x2A25,
    C4F_N3F_V3F                         = 0x2A26,
    T2F_V3F                             = 0x2A27,
    T4F_V4F                             = 0x2A28,
    T2F_C4UB_V3F                        = 0x2A29,
    T2F_C3F_V3F                         = 0x2A2A,
    T2F_N3F_V3F                         = 0x2A2B,
    T2F_C4F_N3F_V3F                     = 0x2A2C,
    T4F_C4F_N3F_V4F                     = 0x2A2D,
	//English
	GL_VERTEX_ARRAY			= 0x8074,
	GL_NORMAL_ARRAY			= 0x8075,
	GL_COLOR_ARRAY			= 0x8076,
	GL_INDEX_ARRAY			= 0x8077,
	GL_TEXTURE_COORD_ARRAY		= 0x8078,
	GL_EDGE_FLAG_ARRAY			= 0x8079,
	GL_VERTEX_ARRAY_SIZE		= 0x807A,
	GL_VERTEX_ARRAY_TYPE		= 0x807B,
	GL_VERTEX_ARRAY_STRIDE		= 0x807C,
	GL_NORMAL_ARRAY_TYPE		= 0x807E,
	GL_NORMAL_ARRAY_STRIDE		= 0x807F,
	GL_COLOR_ARRAY_SIZE		= 0x8081,
	GL_COLOR_ARRAY_TYPE		= 0x8082,
	GL_COLOR_ARRAY_STRIDE		= 0x8083,
	GL_INDEX_ARRAY_TYPE		= 0x8085,
	GL_INDEX_ARRAY_STRIDE		= 0x8086,
	GL_TEXTURE_COORD_ARRAY_SIZE	= 0x8088,
	GL_TEXTURE_COORD_ARRAY_TYPE	= 0x8089,
	GL_TEXTURE_COORD_ARRAY_STRIDE	= 0x808A,
	GL_EDGE_FLAG_ARRAY_STRIDE		= 0x808C,
	GL_VERTEX_ARRAY_POINTER		= 0x808E,
	GL_NORMAL_ARRAY_POINTER		= 0x808F,
	GL_COLOR_ARRAY_POINTER		= 0x8090,
	GL_INDEX_ARRAY_POINTER		= 0x8091,
	GL_TEXTURE_COORD_ARRAY_POINTER	= 0x8092,
	GL_EDGE_FLAG_ARRAY_POINTER		= 0x8093,
	GL_V2F				= 0x2A20,
	GL_V3F				= 0x2A21,
	GL_C4UB_V2F			= 0x2A22,
	GL_C4UB_V3F			= 0x2A23,
	GL_C3F_V3F				= 0x2A24,
	GL_N3F_V3F				= 0x2A25,
	GL_C4F_N3F_V3F			= 0x2A26,
	GL_T2F_V3F				= 0x2A27,
	GL_T4F_V4F				= 0x2A28,
	GL_T2F_C4UB_V3F			= 0x2A29,
	GL_T2F_C3F_V3F			= 0x2A2A,
	GL_T2F_N3F_V3F			= 0x2A2B,
	GL_T2F_C4F_N3F_V3F			= 0x2A2C,
	GL_T4F_C4F_N3F_V4F			= 0x2A2D,

    // Матричный режим
    РЕЖИМ_МАТРИЦЫ                         = 0x0BA0,
    ОБЗОР_МОДЕЛИ                           = 0x1700,
    ПРОЕКЦИЯ                          = 0x1701,
    ТЕКСТУРА                             = 0x1702,
	//English
	GL_MATRIX_MODE			= 0x0BA0,
	GL_MODELVIEW			= 0x1700,
	GL_PROJECTION			= 0x1701,
	GL_TEXTURE				= 0x1702,

    // Точки
    СМЯГЧЕНИЕ_ТОЧКИ                        = 0x0B10,
    РАЗМЕР_ТОЧКИ                          = 0x0B11,
    ГРАНУЛЯРНОСТЬ_РАЗМЕРА_ТОЧКИ              = 0x0B13,
    ДИАПАЗОН_РАЗМЕРА_ТОЧКИ                    = 0x0B12,
	//English
	GL_POINT_SMOOTH			= 0x0B10,
	GL_POINT_SIZE			= 0x0B11,
	GL_POINT_SIZE_GRANULARITY		= 0x0B13,
	GL_POINT_SIZE_RANGE		= 0x0B12,

    // Линии
    СМЯГЧЕНИЕ_ЛИНИИ                         = 0x0B20,
    УЗОР_ЛИНИЙ                        = 0x0B24,
    ОБРАЗЕЦ_УЗОРА_ЛИНИЙ                = 0x0B25,
    ПОВТОР_УЗОРА_ЛИНИЙ                 = 0x0B26,
    ШИРИНА_ЛИНИИ                          = 0x0B21,
    ГРАНУЛЯРНОСТЬ_ШИРИНЫ_ЛИНИИ              = 0x0B23,
    ДИАПАЗОН_ШИРИНЫ_ЛИНИИ                    = 0x0B22,
	//English
	GL_LINE_SMOOTH			= 0x0B20,
	GL_LINE_STIPPLE			= 0x0B24,
	GL_LINE_STIPPLE_PATTERN		= 0x0B25,
	GL_LINE_STIPPLE_REPEAT		= 0x0B26,
	GL_LINE_WIDTH			= 0x0B21,
	GL_LINE_WIDTH_GRANULARITY		= 0x0B23,
	GL_LINE_WIDTH_RANGE		= 0x0B22,

    // Многоугольники
    ТОЧКА                               = 0x1B00,
    ЛИНИЯ                                = 0x1B01,
    ЗАЛИВКА                                = 0x1B02,
    CW                                  = 0x0900,
    CCW                                 = 0x0901,
    ФРОНТ                               = 0x0404,
    ТЫЛ                                = 0x0405,
    РЕЖИМ_МНОГОУГ                        = 0x0B40,
    СМЯГЧЕНИЕ_МНОГОУГ                      = 0x0B41,
    УЗОР_МНОГОУГ                     = 0x0B42,
    ФЛАГ_КРАЯ                           = 0x0B43,
    ПРОФИЛЬ                           = 0x0B44,
    РЕЖИМ_ПРОФИЛЬ                      = 0x0B45,
    ФАС                          = 0x0B46,
    ФАКТОР_СМЕЩЕНИЯ_МНОГОУГ               = 0x8038,
    ЕДИНИЦЫ_СМЕЩЕНИЯ_МНОГОУГ                = 0x2A00,
    ТОЧКА_СМЕЩЕНИЯ_МНОГОУГ                = 0x2A01,
    ЛИНИЯ_СМЕЩЕНИЯ_МНОГОУГ                 = 0x2A02,
    ЗАЛИВКА_СМЕЩЕНИЯ_МНОГОУГ                 = 0x8037,
	//English
	GL_POINT				= 0x1B00,
	GL_LINE				= 0x1B01,
	GL_FILL				= 0x1B02,
	GL_CW				= 0x0900,
	GL_CCW				= 0x0901,
	GL_FRONT				= 0x0404,
	GL_BACK				= 0x0405,
	GL_POLYGON_MODE			= 0x0B40,
	GL_POLYGON_SMOOTH			= 0x0B41,
	GL_POLYGON_STIPPLE			= 0x0B42,
	GL_EDGE_FLAG			= 0x0B43,
	GL_CULL_FACE			= 0x0B44,
	GL_CULL_FACE_MODE			= 0x0B45,
	GL_FRONT_FACE			= 0x0B46,
	GL_POLYGON_OFFSET_FACTOR		= 0x8038,
	GL_POLYGON_OFFSET_UNITS		= 0x2A00,
	GL_POLYGON_OFFSET_POINT		= 0x2A01,
	GL_POLYGON_OFFSET_LINE		= 0x2A02,
	GL_POLYGON_OFFSET_FILL		= 0x8037,

    // Списки отображения
    КОМПИЛИРУЙ                             = 0x1300,
    КОМПИЛИРУЙ_И_ВЫПОЛНИ                 = 0x1301,
    БАЗА_СПИСКА                           = 0x0B32,
    ИНДЕКС_СПИСКА                         = 0x0B33,
    РЕЖИМ_СПИСКА                           = 0x0B30,
	//English
	GL_COMPILE				= 0x1300,
	GL_COMPILE_AND_EXECUTE		= 0x1301,
	GL_LIST_BASE			= 0x0B32,
	GL_LIST_INDEX			= 0x0B33,
	GL_LIST_MODE			= 0x0B30,

    // Буфер глубины
    НИКОГДА                               = 0x0200,
    МЕНЬШЕ                                = 0x0201,
    РАВНЫЙ                               = 0x0202,
    МИЛИР                              = 0x0203,
    БОЛЬШЕ                             = 0x0204,
    НЕРАВН                            = 0x0205,
    БИЛИР                              = 0x0206,
    ВСЕГДА                              = 0x0207,
    ТЕСТ_ДАЛИ                          = 0x0B71,
    БИТЫ_ДАЛИ                          = 0x0D56,
    ЗНАЧЕНИЕ_ОЧИСТКИ_ДАЛИ                   = 0x0B73,
    ФУНКЦ_ДАЛИ                          = 0x0B74,
    ДИАПАЗОН_ДАЛИ                         = 0x0B70,
    МАСКА_ЗАПИСИ_ДАЛИ                     = 0x0B72,
    КОМПОНЕНТА_ДАЛИ                     = 0x1902,
	//English
	GL_NEVER				= 0x0200,
	GL_LESS				= 0x0201,
	GL_EQUAL				= 0x0202,
	GL_LEQUAL				= 0x0203,
	GL_GREATER				= 0x0204,
	GL_NOTEQUAL			= 0x0205,
	GL_GEQUAL				= 0x0206,
	GL_ALWAYS				= 0x0207,
	GL_DEPTH_TEST			= 0x0B71,
	GL_DEPTH_BITS			= 0x0D56,
	GL_DEPTH_CLEAR_VALUE		= 0x0B73,
	GL_DEPTH_FUNC			= 0x0B74,
	GL_DEPTH_RANGE			= 0x0B70,
	GL_DEPTH_WRITEMASK			= 0x0B72,
	GL_DEPTH_COMPONENT			= 0x1902,

    // Освещение
    ОСВЕЩЕНИЕ                            = 0x0B50,
    СВЕТ0                              = 0x4000,
    СВЕТ1                              = 0x4001,
    СВЕТ2                              = 0x4002,
    СВЕТ3                              = 0x4003,
    СВЕТ4                              = 0x4004,
    СВЕТ5                              = 0x4005,
    СВЕТ6                              = 0x4006,
    СВЕТ7                              = 0x4007,
    ЭКСПОНЕНТА_ПРОЖЕКТОРА                       = 0x1205,
    ОБРЕЗКА_ПРОЖЕКТОРА                         = 0x1206,
    ПОСТОЯННОЕ_ЗАТЕНЕНИЕ                = 0x1207,
    ЛИНЕЙНОЕ_ЗАТЕНЕНИЕ                  = 0x1208,
    КВАДРАТИЧНОЕ_ЗАТЕНЕНИЕ               = 0x1209,
    АМБЬЕНТНЫЙ                             = 0x1200,
    ДИФФУЗНЫЙ                             = 0x1201,
    СПЕКУЛЯРНЫЙ                            = 0x1202,
    БЛЕСК                           = 0x1601,
    ЭМИССИЯ                            = 0x1600,
    ПОЗИЦИЯ                            = 0x1203,
    НАПРАВЛЕНИЕ_ПРОЖЕКТОРА                      = 0x1204,
    АМБЬЕНТНО_ДИФФУЗНЫЙ                 = 0x1602,
    ИНДЕКСЫ_ЦВЕТА                       = 0x1603,
    ДВУСТОРОННЯЯ_СВЕТОМОДЕЛЬ                = 0x0B52,
    ЛОКАЛЬНЫЙ_ОБОЗРЕВАТЕЛЬ_СВЕТОМОДЕЛИ            = 0x0B51,
    АМБЬЕНТНАЯ_СВЕТОМОДЕЛЬ                 = 0x0B53,
    ФРОНТ_И_ТЫЛ                      = 0x0408,
    МОДЕЛЬ_ТЕНИ                         = 0x0B54,
    ПЛОСКИЙ                                = 0x1D00,
    ГЛАДКИЙ                              = 0x1D01,
    ЦВЕТОМАТЕРИАЛ                      = 0x0B57,
    ФАС_ЦВЕТОМАТЕРИАЛА                 = 0x0B55,
    ПАРАМЕТР_ЦВЕТОМАТЕРИАЛА            = 0x0B56,
    НОРМАЛИЗУЙ                           = 0x0BA1,
	//English
	GL_LIGHTING			= 0x0B50,
	GL_LIGHT0				= 0x4000,
	GL_LIGHT1				= 0x4001,
	GL_LIGHT2				= 0x4002,
	GL_LIGHT3				= 0x4003,
	GL_LIGHT4				= 0x4004,
	GL_LIGHT5				= 0x4005,
	GL_LIGHT6				= 0x4006,
	GL_LIGHT7				= 0x4007,
	GL_SPOT_EXPONENT			= 0x1205,
	GL_SPOT_CUTOFF			= 0x1206,
	GL_CONSTANT_ATTENUATION		= 0x1207,
	GL_LINEAR_ATTENUATION		= 0x1208,
	GL_QUADRATIC_ATTENUATION		= 0x1209,
	GL_AMBIENT				= 0x1200,
	GL_DIFFUSE				= 0x1201,
	GL_SPECULAR			= 0x1202,
	GL_SHININESS			= 0x1601,
	GL_EMISSION			= 0x1600,
	GL_POSITION			= 0x1203,
	GL_SPOT_DIRECTION			= 0x1204,
	GL_AMBIENT_AND_DIFFUSE		= 0x1602,
	GL_COLOR_INDEXES			= 0x1603,
	GL_LIGHT_MODEL_TWO_SIDE		= 0x0B52,
	GL_LIGHT_MODEL_LOCAL_VIEWER	= 0x0B51,
	GL_LIGHT_MODEL_AMBIENT		= 0x0B53,
	GL_FRONT_AND_BACK			= 0x0408,
	GL_SHADE_MODEL			= 0x0B54,
	GL_FLAT				= 0x1D00,
	GL_SMOOTH				= 0x1D01,
	GL_COLOR_MATERIAL			= 0x0B57,
	GL_COLOR_MATERIAL_FACE		= 0x0B55,
	GL_COLOR_MATERIAL_PARAMETER	= 0x0B56,
	GL_NORMALIZE			= 0x0BA1,

    // Плоскости обрезки пользователя
    ПЛОСКОСТЬ_ОБРЕЗКИ0                         = 0x3000,
    ПЛОСКОСТЬ_ОБРЕЗКИ1                         = 0x3001,
    ПЛОСКОСТЬ_ОБРЕЗКИ2                         = 0x3002,
    ПЛОСКОСТЬ_ОБРЕЗКИ3                         = 0x3003,
    ПЛОСКОСТЬ_ОБРЕЗКИ4                         = 0x3004,
    ПЛОСКОСТЬ_ОБРЕЗКИ5                         = 0x3005,
	//English
	GL_CLIP_PLANE0			= 0x3000,
	GL_CLIP_PLANE1			= 0x3001,
	GL_CLIP_PLANE2			= 0x3002,
	GL_CLIP_PLANE3			= 0x3003,
	GL_CLIP_PLANE4			= 0x3004,
	GL_CLIP_PLANE5			= 0x3005,

    // Буфер накопления
    АККУМ_КРАСНЫЕ_БИТЫ                      = 0x0D58,
    АККУМ_ЗЕЛЁНЫЕ_БИТЫ                    = 0x0D59,
    АККУМ_СИНИЕ_БИТЫ                     = 0x0D5A,
    АККУМ_АЛЬФА_БИТЫ                    = 0x0D5B,
    АККУМ_ЗНАЧЕНИЕ_ОЧИСТКИ                   = 0x0B80,
    АККУМ                               = 0x0100,
    ДОБАВЬ                                 = 0x0104,
    ЗАГРУЗИ                                = 0x0101,
    МУЛЬТ                                = 0x0103,
    ВЕРНИ                              = 0x0102,
	//English
	GL_ACCUM_RED_BITS			= 0x0D58,
	GL_ACCUM_GREEN_BITS		= 0x0D59,
	GL_ACCUM_BLUE_BITS			= 0x0D5A,
	GL_ACCUM_ALPHA_BITS		= 0x0D5B,
	GL_ACCUM_CLEAR_VALUE		= 0x0B80,
	GL_ACCUM				= 0x0100,
	GL_ADD				= 0x0104,
	GL_LOAD				= 0x0101,
	GL_MULT				= 0x0103,
	GL_RETURN				= 0x0102,

    // Тестирование прозрачности
    АЛЬФАТЕСТ                          = 0x0BC0,
    АЛЬФАТЕСТРЕФ                      = 0x0BC2,
    АЛЬФАТЕСТФУНКЦ                     = 0x0BC1,
	//English
	GL_ALPHA_TEST			= 0x0BC0,
	GL_ALPHA_TEST_REF			= 0x0BC2,
	GL_ALPHA_TEST_FUNC			= 0x0BC1,

    // Смешивание
    СМЕСЬ                               = 0x0BE2,
    ИСТОЧНИК_СМЕШИВАНИЯ                           = 0x0BE1,
    ПРИЁМНИК_СМЕШИВАНИЯ                           = 0x0BE0,
    НОЛЬ                                = 0x0,
    ОДИН                                 = 0x1,
    ЦВЕТ_ИСТОЧНИКА                           = 0x0300,
    ОДИН_МИНУС_ЦВЕТ_ИСТОЧНИКА                 = 0x0301,
    АЛЬФА_ИСТОЧНИКА                           = 0x0302,
    ОДИН_МИНУС_АЛЬФА_ИСТОЧНИКА                 = 0x0303,
    АЛЬФА_ПРЁМНИКА                           = 0x0304,
    ОДИН_МИНУС_АЛЬФА_ПРИЁМНИКА                 = 0x0305,
    ЦВЕТ_ПРИЁМНИКА                           = 0x0306,
    ОДИН_МИНУС_ЦВЕТ_ПРИЁМНИКА                 = 0x0307,
    НАСЫТЬ_АЛЬФУ_ИСТОЧНИКА                  = 0x0308,
	//English
	GL_BLEND				= 0x0BE2,
	GL_BLEND_SRC			= 0x0BE1,
	GL_BLEND_DST			= 0x0BE0,
	GL_ZERO				= 0x0,
	GL_ONE				= 0x1,
	GL_SRC_COLOR			= 0x0300,
	GL_ONE_MINUS_SRC_COLOR		= 0x0301,
	GL_SRC_ALPHA			= 0x0302,
	GL_ONE_MINUS_SRC_ALPHA		= 0x0303,
	GL_DST_ALPHA			= 0x0304,
	GL_ONE_MINUS_DST_ALPHA		= 0x0305,
	GL_DST_COLOR			= 0x0306,
	GL_ONE_MINUS_DST_COLOR		= 0x0307,
	GL_SRC_ALPHA_SATURATE		= 0x0308,
    
    // Режим показа
    ФИДБЭК                            = 0x1C01,
    ОТОБРАЗИ                              = 0x1C00,
    ВЫДЕЛИ                              = 0x1C02,
	//English
	GL_FEEDBACK			= 0x1C01,
	GL_RENDER				= 0x1C00,
	GL_SELECT				= 0x1C02,

    // Фидбэк
    М2                                  = 0x0600,
    М3                                  = 0x0601,
    М3_ЦВЕТ                            = 0x0602,
    М3_ТЕКСТУРА_ЦВЕТА                    = 0x0603,
    М4_ТЕКСТУРА_ЦВЕТА                    = 0x0604,
    ЗНАК_ТОЧКИ                         = 0x0701,
    ЗНАК_ЛИНИИ                          = 0x0702,
    ЗНАК_ВОССТАНОВЛЕНИЯ_ЛИНИИ                    = 0x0707,
    ЗНАК_МНОГОУГ                       = 0x0703,
    ЗНАК_БИТМАПА                        = 0x0704,
    ЗНАК_РИСОВАНИЯ_ПИКСЕЛЯ                    = 0x0705,
    ЗНАК_КОПИРОВАНИЯ_ПИКСЕЛЯ                    = 0x0706,
    ЗНАК_ПРОПУСКА                  = 0x0700,
    УК_НА_БУФЕР_ФИДБЭКА             = 0x0DF0,
    РАЗМЕР_БУФЕРА_ФИДБЭКА                = 0x0DF1,
    ТИП_БУФЕРА_ФИДБЭКА                = 0x0DF2,
	//English
	GL_2D				= 0x0600,
	GL_3D				= 0x0601,
	GL_3D_COLOR			= 0x0602,
	GL_3D_COLOR_TEXTURE		= 0x0603,
	GL_4D_COLOR_TEXTURE		= 0x0604,
	GL_POINT_TOKEN			= 0x0701,
	GL_LINE_TOKEN			= 0x0702,
	GL_LINE_RESET_TOKEN		= 0x0707,
	GL_POLYGON_TOKEN			= 0x0703,
	GL_BITMAP_TOKEN			= 0x0704,
	GL_DRAW_PIXEL_TOKEN		= 0x0705,
	GL_COPY_PIXEL_TOKEN		= 0x0706,
	GL_PASS_THROUGH_TOKEN		= 0x0700,
	GL_FEEDBACK_BUFFER_POINTER		= 0x0DF0,
	GL_FEEDBACK_BUFFER_SIZE		= 0x0DF1,
	GL_FEEDBACK_BUFFER_TYPE		= 0x0DF2,

    // Выделение
    УК_НА_БУФЕР_ВЫБОРА            = 0x0DF3,
    РАЗМЕР_БУФЕРА_ВЫБОРА               = 0x0DF4,
	//English
	GL_SELECTION_BUFFER_POINTER	= 0x0DF3,
	GL_SELECTION_BUFFER_SIZE		= 0x0DF4,

    // Туман
    ТУМАН                                 = 0x0B60,
    РЕЖИМ_ТУМАНА                            = 0x0B65,
    ПЛОТНОСТЬ_ТУМАНА                         = 0x0B62,
    ЦВЕТ_ТУМАНА                           = 0x0B66,
    ИНДЕКС_ТУМАНА                           = 0x0B61,
    СТАРТ_ТУМАНА                           = 0x0B63,
    КОНЕЦ_ТУМАНА                             = 0x0B64,
    ЛИНЕЙНЫЙ                              = 0x2601,
    ЭКСП                                 = 0x0800,
    ЭКСП2                                = 0x0801,
	//English
	GL_FOG				= 0x0B60,
	GL_FOG_MODE			= 0x0B65,
	GL_FOG_DENSITY			= 0x0B62,
	GL_FOG_COLOR			= 0x0B66,
	GL_FOG_INDEX			= 0x0B61,
	GL_FOG_START			= 0x0B63,
	GL_FOG_END				= 0x0B64,
	GL_LINEAR				= 0x2601,
	GL_EXP				= 0x0800,
	GL_EXP2				= 0x0801,

    // Логические операции
    ЛОГОП                            = 0x0BF1,
    ИНДЕКСНАЯ_ЛОГОП                      = 0x0BF1,
    ЦВЕТОВАЯ_ЛОГОП                      = 0x0BF2,
    РЕЖИМ_ЛОГОП                       = 0x0BF0,
    ОЧИСТИ                               = 0x1500,
    УСТАНОВИ                                 = 0x150F,
    КОПИРУЙ                                = 0x1503,
    КОПИРУЙ_ИНВ                       = 0x150C,
    НЕТОП                                = 0x1505,
    ИНВЕРТИРУЙ                              = 0x150A,
    И                                 = 0x1501,
    НИ                                = 0x150E,
    ИЛИ                                  = 0x1507,
    НИЛИ                                 = 0x1508,
    ИИЛИ                                 = 0x1506,
    ЭКВИВ                               = 0x1509,
    И_РЕВ                         = 0x1502,
    И_ИНВ                        = 0x1504,
    ИЛИ_РЕВ                         = 0x150B,
    ИЛИ_ИНВ                         = 0x150D,
	//English
	GL_LOGIC_OP			= 0x0BF1,
	GL_INDEX_LOGIC_OP			= 0x0BF1,
	GL_COLOR_LOGIC_OP			= 0x0BF2,
	GL_LOGIC_OP_MODE			= 0x0BF0,
	GL_CLEAR				= 0x1500,
	GL_SET				= 0x150F,
	GL_COPY				= 0x1503,
	GL_COPY_INVERTED			= 0x150C,
	GL_NOOP				= 0x1505,
	GL_INVERT				= 0x150A,
	GL_AND				= 0x1501,
	GL_NAND				= 0x150E,
	GL_OR				= 0x1507,
	GL_NOR				= 0x1508,
	GL_XOR				= 0x1506,
	GL_EQUIV				= 0x1509,
	GL_AND_REVERSE			= 0x1502,
	GL_AND_INVERTED			= 0x1504,
	GL_OR_REVERSE			= 0x150B,
	GL_OR_INVERTED			= 0x150D,

    // Шаблон
    ТЕСТ_ШАБЛОНА                        = 0x0B90,
    МАСКА_ЗАПИСИ_ШАБЛОНА                   = 0x0B98,
    БИТЫ_ШАБЛОНА                        = 0x0D57,
    ФУНКЦ_ШАБЛОНА                        = 0x0B92,
    МАСКА_ЗНАЧЕНИЯ_ШАБЛОНА                  = 0x0B93,
    РЕФ_НА_ШАБЛОН                         = 0x0B97,
    СБОЙ_ШАБЛОНА                        = 0x0B94,
    ПРОХОД_ШАБЛОНА_ПРОХОД_ДАЛИ             = 0x0B96,
    ПРОХОД_ШАБЛОНА_СБОЙ_ДАЛИ             = 0x0B95,
    ЗНАЧЕНИЕ_ОЧИСТКИ_ШАБЛОНА                 = 0x0B91,
    ИНДЕКС_ШАБЛОНА                       = 0x1901,
    СОХРАНИ                                = 0x1E00,
    ЗАМЕНИ                             = 0x1E01,
    УВЕЛИЧЬ                                = 0x1E02,
    УМЕНЬШИ                                = 0x1E03,
	//English
	GL_STENCIL_TEST			= 0x0B90,
	GL_STENCIL_WRITEMASK		= 0x0B98,
	GL_STENCIL_BITS			= 0x0D57,
	GL_STENCIL_FUNC			= 0x0B92,
	GL_STENCIL_VALUE_MASK		= 0x0B93,
	GL_STENCIL_REF			= 0x0B97,
	GL_STENCIL_FAIL			= 0x0B94,
	GL_STENCIL_PASS_DEPTH_PASS		= 0x0B96,
	GL_STENCIL_PASS_DEPTH_FAIL		= 0x0B95,
	GL_STENCIL_CLEAR_VALUE		= 0x0B91,
	GL_STENCIL_INDEX			= 0x1901,
	GL_KEEP				= 0x1E00,
	GL_REPLACE				= 0x1E01,
	GL_INCR				= 0x1E02,
	GL_DECR				= 0x1E03,

    // Буферы, рисование/чтение пикселей
    ПУСТО                                = 0x0,
    ЛЕВЫЙ                                = 0x0406,
    ПРАВЫЙ                               = 0x0407,
    ПЕРЕДНИЙ_ЛЕВЫЙ                          = 0x0400,
    ПЕРЕДНИЙ_ПРАВЫЙ                         = 0x0401,
    ЗАДНИЙ_ЛЕВЫЙ                           = 0x0402,
    ЗАДНИЙ_ПРАВЫЙ                          = 0x0403,
    ДОП0                                = 0x0409,
    ДОП1                                = 0x040A,
    ДОП2                                = 0x040B,
    ДОП3                                = 0x040C,
    ЦВЕТОИНДЕКС                         = 0x1900,
    КРАСНЫЙ                                 = 0x1903,
    ЗЕЛЁНЫЙ                               = 0x1904,
    СИНИЙ                                = 0x1905,
    АЛЬФА                               = 0x1906,
    СВЕЧЕНИЕ                           = 0x1909,
    АЛЬФА_СВЕЧЕНИЯ                     = 0x190A,
    АЛЬФАБИТЫ                          = 0x0D55,
    КРАСНЫЕ_БИТЫ                            = 0x0D52,
    ЗЕЛЁНЫЕ_БИТЫ                          = 0x0D53,
    СИНИЕ_БИТЫ                           = 0x0D54,
    ИНДЕКСБИТЫ                          = 0x0D51,
    БИТЫ_СУБПИКСЕЛЕЙ                       = 0x0D50,
    ДОП_БУФЕРЫ                         = 0x0C00,
    БУФЕР_ЧТЕНИЯ                         = 0x0C02,
    БУФЕР_РИСОВАНИЯ                         = 0x0C01,
    ДВОЙНОЙ_БУФЕР                        = 0x0C32,
    СТЕРЕО                              = 0x0C33,
    БИТМАП                              = 0x1A00,
    ЦВЕТ                               = 0x1800,
    ДАЛЬ                               = 0x1801,
    ШАБЛОН                             = 0x1802,
    ПСЕВДО_СЛУЧАЙНЫЙ                              = 0x0BD0,
    КЗС                                 = 0x1907,
    КЗСА                                = 0x1908,
	//English
	GL_NONE				= 0x0,
	GL_LEFT				= 0x0406, 
	GL_RIGHT				= 0x0407,
	GL_FRONT_LEFT			= 0x0400,
	GL_FRONT_RIGHT			= 0x0401,
	GL_BACK_LEFT			= 0x0402,
	GL_BACK_RIGHT			= 0x0403,
	GL_AUX0				= 0x0409,
	GL_AUX1				= 0x040A,
	GL_AUX2				= 0x040B,
	GL_AUX3				= 0x040C,
	GL_COLOR_INDEX			= 0x1900,
	GL_RED				= 0x1903,
	GL_GREEN				= 0x1904,
	GL_BLUE				= 0x1905,
	GL_ALPHA				= 0x1906,
	GL_LUMINANCE			= 0x1909,
	GL_LUMINANCE_ALPHA			= 0x190A,
	GL_ALPHA_BITS			= 0x0D55,
	GL_RED_BITS			= 0x0D52,
	GL_GREEN_BITS			= 0x0D53,
	GL_BLUE_BITS			= 0x0D54,
	GL_INDEX_BITS			= 0x0D51,
	GL_SUBPIXEL_BITS			= 0x0D50,
	GL_AUX_BUFFERS			= 0x0C00,
	GL_READ_BUFFER			= 0x0C02,
	GL_DRAW_BUFFER			= 0x0C01,
	GL_DOUBLEBUFFER			= 0x0C32,
	GL_STEREO				= 0x0C33,
	GL_BITMAP				= 0x1A00,
	GL_COLOR				= 0x1800,
	GL_DEPTH				= 0x1801,
	GL_STENCIL				= 0x1802,
	GL_DITHER				= 0x0BD0,
	GL_RGB				= 0x1907,
	GL_RGBA				= 0x1908,

    // Реализационные границы
    МАКС_ВНЕДРЕНИЕ_СПИСКА                    = 0x0B31,
    МАКС_ГЛУБИНА_СТЕКА_АТРИБУТОВ              = 0x0D35,
    МАКС_ГЛУБИНА_СТЕКА_ОБЗОРА_МОДЕЛИ           = 0x0D36,
    МАКС_ГЛУБИНА_СТЕКА_ИМЁН                = 0x0D37,
    МАКС_ГЛУБИНА_СТЕКА_ПРОЕКЦИЙ          = 0x0D38,
    МАКС_ГЛУБИНА_СТЕКА_ТЕКСТУР             = 0x0D39,
    МАКС_ПОРЯДОК_ОЦЕНКИ                      = 0x0D30,
    МАКС_ОГНЕЙ                          = 0x0D31,
    МАКС_ПЛОСКОСТЕЙ_ОБРЕЗКИ                     = 0x0D32,
    МАКС_РАЗМЕР_ТЕКСТУРЫ                    = 0x0D33,
    МАКС_ТАБЛИЦА_КАРТЫ_ПИКСЕЛЕЙ                 = 0x0D34,
    МАКС_РАЗМЕРЫ_ВЬЮПОРТА                   = 0x0D3A,
    МАКС_ГЛУБИНА_СТЕКА_АТРИБУТОВ_КЛИЕНТА       = 0x0D3B,
	//English
	GL_MAX_LIST_NESTING		= 0x0B31,
	GL_MAX_ATTRIB_STACK_DEPTH		= 0x0D35,
	GL_MAX_MODELVIEW_STACK_DEPTH	= 0x0D36,
	GL_MAX_NAME_STACK_DEPTH		= 0x0D37,
	GL_MAX_PROJECTION_STACK_DEPTH	= 0x0D38,
	GL_MAX_TEXTURE_STACK_DEPTH		= 0x0D39,
	GL_MAX_EVAL_ORDER			= 0x0D30,
	GL_MAX_LIGHTS			= 0x0D31,
	GL_MAX_CLIP_PLANES			= 0x0D32,
	GL_MAX_TEXTURE_SIZE		= 0x0D33,
	GL_MAX_PIXEL_MAP_TABLE		= 0x0D34,
	GL_MAX_VIEWPORT_DIMS		= 0x0D3A,
	GL_MAX_CLIENT_ATTRIB_STACK_DEPTH	= 0x0D3B,

    // Получатели
    ГЛУБИНА_СТЕКА_АТРИБУТОВ                  = 0x0BB0,
    ГЛУБИНА_СТЕКА_АТРИБ_КЛИЕНТА           = 0x0BB1,
    ЗНАЧЕНИЕ_ОЧИСТКИ_ЦВЕТА                   = 0x0C22,
    МАСКА_ЗАПИСИ_ЦВЕТА                     = 0x0C23,
    ТЕКУЩИЙ_ИНДЕКС                       = 0x0B01,
    ТЕКУЩИЙ_ЦВЕТ                       = 0x0B00,
    ТЕКУЩАЯ_НОРМАЛЬ                      = 0x0B02,
    ТЕКУЩИЙ_ЦВЕТ_РАСТРА                = 0x0B04,
    ТЕКУЩЕЕ_УДАЛЕНИЕ_РАСТРА             = 0x0B09,
    ТЕКУЩИЙ_ИНДЕКС_РАСТРА                = 0x0B05,
    ТЕКУЩАЯ_ПОЗИЦИЯ_РАСТРА             = 0x0B07,
    ТЕКУЩИЕ_КООРД_ТЕКСТУРЫ_РАСТРА       = 0x0B06,
    ТЕКУЩЕЕ_ПОЛОЖЕНИЕ_РАСТРА_НОРМ       = 0x0B08,
    ТЕКУЩИЕ_КООРИНАТЫ_ТЕКСТУРЫ              = 0x0B03,
    ЗНАЧЕНИЕ_ОЧИСТКИ_ИНДЕКСА                   = 0x0C20,
    РЕЖИМ_ИНДЕКСА                          = 0x0C30,
    МАСКА_ЗАПИСИ_ИНДЕКСА                     = 0x0C21,
    МАТРИЦА_ОБЗОРА_МОДЕЛИ                    = 0x0BA6,
    ГЛУБИНА_СТЕКА_ОБЗОРА_МОДЕЛИ               = 0x0BA3,
    ГЛУБИНА_СТЕКА_ИМЁН                    = 0x0D70,
    МАТРИЦА_ПРОЕКЦИИ                   = 0x0BA7,
    ГЛУБИНА_СТЕКА_ПРОЕКЦИИ              = 0x0BA4,
    РЕЖИМ_ОТОБРАЖЕНИЯ                         = 0x0C40,
    РЕЖИМ_КЗСА                           = 0x0C31,
    МАТРИЦА_ТЕКСТУРЫ                      = 0x0BA8,
    ГЛУБИНА_СТЕКА_ТЕКСТУР                 = 0x0BA5,
    ВЬЮПОРТ                            = 0x0BA2,
	//English
	GL_ATTRIB_STACK_DEPTH		= 0x0BB0,
	GL_CLIENT_ATTRIB_STACK_DEPTH	= 0x0BB1,
	GL_COLOR_CLEAR_VALUE		= 0x0C22,
	GL_COLOR_WRITEMASK			= 0x0C23,
	GL_CURRENT_INDEX			= 0x0B01,
	GL_CURRENT_COLOR			= 0x0B00,
	GL_CURRENT_NORMAL			= 0x0B02,
	GL_CURRENT_RASTER_COLOR		= 0x0B04,
	GL_CURRENT_RASTER_DISTANCE		= 0x0B09,
	GL_CURRENT_RASTER_INDEX		= 0x0B05,
	GL_CURRENT_RASTER_POSITION		= 0x0B07,
	GL_CURRENT_RASTER_TEXTURE_COORDS	= 0x0B06,
	GL_CURRENT_RASTER_POSITION_VALID	= 0x0B08,
	GL_CURRENT_TEXTURE_COORDS		= 0x0B03,
	GL_INDEX_CLEAR_VALUE		= 0x0C20,
	GL_INDEX_MODE			= 0x0C30,
	GL_INDEX_WRITEMASK			= 0x0C21,
	GL_MODELVIEW_MATRIX		= 0x0BA6,
	GL_MODELVIEW_STACK_DEPTH		= 0x0BA3,
	GL_NAME_STACK_DEPTH		= 0x0D70,
	GL_PROJECTION_MATRIX		= 0x0BA7,
	GL_PROJECTION_STACK_DEPTH		= 0x0BA4,
	GL_RENDER_MODE			= 0x0C40,
	GL_RGBA_MODE			= 0x0C31,
	GL_TEXTURE_MATRIX			= 0x0BA8,
	GL_TEXTURE_STACK_DEPTH		= 0x0BA5,
	GL_VIEWPORT			= 0x0BA2,

    // Оцениватели
    АВТО_НОРМАЛЬ                         = 0x0D80,
    КАРТА1_ЦВЕТ_4                        = 0x0D90,
    КАРТА1_ДОМЕН_СЕТКИ                    = 0x0DD0,
    КАРТА1_ОТРЕЗКИ_СЕТКИ                  = 0x0DD1,
    КАРТА1_ИНДЕКС                          = 0x0D91,
    КАРТА1_НОРМАЛЬ                         = 0x0D92,
    КАРТА1_КООРД_ТЕКСТУРЫ_1                = 0x0D93,
    КАРТА1_КООРД_ТЕКСТУРЫ_2                = 0x0D94,
    КАРТА1_КООРД_ТЕКСТУРЫ_3                = 0x0D95,
    КАРТА1_КООРД_ТЕКСТУРЫ_4                = 0x0D96,
    КАРТА1_ВЕРШИНА_3                       = 0x0D97,
    КАРТА1_ВЕРШИНА_4                       = 0x0D98,
    КАРТА2_ЦВЕТ_4                        = 0x0DB0,
    КАРТА2_ДОМЕН_СЕТКИ                    = 0x0DD2,
    КАРТА2_ОТРЕЗКИ_СЕТКИ                  = 0x0DD3,
    КАРТА2_ИНДЕКС                          = 0x0DB1,
    КАРТА2_НОРМАЛЬ                         = 0x0DB2,
    КАРТА2_КООРД_ТЕКСТУРЫ_1                = 0x0DB3,
    КАРТА2_КООРД_ТЕКСТУРЫ_2                = 0x0DB4,
    КАРТА2_КООРД_ТЕКСТУРЫ_3                = 0x0DB5,
    КАРТА2_КООРД_ТЕКСТУРЫ_4                = 0x0DB6,
    КАРТА2_ВЕРШИНА_3                       = 0x0DB7,
    КАРТА2_ВЕРШИНА_4                       = 0x0DB8,
    КОЭФФ                               = 0x0A00,
    ДОМЕН                              = 0x0A02,
    ПОРЯДОК                               = 0x0A01,
	//English
	GL_AUTO_NORMAL			= 0x0D80,
	GL_MAP1_COLOR_4			= 0x0D90,
	GL_MAP1_GRID_DOMAIN		= 0x0DD0,
	GL_MAP1_GRID_SEGMENTS		= 0x0DD1,
	GL_MAP1_INDEX			= 0x0D91,
	GL_MAP1_NORMAL			= 0x0D92,
	GL_MAP1_TEXTURE_COORD_1		= 0x0D93,
	GL_MAP1_TEXTURE_COORD_2		= 0x0D94,
	GL_MAP1_TEXTURE_COORD_3		= 0x0D95,
	GL_MAP1_TEXTURE_COORD_4		= 0x0D96,
	GL_MAP1_VERTEX_3			= 0x0D97,
	GL_MAP1_VERTEX_4			= 0x0D98,
	GL_MAP2_COLOR_4			= 0x0DB0,
	GL_MAP2_GRID_DOMAIN		= 0x0DD2,
	GL_MAP2_GRID_SEGMENTS		= 0x0DD3,
	GL_MAP2_INDEX			= 0x0DB1,
	GL_MAP2_NORMAL			= 0x0DB2,
	GL_MAP2_TEXTURE_COORD_1		= 0x0DB3,
	GL_MAP2_TEXTURE_COORD_2		= 0x0DB4,
	GL_MAP2_TEXTURE_COORD_3		= 0x0DB5,
	GL_MAP2_TEXTURE_COORD_4		= 0x0DB6,
	GL_MAP2_VERTEX_3			= 0x0DB7,
	GL_MAP2_VERTEX_4			= 0x0DB8,
	GL_COEFF				= 0x0A00,
	GL_DOMAIN				= 0x0A02,
	GL_ORDER				= 0x0A01,

    // Подсказки
    ТУМАН_ПОДСКАЗКА                            = 0x0C54,
    СМЯГЧЕНИЕ_ЛИНИИ_ПОДСКАЗКА                    = 0x0C52,
    КОРРЕКЦИЯ_ПЕРСПЕКТИВЫ_ПОДСКАЗКА         = 0x0C50,
    СМЯГЧЕНИЕ_ТОЧКИ_ПОДСКАЗКА                   = 0x0C51,
    СМЯГЧЕНИЕ_МНОГОУГ_ПОДСКАЗКА                 = 0x0C53,
    НЕ_ВАЖНО                           = 0x1100,
    НАИБЫСТРО                             = 0x1101,
    НАИЛУЧШЕ                              = 0x1102,
	//English
	GL_FOG_HINT			= 0x0C54,
	GL_LINE_SMOOTH_HINT		= 0x0C52,
	GL_PERSPECTIVE_CORRECTION_HINT	= 0x0C50,
	GL_POINT_SMOOTH_HINT		= 0x0C51,
	GL_POLYGON_SMOOTH_HINT		= 0x0C53,
	GL_DONT_CARE			= 0x1100,
	GL_FASTEST				= 0x1101,
	GL_NICEST				= 0x1102,

    // Захват ножницами
    ТЕСТ_НОЖНИЦ                        = 0x0C11,
    ЗАХВАТ_НОЖНИЦ                         = 0x0C10,
	//English
	GL_SCISSOR_TEST			= 0x0C11,
	GL_SCISSOR_BOX			= 0x0C10,

    // Пиксельный режим/перенос
    ЦВЕТ_КАРТЫ                           = 0x0D10,
    ШАБЛОН_КАРТЫ                         = 0x0D11,
    СДВИГ_ИНДЕКСА                         = 0x0D12,
    СМЕЩЕНИЕ_ИНДЕКСА                        = 0x0D13,
    ШКАЛА_КРАСНОГО                           = 0x0D14,
    УКЛОН_КРАСНОГО                            = 0x0D15,
    ШКАЛА_ЗЕЛЁНОГО                         = 0x0D18,
    УКЛОН_ЗЕЛЁНОГО                          = 0x0D19,
    ШКАЛА_СИНЕГО                          = 0x0D1A,
    УКЛОН_СИНЕГО                           = 0x0D1B,
    ШКАЛА_АЛЬФЫ                         = 0x0D1C,
    УКЛОН_АЛЬФЫ                          = 0x0D1D,
    ШКАЛА_ДАЛИ                         = 0x0D1E,
    УКЛОН_ДАЛИ                          = 0x0D1F,
    РАЗМЕР_КАРТЫ_ПИКСЕЛЯ_Т_В_Т               = 0x0CB1,
    РАЗМЕР_КАРТЫ_ПИКСЕЛЯ_Ц_В_Ц               = 0x0CB0,
    РАЗМЕР_КАРТЫ_ПИКСЕЛЯ_Ц_В_К               = 0x0CB2,
    РАЗМЕР_КАРТЫ_ПИКСЕЛЯ_Ц_В_G               = 0x0CB3,
    РАЗМЕР_КАРТЫ_ПИКСЕЛЯ_Ц_В_С              = 0x0CB4,
    РАЗМЕР_КАРТЫ_ПИКСЕЛЯ_Ц_В_А              = 0x0CB5,
    РАЗМЕР_КАРТЫ_ПИКСЕЛЯ_К_В_К               = 0x0CB6,
    РАЗМЕР_КАРТЫ_ПИКСЕЛЯ_З_В_З               = 0x0CB7,
    РАЗМЕР_КАРТЫ_ПИКСЕЛЯ_С_В_С               = 0x0CB8,
    РАЗМЕР_КАРТЫ_ПИКСЕЛЯ_А_В_А               = 0x0CB9,
    КАРТА_ПИКСЕЛЯ_Т_В_Т                    = 0x0C71,
    КАРТА_ПИКСЕЛЯ_Ц_В_Ц                    = 0x0C70,
    КАРТА_ПИКСЕЛЯ_Ц_В_К                    = 0x0C72,
    КАРТА_ПИКСЕЛЯ_Ц_В_З                    = 0x0C73,
    КАРТА_ПИКСЕЛЯ_Ц_В_С                    = 0x0C74,
    КАРТА_ПИКСЕЛЯ_Ц_В_А                    = 0x0C75,
    КАРТА_ПИКСЕЛЯ_К_В_К                    = 0x0C76,
    КАРТА_ПИКСЕЛЯ_З_В_З                    = 0x0C77,
    КАРТА_ПИКСЕЛЯ_С_В_С                    = 0x0C78,
    КАРТА_ПИКСЕЛЯ_А_В_А                    = 0x0C79,
    ПАК_РАСКЛАДКА                      = 0x0D05,
    ПАК_ВНАЧАЛЕ_МЛБ                      = 0x0D01,
    ПАК_ДЛИНА_РЯДА                     = 0x0D02,
    ПАК_ПРОПУСТИТЬ_ПИКСЕЛИ                    = 0x0D04,
    ПАК_ПРОПУСТИТЬ_РЯДЫ                     = 0x0D03,
    ПАК_ОБМЕНЯТЬ_БУФЕРЫ                     = 0x0D00,
    РАСПАК_РАСКЛАДКА                    = 0x0CF5,
    РАСПАК_ВНАЧАЛЕ_МЛБ                    = 0x0CF1,
    РАСПАК_ДЛИНА_РЯДА                   = 0x0CF2,
    РАСПАК_ПРОПУСТИТЬ_ПИКСЕЛИ                  = 0x0CF4,
    РАСПАК_ПРОПУСТИТЬ_РЯДЫ                    = 0x0CF3,
    РАСПАК_ОБМЕНЯТЬ_БУФЕРЫ                   = 0x0CF0,
    ЗУМ_КШ                              = 0x0D16,
    ЗУМ_КВ                              = 0x0D17,
	//English
    GL_MAP_COLOR			= 0x0D10,
	GL_MAP_STENCIL			= 0x0D11,
	GL_INDEX_SHIFT			= 0x0D12,
	GL_INDEX_OFFSET			= 0x0D13,
	GL_RED_SCALE			= 0x0D14,
	GL_RED_BIAS			= 0x0D15,
	GL_GREEN_SCALE			= 0x0D18,
	GL_GREEN_BIAS			= 0x0D19,
	GL_BLUE_SCALE			= 0x0D1A,
	GL_BLUE_BIAS			= 0x0D1B,
	GL_ALPHA_SCALE			= 0x0D1C,
	GL_ALPHA_BIAS			= 0x0D1D,
	GL_DEPTH_SCALE			= 0x0D1E,
	GL_DEPTH_BIAS			= 0x0D1F,
	GL_PIXEL_MAP_S_TO_S_SIZE		= 0x0CB1,
	GL_PIXEL_MAP_I_TO_I_SIZE		= 0x0CB0,
	GL_PIXEL_MAP_I_TO_R_SIZE		= 0x0CB2,
	GL_PIXEL_MAP_I_TO_G_SIZE		= 0x0CB3,
	GL_PIXEL_MAP_I_TO_B_SIZE		= 0x0CB4,
	GL_PIXEL_MAP_I_TO_A_SIZE		= 0x0CB5,
	GL_PIXEL_MAP_R_TO_R_SIZE		= 0x0CB6,
	GL_PIXEL_MAP_G_TO_G_SIZE		= 0x0CB7,
	GL_PIXEL_MAP_B_TO_B_SIZE		= 0x0CB8,
	GL_PIXEL_MAP_A_TO_A_SIZE		= 0x0CB9,
	GL_PIXEL_MAP_S_TO_S		= 0x0C71,
	GL_PIXEL_MAP_I_TO_I		= 0x0C70,
	GL_PIXEL_MAP_I_TO_R		= 0x0C72,
	GL_PIXEL_MAP_I_TO_G		= 0x0C73,
	GL_PIXEL_MAP_I_TO_B		= 0x0C74,
	GL_PIXEL_MAP_I_TO_A		= 0x0C75,
	GL_PIXEL_MAP_R_TO_R		= 0x0C76,
	GL_PIXEL_MAP_G_TO_G		= 0x0C77,
	GL_PIXEL_MAP_B_TO_B		= 0x0C78,
	GL_PIXEL_MAP_A_TO_A		= 0x0C79,
	GL_PACK_ALIGNMENT			= 0x0D05,
	GL_PACK_LSB_FIRST			= 0x0D01,
	GL_PACK_ROW_LENGTH			= 0x0D02,
	GL_PACK_SKIP_PIXELS		= 0x0D04,
	GL_PACK_SKIP_ROWS			= 0x0D03,
	GL_PACK_SWAP_BYTES			= 0x0D00,
	GL_UNPACK_ALIGNMENT		= 0x0CF5,
	GL_UNPACK_LSB_FIRST		= 0x0CF1,
	GL_UNPACK_ROW_LENGTH		= 0x0CF2,
	GL_UNPACK_SKIP_PIXELS		= 0x0CF4,
	GL_UNPACK_SKIP_ROWS		= 0x0CF3,
	GL_UNPACK_SWAP_BYTES		= 0x0CF0,
	GL_ZOOM_X				= 0x0D16,
	GL_ZOOM_Y				= 0x0D17,

    // Картирование текстуры
    СРЕДА_ТЕКС                         = 0x2300,
    РЕЖИМ_СРЕДЫ_ТЕКС                    = 0x2200,
    ТЕКСТУРА_М1                          = 0x0DE0,
    ТЕКСТУРА_М2                          = 0x0DE1,
    TEXTURE_WRAP_S                      = 0x2802,
    TEXTURE_WRAP_T                      = 0x2803,
    TEXTURE_MAG_FILTER                  = 0x2800,
    TEXTURE_MIN_FILTER                  = 0x2801,
    СРЕДА_ТЕКС_ЦВЕТ                   = 0x2201,
    ГЕН_ТЕКС_S                       = 0x0C60,
    ГЕН_ТЕКС_T                       = 0x0C61,
    РЕЖИМ_ГЕН_ТЕКСТУРЫ                    = 0x2500,
    ЦВЕТ_КАЙМЫ_ТЕКСТУРЫ                = 0x1004,
    ШИРИНА_ТЕКСТУРЫ                       = 0x1000,
    ВЫСОТА_ТЕКСТУРЫ                      = 0x1001,
    КАЙМА_ТЕКСТУРЫ                      = 0x1005,
    КОМПОНЕНТЫ_ТЕКСТУРЫ                  = 0x1003,
    РАЗМЕР_КРАСНОГО_ТЕКСТУРЫ                    = 0x805C,
    РАЗМЕР_ЗЕЛЁНОГО_ТЕКСТУРЫ                  = 0x805D,
    РАЗМЕР_СИНЕГО_ТЕКСТУРЫ                   = 0x805E,
    РАЗМЕР_АЛЬФЫ_ТЕКСТУРЫ                  = 0x805F,
    РАЗМЕР_ОСВЕЩЕННОСТИ_ТЕКСТУРЫ              = 0x8060,
    РАЗМЕР_ИНТЕНСИВНОСТИ_ТЕКСТУРЫ              = 0x8061,
	 NEAREST_MIPКАРТА_NEAREST              = 0x2700,
    NEAREST_MIPКАРТА_LINEAR               = 0x2702,
    LINEAR_MIPКАРТА_NEAREST               = 0x2701,
    LINEAR_MIPКАРТА_LINEAR                = 0x2703,
    ЛИНЕЙНЫЙ_ОБЪЕКТ                       = 0x2401,
    ПЛОСКИЙ_ОБЪЕКТ                        = 0x2501,
    EYE_LINEAR                          = 0x2400,
    EYE_PLANE                           = 0x2502,
    КАРТА_ШАРА                          = 0x2402,
    DECAL                               = 0x2101,
    МОДУЛИРУЙ                            = 0x2100,
    БЛИЖАЙШАЯ                             = 0x2600,
    ПОВТОРИ                              = 0x2901,
    CLAMP                               = 0x2900,
    S                                   = 0x2000,
    T                                   = 0x2001,
    R                                   = 0x2002,
    Q                                   = 0x2003,
    ГЕН_ТЕКС_R                       = 0x0C62,
    ГЕН_ТЕКС_Q                       = 0x0C63,
	//English
	GL_TEXTURE_ENV			= 0x2300,
	GL_TEXTURE_ENV_MODE		= 0x2200,
	GL_TEXTURE_1D			= 0x0DE0,
	GL_TEXTURE_2D			= 0x0DE1,
	GL_TEXTURE_WRAP_S			= 0x2802,
	GL_TEXTURE_WRAP_T			= 0x2803,
	GL_TEXTURE_MAG_FILTER		= 0x2800,
	GL_TEXTURE_MIN_FILTER		= 0x2801,
	GL_TEXTURE_ENV_COLOR		= 0x2201,
	GL_TEXTURE_GEN_S			= 0x0C60,
	GL_TEXTURE_GEN_T			= 0x0C61,
	GL_TEXTURE_GEN_MODE		= 0x2500,
	GL_TEXTURE_BORDER_COLOR		= 0x1004,
	GL_TEXTURE_WIDTH			= 0x1000,
	GL_TEXTURE_HEIGHT			= 0x1001,
	GL_TEXTURE_BORDER			= 0x1005,
	GL_TEXTURE_COMPONENTS		= 0x1003,
	GL_TEXTURE_RED_SIZE		= 0x805C,
	GL_TEXTURE_GREEN_SIZE		= 0x805D,
	GL_TEXTURE_BLUE_SIZE		= 0x805E,
	GL_TEXTURE_ALPHA_SIZE		= 0x805F,
	GL_TEXTURE_LUMINANCE_SIZE		= 0x8060,
	GL_TEXTURE_INTENSITY_SIZE		= 0x8061,
	GL_NEAREST_MIPMAP_NEAREST		= 0x2700,
	GL_NEAREST_MIPMAP_LINEAR		= 0x2702,
	GL_LINEAR_MIPMAP_NEAREST		= 0x2701,
	GL_LINEAR_MIPMAP_LINEAR		= 0x2703,
	GL_OBJECT_LINEAR			= 0x2401,
	GL_OBJECT_PLANE			= 0x2501,
	GL_EYE_LINEAR			= 0x2400,
	GL_EYE_PLANE			= 0x2502,
	GL_SPHERE_MAP			= 0x2402,
	GL_DECAL				= 0x2101,
	GL_MODULATE			= 0x2100,
	GL_NEAREST				= 0x2600,
	GL_REPEAT				= 0x2901,
	GL_CLAMP				= 0x2900,
	GL_S				= 0x2000,
	GL_T				= 0x2001,
	GL_R				= 0x2002,
	GL_Q				= 0x2003,
	GL_TEXTURE_GEN_R			= 0x0C62,
	GL_TEXTURE_GEN_Q			= 0x0C63,

    // Утилиты
    ПРОИЗВОДИТЕЛЬ                              = 0x1F00,
    ОТОБРАЗИТЕЛЬ                            = 0x1F01,
    ВЕРСИЯ                             = 0x1F02,
    РАСШИРЕНИЯ                          = 0x1F03,
	//English
	GL_VENDOR				= 0x1F00,
	GL_RENDERER			= 0x1F01,
	GL_VERSION				= 0x1F02,
	GL_EXTENSIONS			= 0x1F03,

    // Ошибки
    ОШИБОК_НЕТ                            = 0x0,
    НЕВЕРНОЕ_ЗНАЧЕНИЕ                       = 0x0501,
    НЕПРАВИЛЬНЫЙ_ПЕРЕЧЕНЬ                        = 0x0500,
    НЕВЕРНАЯ_ОПЕРАЦИЯ                   = 0x0502,
    ПЕРЕПОЛНЕНИЕ_СТЕКА                      = 0x0503,
    НЕДОБОР_СТЕКА                    = 0x0504,
    НЕХВАТКА_ПАМЯТИ                       = 0x0505,
	//English
	GL_NO_ERROR			= 0x0,
	GL_INVALID_VALUE			= 0x0501,
	GL_INVALID_ENUM			= 0x0500,
	GL_INVALID_OPERATION		= 0x0502,
	GL_STACK_OVERFLOW			= 0x0503,
	GL_STACK_UNDERFLOW			= 0x0504,
	GL_OUT_OF_MEMORY			= 0x0505,
}

// glPush/PopAttrib bits
enum : бцел
{
    ТЕКУЩИЙ_БИТ                         = 0x00000001,
    БИТ_ТОЧКИ                           = 0x00000002,
    БИТ_ЛИНИИ                            = 0x00000004,
    БИТ_МНОГОУГ                         = 0x00000008,
    БИТ_УЗОРА_МНОГОУГ                 = 0x00000010,
    БИТ__РЕЖИМА_ПИКСЕЛЯ                      = 0x00000020,
    БИТ_ОСВЕЩЕНИЯ                        = 0x00000040,
    БИТ_ТУМАНА                             = 0x00000080,
    БИТ_БУФЕРА_ДАЛИ                    = 0x00000100,
    БИТ_БУФЕРА_АККУМ                    = 0x00000200,
    БИТ_БУФЕРА_ШАБЛОНА                  = 0x00000400,
    БИТ_ВЬЮПОРТА                        = 0x00000800,
    БИТ_ТРАНСФОРМА                       = 0x00001000,
    БИТ_ВКЛЮЧИТЬ                          = 0x00002000,
    БИТ_БУФЕРА_ЦВЕТА                    = 0x00004000,
    БИТ_ПОДСКАЗКИ                            = 0x00008000,
    БИТ_ОЦЕНКИ                            = 0x00010000,
    БИТ_СПИСКА                            = 0x00020000,
    БИТ_ТЕКСТУРЫ                         = 0x00040000,
    БИТ_НОЖНИЦ                         = 0x00080000,
    БИТЫ_ВСЕХ_АТРИБУТОВ                     = 0x000FFFFF,
	//English
	GL_CURRENT_BIT			= 0x00000001,
	GL_POINT_BIT			= 0x00000002,
	GL_LINE_BIT			= 0x00000004,
	GL_POLYGON_BIT			= 0x00000008,
	GL_POLYGON_STIPPLE_BIT		= 0x00000010,
	GL_PIXEL_MODE_BIT			= 0x00000020,
	GL_LIGHTING_BIT			= 0x00000040,
	GL_FOG_BIT				= 0x00000080,
	GL_DEPTH_BUFFER_BIT		= 0x00000100,
	GL_ACCUM_BUFFER_BIT		= 0x00000200,
	GL_STENCIL_BUFFER_BIT		= 0x00000400,
	GL_VIEWPORT_BIT			= 0x00000800,
	GL_TRANSFORM_BIT			= 0x00001000,
	GL_ENABLE_BIT			= 0x00002000,
	GL_COLOR_BUFFER_BIT		= 0x00004000,
	GL_HINT_BIT			= 0x00008000,
	GL_EVAL_BIT			= 0x00010000,
	GL_LIST_BIT			= 0x00020000,
	GL_TEXTURE_BIT			= 0x00040000,
	GL_SCISSOR_BIT			= 0x00080000,
	GL_ALL_ATTRIB_BITS			= 0x000FFFFF,
	}

// gl 1.1
enum : Гперечень
{
ПРОКСИТЕКСТУРА_1М                    = 0x8063,
ПРОКСИТЕКСТУРА_2М                    = 0x8064,
ПРИОРИТЕТ_ТЕКСТУРЫ                    = 0x8066,
РЕЗИДЕНТНАЯ_ТЕКСТУРА                    = 0x8067,
ПРИВЯЗКА_ТЕКСТУРЫ_1М                  = 0x8068,
ПРИВЯЗКА_ТЕКСТУРЫ_2М                  = 0x8069,
ВНУТРЕННИЙ_ФОРМАТ_ТЕКСТУРЫ             = 0x1003,
АЛЬФА4                              = 0x803B,
АЛЬФА8                              = 0x803C,
АЛЬФА12                             = 0x803D,
АЛЬФА16                             = 0x803E,
СВЕТИМОСТЬ4                          = 0x803F,
СВЕТИМОСТЬ8                          = 0x8040,
СВЕТИМОСТЬ12                         = 0x8041,
СВЕТИМОСТЬ16                         = 0x8042,
СВЕТИМОСТЬ4_АЛЬФА4                   = 0x8043,
СВЕТИМОСТЬ6_АЛЬФА2                   = 0x8044,
СВЕТИМОСТЬ8_АЛЬФА8                   = 0x8045,
СВЕТИМОСТЬ12_АЛЬФА4                  = 0x8046,
СВЕТИМОСТЬ12_АЛЬФА12                 = 0x8047,
СВЕТИМОСТЬ16_АЛЬФА16                 = 0x8048,
ИНТЕНСИВНОСТЬ                           = 0x8049,
ИНТЕНСИВНОСТЬ4                          = 0x804A,
ИНТЕНСИВНОСТЬ8                          = 0x804B,
ИНТЕНСИВНОСТЬ12                         = 0x804C,
ИНТЕНСИВНОСТЬ16                         = 0x804D,
К3_З3_С2                            = 0x2A10,
КЗС4                                = 0x804F,
КЗС5                                = 0x8050,
КЗС8                                = 0x8051,
КЗС10                               = 0x8052,
КЗС12                               = 0x8053,
КЗС16                               = 0x8054,
КЗСА2                               = 0x8055,
КЗСА4                               = 0x8056,
КЗС5_А1                             = 0x8057,
КЗСА8                               = 0x8058,
КЗС10_А2                            = 0x8059,
КЗСА12                              = 0x805A,
КЗСА16                              = 0x805B,
//English
GL_PROXY_TEXTURE_1D		= 0x8063,
GL_PROXY_TEXTURE_2D		= 0x8064,
GL_TEXTURE_PRIORITY		= 0x8066,
GL_TEXTURE_RESIDENT		= 0x8067,
GL_TEXTURE_BINDING_1D		= 0x8068,
GL_TEXTURE_BINDING_2D		= 0x8069,
GL_TEXTURE_INTERNAL_FORMAT		= 0x1003,
GL_ALPHA4				= 0x803B,
GL_ALPHA8				= 0x803C,
GL_ALPHA12				= 0x803D,
GL_ALPHA16				= 0x803E,
GL_LUMINANCE4			= 0x803F,
GL_LUMINANCE8			= 0x8040,
GL_LUMINANCE12			= 0x8041,
GL_LUMINANCE16			= 0x8042,
GL_LUMINANCE4_ALPHA4		= 0x8043,
GL_LUMINANCE6_ALPHA2		= 0x8044,
GL_LUMINANCE8_ALPHA8		= 0x8045,
GL_LUMINANCE12_ALPHA4		= 0x8046,
GL_LUMINANCE12_ALPHA12		= 0x8047,
GL_LUMINANCE16_ALPHA16		= 0x8048,
GL_INTENSITY			= 0x8049,
GL_INTENSITY4			= 0x804A,
GL_INTENSITY8			= 0x804B,
GL_INTENSITY12			= 0x804C,
GL_INTENSITY16			= 0x804D,
GL_R3_G3_B2			= 0x2A10,
GL_RGB4				= 0x804F,
GL_RGB5				= 0x8050,
GL_RGB8				= 0x8051,
GL_RGB10				= 0x8052,
GL_RGB12				= 0x8053,
GL_RGB16				= 0x8054,
GL_RGBA2				= 0x8055,
GL_RGBA4				= 0x8056,
GL_RGB5_A1				= 0x8057,
GL_RGBA8				= 0x8058,
GL_RGB10_A2			= 0x8059,
GL_RGBA12				= 0x805A,
GL_RGBA16				= 0x805B,
}

enum : бцел
{
    БИТ_ХРАНЕНИЯ_ПИКСЕЛЯ_КЛИЕНТА              = 0x00000001,
    БИТ_МАССИВА_КВЕРШИН_КЛИЕНТА             = 0x00000002,
    ВСЕ_БИТЫ_АТРБУТОВ_КЛИЕНТА              = 0xFFFFFFFF,
    БИТЫ_ВСЕХ_АТРИБУТОВ_КЛИЕНТА              = 0xFFFFFFFF,
	//English
	GL_CLIENT_PIXEL_STORE_BIT		= 0x00000001,
    GL_CLIENT_VERTEX_ARRAY_BIT		= 0x00000002,
	GL_ALL_CLIENT_ATTRIB_BITS		= 0xFFFFFFFF,
	GL_CLIENT_ALL_ATTRIB_BITS		= 0xFFFFFFFF,
}

enum: Гперечень
{
// OpenGL 1.2
 GL_RESCALE_NORMAL			= 0x803A,
 GL_CLAMP_TO_EDGE			= 0x812F,
 GL_MAX_ELEMENTS_VERTICES		= 0x80E8,
 GL_MAX_ELEMENTS_INDICES		= 0x80E9,
 GL_BGR				= 0x80E0,
 GL_BGRA				= 0x80E1,
 GL_UNSIGNED_BYTE_3_3_2		= 0x8032,
 GL_UNSIGNED_BYTE_2_3_3_REV		= 0x8362,
 GL_UNSIGNED_SHORT_5_6_5		= 0x8363,
 GL_UNSIGNED_SHORT_5_6_5_REV	= 0x8364,
 GL_UNSIGNED_SHORT_4_4_4_4		= 0x8033,
 GL_UNSIGNED_SHORT_4_4_4_4_REV	= 0x8365,
 GL_UNSIGNED_SHORT_5_5_5_1		= 0x8034,
 GL_UNSIGNED_SHORT_1_5_5_5_REV	= 0x8366,
 GL_UNSIGNED_INT_8_8_8_8		= 0x8035,
 GL_UNSIGNED_INT_8_8_8_8_REV	= 0x8367,
 GL_UNSIGNED_INT_10_10_10_2		= 0x8036,
 GL_UNSIGNED_INT_2_10_10_10_REV	= 0x8368,
 GL_LIGHT_MODEL_COLOR_CONTROL	= 0x81F8,
 GL_SINGLE_COLOR			= 0x81F9,
 GL_SEPARATE_SPECULAR_COLOR		= 0x81FA,
 GL_TEXTURE_MIN_LOD			= 0x813A,
 GL_TEXTURE_MAX_LOD			= 0x813B,
 GL_TEXTURE_BASE_LEVEL		= 0x813C,
 GL_TEXTURE_MAX_LEVEL		= 0x813D,
 GL_SMOOTH_POINT_SIZE_RANGE		= 0x0B12,
 GL_SMOOTH_POINT_SIZE_GRANULARITY	= 0x0B13,
 GL_SMOOTH_LINE_WIDTH_RANGE		= 0x0B22,
 GL_SMOOTH_LINE_WIDTH_GRANULARITY	= 0x0B23,
 GL_ALIASED_POINT_SIZE_RANGE	= 0x846D,
 GL_ALIASED_LINE_WIDTH_RANGE	= 0x846E,
 GL_PACK_SKIP_IMAGES		= 0x806B,
 GL_PACK_IMAGE_HEIGHT		= 0x806C,
 GL_UNPACK_SKIP_IMAGES		= 0x806D,
 GL_UNPACK_IMAGE_HEIGHT		= 0x806E,
 GL_TEXTURE_3D			= 0x806F,
 GL_PROXY_TEXTURE_3D		= 0x8070,
 GL_TEXTURE_DEPTH			= 0x8071,
 GL_TEXTURE_WRAP_R			= 0x8072,
 GL_MAX_3D_TEXTURE_SIZE		= 0x8073,
 GL_TEXTURE_BINDING_3D		= 0x806A,

// OpenGL 1.3
 GL_TEXTURE0			= 0x84C0,
 GL_TEXTURE1			= 0x84C1,
 GL_TEXTURE2			= 0x84C2,
 GL_TEXTURE3			= 0x84C3,
 GL_TEXTURE4			= 0x84C4,
 GL_TEXTURE5			= 0x84C5,
 GL_TEXTURE6			= 0x84C6,
 GL_TEXTURE7			= 0x84C7,
 GL_TEXTURE8			= 0x84C8,
 GL_TEXTURE9			= 0x84C9,
 GL_TEXTURE10			= 0x84CA,
 GL_TEXTURE11			= 0x84CB,
 GL_TEXTURE12			= 0x84CC,
 GL_TEXTURE13			= 0x84CD,
 GL_TEXTURE14			= 0x84CE,
 GL_TEXTURE15			= 0x84CF,
 GL_TEXTURE16			= 0x84D0,
 GL_TEXTURE17			= 0x84D1,
 GL_TEXTURE18			= 0x84D2,
 GL_TEXTURE19			= 0x84D3,
 GL_TEXTURE20			= 0x84D4,
 GL_TEXTURE21			= 0x84D5,
 GL_TEXTURE22			= 0x84D6,
 GL_TEXTURE23			= 0x84D7,
 GL_TEXTURE24			= 0x84D8,
 GL_TEXTURE25			= 0x84D9,
 GL_TEXTURE26			= 0x84DA,
 GL_TEXTURE27			= 0x84DB,
 GL_TEXTURE28			= 0x84DC,
 GL_TEXTURE29			= 0x84DD,
 GL_TEXTURE30			= 0x84DE,
 GL_TEXTURE31			= 0x84DF,
 GL_ACTIVE_TEXTURE			= 0x84E0,
 GL_CLIENT_ACTIVE_TEXTURE		= 0x84E1,
 GL_MAX_TEXTURE_UNITS		= 0x84E2,
 GL_NORMAL_MAP			= 0x8511,
 GL_REFLECTION_MAP			= 0x8512,
 GL_TEXTURE_CUBE_MAP		= 0x8513,
 GL_TEXTURE_BINDING_CUBE_MAP	= 0x8514,
 GL_TEXTURE_CUBE_MAP_POSITIVE_X	= 0x8515,
 GL_TEXTURE_CUBE_MAP_NEGATIVE_X	= 0x8516,
 GL_TEXTURE_CUBE_MAP_POSITIVE_Y	= 0x8517,
 GL_TEXTURE_CUBE_MAP_NEGATIVE_Y	= 0x8518,
 GL_TEXTURE_CUBE_MAP_POSITIVE_Z	= 0x8519,
 GL_TEXTURE_CUBE_MAP_NEGATIVE_Z	= 0x851A,
 GL_PROXY_TEXTURE_CUBE_MAP		= 0x851B,
 GL_MAX_CUBE_MAP_TEXTURE_SIZE	= 0x851C,
 GL_COMPRESSED_ALPHA		= 0x84E9,
 GL_COMPRESSED_LUMINANCE		= 0x84EA,
 GL_COMPRESSED_LUMINANCE_ALPHA	= 0x84EB,
 GL_COMPRESSED_INTENSITY		= 0x84EC,
 GL_COMPRESSED_RGB			= 0x84ED,
 GL_COMPRESSED_RGBA			= 0x84EE,
 GL_TEXTURE_COMPRESSION_HINT	= 0x84EF,
 GL_TEXTURE_COMPRESSED_IMAGE_SIZE	= 0x86A0,
 GL_TEXTURE_COMPRESSED		= 0x86A1,
 GL_NUM_COMPRESSED_TEXTURE_FORMATS	= 0x86A2,
 GL_COMPRESSED_TEXTURE_FORMATS	= 0x86A3,
 GL_MULTISAMPLE			= 0x809D,
 GL_SAMPLE_ALPHA_TO_COVERAGE	= 0x809E,
 GL_SAMPLE_ALPHA_TO_ONE		= 0x809F,
 GL_SAMPLE_COVERAGE			= 0x80A0,
 GL_SAMPLE_BUFFERS			= 0x80A8,
 GL_SAMPLES				= 0x80A9,
 GL_SAMPLE_COVERAGE_VALUE		= 0x80AA,
 GL_SAMPLE_COVERAGE_INVERT		= 0x80AB,
 GL_MULTISAMPLE_BIT			= 0x20000000,
 GL_TRANSPOSE_MODELVIEW_MATRIX	= 0x84E3,
 GL_TRANSPOSE_PROJECTION_MATRIX	= 0x84E4,
 GL_TRANSPOSE_TEXTURE_MATRIX	= 0x84E5,
 GL_TRANSPOSE_COLOR_MATRIX		= 0x84E6,
 GL_COMBINE				= 0x8570,
 GL_COMBINE_RGB			= 0x8571,
 GL_COMBINE_ALPHA			= 0x8572,
 GL_SOURCE0_RGB			= 0x8580,
 GL_SOURCE1_RGB			= 0x8581,
 GL_SOURCE2_RGB			= 0x8582,
 GL_SOURCE0_ALPHA			= 0x8588,
 GL_SOURCE1_ALPHA			= 0x8589,
 GL_SOURCE2_ALPHA			= 0x858A,
 GL_OPERAND0_RGB			= 0x8590,
 GL_OPERAND1_RGB			= 0x8591,
 GL_OPERAND2_RGB			= 0x8592,
 GL_OPERAND0_ALPHA			= 0x8598,
 GL_OPERAND1_ALPHA			= 0x8599,
 GL_OPERAND2_ALPHA			= 0x859A,
 GL_RGB_SCALE			= 0x8573,
 GL_ADD_SIGNED			= 0x8574,
 GL_INTERPOLATE			= 0x8575,
 GL_SUBTRACT			= 0x84E7,
 GL_CONSTANT			= 0x8576,
 GL_PRIMARY_COLOR			= 0x8577,
 GL_PREVIOUS			= 0x8578,
 GL_DOT3_RGB			= 0x86AE,
 GL_DOT3_RGBA			= 0x86AF,
 GL_CLAMP_TO_BORDER			= 0x812D,

// OpenGL 1.4
 GL_BLEND_DST_RGB			= 0x80C8,
 GL_BLEND_SRC_RGB			= 0x80C9,
 GL_BLEND_DST_ALPHA			= 0x80CA,
 GL_BLEND_SRC_ALPHA			= 0x80CB,
 GL_POINT_SIZE_MIN			= 0x8126,
 GL_POINT_SIZE_MAX			= 0x8127,
 GL_POINT_FADE_THRESHOLD_SIZE	= 0x8128,
 GL_POINT_DISTANCE_ATTENUATION	= 0x8129,
 GL_GENERATE_MIPMAP			= 0x8191,
 GL_GENERATE_MIPMAP_HINT		= 0x8192,
 GL_DEPTH_COMPONENT16		= 0x81A5,
 GL_DEPTH_COMPONENT24		= 0x81A6,
 GL_DEPTH_COMPONENT32		= 0x81A7,
 GL_MIRRORED_REPEAT			= 0x8370,
 GL_FOG_COORDINATE_SOURCE		= 0x8450,
 GL_FOG_COORDINATE			= 0x8451,
 GL_FRAGMENT_DEPTH			= 0x8452,
 GL_CURRENT_FOG_COORDINATE		= 0x8453,
 GL_FOG_COORDINATE_ARRAY_TYPE	= 0x8454,
 GL_FOG_COORDINATE_ARRAY_STRIDE	= 0x8455,
 GL_FOG_COORDINATE_ARRAY_POINTER	= 0x8456,
 GL_FOG_COORDINATE_ARRAY		= 0x8457,
 GL_COLOR_SUM			= 0x8458,
 GL_CURRENT_SECONDARY_COLOR		= 0x8459,
 GL_SECONDARY_COLOR_ARRAY_SIZE	= 0x845A,
 GL_SECONDARY_COLOR_ARRAY_TYPE	= 0x845B,
 GL_SECONDARY_COLOR_ARRAY_STRIDE	= 0x845C,
 GL_SECONDARY_COLOR_ARRAY_POINTER	= 0x845D,
 GL_SECONDARY_COLOR_ARRAY		= 0x845E,
 GL_MAX_TEXTURE_LOD_BIAS		= 0x84FD,
 GL_TEXTURE_FILTER_CONTROL		= 0x8500,
 GL_TEXTURE_LOD_BIAS		= 0x8501,
 GL_INCR_WRAP			= 0x8507,
 GL_DECR_WRAP			= 0x8508,
 GL_TEXTURE_DEPTH_SIZE		= 0x884A,
 GL_DEPTH_TEXTURE_MODE		= 0x884B,
 GL_TEXTURE_COMPARE_MODE		= 0x884C,
 GL_TEXTURE_COMPARE_FUNC		= 0x884D,
 GL_COMPARE_R_TO_TEXTURE		= 0x884E,

// OpenGL 1.5
 GL_BUFFER_SIZE			= 0x8764,
 GL_BUFFER_USAGE			= 0x8765,
 GL_QUERY_COUNTER_BITS		= 0x8864,
 GL_CURRENT_QUERY			= 0x8865,
 GL_QUERY_RESULT			= 0x8866,
 GL_QUERY_RESULT_AVAILABLE		= 0x8867,
 GL_ARRAY_BUFFER			= 0x8892,
 GL_ELEMENT_ARRAY_BUFFER		= 0x8893,
 GL_ARRAY_BUFFER_BINDING		= 0x8894,
 GL_ELEMENT_ARRAY_BUFFER_BINDING	= 0x8895,
 GL_VERTEX_ARRAY_BUFFER_BINDING	= 0x8896,
 GL_NORMAL_ARRAY_BUFFER_BINDING	= 0x8897,
 GL_COLOR_ARRAY_BUFFER_BINDING	= 0x8898,
 GL_INDEX_ARRAY_BUFFER_BINDING	= 0x8899,
 GL_TEXTURE_COORD_ARRAY_BUFFER_BINDING= 0x889A,
 GL_EDGE_FLAG_ARRAY_BUFFER_BINDING	= 0x889B,
 GL_SECONDARY_COLOR_ARRAY_BUFFER_BINDING= 0x889C,
 GL_FOG_COORDINATE_ARRAY_BUFFER_BINDING= 0x889D,
 GL_WEIGHT_ARRAY_BUFFER_BINDING	= 0x889E,
 GL_VERTEX_ATTRIB_ARRAY_BUFFER_BINDING= 0x889F,
 GL_READ_ONLY			= 0x88B8,
 GL_WRITE_ONLY			= 0x88B9,
 GL_READ_WRITE			= 0x88BA,
 GL_BUFFER_ACCESS			= 0x88BB,
 GL_BUFFER_MAPPED			= 0x88BC,
 GL_BUFFER_MAP_POINTER		= 0x88BD,
 GL_STREAM_DRAW			= 0x88E0,
 GL_STREAM_READ			= 0x88E1,
 GL_STREAM_COPY			= 0x88E2,
 GL_STATIC_DRAW			= 0x88E4,
 GL_STATIC_READ			= 0x88E5,
 GL_STATIC_COPY			= 0x88E6,
 GL_DYNAMIC_DRAW			= 0x88E8,
 GL_DYNAMIC_READ			= 0x88E9,
 GL_DYNAMIC_COPY			= 0x88EA,
 GL_SAMPLES_PASSED			= 0x8914,
 GL_FOG_COORD_SRC			= GL_FOG_COORDINATE_SOURCE,
 GL_FOG_COORD			= GL_FOG_COORDINATE,
 GL_CURRENT_FOG_COORD		= GL_CURRENT_FOG_COORDINATE,
 GL_FOG_COORD_ARRAY_TYPE		= GL_FOG_COORDINATE_ARRAY_TYPE,
 GL_FOG_COORD_ARRAY_STRIDE		= GL_FOG_COORDINATE_ARRAY_STRIDE,
 GL_FOG_COORD_ARRAY_POINTER		= GL_FOG_COORDINATE_ARRAY_POINTER,
 GL_FOG_COORD_ARRAY			= GL_FOG_COORDINATE_ARRAY,
 GL_FOG_COORD_ARRAY_BUFFER_BINDING	= GL_FOG_COORDINATE_ARRAY_BUFFER_BINDING,
 GL_SRC0_RGB			= GL_SOURCE0_RGB,
 GL_SRC1_RGB			= GL_SOURCE1_RGB,
 GL_SRC2_RGB			= GL_SOURCE2_RGB,
 GL_SRC0_ALPHA			= GL_SOURCE0_ALPHA,
 GL_SRC1_ALPHA			= GL_SOURCE1_ALPHA,
 GL_SRC2_ALPHA			= GL_SOURCE2_ALPHA,

// OpenGL 2.0
 GL_BLEND_EQUATION_RGB		= 0x8009,
 GL_VERTEX_ATTRIB_ARRAY_ENABLED	= 0x8622,
 GL_VERTEX_ATTRIB_ARRAY_SIZE	= 0x8623,
 GL_VERTEX_ATTRIB_ARRAY_STRIDE	= 0x8624,
 GL_VERTEX_ATTRIB_ARRAY_TYPE	= 0x8625,
 GL_CURRENT_VERTEX_ATTRIB		= 0x8626,
 GL_VERTEX_PROGRAM_POINT_SIZE	= 0x8642,
 GL_VERTEX_PROGRAM_TWO_SIDE		= 0x8643,
 GL_VERTEX_ATTRIB_ARRAY_POINTER	= 0x8645,
 GL_STENCIL_BACK_FUNC		= 0x8800,
 GL_STENCIL_BACK_FAIL		= 0x8801,
 GL_STENCIL_BACK_PASS_DEPTH_FAIL	= 0x8802,
 GL_STENCIL_BACK_PASS_DEPTH_PASS	= 0x8803,
 GL_MAX_DRAW_BUFFERS		= 0x8824,
 GL_DRAW_BUFFER0			= 0x8825,
 GL_DRAW_BUFFER1			= 0x8826,
 GL_DRAW_BUFFER2			= 0x8827,
 GL_DRAW_BUFFER3			= 0x8828,
 GL_DRAW_BUFFER4			= 0x8829,
 GL_DRAW_BUFFER5			= 0x882A,
 GL_DRAW_BUFFER6			= 0x882B,
 GL_DRAW_BUFFER7			= 0x882C,
 GL_DRAW_BUFFER8			= 0x882D,
 GL_DRAW_BUFFER9			= 0x882E,
 GL_DRAW_BUFFER10			= 0x882F,
 GL_DRAW_BUFFER11			= 0x8830,
 GL_DRAW_BUFFER12			= 0x8831,
 GL_DRAW_BUFFER13			= 0x8832,
 GL_DRAW_BUFFER14			= 0x8833,
 GL_DRAW_BUFFER15			= 0x8834,
 GL_BLEND_EQUATION_ALPHA		= 0x883D,
 GL_POINT_SPRITE			= 0x8861,
 GL_COORD_REPLACE			= 0x8862,
 GL_MAX_VERTEX_ATTRIBS		= 0x8869,
 GL_VERTEX_ATTRIB_ARRAY_NORMALIZED	= 0x886A,
 GL_MAX_TEXTURE_COORDS		= 0x8871,
 GL_MAX_TEXTURE_IMAGE_UNITS		= 0x8872,
 GL_FRAGMENT_SHADER			= 0x8B30,
 GL_VERTEX_SHADER			= 0x8B31,
 GL_MAX_FRAGMENT_UNIFORM_COMPONENTS	= 0x8B49,
 GL_MAX_VERTEX_UNIFORM_COMPONENTS	= 0x8B4A,
 GL_MAX_VARYING_FLOATS		= 0x8B4B,
 GL_MAX_VERTEX_TEXTURE_IMAGE_UNITS	= 0x8B4C,
 GL_MAX_COMBINED_TEXTURE_IMAGE_UNITS= 0x8B4D,
 GL_SHADER_TYPE			= 0x8B4F,
 GL_FLOAT_VEC2			= 0x8B50,
 GL_FLOAT_VEC3			= 0x8B51,
 GL_FLOAT_VEC4			= 0x8B52,
 GL_INT_VEC2			= 0x8B53,
 GL_INT_VEC3			= 0x8B54,
 GL_INT_VEC4			= 0x8B55,
 GL_BOOL				= 0x8B56,
 GL_BOOL_VEC2			= 0x8B57,
 GL_BOOL_VEC3			= 0x8B58,
 GL_BOOL_VEC4			= 0x8B59,
 GL_FLOAT_MAT2			= 0x8B5A,
 GL_FLOAT_MAT3			= 0x8B5B,
 GL_FLOAT_MAT4			= 0x8B5C,
 GL_SAMPLER_1D			= 0x8B5D,
 GL_SAMPLER_2D			= 0x8B5E,
 GL_SAMPLER_3D			= 0x8B5F,
 GL_SAMPLER_CUBE			= 0x8B60,
 GL_SAMPLER_1D_SHADOW		= 0x8B61,
 GL_SAMPLER_2D_SHADOW		= 0x8B62,
 GL_DELETE_STATUS			= 0x8B80,
 GL_COMPILE_STATUS			= 0x8B81,
 GL_LINK_STATUS			= 0x8B82,
 GL_VALIDATE_STATUS			= 0x8B83,
 GL_INFO_LOG_LENGTH			= 0x8B84,
 GL_ATTACHED_SHADERS		= 0x8B85,
 GL_ACTIVE_UNIFORMS			= 0x8B86,
 GL_ACTIVE_UNIFORM_MAX_LENGTH	= 0x8B87,
 GL_SHADER_SOURCE_LENGTH		= 0x8B88,
 GL_ACTIVE_ATTRIBUTES		= 0x8B89,
 GL_ACTIVE_ATTRIBUTE_MAX_LENGTH	= 0x8B8A,
 GL_FRAGMENT_SHADER_DERIVATIVE_HINT	= 0x8B8B,
 GL_SHADING_LANGUAGE_VERSION	= 0x8B8C,
 GL_CURRENT_PROGRAM			= 0x8B8D,
 GL_POINT_SPRITE_COORD_ORIGIN	= 0x8CA0,
 GL_LOWER_LEFT			= 0x8CA1,
 GL_UPPER_LEFT			= 0x8CA2,
 GL_STENCIL_BACK_REF		= 0x8CA3,
 GL_STENCIL_BACK_VALUE_MASK		= 0x8CA4,
 GL_STENCIL_BACK_WRITEMASK		= 0x8CA5,

// ARB_Imaging
 GL_CONSTANT_COLOR			= 0x8001,
 GL_ONE_MINUS_CONSTANT_COLOR	= 0x8002,
 GL_CONSTANT_ALPHA			= 0x8003,
 GL_ONE_MINUS_CONSTANT_ALPHA	= 0x8004,
 GL_BLEND_COLOR			= 0x8005,
 GL_FUNC_ADD			= 0x8006,
 GL_MIN				= 0x8007,
 GL_MAX				= 0x8008,
 GL_BLEND_EQUATION			= 0x8009,
 GL_FUNC_SUBTRACT			= 0x800A,
 GL_FUNC_REVERSE_SUBTRACT		= 0x800B,
 GL_CONVOLUTION_1D			= 0x8010,
 GL_CONVOLUTION_2D			= 0x8011,
 GL_SEPARABLE_2D			= 0x8012,
 GL_CONVOLUTION_BORDER_MODE		= 0x8013,
 GL_CONVOLUTION_FILTER_SCALE	= 0x8014,
 GL_CONVOLUTION_FILTER_BIAS		= 0x8015,
 GL_REDUCE				= 0x8016,
 GL_CONVOLUTION_FORMAT		= 0x8017,
 GL_CONVOLUTION_WIDTH		= 0x8018,
 GL_CONVOLUTION_HEIGHT		= 0x8019,
 GL_MAX_CONVOLUTION_WIDTH		= 0x801A,
 GL_MAX_CONVOLUTION_HEIGHT		= 0x801B,
 GL_POST_CONVOLUTION_RED_SCALE	= 0x801C,
 GL_POST_CONVOLUTION_GREEN_SCALE	= 0x801D,
 GL_POST_CONVOLUTION_BLUE_SCALE	= 0x801E,
 GL_POST_CONVOLUTION_ALPHA_SCALE	= 0x801F,
 GL_POST_CONVOLUTION_RED_BIAS	= 0x8020,
 GL_POST_CONVOLUTION_GREEN_BIAS	= 0x8021,
 GL_POST_CONVOLUTION_BLUE_BIAS	= 0x8022,
 GL_POST_CONVOLUTION_ALPHA_BIAS	= 0x8023,
 GL_HISTOGRAM			= 0x8024,
 GL_PROXY_HISTOGRAM			= 0x8025,
 GL_HISTOGRAM_WIDTH			= 0x8026,
 GL_HISTOGRAM_FORMAT		= 0x8027,
 GL_HISTOGRAM_RED_SIZE		= 0x8028,
 GL_HISTOGRAM_GREEN_SIZE		= 0x8029,
 GL_HISTOGRAM_BLUE_SIZE		= 0x802A,
 GL_HISTOGRAM_ALPHA_SIZE		= 0x802B,
 GL_HISTOGRAM_LUMINANCE_SIZE	= 0x802C,
 GL_HISTOGRAM_SINK			= 0x802D,
 GL_MINMAX				= 0x802E,
 GL_MINMAX_FORMAT			= 0x802F,
 GL_MINMAX_SINK			= 0x8030,
 GL_TABLE_TOO_LARGE			= 0x8031,
 GL_COLOR_MATRIX			= 0x80B1,
 GL_COLOR_MATRIX_STACK_DEPTH	= 0x80B2,
 GL_MAX_COLOR_MATRIX_STACK_DEPTH	= 0x80B3,
 GL_POST_COLOR_MATRIX_RED_SCALE	= 0x80B4,
 GL_POST_COLOR_MATRIX_GREEN_SCALE	= 0x80B5,
 GL_POST_COLOR_MATRIX_BLUE_SCALE	= 0x80B6,
 GL_POST_COLOR_MATRIX_ALPHA_SCALE	= 0x80B7,
 GL_POST_COLOR_MATRIX_RED_BIAS	= 0x80B8,
 GL_POST_COLOR_MATRIX_GREEN_BIAS	= 0x80B9,
 GL_POST_COLOR_MATRIX_BLUE_BIAS	= 0x80BA,
 GL_POST_COLOR_MATRIX_ALPHA_BIAS	= 0x80BB,
 GL_COLOR_TABLE			= 0x80D0,
 GL_POST_CONVOLUTION_COLOR_TABLE	= 0x80D1,
 GL_POST_COLOR_MATRIX_COLOR_TABLE	= 0x80D2,
 GL_PROXY_COLOR_TABLE		= 0x80D3,
 GL_PROXY_POST_CONVOLUTION_COLOR_TABLE= 0x80D4,
 GL_PROXY_POST_COLOR_MATRIX_COLOR_TABLE= 0x80D5,
 GL_COLOR_TABLE_SCALE		= 0x80D6,
 GL_COLOR_TABLE_BIAS		= 0x80D7,
 GL_COLOR_TABLE_FORMAT		= 0x80D8,
 GL_COLOR_TABLE_WIDTH		= 0x80D9,
 GL_COLOR_TABLE_RED_SIZE		= 0x80DA,
 GL_COLOR_TABLE_GREEN_SIZE		= 0x80DB,
 GL_COLOR_TABLE_BLUE_SIZE		= 0x80DC,
 GL_COLOR_TABLE_ALPHA_SIZE		= 0x80DD,
 GL_COLOR_TABLE_LUMINANCE_SIZE	= 0x80DE,
 GL_COLOR_TABLE_INTENSITY_SIZE	= 0x80DF,
 GL_CONSTANT_BORDER			= 0x8151,
 GL_REPLICATE_BORDER		= 0x8153,
 GL_CONVOLUTION_BORDER_COLOR	= 0x8154,

//glu

//==============================================================================
// CONSTANTS
//==============================================================================
// StringName
 GLU_VERSION			= 100800,
 GLU_EXTENSIONS			= 100801,
 GLU_EXT_object_space_tess   =       1,
 GLU_EXT_nurbs_tessellator    =      1,
// ErrorCode
 GLU_INVALID_ENUM			= 100900,
 GLU_INVALID_VALUE			= 100901,
 GLU_OUT_OF_MEMORY			= 100902,
 GLU_INVALID_OPERATION		= 100904,
 GLU_INCOMPATIBLE_GL_VERSION     =   100903,
// NurbsDisplay
 GLU_OUTLINE_POLYGON		= 100240,
 GLU_OUTLINE_PATCH			= 100241,
// NurbsCallback
 GLU_NURBS_ERROR			= 100103,
 GLU_ERROR				= 100103,
 GLU_NURBS_BEGIN			= 100164,
 GLU_NURBS_BEGIN_EXT		= 100164,
 GLU_NURBS_VERTEX			= 100165,
 GLU_NURBS_VERTEX_EXT		= 100165,
 GLU_NURBS_NORMAL			= 100166,
 GLU_NURBS_NORMAL_EXT		= 100166,
 GLU_NURBS_COLOR			= 100167,
 GLU_NURBS_COLOR_EXT		= 100167,
 GLU_NURBS_TEXTURE_COORD		= 100168,
 GLU_NURBS_TEX_COORD_EXT		= 100168,
 GLU_NURBS_END			= 100169,
 GLU_NURBS_END_EXT			= 100169,
 GLU_NURBS_BEGIN_DATA		= 100170,
 GLU_NURBS_BEGIN_DATA_EXT		= 100170,
 GLU_NURBS_VERTEX_DATA		= 100171,
 GLU_NURBS_VERTEX_DATA_EXT		= 100171,
 GLU_NURBS_NORMAL_DATA		= 100172,
 GLU_NURBS_NORMAL_DATA_EXT		= 100172,
 GLU_NURBS_COLOR_DATA		= 100173,
 GLU_NURBS_COLOR_DATA_EXT		= 100173,
 GLU_NURBS_TEXTURE_COORD_DATA	= 100174,
 GLU_NURBS_TEX_COORD_DATA_EXT 	= 100174,
 GLU_NURBS_END_DATA			= 100175,
 GLU_NURBS_END_DATA_EXT		= 100175,
// NurbsError
 GLU_NURBS_ERROR1			= 100251,
 GLU_NURBS_ERROR2			= 100252,
 GLU_NURBS_ERROR3			= 100253,
 GLU_NURBS_ERROR4			= 100254,
 GLU_NURBS_ERROR5			= 100255,
 GLU_NURBS_ERROR6			= 100256,
 GLU_NURBS_ERROR7			= 100257,
 GLU_NURBS_ERROR8			= 100258,
 GLU_NURBS_ERROR9			= 100259,
 GLU_NURBS_ERROR10			= 100260,
 GLU_NURBS_ERROR11			= 100261,
 GLU_NURBS_ERROR12			= 100262,
 GLU_NURBS_ERROR13			= 100263,
 GLU_NURBS_ERROR14			= 100264,
 GLU_NURBS_ERROR15			= 100265,
 GLU_NURBS_ERROR16			= 100266,
 GLU_NURBS_ERROR17			= 100267,
 GLU_NURBS_ERROR18			= 100268,
 GLU_NURBS_ERROR19			= 100269,
 GLU_NURBS_ERROR20			= 100270,
 GLU_NURBS_ERROR21			= 100271,
 GLU_NURBS_ERROR22			= 100272,
 GLU_NURBS_ERROR23			= 100273,
 GLU_NURBS_ERROR24			= 100274,
 GLU_NURBS_ERROR25			= 100275,
 GLU_NURBS_ERROR26			= 100276,
 GLU_NURBS_ERROR27			= 100277,
 GLU_NURBS_ERROR28			= 100278,
 GLU_NURBS_ERROR29			= 100279,
 GLU_NURBS_ERROR30			= 100280,
 GLU_NURBS_ERROR31			= 100281,
 GLU_NURBS_ERROR32			= 100282,
 GLU_NURBS_ERROR33			= 100283,
 GLU_NURBS_ERROR34			= 100284,
 GLU_NURBS_ERROR35			= 100285,
 GLU_NURBS_ERROR36			= 100286,
 GLU_NURBS_ERROR37			= 100287,
// NurbsProperty
 GLU_AUTO_LOAD_MATRIX		= 100200,
 GLU_CULLING			= 100201,
 GLU_SAMPLING_TOLERANCE		= 100203,
 GLU_DISPLAY_MODE			= 100204,
 GLU_PARAMETRIC_TOLERANCE		= 100202,
 GLU_SAMPLING_METHOD		= 100205,
 GLU_U_STEP				= 100206,
 GLU_V_STEP				= 100207,
 GLU_NURBS_MODE			= 100160,
 GLU_NURBS_MODE_EXT			= 100160,
 GLU_NURBS_TESSELLATOR		= 100161,
 GLU_NURBS_TESSELLATOR_EXT		= 100161,
 GLU_NURBS_RENDERER			= 100162,
 GLU_NURBS_RENDERER_EXT		= 100162,
// NurbsSampling
 GLU_OBJECT_PARAMETRIC_ERROR	= 100208,
 GLU_OBJECT_PARAMETRIC_ERROR_EXT	= 100208,
 GLU_OBJECT_PATH_LENGTH		= 100209,
 GLU_OBJECT_PATH_LENGTH_EXT		= 100209,
 GLU_PATH_LENGTH			= 100215,
 GLU_PARAMETRIC_ERROR		= 100216,
 GLU_DOMAIN_DISTANCE		= 100217,
// NurbsTrim
 GLU_MAP1_TRIM_2			= 100210,
 GLU_MAP2_TRIM_3			= 100211,
// QuadricDrawStyle
 GLU_POINT				= 100010,
 GLU_LINE				= 100011,
 GLU_FILL				= 100012,
 GLU_SILHOUETTE			= 100013,
 
 /* QuadricNormal */
GLU_SMOOTH   =                      100000,
GLU_FLAT         =                  100001,
GLU_NONE        =                   100002,

/* QuadricOrientation */
GLU_OUTSIDE        =                100020,
GLU_INSIDE         =                100021,

// QuadricNormal
 GLU_TESS_BEGIN			= 100100,
 GLU_BEGIN				= 100100,
 GLU_TESS_VERTEX			= 100101,
 GLU_VERTEX				= 100101,
 GLU_TESS_END			= 100102,
 GLU_END				= 100102,
 GLU_TESS_ERROR			= 100103,
 GLU_TESS_EDGE_FLAG			= 100104,
 GLU_EDGE_FLAG			= 100104,
 GLU_TESS_COMBINE			= 100105,
 GLU_TESS_BEGIN_DATA		= 100106,
 GLU_TESS_VERTEX_DATA		= 100107,
 GLU_TESS_END_DATA			= 100108,
 GLU_TESS_ERROR_DATA		= 100109,
 GLU_TESS_EDGE_FLAG_DATA		= 100110,
 GLU_TESS_COMBINE_DATA		= 100111,
// TessContour
 GLU_CW				= 100120,
 GLU_CCW				= 100121,
 GLU_INTERIOR			= 100122,
 GLU_EXTERIOR			= 100123,
 GLU_UNKNOWN			= 100124,
// TessProperty
 GLU_TESS_WINDING_RULE		= 100140,
 GLU_TESS_BOUNDARY_ONLY		= 100141,
 GLU_TESS_TOLERANCE			= 100142,
// TessError
 GLU_TESS_ERROR1			= 100151,
 GLU_TESS_ERROR2			= 100152,
 GLU_TESS_ERROR3			= 100153,
 GLU_TESS_ERROR4			= 100154,
 GLU_TESS_ERROR5			= 100155,
 GLU_TESS_ERROR6			= 100156,
 GLU_TESS_ERROR7			= 100157,
 GLU_TESS_ERROR8			= 100158,
 GLU_TESS_MISSING_BEGIN_POLYGON	= 100151,
 GLU_TESS_MISSING_BEGIN_COUNTER	= 100152,
 GLU_TESS_MISSING_END_POLYGON	= 100153,
 GLU_TESS_MISSING_END_COUNTER	= 100154,
 GLU_TESS_COORD_TOO_LARGE		= 100155,
 GLU_TESS_NEED_COMBINE_CALLBACK	= 100156,
// TessWinding
 GLU_TESS_WINDING_ODD		= 100130,
 GLU_TESS_WINDING_NONZERO		= 100131,
 GLU_TESS_WINDING_POSITIVE		= 100132,
 GLU_TESS_WINDING_NEGATIVE		= 100133,
 GLU_TESS_WINDING_ABS_GEQ_TWO	= 100134,
 
}


extern  (C)

{
 GLint  gluBuild1DMipmapLevels (GLenum цель, GLint внутрФормат, GLsizei ширина, GLenum формат, GLenum тип, GLint уровень, GLint ова, GLint макс,  void *данные);
 GLint  gluBuild2DMipmapLevels (GLenum цель, GLint внутрФормат, GLsizei ширина, GLsizei высота, GLenum формат, GLenum тип, GLint уровень, GLint ова, GLint макс,  ук данные);
 GLint  gluBuild3DMipmapLevels (GLenum цель, GLint внутрФормат, GLsizei ширина, GLsizei высота, GLsizei глубина, GLenum формат, GLenum тип, GLint уровень, GLint ова, GLint макс,  ук данные);
 GLboolean  gluCheckExtension ( GLubyte *имяРасш,  GLubyte *ткстРасш);
 GLint  gluBuild3DMipmaps (GLenum цель, GLint внутрФормат, GLsizei ширина, GLsizei высота, GLsizei глубина, GLenum формат, GLenum тип,  ук данные);
}

extern  (C) 

{

	 void  gluBeginCurve (GLUnurbs* нурб);
	 void  gluBeginPolygon (GLUtesselator* tess);
	 void  gluBeginSurface (GLUnurbs* нурб);
	 void  gluBeginTrim (GLUnurbs* нурб);
	
	 GLint  gluBuild1DMipmaps (GLenum цель, GLint внутрФормат, GLsizei ширина, GLenum формат, GLenum тип,  ук данные);
	 
	 GLint  gluBuild2DMipmaps (GLenum цель, GLint внутрФормат, GLsizei ширина, GLsizei высота, GLenum формат, GLenum тип,  ук данные);
	 
	 
	 
	 void  gluCylinder (GLUquadric* квад, GLdouble ова, GLdouble верх, GLdouble высота, GLint доли, GLint пачки);
	 void  gluDeleteNurbsRenderer (GLUnurbs* нурб);
	 void  gluDeleteQuadric (GLUquadric* квад);
	 void  gluDeleteTess (GLUtesselator* tess);
	 void  gluDisk (GLUquadric* квад, GLdouble inner, GLdouble внешний, GLint доли, GLint loops);
	 void  gluEndCurve (GLUnurbs* нурб);
	 void  gluEndPolygon (GLUtesselator* tess);
	 void  gluEndSurface (GLUnurbs* нурб);
	 void  gluEndTrim (GLUnurbs* нурб);
	  GLubyte *  gluErrorString (GLenum error);
	 void  gluGetNurbsProperty (GLUnurbs* нурб, GLenum property, GLfloat* данные);
	  GLubyte *  gluGetString (GLenum имя);
	 void  gluGetTessProperty (GLUtesselator* tess, GLenum which, GLdouble* данные);
	 void  gluLoadSamplingMatrices (GLUnurbs* нурб,  GLfloat *model,  GLfloat *perspective,  GLint *view);
	 void  gluLookAt (GLdouble eyeX, GLdouble eyeY, GLdouble eyeZ, GLdouble centerX, GLdouble centerY, GLdouble centerZ, GLdouble upX, GLdouble upY, GLdouble upZ);
	 GLUnurbs*  gluNewNurbsRenderer ();
	 GLUquadric*  gluNewQuadric ();
	 GLUtesselator*  gluNewTess ();
	 void  gluNextContour (GLUtesselator* tess, GLenum тип);
	 void  gluNurbsCallback (GLUnurbs* нурб, GLenum which, сифунк CallBackFunc);
	 void  gluNurbsCallbackData (GLUnurbs* нурб, GLvoid* userData);
	 void  gluNurbsCallbackDataEXT (GLUnurbs* нурб, GLvoid* userData);
	 void  gluNurbsCurve (GLUnurbs* нурб, GLint knotCount, GLfloat *knots, GLint stride, GLfloat *control, GLint order, GLenum тип);
	 void  gluNurbsProperty (GLUnurbs* нурб, GLenum property, GLfloat value);
	 void  gluNurbsSurface (GLUnurbs* нурб, GLint sKnotCount, GLfloat* sKnots, GLint tKnotCount, GLfloat* tKnots, GLint sStride, GLint tStride, GLfloat* control, GLint sOrder, GLint tOrder, GLenum тип);
	 void  gluOrtho2D (GLdouble left, GLdouble right, GLdouble bottom, GLdouble верх);
	 void  gluPartialDisk (GLUquadric* квад, GLdouble inner, GLdouble внешний, GLint доли, GLint loops, GLdouble start, GLdouble sweep);
	 void  gluPerspective (GLdouble fovy, GLdouble aspect, GLdouble zNear, GLdouble zFar);
	 void  gluPickMatrix (GLdouble x, GLdouble y, GLdouble delX, GLdouble delY, GLint *viewport);
	 GLint  gluProject (GLdouble objX, GLdouble objY, GLdouble objZ,  GLdouble *model,  GLdouble *proj,  GLint *view, GLdouble* winX, GLdouble* winY, GLdouble* winZ);
	 void  gluPwlCurve (GLUnurbs* нурб, GLint count, GLfloat* данные, GLint stride, GLenum тип);
	 void  gluQuadricCallback (GLUquadric* квад, GLenum which, сифунк CallBackFunc);
	 void  gluQuadricDrawStyle (GLUquadric* квад, GLenum draw);
	 void  gluQuadricNormals (GLUquadric* квад, GLenum normal);
	 void  gluQuadricOrientation (GLUquadric* квад, GLenum orientation);
	 void  gluQuadricTexture (GLUquadric* квад, GLboolean texture);
	 GLint  gluScaleImage (GLenum формат, GLsizei wIn, GLsizei hIn, GLenum typeIn,  ук dataIn, GLsizei wOut, GLsizei hOut, GLenum typeOut, GLvoid* dataOut);
	 void  gluSphere (GLUquadric* квад, GLdouble radius, GLint доли, GLint пачки);
	 void  gluTessBeginContour (GLUtesselator* tess);
	 void  gluTessBeginPolygon (GLUtesselator* tess, GLvoid* данные);
	 void  gluTessCallback (GLUtesselator* tess, GLenum which, сифунк CallBackFunc);
	 void  gluTessEndContour (GLUtesselator* tess);
	 void  gluTessEndPolygon (GLUtesselator* tess);
	 void  gluTessNormal (GLUtesselator* tess, GLdouble valueX, GLdouble valueY, GLdouble valueZ);
	 void  gluTessProperty (GLUtesselator* tess, GLenum which, GLdouble данные);
	 void  gluTessVertex (GLUtesselator* tess, GLdouble *location, GLvoid* данные);
	 GLint  gluUnProject (GLdouble winX, GLdouble winY, GLdouble winZ,  GLdouble *model,  GLdouble *proj,  GLint *view, GLdouble* objX, GLdouble* objY, GLdouble* objZ);
	 GLint  gluUnProject4 (GLdouble winX, GLdouble winY, GLdouble winZ, GLdouble clipW,  GLdouble *model,  GLdouble *proj,  GLint *view, GLdouble nearVal, GLdouble farVal, GLdouble* objX, GLdouble* objY, GLdouble* objZ, GLdouble* objW);
 }

extern  (C)

{


void glutReportErrors();
int glutExtensionSupported(char *имя);
void    glutIgnoreKeyRepeat(int ignore);
void    glutSetKeyRepeat(int repeatMode);
void    glutForceJoystickFunc();
int glutGetModifiers();
int glutLayerGet(GLenum тип);
int    glutBitmapLength(ук font, сим *string);
 int    glutStrokeLength(ук font,  сим *string);
void glutMenuStatusFunc(сифунк_ЦЦЦ);
void glutOverlayDisplayFunc(сифунк);
void glutWindowStatusFunc(сифунк_Ц);
void glutGameModeString(char*);
int  glutEnterGameMode();
void glutLeaveGameMode();
int glutGameModeGet(GLenum);

  int    glutVideoResizeGet(GLenum);
  void    glutSetupVideoResizing();
  void    glutStopVideoResizing();
  void    glutVideoResize(int x, int y, int ширина, int высота);
  void    glutVideoPan(int x, int y, int ширина, int высота);
/*
 * Miscellaneous
 */

 void  glClearIndex( GLfloat к );
 void  glClearColor( GLclampf red, GLclampf green, GLclampf blue, GLclampf alpha );
 void  glClear( GLbitfield маска );
 void  glIndexMask( GLuint маска );
 void  glColorMask( GLboolean red, GLboolean green, GLboolean blue, GLboolean alpha );
 void  glAlphaFunc( GLenum func, GLclampf reference );
 void  glBlendFunc( GLenum sfactor, GLenum dfactor );
 void  glLogicOp( GLenum opcode );
 void  glCullFace( GLenum mode );
 void  glFrontFace( GLenum mode );
 void  glPointSize( GLfloat размер );
 void  glLineWidth( GLfloat ширина );
 void  glLineStipple( GLint factor, GLushort pattern );
 void  glPolygonMode( GLenum face, GLenum mode );
 void  glPolygonOffset( GLfloat factor, GLfloat units );
 void  glPolygonStipple(  GLubyte *маска );
 void  glGetPolygonStipple( GLubyte *маска );
 void  glEdgeFlag( GLboolean flag );
 void  glEdgeFlagv(  GLboolean *flag );
 void  glScissor( GLint x, GLint y, GLsizei ширина, GLsizei высота);
 void  glClipPlane( GLenum plane,  GLdouble *equation );
 void  glGetClipPlane( GLenum plane, GLdouble *equation );
 void  glDrawBuffer( GLenum mode );
 void  glReadBuffer( GLenum mode );
 void  glEnable( GLenum cap );
 void  glDisable( GLenum cap );
 GLboolean  glIsEnabled( GLenum cap );
 void  glEnableClientState( GLenum cap );  /* 1.1 */
 void  glDisableClientState( GLenum cap );  /* 1.1 */
 void  glGetBooleanv( GLenum pname, GLboolean *парамы );
 void  glGetDoublev( GLenum pname, GLdouble *парамы );
 void  glGetFloatv( GLenum pname, GLfloat *парамы );
 void  glGetIntegerv( GLenum pname, GLint *парамы );
 void  glPushAttrib( GLbitfield маска );
 void  glPopAttrib();
 void  glPushClientAttrib( GLbitfield маска );  /* 1.1 */
 void  glPopClientAttrib();  /* 1.1 */
 GLint  glRenderMode( GLenum mode );
 GLenum  glGetError();
  GLubyte *  glGetString( GLenum имя );
 void  glFinish();
 void  glFlush();
 void  glHint( GLenum цель, GLenum mode );

/*
 * Depth Buffer
 */

 void  glClearDepth( GLclampd глубина );
 void  glDepthFunc( GLenum func );
 void  glDepthMask( GLboolean flag );
 void  glDepthRange( GLclampd near_val, GLclampd far_val );

/*
 * Accumulation Buffer
 */

 void  glClearAccum( GLfloat red, GLfloat green, GLfloat blue, GLfloat alpha );
 void  glAccum( GLenum op, GLfloat value );

/*
 * Transformation
 */

 void  glMatrixMode( GLenum mode );
 void  glOrtho( GLdouble left, GLdouble right,
                                 GLdouble bottom, GLdouble верх,
                                 GLdouble near_val, GLdouble far_val );
 void  glFrustum( GLdouble left, GLdouble right,
                                   GLdouble bottom, GLdouble верх,
                                   GLdouble near_val, GLdouble far_val );
 void  glViewport( GLint x, GLint y,
                                    GLsizei ширина, GLsizei высота );
 void  glPushMatrix();
 void  glPopMatrix();
 void  glLoadIdentity();
 void  glLoadMatrixd(  GLdouble *m );
 void  glLoadMatrixf(  GLfloat *m );
 void  glMultMatrixd(  GLdouble *m );
 void  glMultMatrixf(  GLfloat *m );
 void  glRotated( GLdouble angle,
                                   GLdouble x, GLdouble y, GLdouble z );
 void  glRotatef( GLfloat angle,
                                   GLfloat x, GLfloat y, GLfloat z );
 void  glScaled( GLdouble x, GLdouble y, GLdouble z );
 void  glScalef( GLfloat x, GLfloat y, GLfloat z );
 void  glTranslated( GLdouble x, GLdouble y, GLdouble z );
 void  glTranslatef( GLfloat x, GLfloat y, GLfloat z );

/*
 * Display Lists
 */

 GLboolean  glIsList( GLuint list );
 void  glDeleteLists( GLuint list, GLsizei range );
 GLuint  glGenLists( GLsizei range );
 void  glNewList( GLuint list, GLenum mode );
 void  glEndList();
 void  glCallList( GLuint list );
 void  glCallLists( GLsizei n, GLenum тип,
                                      GLvoid *lists );
 void  glListBase( GLuint ова );


/*
 * Drawing Functions
 */

 void  glBegin( GLenum mode );
 void  glEnd();

 void  glVertex2d( GLdouble x, GLdouble y );
 void  glVertex2f( GLfloat x, GLfloat y );
 void  glVertex2i( GLint x, GLint y );
 void  glVertex2s( GLshort x, GLshort y );

 void  glVertex3d( GLdouble x, GLdouble y, GLdouble z );
 void  glVertex3f( GLfloat x, GLfloat y, GLfloat z );
 void  glVertex3i( GLint x, GLint y, GLint z );
 void  glVertex3s( GLshort x, GLshort y, GLshort z );

 void  glVertex4d( GLdouble x, GLdouble y, GLdouble z, GLdouble w );
 void  glVertex4f( GLfloat x, GLfloat y, GLfloat z, GLfloat w );
 void  glVertex4i( GLint x, GLint y, GLint z, GLint w );
 void  glVertex4s( GLshort x, GLshort y, GLshort z, GLshort w );

 void  glVertex2dv(  GLdouble *v );
 void  glVertex2fv(  GLfloat *v );
 void  glVertex2iv(  GLint *v );
 void  glVertex2sv(  GLshort *v );

 void  glVertex3dv(  GLdouble *v );
 void  glVertex3fv(  GLfloat *v );
 void  glVertex3iv(  GLint *v );
 void  glVertex3sv(  GLshort *v );

 void  glVertex4dv(  GLdouble *v );
 void  glVertex4fv(  GLfloat *v );
 void  glVertex4iv(  GLint *v );
 void  glVertex4sv(  GLshort *v );


 void  glNormal3b( GLbyte nx, GLbyte ny, GLbyte nz );
 void  glNormal3d( GLdouble nx, GLdouble ny, GLdouble nz );
 void  glNormal3f( GLfloat nx, GLfloat ny, GLfloat nz );
 void  glNormal3i( GLint nx, GLint ny, GLint nz );
 void  glNormal3s( GLshort nx, GLshort ny, GLshort nz );

 void  glNormal3bv(  GLbyte *v );
 void  glNormal3dv(  GLdouble *v );
 void  glNormal3fv(  GLfloat *v );
 void  glNormal3iv(  GLint *v );
 void  glNormal3sv(  GLshort *v );


 void  glIndexd( GLdouble к );
 void  glIndexf( GLfloat к );
 void  glIndexi( GLint к );
 void  glIndexs( GLshort к );
 void  glIndexub( GLubyte к );  /* 1.1 */

 void  glIndexdv(  GLdouble *к );
 void  glIndexfv(  GLfloat *к );
 void  glIndexiv(  GLint *к );
 void  glIndexsv(  GLshort *к );
 void  glIndexubv(  GLubyte *к );  /* 1.1 */

 void  glColor3b( GLbyte red, GLbyte green, GLbyte blue );
 void  glColor3d( GLdouble red, GLdouble green, GLdouble blue );
 void  glColor3f( GLfloat red, GLfloat green, GLfloat blue );
 void  glColor3i( GLint red, GLint green, GLint blue );
 void  glColor3s( GLshort red, GLshort green, GLshort blue );
 void  glColor3ub( GLubyte red, GLubyte green, GLubyte blue );
 void  glColor3ui( GLuint red, GLuint green, GLuint blue );
 void  glColor3us( GLushort red, GLushort green, GLushort blue );

 void  glColor4b( GLbyte red, GLbyte green,
                                   GLbyte blue, GLbyte alpha );
 void  glColor4d( GLdouble red, GLdouble green,
                                   GLdouble blue, GLdouble alpha );
 void  glColor4f( GLfloat red, GLfloat green,
                                   GLfloat blue, GLfloat alpha );
 void  glColor4i( GLint red, GLint green,
                                   GLint blue, GLint alpha );
 void  glColor4s( GLshort red, GLshort green,
                                   GLshort blue, GLshort alpha );
 void  glColor4ub( GLubyte red, GLubyte green,
                                    GLubyte blue, GLubyte alpha );
 void  glColor4ui( GLuint red, GLuint green,
                                    GLuint blue, GLuint alpha );
 void  glColor4us( GLushort red, GLushort green,
                                    GLushort blue, GLushort alpha );


 void  glColor3bv(  GLbyte *v );
 void  glColor3dv(  GLdouble *v );
 void  glColor3fv(  GLfloat *v );
 void  glColor3iv(  GLint *v );
 void  glColor3sv(  GLshort *v );
 void  glColor3ubv(  GLubyte *v );
 void  glColor3uiv(  GLuint *v );
 void  glColor3usv(  GLushort *v );

 void  glColor4bv(  GLbyte *v );
 void  glColor4dv(  GLdouble *v );
 void  glColor4fv(  GLfloat *v );
 void  glColor4iv(  GLint *v );
 void  glColor4sv(  GLshort *v );
 void  glColor4ubv(  GLubyte *v );
 void  glColor4uiv(  GLuint *v );
 void  glColor4usv(  GLushort *v );


 void  glTexCoord1d( GLdouble т );
 void  glTexCoord1f( GLfloat т );
 void  glTexCoord1i( GLint т );
 void  glTexCoord1s( GLshort т );

 void  glTexCoord2d( GLdouble т, GLdouble t );
 void  glTexCoord2f( GLfloat т, GLfloat t );
 void  glTexCoord2i( GLint т, GLint t );
 void  glTexCoord2s( GLshort т, GLshort t );

 void  glTexCoord3d( GLdouble т, GLdouble t, GLdouble r );
 void  glTexCoord3f( GLfloat т, GLfloat t, GLfloat r );
 void  glTexCoord3i( GLint т, GLint t, GLint r );
 void  glTexCoord3s( GLshort т, GLshort t, GLshort r );

 void  glTexCoord4d( GLdouble т, GLdouble t, GLdouble r, GLdouble q );
 void  glTexCoord4f( GLfloat т, GLfloat t, GLfloat r, GLfloat q );
 void  glTexCoord4i( GLint т, GLint t, GLint r, GLint q );
 void  glTexCoord4s( GLshort т, GLshort t, GLshort r, GLshort q );

 void  glTexCoord1dv(  GLdouble *v );
 void  glTexCoord1fv(  GLfloat *v );
 void  glTexCoord1iv(  GLint *v );
 void  glTexCoord1sv(  GLshort *v );

 void  glTexCoord2dv(  GLdouble *v );
 void  glTexCoord2fv(  GLfloat *v );
 void  glTexCoord2iv(  GLint *v );
 void  glTexCoord2sv(  GLshort *v );

 void  glTexCoord3dv(  GLdouble *v );
 void  glTexCoord3fv(  GLfloat *v );
 void  glTexCoord3iv(  GLint *v );
 void  glTexCoord3sv(  GLshort *v );

 void  glTexCoord4dv(  GLdouble *v );
 void  glTexCoord4fv(  GLfloat *v );
 void  glTexCoord4iv(  GLint *v );
 void  glTexCoord4sv(  GLshort *v );


 void  glRasterPos2d( GLdouble x, GLdouble y );
 void  glRasterPos2f( GLfloat x, GLfloat y );
 void  glRasterPos2i( GLint x, GLint y );
 void  glRasterPos2s( GLshort x, GLshort y );

 void  glRasterPos3d( GLdouble x, GLdouble y, GLdouble z );
 void  glRasterPos3f( GLfloat x, GLfloat y, GLfloat z );
 void  glRasterPos3i( GLint x, GLint y, GLint z );
 void  glRasterPos3s( GLshort x, GLshort y, GLshort z );

 void  glRasterPos4d( GLdouble x, GLdouble y, GLdouble z, GLdouble w );
 void  glRasterPos4f( GLfloat x, GLfloat y, GLfloat z, GLfloat w );
 void  glRasterPos4i( GLint x, GLint y, GLint z, GLint w );
 void  glRasterPos4s( GLshort x, GLshort y, GLshort z, GLshort w );

 void  glRasterPos2dv(  GLdouble *v );
 void  glRasterPos2fv(  GLfloat *v );
 void  glRasterPos2iv(  GLint *v );
 void  glRasterPos2sv(  GLshort *v );

 void  glRasterPos3dv(  GLdouble *v );
 void  glRasterPos3fv(  GLfloat *v );
 void  glRasterPos3iv(  GLint *v );
 void  glRasterPos3sv(  GLshort *v );

 void  glRasterPos4dv(  GLdouble *v );
 void  glRasterPos4fv(  GLfloat *v );
 void  glRasterPos4iv(  GLint *v );
 void  glRasterPos4sv(  GLshort *v );


 void  glRectd( GLdouble x1, GLdouble y1, GLdouble x2, GLdouble y2 );
 void  glRectf( GLfloat x1, GLfloat y1, GLfloat x2, GLfloat y2 );
 void  glRecti( GLint x1, GLint y1, GLint x2, GLint y2 );
 void  glRects( GLshort x1, GLshort y1, GLshort x2, GLshort y2 );


 void  glRectdv(  GLdouble *v1,  GLdouble *v2 );
 void  glRectfv(  GLfloat *v1,  GLfloat *v2 );
 void  glRectiv(  GLint *v1,  GLint *v2 );
 void  glRectsv(  GLshort *v1,  GLshort *v2 );

/*
 * Vertex Arrays  (1.1)
 */

 void  glVertexPointer( GLint размер, GLenum тип,
                                       GLsizei stride,  GLvoid *укз );

 void  glNormalPointer( GLenum тип, GLsizei stride,
                                        GLvoid *укз );

 void  glColorPointer( GLint размер, GLenum тип,
                                      GLsizei stride,  GLvoid *укз );

 void  glIndexPointer( GLenum тип, GLsizei stride,
                                       GLvoid *укз );

 void  glTexCoordPointer( GLint размер, GLenum тип,
                                         GLsizei stride,  GLvoid *укз );

 void  glEdgeFlagPointer( GLsizei stride,  GLvoid *укз );
 void  glGetPointerv( GLenum pname, GLvoid **парамы );
 void  glArrayElement( GLint и );
 void  glDrawArrays( GLenum mode, GLint first, GLsizei count );
 void  glDrawElements( GLenum mode, GLsizei count,
                                      GLenum тип,  GLvoid *indices );

 void  glInterleavedArrays( GLenum формат, GLsizei stride,
                                            GLvoid *pointer );

/*
 * Lighting
 */

 void  glShadeModel( GLenum mode );
 void  glLightf( GLenum light, GLenum pname, GLfloat param );
 void  glLighti( GLenum light, GLenum pname, GLint param );
 void  glLightfv( GLenum light, GLenum pname,
                                  GLfloat *парамы );
 void  glLightiv( GLenum light, GLenum pname,
                                  GLint *парамы );
 void  glGetLightfv( GLenum light, GLenum pname,
                                    GLfloat *парамы );
 void  glGetLightiv( GLenum light, GLenum pname,
                                    GLint *парамы );
 void  glLightModelf( GLenum pname, GLfloat param );
 void  glLightModeli( GLenum pname, GLint param );
 void  glLightModelfv( GLenum pname,  GLfloat *парамы );
 void  glLightModeliv( GLenum pname,  GLint *парамы );
 void  glMaterialf( GLenum face, GLenum pname, GLfloat param );
 void  glMateriali( GLenum face, GLenum pname, GLint param );
 void  glMaterialfv( GLenum face, GLenum pname,  GLfloat *парамы );
 void  glMaterialiv( GLenum face, GLenum pname,  GLint *парамы );
 void  glGetMaterialfv( GLenum face, GLenum pname, GLfloat *парамы );
 void  glGetMaterialiv( GLenum face, GLenum pname, GLint *парамы );
 void  glColorMaterial( GLenum face, GLenum mode );


/*
 * Raster functions
 */

 void  glPixelZoom( GLfloat xfactor, GLfloat yfactor );

 void  glPixelStoref( GLenum pname, GLfloat param );
 void  glPixelStorei( GLenum pname, GLint param );

 void  glPixelTransferf( GLenum pname, GLfloat param );
 void  glPixelTransferi( GLenum pname, GLint param );

 void  glPixelMapfv( GLenum map, GLsizei mapsize,
                                     GLfloat *values );
 void  glPixelMapuiv( GLenum map, GLsizei mapsize,
                                      GLuint *values );
 void  glPixelMapusv( GLenum map, GLsizei mapsize,
                                      GLushort *values );

 void  glGetPixelMapfv( GLenum map, GLfloat *values );
 void  glGetPixelMapuiv( GLenum map, GLuint *values );
 void  glGetPixelMapusv( GLenum map, GLushort *values );

 void  glBitmap( GLsizei ширина, GLsizei высота,
                                GLfloat xorig, GLfloat yorig,
                                GLfloat xmove, GLfloat ymove,
                                 GLubyte *bitmap );

 void  glReadPixels( GLint x, GLint y,
                                    GLsizei ширина, GLsizei высота,
                                    GLenum формат, GLenum тип,
                                    GLvoid *pixels );

 void  glDrawPixels( GLsizei ширина, GLsizei высота,
                                    GLenum формат, GLenum тип,
                                     GLvoid *pixels );

 void  glCopyPixels( GLint x, GLint y,
                                    GLsizei ширина, GLsizei высота,
                                    GLenum тип );

/*
 * Stenciling
 */

 void  glStencilFunc( GLenum func, GLint reference, GLuint маска );

 void  glStencilMask( GLuint маска );

 void  glStencilOp( GLenum fail, GLenum zfail, GLenum zpass );

 void  glClearStencil( GLint т );



/*
 * Texture mapping
 */

 void  glTexGend( GLenum coord, GLenum pname, GLdouble param );
 void  glTexGenf( GLenum coord, GLenum pname, GLfloat param );
 void  glTexGeni( GLenum coord, GLenum pname, GLint param );

 void  glTexGendv( GLenum coord, GLenum pname,  GLdouble *парамы );
 void  glTexGenfv( GLenum coord, GLenum pname,  GLfloat *парамы );
 void  glTexGeniv( GLenum coord, GLenum pname,  GLint *парамы );

 void  glGetTexGendv( GLenum coord, GLenum pname, GLdouble *парамы );
 void  glGetTexGenfv( GLenum coord, GLenum pname, GLfloat *парамы );
 void  glGetTexGeniv( GLenum coord, GLenum pname, GLint *парамы );


 void  glTexEnvf( GLenum цель, GLenum pname, GLfloat param );
 void  glTexEnvi( GLenum цель, GLenum pname, GLint param );

 void  glTexEnvfv( GLenum цель, GLenum pname,  GLfloat *парамы );
 void  glTexEnviv( GLenum цель, GLenum pname,  GLint *парамы );

 void  glGetTexEnvfv( GLenum цель, GLenum pname, GLfloat *парамы );
 void  glGetTexEnviv( GLenum цель, GLenum pname, GLint *парамы );


 void  glTexParameterf( GLenum цель, GLenum pname, GLfloat param );
 void  glTexParameteri( GLenum цель, GLenum pname, GLint param );

 void  glTexParameterfv( GLenum цель, GLenum pname,
                                           GLfloat *парамы );
 void  glTexParameteriv( GLenum цель, GLenum pname,
                                           GLint *парамы );

 void  glGetTexParameterfv( GLenum цель,
                                           GLenum pname, GLfloat *парамы);
 void  glGetTexParameteriv( GLenum цель,
                                           GLenum pname, GLint *парамы );

 void  glGetTexLevelParameterfv( GLenum цель, GLint уровень,
                                                GLenum pname, GLfloat *парамы );
 void  glGetTexLevelParameteriv( GLenum цель, GLint уровень,
                                                GLenum pname, GLint *парамы );


 void  glTexImage1D( GLenum цель, GLint уровень,
                                    GLint внутрФормат,
                                    GLsizei ширина, GLint border,
                                    GLenum формат, GLenum тип,
                                     GLvoid *pixels );

 void  glTexImage2D( GLenum цель, GLint уровень,
                                    GLint внутрФормат,
                                    GLsizei ширина, GLsizei высота,
                                    GLint border, GLenum формат, GLenum тип,
                                     GLvoid *pixels );

 void  glGetTexImage( GLenum цель, GLint уровень,
                                     GLenum формат, GLenum тип,
                                     GLvoid *pixels );


/* 1.1 functions */

 void  glGenTextures( GLsizei n, GLuint *textures );

 void  glDeleteTextures( GLsizei n,  GLuint *textures);

 void  glBindTexture( GLenum цель, GLuint texture );

 void  glPrioritizeTextures( GLsizei n,
                                             GLuint *textures,
                                             GLclampf *priorities );

 GLboolean  glAreTexturesResident( GLsizei n,
                                                   GLuint *textures,
                                                  GLboolean *residences );

 GLboolean  glIsTexture( GLuint texture );

 void  glTexSubImage1D( GLenum цель, GLint уровень,
                                       GLint xoffset,
                                       GLsizei ширина, GLenum формат,
                                       GLenum тип,  GLvoid *pixels );


 void  glTexSubImage2D( GLenum цель, GLint уровень,
                                       GLint xoffset, GLint yoffset,
                                       GLsizei ширина, GLsizei высота,
                                       GLenum формат, GLenum тип,
                                        GLvoid *pixels );

 void  glCopyTexImage1D( GLenum цель, GLint уровень,
                                        GLenum internalformat,
                                        GLint x, GLint y,
                                        GLsizei ширина, GLint border );

 void  glCopyTexImage2D( GLenum цель, GLint уровень,
                                        GLenum internalformat,
                                        GLint x, GLint y,
                                        GLsizei ширина, GLsizei высота,
                                        GLint border );

 void  glCopyTexSubImage1D( GLenum цель, GLint уровень,
                                           GLint xoffset, GLint x, GLint y,
                                           GLsizei ширина );

 void  glCopyTexSubImage2D( GLenum цель, GLint уровень,
                                           GLint xoffset, GLint yoffset,
                                           GLint x, GLint y,
                                           GLsizei ширина, GLsizei высота );


/*
 * Evaluators
 */

 void  glMap1d( GLenum цель, GLdouble u1, GLdouble u2,
                               GLint stride,
                               GLint order,  GLdouble *points );
 void  glMap1f( GLenum цель, GLfloat u1, GLfloat u2,
                               GLint stride,
                               GLint order,  GLfloat *points );

 void  glMap2d( GLenum цель,
		     GLdouble u1, GLdouble u2, GLint ustride, GLint uorder,
		     GLdouble v1, GLdouble v2, GLint vstride, GLint vorder,
		      GLdouble *points );
 void  glMap2f( GLenum цель,
		     GLfloat u1, GLfloat u2, GLint ustride, GLint uorder,
		     GLfloat v1, GLfloat v2, GLint vstride, GLint vorder,
		      GLfloat *points );

 void  glGetMapdv( GLenum цель, GLenum query, GLdouble *v );
 void  glGetMapfv( GLenum цель, GLenum query, GLfloat *v );
 void  glGetMapiv( GLenum цель, GLenum query, GLint *v );

 void  glEvalCoord1d( GLdouble u );
 void  glEvalCoord1f( GLfloat u );

 void  glEvalCoord1dv(  GLdouble *u );
 void  glEvalCoord1fv(  GLfloat *u );

 void  glEvalCoord2d( GLdouble u, GLdouble v );
 void  glEvalCoord2f( GLfloat u, GLfloat v );

 void  glEvalCoord2dv(  GLdouble *u );
 void  glEvalCoord2fv(  GLfloat *u );

 void  glMapGrid1d( GLint un, GLdouble u1, GLdouble u2 );
 void  glMapGrid1f( GLint un, GLfloat u1, GLfloat u2 );

 void  glMapGrid2d( GLint un, GLdouble u1, GLdouble u2,
                                   GLint vn, GLdouble v1, GLdouble v2 );
 void  glMapGrid2f( GLint un, GLfloat u1, GLfloat u2,
                                   GLint vn, GLfloat v1, GLfloat v2 );

 void  glEvalPoint1( GLint и );

 void  glEvalPoint2( GLint и, GLint j );

 void  glEvalMesh1( GLenum mode, GLint i1, GLint i2 );

 void  glEvalMesh2( GLenum mode, GLint i1, GLint i2, GLint j1, GLint j2 );


/*
 * Fog
 */

 void  glFogf( GLenum pname, GLfloat param );

 void  glFogi( GLenum pname, GLint param );

 void  glFogfv( GLenum pname,  GLfloat *парамы );

 void  glFogiv( GLenum pname,  GLint *парамы );


/*
 * Selection and Feedback
 */

 void  glFeedbackBuffer( GLsizei размер, GLenum тип, GLfloat *буфер );

 void  glPassThrough( GLfloat token );

 void  glSelectBuffer( GLsizei размер, GLuint *буфер );

 void  glInitNames();

 void  glLoadName( GLuint имя );

 void  glPushName( GLuint имя );

 void  glPopName();



/*
 * OpenGL 1.2
 */

 void  glDrawRangeElements( GLenum mode, GLuint start,
	GLuint end, GLsizei count, GLenum тип,  GLvoid *indices );

 void  glTexImage3D( GLenum цель, GLint уровень,
                                      GLint внутрФормат,
                                      GLsizei ширина, GLsizei высота,
                                      GLsizei глубина, GLint border,
                                      GLenum формат, GLenum тип,
                                       GLvoid *pixels );

 void  glTexSubImage3D( GLenum цель, GLint уровень,
                                         GLint xoffset, GLint yoffset,
                                         GLint zoffset, GLsizei ширина,
                                         GLsizei высота, GLsizei глубина,
                                         GLenum формат,
                                         GLenum тип,  GLvoid *pixels);

 void  glCopyTexSubImage3D( GLenum цель, GLint уровень,
                                             GLint xoffset, GLint yoffset,
                                             GLint zoffset, GLint x,
                                             GLint y, GLsizei ширина,
                                             GLsizei высота );

											 
 void  glColorTable( GLenum цель, GLenum internalformat,
                                    GLsizei ширина, GLenum формат,
                                    GLenum тип,  GLvoid *table );
 void  glColorSubTable( GLenum цель,
                                       GLsizei start, GLsizei count,
                                       GLenum формат, GLenum тип,
                                        GLvoid *данные );
 void  glColorTableParameteriv(GLenum цель, GLenum pname,
                                               GLint *парамы);
 void  glColorTableParameterfv(GLenum цель, GLenum pname,
                                               GLfloat *парамы);
 void  glCopyColorSubTable( GLenum цель, GLsizei start,
                                           GLint x, GLint y, GLsizei ширина );
 void  glCopyColorTable( GLenum цель, GLenum internalformat,
                                        GLint x, GLint y, GLsizei ширина );
 void  glGetColorTable( GLenum цель, GLenum формат,
                                       GLenum тип, GLvoid *table );
 void  glGetColorTableParameterfv( GLenum цель, GLenum pname,
                                                  GLfloat *парамы );
 void  glGetColorTableParameteriv( GLenum цель, GLenum pname,
                                                  GLint *парамы );
 void  glBlendEquation( GLenum mode );
 void  glBlendColor( GLclampf red, GLclampf green,
                                    GLclampf blue, GLclampf alpha );
 void  glHistogram( GLenum цель, GLsizei ширина,
				   GLenum internalformat, GLboolean sink );
 void  glResetHistogram( GLenum цель );
 void  glGetHistogram( GLenum цель, GLboolean reset,
				      GLenum формат, GLenum тип,
				      GLvoid *values );
 void  glGetHistogramParameterfv( GLenum цель, GLenum pname,
						 GLfloat *парамы );
 void  glGetHistogramParameteriv( GLenum цель, GLenum pname,
						 GLint *парамы );
 void  glMinmax( GLenum цель, GLenum internalformat,
				GLboolean sink );
 void  glResetMinmax( GLenum цель );
 void  glGetMinmax( GLenum цель, GLboolean reset,
                                   GLenum формат, GLenum типы,
                                   GLvoid *values );
 void  glGetMinmaxParameterfv( GLenum цель, GLenum pname,
					      GLfloat *парамы );
 void  glGetMinmaxParameteriv( GLenum цель, GLenum pname,
					      GLint *парамы );
 void  glConvolutionFilter1D( GLenum цель,
	GLenum internalformat, GLsizei ширина, GLenum формат, GLenum тип,
	 GLvoid *image );
 void  glConvolutionFilter2D( GLenum цель,
	GLenum internalformat, GLsizei ширина, GLsizei высота, GLenum формат,
	GLenum тип,  GLvoid *image );
 void  glConvolutionParameterf( GLenum цель, GLenum pname,
	GLfloat парамы );
 void  glConvolutionParameterfv( GLenum цель, GLenum pname,
	 GLfloat *парамы );
 void  glConvolutionParameteri( GLenum цель, GLenum pname,
	GLint парамы );
 void  glConvolutionParameteriv( GLenum цель, GLenum pname,
	 GLint *парамы );
 void  glCopyConvolutionFilter1D( GLenum цель,
	GLenum internalformat, GLint x, GLint y, GLsizei ширина );
 void  glCopyConvolutionFilter2D( GLenum цель,
	GLenum internalformat, GLint x, GLint y, GLsizei ширина,
	GLsizei высота);
 void  glGetConvolutionFilter( GLenum цель, GLenum формат,
	GLenum тип, GLvoid *image );
 void  glGetConvolutionParameterfv( GLenum цель, GLenum pname,
	GLfloat *парамы );
 void  glGetConvolutionParameteriv( GLenum цель, GLenum pname,
	GLint *парамы );
 void  glSeparableFilter2D( GLenum цель,
	GLenum internalformat, GLsizei ширина, GLsizei высота, GLenum формат,
	GLenum тип,  GLvoid *row,  GLvoid *column );

 void  glGetSeparableFilter( GLenum цель, GLenum формат,
	GLenum тип, GLvoid *row, GLvoid *column, GLvoid *span );


/*
 * OpenGL 1.3
 */

 void  glActiveTexture( GLenum texture );

 void  glClientActiveTexture( GLenum texture );

 void  glCompressedTexImage1D( GLenum цель, GLint уровень, GLenum internalformat, GLsizei ширина, GLint border, GLsizei imageSize,  GLvoid *данные );

 void  glCompressedTexImage2D( GLenum цель, GLint уровень, GLenum internalformat, GLsizei ширина, GLsizei высота, GLint border, GLsizei imageSize,  GLvoid *данные );

 void  glCompressedTexImage3D( GLenum цель, GLint уровень, GLenum internalformat, GLsizei ширина, GLsizei высота, GLsizei глубина, GLint border, GLsizei imageSize,  GLvoid *данные );

 void  glCompressedTexSubImage1D( GLenum цель, GLint уровень, GLint xoffset, GLsizei ширина, GLenum формат, GLsizei imageSize,  GLvoid *данные );

 void  glCompressedTexSubImage2D( GLenum цель, GLint уровень, GLint xoffset, GLint yoffset, GLsizei ширина, GLsizei высота, GLenum формат, GLsizei imageSize,  GLvoid *данные );

 void  glCompressedTexSubImage3D( GLenum цель, GLint уровень, GLint xoffset, GLint yoffset, GLint zoffset, GLsizei ширина, GLsizei высота, GLsizei глубина, GLenum формат, GLsizei imageSize,  GLvoid *данные );

 void  glGetCompressedTexImage( GLenum цель, GLint lod, GLvoid *img );

 void  glMultiTexCoord1d( GLenum цель, GLdouble т );

 void  glMultiTexCoord1dv( GLenum цель,  GLdouble *v );

 void  glMultiTexCoord1f( GLenum цель, GLfloat т );

 void  glMultiTexCoord1fv( GLenum цель,  GLfloat *v );

 void  glMultiTexCoord1i( GLenum цель, GLint т );

 void  glMultiTexCoord1iv( GLenum цель,  GLint *v );

 void  glMultiTexCoord1s( GLenum цель, GLshort т );

 void  glMultiTexCoord1sv( GLenum цель,  GLshort *v );

 void  glMultiTexCoord2d( GLenum цель, GLdouble т, GLdouble t );

 void  glMultiTexCoord2dv( GLenum цель,  GLdouble *v );

 void  glMultiTexCoord2f( GLenum цель, GLfloat т, GLfloat t );

 void  glMultiTexCoord2fv( GLenum цель,  GLfloat *v );

 void  glMultiTexCoord2i( GLenum цель, GLint т, GLint t );

 void  glMultiTexCoord2iv( GLenum цель,  GLint *v );

 void  glMultiTexCoord2s( GLenum цель, GLshort т, GLshort t );

 void  glMultiTexCoord2sv( GLenum цель,  GLshort *v );

 void  glMultiTexCoord3d( GLenum цель, GLdouble т, GLdouble t, GLdouble r );

 void  glMultiTexCoord3dv( GLenum цель,  GLdouble *v );

 void  glMultiTexCoord3f( GLenum цель, GLfloat т, GLfloat t, GLfloat r );

 void  glMultiTexCoord3fv( GLenum цель,  GLfloat *v );

 void  glMultiTexCoord3i( GLenum цель, GLint т, GLint t, GLint r );

 void  glMultiTexCoord3iv( GLenum цель,  GLint *v );

 void  glMultiTexCoord3s( GLenum цель, GLshort т, GLshort t, GLshort r );

 void  glMultiTexCoord3sv( GLenum цель,  GLshort *v );

 void  glMultiTexCoord4d( GLenum цель, GLdouble т, GLdouble t, GLdouble r, GLdouble q );

 void  glMultiTexCoord4dv( GLenum цель,  GLdouble *v );

 void  glMultiTexCoord4f( GLenum цель, GLfloat т, GLfloat t, GLfloat r, GLfloat q );

 void  glMultiTexCoord4fv( GLenum цель,  GLfloat *v );

 void  glMultiTexCoord4i( GLenum цель, GLint т, GLint t, GLint r, GLint q );

 void  glMultiTexCoord4iv( GLenum цель,  GLint *v );

 void  glMultiTexCoord4s( GLenum цель, GLshort т, GLshort t, GLshort r, GLshort q );

 void  glMultiTexCoord4sv( GLenum цель,  GLshort *v );


 void  glLoadTransposeMatrixd(  GLdouble m[16] );

 void  glLoadTransposeMatrixf(  GLfloat m[16] );

 void  glMultTransposeMatrixd(  GLdouble m[16] );

 void  glMultTransposeMatrixf(  GLfloat m[16] );

 void  glSampleCoverage( GLclampf value, GLboolean invert );

 
 void  glActiveTextureARB(GLenum texture);
 void  glClientActiveTextureARB(GLenum texture);
 void  glMultiTexCoord1dARB(GLenum цель, GLdouble т);
 void  glMultiTexCoord1dvARB(GLenum цель,  GLdouble *v);
 void  glMultiTexCoord1fARB(GLenum цель, GLfloat т);
 void  glMultiTexCoord1fvARB(GLenum цель,  GLfloat *v);
 void  glMultiTexCoord1iARB(GLenum цель, GLint т);
 void  glMultiTexCoord1ivARB(GLenum цель,  GLint *v);
 void  glMultiTexCoord1sARB(GLenum цель, GLshort т);
 void  glMultiTexCoord1svARB(GLenum цель,  GLshort *v);
 void  glMultiTexCoord2dARB(GLenum цель, GLdouble т, GLdouble t);
 void  glMultiTexCoord2dvARB(GLenum цель,  GLdouble *v);
 void  glMultiTexCoord2fARB(GLenum цель, GLfloat т, GLfloat t);
 void  glMultiTexCoord2fvARB(GLenum цель,  GLfloat *v);
 void  glMultiTexCoord2iARB(GLenum цель, GLint т, GLint t);
 void  glMultiTexCoord2ivARB(GLenum цель,  GLint *v);
 void  glMultiTexCoord2sARB(GLenum цель, GLshort т, GLshort t);
 void  glMultiTexCoord2svARB(GLenum цель,  GLshort *v);
 void  glMultiTexCoord3dARB(GLenum цель, GLdouble т, GLdouble t, GLdouble r);
 void  glMultiTexCoord3dvARB(GLenum цель,  GLdouble *v);
 void  glMultiTexCoord3fARB(GLenum цель, GLfloat т, GLfloat t, GLfloat r);
 void  glMultiTexCoord3fvARB(GLenum цель,  GLfloat *v);
 void  glMultiTexCoord3iARB(GLenum цель, GLint т, GLint t, GLint r);
 void  glMultiTexCoord3ivARB(GLenum цель,  GLint *v);
 void  glMultiTexCoord3sARB(GLenum цель, GLshort т, GLshort t, GLshort r);
 void  glMultiTexCoord3svARB(GLenum цель,  GLshort *v);
 void  glMultiTexCoord4dARB(GLenum цель, GLdouble т, GLdouble t, GLdouble r, GLdouble q);
 void  glMultiTexCoord4dvARB(GLenum цель,  GLdouble *v);
 void  glMultiTexCoord4fARB(GLenum цель, GLfloat т, GLfloat t, GLfloat r, GLfloat q);
 void  glMultiTexCoord4fvARB(GLenum цель,  GLfloat *v);
 void  glMultiTexCoord4iARB(GLenum цель, GLint т, GLint t, GLint r, GLint q);
 void  glMultiTexCoord4ivARB(GLenum цель,  GLint *v);
 void  glMultiTexCoord4sARB(GLenum цель, GLshort т, GLshort t, GLshort r, GLshort q);
 void  glMultiTexCoord4svARB(GLenum цель,  GLshort *v);
 
 
/* GLUT initialization sub-API. */

 void  glutInit(int *argcp, char **argv);
 void  glutInitDisplayMode(uint mode);

 void  glutInitWindowPosition(int x, int y);
 void  glutInitWindowSize(int ширина, int высота);
 void  glutMainLoop();

/* GLUT window sub-API. */
 int  glutCreateWindow( char *title);

 int  glutCreateSubWindow(int win, int x, int y, int ширина, int высота);
 void  glutDestroyWindow(int win);
 void  glutPostRedisplay();

 void  glutSwapBuffers();
 int  glutGetWindow();
 void  glutSetWindow(int win);
 void  glutSetWindowTitle( char *title);
 void  glutSetIconTitle( char *title);
 void  glutPositionWindow(int x, int y);
 void  glutReshapeWindow(int ширина, int высота);
 void  glutPopWindow();
 void  glutPushWindow();
 void  glutIconifyWindow();
 void  glutShowWindow();
 void  glutHideWindow();
 void glutFullScreen();
/* GLUT overlay sub-API. */
 void  glutEstablishOverlay();
 void  glutRemoveOverlay();
 void  glutUseLayer(GLenum layer);
 void  glutPostOverlayRedisplay();

/* GLUT menu sub-API. */
 int  glutCreateMenu(сифунк_Ц);

 void  glutDestroyMenu(int menu);
 int  glutGetMenu();
 void  glutSetMenu(int menu);
 void  glutAddMenuEntry( char *label, int value);
 void  glutAddSubMenu( char *label, int submenu);
 void  glutChangeToMenuEntry(int item,  char *label, int value);
 void  glutChangeToSubMenu(int item,  char *label, int submenu);
 void  glutRemoveMenuItem(int item);
 void  glutAttachMenu(int button);
 void  glutDetachMenu(int button);

/* GLUT window callback sub-API. */
 void  glutDisplayFunc(сифунк);
 void  glutReshapeFunc(сифунк_ЦЦ);
 void  glutKeyboardFunc(сифунк_СЦЦ);
 void  glutMouseFunc(сифунк_ЦЦЦЦ);
 void  glutMotionFunc(сифунк_ЦЦ);
 void  glutPassiveMotionFunc(сифунк_ЦЦ);
 void  glutEntryFunc(сифунк_Ц);
 void  glutVisibilityFunc(сифунк_Ц);
 void  glutIdleFunc(сифунк);
 void  glutTimerFunc(uint millis, сифунк_Ц, int value);
 void  glutMenuStateFunc(сифунк_Ц);


/* GLUT color index sub-API. */
 void  glutSetColor(int ndx, GLfloat red, GLfloat green, GLfloat blue);
 GLfloat  glutGetColor(int ndx, int component);
 void  glutCopyColormap(int win);

/* GLUT state retrieval sub-API. */
 int  glutGet(GLenum тип);
 int  glutDeviceGet(GLenum тип);


/* GLUT font sub-API */
 void  glutBitmapCharacter(ук font, int character);
 int  glutBitmapWidth(ук font, int character);
 void  glutStrokeCharacter(ук font, int character);
 int  glutStrokeWidth(ук font, int character);


/* GLUT pre-built models sub-API */
 void  glutWireSphere(GLdouble radius, GLint доли, GLint пачки);
 void  glutSolidSphere(GLdouble radius, GLint доли, GLint пачки);
 void  glutWireCone(GLdouble ова, GLdouble высота, GLint доли, GLint пачки);
 void  glutSolidCone(GLdouble ова, GLdouble высота, GLint доли, GLint пачки);
 void  glutWireCube(GLdouble размер);
 void  glutSolidCube(GLdouble размер);
 void  glutWireTorus(GLdouble innerRadius, GLdouble outerRadius, GLint sides, GLint rings);
 void  glutSolidTorus(GLdouble innerRadius, GLdouble outerRadius, GLint sides, GLint rings);
 void  glutWireDodecahedron();
 void  glutSolidDodecahedron();
 void  glutWireTeapot(GLdouble размер);
 void  glutSolidTeapot(GLdouble размер);
 void  glutWireOctahedron();
 void  glutSolidOctahedron();
 void  glutWireTetrahedron();
 void  glutSolidTetrahedron();
 void  glutWireIcosahedron();
 void  glutSolidIcosahedron();
 
 void glutInitDisplayString(GLchar* а);
 
 void glutPostWindowRedisplay(int win);
 void  glutWarpPointer(int x, int y);
  void  glutSetCursor(int cursor);
  void  glutPostWindowOverlayRedisplay(int win);
  void glutShowOverlay();
void  glutHideOverlay();

 void  glutSpecialFunc(сифунк_ЦЦЦ);
 void  glutSpaceballMotionFunc(сифунк_ЦЦЦ);
 void  glutSpaceballRotateFunc(сифунк_ЦЦЦ);
 void  glutSpaceballButtonFunc(сифунк_ЦЦ);
 void  glutButtonBoxFunc(сифунк_ЦЦ);
 void  glutDialsFunc(сифунк_ЦЦ);
 void  glutTabletMotionFunc(сифунк_ЦЦ);
 void  glutTabletButtonFunc(сифунк_ЦЦЦЦ);
 
 void  glutKeyboardUpFunc(сифунк_СЦЦ);
 void  glutSpecialUpFunc(сифунк_ЦЦЦ);
 void  glutJoystickFunc(сифунк_бЦЦЦЦ, int pollInterval);
 

}
/////////////////////////////////////////

void грузиОпенГл(Биб биб)
{
    вяжи(glClearIndex)("_glClearIndex", биб);
    вяжи(glClearColor)("glClearColor", биб);
    вяжи(glClear)("glClear", биб);
    вяжи(glIndexMask)("glIndexMask", биб);
    вяжи(glColorMask)("glColorMask", биб);
    вяжи(glAlphaFunc)("glAlphaFunc", биб);
    вяжи(glBlendFunc)("glBlendFunc", биб);
    вяжи(glLogicOp)("glLogicOp", биб);
    вяжи(glCullFace)("glCullFace", биб);
    вяжи(glFrontFace)("glFrontFace", биб);
    вяжи(glPointSize)("glPointSize", биб);
    вяжи(glLineWidth)("glLineWidth", биб);
    вяжи(glLineStipple)("glLineStipple", биб);
    вяжи(glPolygonMode)("glPolygonMode", биб);
    вяжи(glPolygonOffset)("glPolygonOffset", биб);
    вяжи(glPolygonStipple)("glPolygonStipple", биб);
    вяжи(glGetPolygonStipple)("glGetPolygonStipple", биб);
    вяжи(glEdgeFlag)("glEdgeFlag", биб);
    вяжи(glEdgeFlagv)("glEdgeFlagv", биб);
    вяжи(glScissor)("glScissor", биб);
    вяжи(glClipPlane)("glClipPlane", биб);
    вяжи(glGetClipPlane)("glGetClipPlane", биб);
    вяжи(glDrawBuffer)("glDrawBuffer", биб);
    вяжи(glReadBuffer)("glReadBuffer", биб);
    вяжи(glEnable)("glEnable", биб);
    вяжи(glDisable)("glDisable", биб);
    вяжи(glIsEnabled)("glIsEnabled", биб);
    вяжи(glEnableClientState)("glEnableClientState", биб);
    вяжи(glDisableClientState)("glDisableClientState", биб);
    вяжи(glGetBooleanv)("glGetBooleanv", биб);
    вяжи(glGetDoublev)("glGetDoublev", биб);
    вяжи(glGetFloatv)("glGetFloatv", биб);
    вяжи(glGetIntegerv)("glGetIntegerv", биб);
    вяжи(glPushAttrib)("glPushAttrib", биб);
    вяжи(glPopAttrib)("glPopAttrib", биб);
    вяжи(glPushClientAttrib)("glPushClientAttrib", биб);
    вяжи(glPopClientAttrib)("glPopClientAttrib", биб);
    вяжи(glRenderMode)("glRenderMode", биб);
    вяжи(glGetError)("glGetError", биб);
    вяжи(glGetString)("glGetString", биб);
    вяжи(glFinish)("glFinish", биб);
    вяжи(glFlush)("glFlush", биб);
    вяжи(glHint)("glHint", биб);
    вяжи(glClearDepth)("glClearDepth", биб);
    вяжи(glDepthFunc)("glDepthFunc", биб);
    вяжи(glDepthMask)("glDepthMask", биб);
    вяжи(glDepthRange)("glDepthRange", биб);
    вяжи(glClearAccum)("glClearAccum", биб);
    вяжи(glAccum)("glAccum", биб);
    вяжи(glMatrixMode)("glMatrixMode", биб);
    вяжи(glOrtho)("glOrtho", биб);
    вяжи(glFrustum)("glFrustum", биб);
    вяжи(glViewport)("glViewport", биб);
    вяжи(glPushMatrix)("glPushMatrix", биб);
    вяжи(glPopMatrix)("glPopMatrix", биб);
    вяжи(glLoadIdentity)("glLoadIdentity", биб);
    вяжи(glLoadMatrixd)("glLoadMatrixd", биб);
    вяжи(glLoadMatrixf)("glLoadMatrixf", биб);
    вяжи(glMultMatrixd)("glMultMatrixd", биб);
    вяжи(glMultMatrixf)("glMultMatrixf", биб);
    вяжи(glRotated)("glRotated", биб);
    вяжи(glRotatef)("glRotatef", биб);
    вяжи(glScaled)("glScaled", биб);
    вяжи(glScalef)("glScalef", биб);
    вяжи(glTranslated)("glTranslated", биб);
    вяжи(glTranslatef)("glTranslatef", биб);
    вяжи(glIsList)("glIsList", биб);
    вяжи(glDeleteLists)("glDeleteLists", биб);
    вяжи(glGenLists)("glGenLists", биб);
    вяжи(glNewList)("glNewList", биб);
    вяжи(glEndList)("glEndList", биб);
    вяжи(glCallList)("glCallList", биб);
    вяжи(glCallLists)("glCallLists", биб);
    вяжи(glListBase)("glListBase", биб);
    вяжи(glBegin)("glBegin", биб);
    вяжи(glEnd)("glEnd", биб);
    вяжи(glVertex2d)("glVertex2d", биб);
    вяжи(glVertex2f)("glVertex2f", биб);
    вяжи(glVertex2i)("glVertex2i", биб);
    вяжи(glVertex2s)("glVertex2s", биб);
    вяжи(glVertex3d)("glVertex3d", биб);
    вяжи(glVertex3f)("glVertex3f", биб);
    вяжи(glVertex3i)("glVertex3i", биб);
    вяжи(glVertex3s)("glVertex3s", биб);
    вяжи(glVertex4d)("glVertex4d", биб);
    вяжи(glVertex4f)("glVertex4f", биб);
    вяжи(glVertex4i)("glVertex4i", биб);
    вяжи(glVertex4s)("glVertex4s", биб);
    вяжи(glVertex2dv)("glVertex2dv", биб);
    вяжи(glVertex2fv)("glVertex2fv", биб);
    вяжи(glVertex2iv)("glVertex2iv", биб);
    вяжи(glVertex2sv)("glVertex2sv", биб);
    вяжи(glVertex3dv)("glVertex3dv", биб);
    вяжи(glVertex3fv)("glVertex3fv", биб);
    вяжи(glVertex3iv)("glVertex3iv", биб);
    вяжи(glVertex3sv)("glVertex3sv", биб);
    вяжи(glVertex4dv)("glVertex4dv", биб);
    вяжи(glVertex4fv)("glVertex4fv", биб);
    вяжи(glVertex4iv)("glVertex4iv", биб);
    вяжи(glVertex4sv)("glVertex4sv", биб);
    вяжи(glNormal3b)("glNormal3b", биб);
    вяжи(glNormal3d)("glNormal3d", биб);
    вяжи(glNormal3f)("glNormal3f", биб);
    вяжи(glNormal3i)("glNormal3i", биб);
    вяжи(glNormal3s)("glNormal3s", биб);
    вяжи(glNormal3bv)("glNormal3bv", биб);
    вяжи(glNormal3dv)("glNormal3dv", биб);
    вяжи(glNormal3fv)("glNormal3fv", биб);
    вяжи(glNormal3iv)("glNormal3iv", биб);
    вяжи(glNormal3sv)("glNormal3sv", биб);
    вяжи(glIndexd)("glIndexd", биб);
    вяжи(glIndexf)("glIndexf", биб);
    вяжи(glIndexi)("glIndexi", биб);
    вяжи(glIndexs)("glIndexs", биб);
    вяжи(glIndexub)("glIndexub", биб);
    вяжи(glIndexdv)("glIndexdv", биб);
    вяжи(glIndexfv)("glIndexfv", биб);
    вяжи(glIndexiv)("glIndexiv", биб);
    вяжи(glIndexsv)("glIndexsv", биб);
    вяжи(glIndexubv)("glIndexubv", биб);
    вяжи(glColor3b)("glColor3b", биб);
    вяжи(glColor3d)("glColor3d", биб);
    вяжи(glColor3f)("glColor3f", биб);
    вяжи(glColor3i)("glColor3i", биб);
    вяжи(glColor3s)("glColor3s", биб);
    вяжи(glColor3ub)("glColor3ub", биб);
    вяжи(glColor3ui)("glColor3ui", биб);
    вяжи(glColor3us)("glColor3us", биб);
    вяжи(glColor4b)("glColor4b", биб);
    вяжи(glColor4d)("glColor4d", биб);
    вяжи(glColor4f)("glColor4f", биб);
    вяжи(glColor4i)("glColor4i", биб);
    вяжи(glColor4s)("glColor4s", биб);
    вяжи(glColor4ub)("glColor4ub", биб);
    вяжи(glColor4ui)("glColor4ui", биб);
    вяжи(glColor4us)("glColor4us", биб);
    вяжи(glColor3bv)("glColor3bv", биб);
    вяжи(glColor3dv)("glColor3dv", биб);
    вяжи(glColor3fv)("glColor3fv", биб);
    вяжи(glColor3iv)("glColor3iv", биб);
    вяжи(glColor3sv)("glColor3sv", биб);
    вяжи(glColor3ubv)("glColor3ubv", биб);
    вяжи(glColor3uiv)("glColor3uiv", биб);
    вяжи(glColor3usv)("glColor3usv", биб);
    вяжи(glColor4bv)("glColor4bv", биб);
    вяжи(glColor4dv)("glColor4dv", биб);
    вяжи(glColor4fv)("glColor4fv", биб);
    вяжи(glColor4iv)("glColor4iv", биб);
    вяжи(glColor4sv)("glColor4sv", биб);
    вяжи(glColor4ubv)("glColor4ubv", биб);
    вяжи(glColor4uiv)("glColor4uiv", биб);
    вяжи(glColor4usv)("glColor4usv", биб);
    вяжи(glTexCoord1d)("glTexCoord1d", биб);
    вяжи(glTexCoord1f)("glTexCoord1f", биб);
    вяжи(glTexCoord1i)("glTexCoord1i", биб);
    вяжи(glTexCoord1s)("glTexCoord1s", биб);
    вяжи(glTexCoord2d)("glTexCoord2d", биб);
    вяжи(glTexCoord2f)("glTexCoord2f", биб);
    вяжи(glTexCoord2i)("glTexCoord2i", биб);
    вяжи(glTexCoord2s)("glTexCoord2s", биб);
    вяжи(glTexCoord3d)("glTexCoord3d", биб);
    вяжи(glTexCoord3f)("glTexCoord3f", биб);
    вяжи(glTexCoord3i)("glTexCoord3i", биб);
    вяжи(glTexCoord3s)("glTexCoord3s", биб);
    вяжи(glTexCoord4d)("glTexCoord4d", биб);
    вяжи(glTexCoord4f)("glTexCoord4f", биб);
    вяжи(glTexCoord4i)("glTexCoord4i", биб);
    вяжи(glTexCoord4s)("glTexCoord4s", биб);
    вяжи(glTexCoord1dv)("glTexCoord1dv", биб);
    вяжи(glTexCoord1fv)("glTexCoord1fv", биб);
    вяжи(glTexCoord1iv)("glTexCoord1iv", биб);
    вяжи(glTexCoord1sv)("glTexCoord1sv", биб);
    вяжи(glTexCoord2dv)("glTexCoord2dv", биб);
    вяжи(glTexCoord2fv)("glTexCoord2fv", биб);
    вяжи(glTexCoord2iv)("glTexCoord2iv", биб);
    вяжи(glTexCoord2sv)("glTexCoord2sv", биб);
    вяжи(glTexCoord3dv)("glTexCoord3dv", биб);
    вяжи(glTexCoord3fv)("glTexCoord3fv", биб);
    вяжи(glTexCoord3iv)("glTexCoord3iv", биб);
    вяжи(glTexCoord3sv)("glTexCoord3sv", биб);
    вяжи(glTexCoord4dv)("glTexCoord4dv", биб);
    вяжи(glTexCoord4fv)("glTexCoord4fv", биб);
    вяжи(glTexCoord4iv)("glTexCoord4iv", биб);
    вяжи(glTexCoord4sv)("glTexCoord4sv", биб);
    вяжи(glRasterPos2d)("glRasterPos2d", биб);
    вяжи(glRasterPos2f)("glRasterPos2f", биб);
    вяжи(glRasterPos2i)("glRasterPos2i", биб);
    вяжи(glRasterPos2s)("glRasterPos2s", биб);
    вяжи(glRasterPos3d)("glRasterPos3d", биб);
    вяжи(glRasterPos3f)("glRasterPos3f", биб);
    вяжи(glRasterPos3i)("glRasterPos3i", биб);
    вяжи(glRasterPos3s)("glRasterPos3s", биб);
    вяжи(glRasterPos4d)("glRasterPos4d", биб);
    вяжи(glRasterPos4f)("glRasterPos4f", биб);
    вяжи(glRasterPos4i)("glRasterPos4i", биб);
    вяжи(glRasterPos4s)("glRasterPos4s", биб);
    вяжи(glRasterPos2dv)("glRasterPos2dv", биб);
    вяжи(glRasterPos2fv)("glRasterPos2fv", биб);
    вяжи(glRasterPos2iv)("glRasterPos2iv", биб);
    вяжи(glRasterPos2sv)("glRasterPos2sv", биб);
    вяжи(glRasterPos3dv)("glRasterPos3dv", биб);
    вяжи(glRasterPos3fv)("glRasterPos3fv", биб);
    вяжи(glRasterPos3iv)("glRasterPos3iv", биб);
    вяжи(glRasterPos3sv)("glRasterPos3sv", биб);
    вяжи(glRasterPos4dv)("glRasterPos4dv", биб);
    вяжи(glRasterPos4fv)("glRasterPos4fv", биб);
    вяжи(glRasterPos4iv)("glRasterPos4iv", биб);
    вяжи(glRasterPos4sv)("glRasterPos4sv", биб);
    вяжи(glRectd)("glRectd", биб);
    вяжи(glRectf)("glRectf", биб);
    вяжи(glRecti)("glRecti", биб);
    вяжи(glRects)("glRects", биб);
    вяжи(glRectdv)("glRectdv", биб);
    вяжи(glRectfv)("glRectfv", биб);
    вяжи(glRectiv)("glRectiv", биб);
    вяжи(glRectsv)("glRectsv", биб);
    вяжи(glShadeModel)("glShadeModel", биб);
    вяжи(glLightf)("glLightf", биб);
    вяжи(glLighti)("glLighti", биб);
    вяжи(glLightfv)("glLightfv", биб);
    вяжи(glLightiv)("glLightiv", биб);
    вяжи(glGetLightfv)("glGetLightfv", биб);
    вяжи(glGetLightiv)("glGetLightiv", биб);
    вяжи(glLightModelf)("glLightModelf", биб);
    вяжи(glLightModeli)("glLightModeli", биб);
    вяжи(glLightModelfv)("glLightModelfv", биб);
    вяжи(glLightModeliv)("glLightModeliv", биб);
    вяжи(glMaterialf)("glMaterialf", биб);
    вяжи(glMateriali)("glMateriali", биб);
    вяжи(glMaterialfv)("glMaterialfv", биб);
    вяжи(glMaterialiv)("glMaterialiv", биб);
    вяжи(glGetMaterialfv)("glGetMaterialfv", биб);
    вяжи(glGetMaterialiv)("glGetMaterialiv", биб);
    вяжи(glColorMaterial)("glColorMaterial", биб);
    вяжи(glPixelZoom)("glPixelZoom", биб);
    вяжи(glPixelStoref)("glPixelStoref", биб);
    вяжи(glPixelStorei)("glPixelStorei", биб);
    вяжи(glPixelTransferf)("glPixelTransferf", биб);
    вяжи(glPixelTransferi)("glPixelTransferi", биб);
    вяжи(glPixelMapfv)("glPixelMapfv", биб);
    вяжи(glPixelMapuiv)("glPixelMapuiv", биб);
    вяжи(glPixelMapusv)("glPixelMapusv", биб);
    вяжи(glGetPixelMapfv)("glGetPixelMapfv", биб);
    вяжи(glGetPixelMapuiv)("glGetPixelMapuiv", биб);
    вяжи(glGetPixelMapusv)("glGetPixelMapusv", биб);
    вяжи(glBitmap)("glBitmap", биб);
    вяжи(glReadPixels)("glReadPixels", биб);
    вяжи(glDrawPixels)("glDrawPixels", биб);
    вяжи(glCopyPixels)("glCopyPixels", биб);
    вяжи(glStencilFunc)("glStencilFunc", биб);
    вяжи(glStencilMask)("glStencilMask", биб);
    вяжи(glStencilOp)("glStencilOp", биб);
    вяжи(glClearStencil)("glClearStencil", биб);
    вяжи(glTexGend)("glTexGend", биб);
    вяжи(glTexGenf)("glTexGenf", биб);
    вяжи(glTexGeni)("glTexGeni", биб);
    вяжи(glTexGendv)("glTexGendv", биб);
    вяжи(glTexGenfv)("glTexGenfv", биб);
    вяжи(glTexGeniv)("glTexGeniv", биб);
    вяжи(glTexEnvf)("glTexEnvf", биб);
    вяжи(glTexEnvi)("glTexEnvi", биб);
    вяжи(glTexEnvfv)("glTexEnvfv", биб);
    вяжи(glTexEnviv)("glTexEnviv", биб);
    вяжи(glGetTexEnvfv)("glGetTexEnvfv", биб);
    вяжи(glGetTexEnviv)("glGetTexEnviv", биб);
    вяжи(glTexParameterf)("glTexParameterf", биб);
    вяжи(glTexParameteri)("glTexParameteri", биб);
    вяжи(glTexParameterfv)("glTexParameterfv", биб);
    вяжи(glTexParameteriv)("glTexParameteriv", биб);
    вяжи(glGetTexParameterfv)("glGetTexParameterfv", биб);
    вяжи(glGetTexParameteriv)("glGetTexParameteriv", биб);
    вяжи(glGetTexLevelParameterfv)("glGetTexLevelParameterfv", биб);
    вяжи(glGetTexLevelParameteriv)("glGetTexLevelParameteriv", биб);
    вяжи(glTexImage1D)("glTexImage1D", биб);
    вяжи(glTexImage2D)("glTexImage2D", биб);
    вяжи(glGetTexImage)("glGetTexImage", биб);
    вяжи(glMap1d)("glMap1d", биб);
    вяжи(glMap1f)("glMap1f", биб);
    вяжи(glMap2d)("glMap2d", биб);
    вяжи(glMap2f)("glMap2f", биб);
    вяжи(glGetMapdv)("glGetMapdv", биб);
    вяжи(glGetMapfv)("glGetMapfv", биб);
    вяжи(glEvalCoord1d)("glEvalCoord1d", биб);
    вяжи(glEvalCoord1f)("glEvalCoord1f", биб);
    вяжи(glEvalCoord1dv)("glEvalCoord1dv", биб);
    вяжи(glEvalCoord1fv)("glEvalCoord1fv", биб);
    вяжи(glEvalCoord2d)("glEvalCoord2d", биб);
    вяжи(glEvalCoord2f)("glEvalCoord2f", биб);
    вяжи(glEvalCoord2dv)("glEvalCoord2dv", биб);
    вяжи(glEvalCoord2fv)("glEvalCoord2fv", биб);
    вяжи(glMapGrid1d)("glMapGrid1d", биб);
    вяжи(glMapGrid1f)("glMapGrid1f", биб);
    вяжи(glMapGrid2d)("glMapGrid2d", биб);
    вяжи(glMapGrid2f)("glMapGrid2f", биб);
    вяжи(glEvalPoint1)("glEvalPoint1", биб);
    вяжи(glEvalPoint2)("glEvalPoint2", биб);
    вяжи(glEvalMesh1)("glEvalMesh1", биб);
    вяжи(glEvalMesh2)("glEvalMesh2", биб);
    вяжи(glFogf)("glFogf", биб);
    вяжи(glFogi)("glFogi", биб);
    вяжи(glFogfv)("glFogfv", биб);
    вяжи(glFogiv)("glFogiv", биб);
    вяжи(glFeedbackBuffer)("glFeedbackBuffer", биб);
    вяжи(glPassThrough)("glPassThrough", биб);
    вяжи(glSelectBuffer)("glSelectBuffer", биб);
    вяжи(glInitNames)("glInitNames", биб);
    вяжи(glLoadName)("glLoadName", биб);
    вяжи(glPushName)("glPushName", биб);
    вяжи(glPopName)("glPopName", биб);
    // gl 1.1
    вяжи(glGenTextures)("glGenTextures", биб);
    вяжи(glDeleteTextures)("glDeleteTextures", биб);
    вяжи(glBindTexture)("glBindTexture", биб);
    вяжи(glPrioritizeTextures)("glPrioritizeTextures", биб);
    вяжи(glAreTexturesResident)("glAreTexturesResident", биб);
    вяжи(glIsTexture)("glIsTexture", биб);
    вяжи(glTexSubImage1D)("glTexSubImage1D", биб);
    вяжи(glTexSubImage2D)("glTexSubImage2D", биб);
    вяжи(glCopyTexImage1D)("glCopyTexImage1D", биб);
    вяжи(glCopyTexImage2D)("glCopyTexImage2D", биб);
    вяжи(glCopyTexSubImage1D)("glCopyTexSubImage1D", биб);
    вяжи(glCopyTexSubImage2D)("glCopyTexSubImage2D", биб);
    вяжи(glVertexPointer)("glVertexPointer", биб);
    вяжи(glNormalPointer)("glNormalPointer", биб);
    вяжи(glColorPointer)("glColorPointer", биб);
    вяжи(glIndexPointer)("glIndexPointer", биб);
    вяжи(glTexCoordPointer)("glTexCoordPointer", биб);
    вяжи(glEdgeFlagPointer)("glEdgeFlagPointer", биб);
    вяжи(glGetPointerv)("glGetPointerv", биб);
    вяжи(glArrayElement)("glArrayElement", биб);
    вяжи(glDrawArrays)("glDrawArrays", биб);
    вяжи(glDrawElements)("glDrawElements", биб);
    вяжи(glInterleavedArrays)("glInterleavedArrays", биб);
}

void грузиГлу(Биб биб)
{
    вяжи(gluBeginCurve)("gluBeginCurve", биб);
    вяжи(gluBeginPolygon)("gluBeginPolygon", биб);
    вяжи(gluBeginSurface)("gluBeginSurface", биб);
    вяжи(gluBeginTrim)("gluBeginTrim", биб);
    вяжи(gluBuild1DMipmaps)("gluBuild1DMipmaps", биб);
    вяжи(gluBuild2DMipmaps)("gluBuild2DMipmaps", биб);
    вяжи(gluCylinder)("gluCylinder", биб);
    вяжи(gluDeleteNurbsRenderer)("gluDeleteNurbsRenderer", биб);
    вяжи(gluDeleteQuadric)("gluDeleteQuadric", биб);
    вяжи(gluDeleteTess)("gluDeleteTess", биб);
    вяжи(gluDisk)("gluDisk", биб);
    вяжи(gluEndCurve)("gluEndCurve", биб);
    вяжи(gluEndPolygon)("gluEndPolygon", биб);
    вяжи(gluEndSurface)("gluEndSurface", биб);
    вяжи(gluEndTrim)("gluEndTrim", биб);
    вяжи(gluErrorString)("gluErrorString", биб);
    // вяжи(gluErrorUnicodeStringEXT)("gluErrorUnicodeStringEXT", биб); --> Windows only?
    вяжи(gluGetNurbsProperty)("gluGetNurbsProperty", биб);
    вяжи(gluGetString)("gluGetString", биб);
    вяжи(gluGetTessProperty)("gluGetTessProperty", биб);
    вяжи(gluLoadSamplingMatrices)("gluLoadSamplingMatrices", биб);
    вяжи(gluLookAt)("gluLookAt", биб);
    вяжи(gluNewNurbsRenderer)("gluNewNurbsRenderer", биб);
    вяжи(gluNewQuadric)("gluNewQuadric", биб);
    вяжи(gluNewTess)("gluNewTess", биб);
    вяжи(gluNextContour)("gluNextContour", биб);
    вяжи(gluNurbsCallback)("gluNurbsCallback", биб);
    вяжи(gluNurbsCurve)("gluNurbsCurve", биб);
    вяжи(gluNurbsProperty)("gluNurbsProperty", биб);
    вяжи(gluNurbsSurface)("gluNurbsSurface", биб);
    вяжи(gluOrtho2D)("gluOrtho2D", биб);
    вяжи(gluPartialDisk)("gluPartialDisk", биб);
    вяжи(gluPerspective)("gluPerspective", биб);
    вяжи(gluPickMatrix)("gluPickMatrix", биб);
    вяжи(gluProject)("gluProject", биб);
    вяжи(gluPwlCurve)("gluPwlCurve", биб);
    вяжи(gluQuadricCallback)("gluQuadricCallback", биб);
    вяжи(gluQuadricDrawStyle)("gluQuadricDrawStyle", биб);
    вяжи(gluQuadricNormals)("gluQuadricNormals", биб);
    вяжи(gluQuadricOrientation)("gluQuadricOrientation", биб);
    вяжи(gluQuadricTexture)("gluQuadricTexture", биб);
    вяжи(gluScaleImage)("gluScaleImage", биб);
    вяжи(gluSphere)("gluSphere", биб);
    вяжи(gluTessBeginContour)("gluTessBeginContour", биб);
    вяжи(gluTessBeginPolygon)("gluTessBeginPolygon", биб);
    вяжи(gluTessCallback)("gluTessCallback", биб);
    вяжи(gluTessEndContour)("gluTessEndContour", биб);
    вяжи(gluTessEndPolygon)("gluTessEndPolygon", биб);
    вяжи(gluTessNormal)("gluTessNormal", биб);
    вяжи(gluTessProperty)("gluTessProperty", биб);
    вяжи(gluTessVertex)("gluTessVertex", биб);
    вяжи(gluUnProject)("gluUnProject", биб);
//    вяжи(gluUnProject4)("gluUnProject4", биб); --> OpenGL 1.3 function, extremely rare in the wild
}

private void грузиГлут(Биб биб)
{
	вяжи(glutInit)("glutInit", биб);
	вяжи(glutInitWindowPosition)("glutInitWindowPosition", биб);
	вяжи(glutInitWindowSize)("glutInitWindowSize", биб);
	вяжи(glutInitDisplayMode)("glutInitDisplayMode", биб);
	вяжи(glutInitDisplayString)("glutInitDisplayString", биб);
	вяжи(glutMainLoop)("glutMainLoop", биб);
	вяжи(glutCreateWindow)("glutCreateWindow", биб);
	вяжи(glutCreateSubWindow)("glutCreateSubWindow", биб);
	вяжи(glutDestroyWindow)("glutDestroyWindow", биб);
	вяжи(glutSetWindow)("glutSetWindow", биб);
	вяжи(glutGetWindow)("glutGetWindow", биб);
	вяжи(glutSetWindowTitle)("glutSetWindowTitle", биб);
	вяжи(glutSetIconTitle)("glutSetIconTitle", биб);
	вяжи(glutReshapeWindow)("glutReshapeWindow", биб);
	вяжи(glutPositionWindow)("glutPositionWindow", биб);
	вяжи(glutShowWindow)("glutShowWindow", биб);
	вяжи(glutHideWindow)("glutHideWindow", биб);
	вяжи(glutIconifyWindow)("glutIconifyWindow", биб);
	вяжи(glutPushWindow)("glutPushWindow", биб);
	вяжи(glutPopWindow)("glutPopWindow", биб);
	вяжи(glutFullScreen)("glutFullScreen", биб);
	вяжи(glutPostWindowRedisplay)("glutPostWindowRedisplay", биб);
	вяжи(glutPostRedisplay)("glutPostRedisplay", биб);
	вяжи(glutSwapBuffers)("glutSwapBuffers", биб);
	вяжи(glutWarpPointer)("glutWarpPointer", биб);
	вяжи(glutSetCursor)("glutSetCursor", биб);
	вяжи(glutEstablishOverlay)("glutEstablishOverlay", биб);
	вяжи(glutRemoveOverlay)("glutRemoveOverlay", биб);
	вяжи(glutUseLayer)("glutUseLayer", биб);
	вяжи(glutPostOverlayRedisplay)("glutPostOverlayRedisplay", биб);
	вяжи(glutPostWindowOverlayRedisplay)("glutPostWindowOverlayRedisplay", биб);
	вяжи(glutHideOverlay)("glutHideOverlay", биб);
	вяжи(glutCreateMenu)("glutCreateMenu", биб);
	вяжи(glutDestroyMenu)("glutDestroyMenu", биб);
	вяжи(glutGetMenu)("glutGetMenu", биб);
	вяжи(glutSetMenu)("glutSetMenu", биб);
	вяжи(glutAddMenuEntry)("glutAddMenuEntry", биб);
	вяжи(glutAddSubMenu)("glutAddSubMenu", биб);
	вяжи(glutChangeToMenuEntry)("glutChangeToMenuEntry", биб);
	вяжи(glutChangeToSubMenu)("glutChangeToSubMenu", биб);
	вяжи(glutRemoveMenuItem)("glutRemoveMenuItem", биб);
	вяжи(glutAttachMenu)("glutAttachMenu", биб);
	вяжи(glutDetachMenu)("glutDetachMenu", биб);
	вяжи(glutTimerFunc)("glutTimerFunc", биб);
	вяжи(glutIdleFunc)("glutIdleFunc", биб);
	вяжи(glutKeyboardFunc)("glutKeyboardFunc", биб);
	вяжи(glutSpecialFunc)("glutSpecialFunc", биб);
	вяжи(glutReshapeFunc)("glutReshapeFunc", биб);
	вяжи(glutVisibilityFunc)("glutVisibilityFunc", биб);
	вяжи(glutDisplayFunc)("glutDisplayFunc", биб);
	вяжи(glutMouseFunc)("glutMouseFunc", биб);
	вяжи(glutMotionFunc)("glutMotionFunc", биб);
	вяжи(glutPassiveMotionFunc)("glutPassiveMotionFunc", биб);
	вяжи(glutEntryFunc)("glutEntryFunc", биб);
	вяжи(glutKeyboardUpFunc)("glutKeyboardUpFunc", биб);
	вяжи(glutSpecialUpFunc)("glutSpecialUpFunc", биб);
	вяжи(glutJoystickFunc)("glutJoystickFunc", биб);
	вяжи(glutMenuStateFunc)("glutMenuStateFunc", биб);
	вяжи(glutMenuStatusFunc)("glutMenuStatusFunc", биб);
	вяжи(glutOverlayDisplayFunc)("glutOverlayDisplayFunc", биб);
	вяжи(glutWindowStatusFunc)("glutWindowStatusFunc", биб);
	вяжи(glutSpaceballMotionFunc)("glutSpaceballMotionFunc", биб);
	вяжи(glutSpaceballRotateFunc)("glutSpaceballRotateFunc", биб);
	вяжи(glutSpaceballButtonFunc)("glutSpaceballButtonFunc", биб);
	вяжи(glutButtonBoxFunc)("glutButtonBoxFunc", биб);
	вяжи(glutDialsFunc)("glutDialsFunc", биб);
	вяжи(glutTabletMotionFunc)("glutTabletMotionFunc", биб);
	вяжи(glutTabletButtonFunc)("glutTabletButtonFunc", биб);
	вяжи(glutGet)("glutGet", биб);
	вяжи(glutDeviceGet)("glutDeviceGet", биб);
	вяжи(glutGetModifiers)("glutGetModifiers", биб);
	вяжи(glutLayerGet)("glutLayerGet", биб);
	вяжи(glutBitmapCharacter)("glutBitmapCharacter", биб);
	вяжи(glutBitmapWidth)("glutBitmapWidth", биб);
	вяжи(glutStrokeCharacter)("glutStrokeCharacter", биб);
	вяжи(glutStrokeWidth)("glutStrokeWidth", биб);
	вяжи(glutBitmapLength)("glutBitmapLength", биб);
	вяжи(glutStrokeLength)("glutStrokeLength", биб);
	вяжи(glutWireCube)("glutWireCube", биб);
	вяжи(glutSolidCube)("glutSolidCube", биб);
	вяжи(glutWireSphere)("glutWireSphere", биб);
	вяжи(glutSolidSphere)("glutSolidSphere", биб);
	вяжи(glutWireCone)("glutWireCone", биб);
	вяжи(glutSolidCone)("glutSolidCone", биб);
	вяжи(glutWireTorus)("glutWireTorus", биб);
	вяжи(glutSolidTorus)("glutSolidTorus", биб);
	вяжи(glutWireDodecahedron)("glutWireDodecahedron", биб);
	вяжи(glutSolidDodecahedron)("glutSolidDodecahedron", биб);
	вяжи(glutWireOctahedron)("glutWireOctahedron", биб);
	вяжи(glutSolidOctahedron)("glutSolidOctahedron", биб);
	вяжи(glutWireTetrahedron)("glutWireTetrahedron", биб);
	вяжи(glutSolidTetrahedron)("glutSolidTetrahedron", биб);
	вяжи(glutWireIcosahedron)("glutWireIcosahedron", биб);
	вяжи(glutSolidIcosahedron)("glutSolidIcosahedron", биб);
	вяжи(glutWireTeapot)("glutWireTeapot", биб);
	вяжи(glutSolidTeapot)("glutSolidTeapot", биб);
	вяжи(glutGameModeString)("glutGameModeString", биб);
	вяжи(glutEnterGameMode)("glutEnterGameMode", биб);
	вяжи(glutLeaveGameMode)("glutLeaveGameMode", биб);
	вяжи(glutGameModeGet)("glutGameModeGet", биб);
	вяжи(glutVideoResizeGet)("glutVideoResizeGet", биб);
	вяжи(glutSetupVideoResizing)("glutSetupVideoResizing", биб);
	вяжи(glutStopVideoResizing)("glutStopVideoResizing", биб);
	вяжи(glutVideoResize)("glutVideoResize", биб);
	вяжи(glutVideoPan)("glutVideoPan", биб);
	вяжи(glutSetColor)("glutSetColor", биб);
	вяжи(glutGetColor)("glutGetColor", биб);
	вяжи(glutCopyColormap)("glutCopyColormap", биб);
	вяжи(glutIgnoreKeyRepeat)("glutIgnoreKeyRepeat", биб);
	вяжи(glutSetKeyRepeat)("glutSetKeyRepeat", биб);
	вяжи(glutForceJoystickFunc)("glutForceJoystickFunc", биб);
	вяжи(glutExtensionSupported)("glutExtensionSupported", биб);
	вяжи(glutReportErrors)("glutReportErrors", биб);

	version (FREEGLUT_EXTRAS)
	{
		вяжи(glutMainLoopEvent)("glutMainLoopEvent", биб);
		вяжи(glutLeaveMainLoop)("glutLeaveMainLoop", биб);
		вяжи(glutMouseWheelFunc)("glutMouseWheelFunc", биб);
		вяжи(glutCloseFunc)("glutCloseFunc", биб);
		вяжи(glutWMCloseFunc)("glutWMCloseFunc", биб);
		вяжи(glutMenuDestroyFunc)("glutMenuDestroyFunc", биб);
		вяжи(glutSetOption)("glutSetOption", биб);
		вяжи(glutGetWindowData)("glutGetWindowData", биб);
		вяжи(glutSetWindowData)("glutSetWindowData", биб);
		вяжи(glutGetMenuData)("glutGetMenuData", биб);
		вяжи(glutSetMenuData)("glutSetMenuData", биб);
		вяжи(glutBitmapHeight)("glutBitmapHeight", биб);
		вяжи(glutStrokeHeight)("glutStrokeHeight", биб);
		вяжи(glutBitmapString)("glutBitmapString", биб);
		вяжи(glutStrokeString)("glutStrokeString", биб);
		вяжи(glutWireRhombicDodecahedron)("glutWireRhombicDodecahedron", биб);
		вяжи(glutSolidRhombicDodecahedron)("glutSolidRhombicDodecahedron", биб);
		вяжи(glutWireSierpinskiSponge)("glutWireSierpinskiSponge", биб);
		вяжи(glutSolidSierpinskiSponge)("glutSolidSierpinskiSponge", биб);
		вяжи(glutWireCylinder)("glutWireCylinder", биб);
		вяжи(glutSolidCylinder)("glutSolidCylinder", биб);
		вяжи(glutGetProcAddress)("glutGetProcAddress", биб);
	}
}

ЖанБибгр ОпенГл;
ЖанБибгр Глу;
ЖанБибгр Глут;
static this() {
    ОпенГл.заряжай("OpenGl32.dll", &грузиОпенГл );
	ОпенГл.загружай();
	 Глу.заряжай("Glu32.dll", &грузиГлу );
	Глу.загружай();
	Глут.заряжай("Glut32.dll", &грузиГлут );
	Глут.загружай();
}
/////////////////////////////////////////////////////////////////
export extern(D)
{

    void глОчистиИндекс(плав а) {glClearIndex(cast(GLfloat) а);}
    void глЦветОчистки(Гклампп а,Гклампп б,Гклампп в,Гклампп г) { glClearColor(cast(GLclampf) а, cast(GLclampf) б, cast(GLclampf) в, cast(GLclampf) г);}
    void глОчисти(Гбитполе а) {glClear(cast(GLbitfield) а);}
    void глМаскаИндекса(бцел а) { glIndexMask(cast(GLuint) а);}
    void глМаскаЦвета(Гбул а,Гбул б,Гбул в,Гбул г){ glColorMask(cast(GLboolean) а, cast(GLboolean) б,cast(GLboolean) в,cast(GLboolean) г);}
    void глФункцАльфы(Гперечень а,Гклампп б){ glAlphaFunc(cast(GLenum) а,cast(GLclampf) б);}
    void глФункцСмеси(Гперечень а,Гперечень б){ glBlendFunc(cast(GLenum) а, cast(GLenum) б);}
    void глЛогическаяОп(Гперечень а){ glLogicOp(cast(GLenum) а);}
    void глПрофиль(Гперечень а){ glCullFace(cast(GLenum) а);}
    void глФас(Гперечень а){ glFrontFace(cast(GLenum) а);}
    void глРазмерТочки(плав а){ glPointSize(cast(GLfloat) а);}
    void глШиринаЛинии(плав а){ glLineWidth(cast(GLfloat) а);}
    void глПолоскаЛиний(цел а,бкрат б){ glLineStipple(cast(GLint) а, cast(GLushort) б);}
    void глРежимМногоуг(Гперечень а,Гперечень б){ glPolygonMode(cast(GLenum) а,cast(GLenum) б);}
    void глСмещениеМногоуг(плав а,плав б){ glPolygonOffset(cast(GLfloat) а,cast(GLfloat) б);}
    void глПолоскаМногоуг(ббайт* а){ glPolygonStipple(cast(GLubyte*) а);}
    void глДайПолоскуМногоуг(ббайт* а){ glGetPolygonStipple(cast(GLubyte*) а);}
    void глФлагКрая(Гбул а){ glEdgeFlag(cast(GLboolean) а);}
    void глФлагКрая(Гбул* а){glEdgeFlagv(cast(GLboolean*) а);}
    void глНожницы(цел а,цел б,Гцразм в,Гцразм г){ glScissor(cast(GLint) а, cast(GLint) б,cast(GLsizei) в,cast(GLsizei) г);}
    void глОПлоскостьОбрезки(Гперечень а,дво* б) {glClipPlane(cast(GLenum) а, cast(GLdouble*) б);}
    void глДайПлоскостьОбрезки(Гперечень а,дво* б){ glGetClipPlane(cast(GLenum) а,cast(GLdouble*) б);}
    void глБуфРис(Гперечень а){ glDrawBuffer(cast(GLenum) а);}
    void глБуфЧтения(Гперечень а){ glReadBuffer(cast(GLenum) а);}
    void глВключи(Гперечень а){ glEnable(cast(GLenum) а);}
    void глОтключи(Гперечень а){ glDisable(cast(GLenum) а);}
    Гбул  глВключен_ли(Гперечень а){return cast(Гбул)  glIsEnabled(cast(GLenum) а);}
    void глВключиСостояниеКлиента(Гперечень а){ glEnableClientState(cast(GLenum) а);}
    void глОтключиСостояниеКлиента(Гперечень а){ glDisableClientState(cast(GLenum) а);}
    void глДайБул(Гперечень а,Гбул* б){ glGetBooleanv(cast(GLenum) а,cast(GLboolean*) б);}
    void глДайДво(Гперечень а,дво* б){ glGetDoublev(cast(GLenum) а, cast(GLdouble*) б);}
    void глДайПлав(Гперечень а,плав* б){ glGetFloatv(cast(GLenum) а,cast(GLfloat*) б);}
    void глДайЦел(Гперечень а,цел* б){ glGetIntegerv(cast(GLenum) а,cast(GLint*) б);}
    void глСуньАтриб(Гбитполе а){ glPushAttrib(cast(GLbitfield) а);}
    void глВыньАтриб(){ glPopAttrib();}
    void глСуньАтрибКлиента(Гбитполе а){ glPushClientAttrib(cast(GLbitfield) а);}
    void глВыньАтрибКлиента() {glPopClientAttrib();}
    цел глРежимОтображения(Гперечень а){return cast(цел) glRenderMode(cast(GLenum) а);}
    Гперечень глДайОшибку(){return cast(Гперечень)  glGetError();}
    сим* глДайТекст(Гперечень а){return cast(сим*)  glGetString(cast(GLenum) а);}
    void глФиниш(){ glFinish();}
    void глСлей(){ glFlush();}
    void глПодсказка(Гперечень а,Гперечень б){ glHint(cast(GLenum) а, cast(GLenum) б);}

    void глОчистиДаль(Гклампд а){ glClearDepth(cast(GLclampd) а);}
    void глФункцДали(Гперечень а){ glDepthFunc(cast(GLenum) а);}
    void глМаскаДали(Гбул а){ glDepthMask(cast(GLboolean) а);}
    void глДиапазонДали(Гклампд а,Гклампд б){ glDepthRange(cast(GLclampd) а,cast(GLclampd) б);}

    void глОчистиАккум(плав а,плав б,плав в,плав г){ glClearAccum(cast(GLfloat) а, cast(GLfloat) б,cast(GLfloat) в, cast(GLfloat) г);}
    void глАккум(Гперечень а,плав б){ glAccum(cast(GLenum) а, cast(GLfloat) б);}

    void глРежимМатр(Гперечень а){ glMatrixMode(cast(GLenum) а);}
    void глОрто(дво а,дво б,дво в,дво г,дво д,дво е){ glOrtho(cast(GLdouble) а,cast(GLdouble) б,cast(GLdouble) в,cast(GLdouble) г,cast(GLdouble) д, cast(GLdouble) е);}
    void глФруструм(дво а,дво б,дво в,дво г,дво д,дво е){ glFrustum(cast(GLdouble) а,cast(GLdouble) б,cast(GLdouble) в,cast(GLdouble) г,cast(GLdouble) д,cast(GLdouble) е);}
    void глВьюпорт(цел а,цел б,Гцразм в,Гцразм г){ glViewport(cast(GLint) а, cast(GLint) б, в, г);}
    void глСуньМатр(){ glPushMatrix();}
    void глВыньМатр(){ glPopMatrix();}
    void глЗагрузиИдент() {glLoadIdentity();}
    void глЗагрузиМатр(дво* а) {glLoadMatrixd(cast(GLdouble*) а);}
    void глЗагрузиМатр(плав* а){ glLoadMatrixf(cast(GLfloat*) а);}
    void глУмножьМатр(дво* а){ glMultMatrixd(cast(GLdouble*) а);}
    void глУмножьМатр(плав* а){ glMultMatrixf(cast(GLfloat*) а);}
    void глВращайд(дво а,дво б,дво в,дво г){ glRotated(cast(GLdouble) а,cast(GLdouble)  б,cast(GLdouble)  в,cast(GLdouble)  г);}
    void глВращай(плав а,плав б,плав в,плав г){ glRotatef(cast(GLfloat) а, cast(GLfloat) б, cast(GLfloat) в, cast(GLfloat) г);}
    void глМасштабируйд(дво а,дво б,дво в){ glScaled(cast(GLdouble) а,cast(GLdouble)  б,cast(GLdouble)  в);}
    void глМасштабируй(плав а,плав б,плав в){ glScalef(cast(GLfloat) а, cast(GLfloat) б, cast(GLfloat) в);}
    void глПеренесид(дво а,дво б,дво в){ glTranslated(cast(GLdouble) а,cast(GLdouble)  б,cast(GLdouble)  в);}
    void глПеренеси(плав а,плав б,плав в){ glTranslatef(cast(GLfloat) а, cast(GLfloat) б,cast(GLfloat)  в);}

    Гбул  глСписок_ли(бцел а){return cast(Гбул)  glIsList(а);}
    void глУдалиСписки(бцел а,Гцразм б){ glDeleteLists(а, б);}
    бцел глГенСписки(Гцразм а){return  cast(бцел) glGenLists(а);}
    void глНовСписок(бцел а,Гперечень б){ glNewList(а, cast(GLenum) б);}
    void глКонецСписка(){ glEndList();}
    void глВызовиСписок(бцел а){ glCallList(а);}
    void глВызовиСписки(Гцразм а,Гперечень б,ук в){ glCallLists(а, cast(GLenum) б, в);}
    void глОваСписка(бцел а){ glListBase(а);}

    void глНачни(Гперечень а){ glBegin(cast(GLenum) а);}
    void глСтоп(){ glEnd();}
    void глВершинад(дво а,дво б){ glVertex2d(cast(GLdouble) а,cast(GLdouble)  б);}
    void глВершина(плав а,плав б){ glVertex2f(cast(GLfloat) а,cast(GLfloat) б);}
    void глВершина(цел а,цел б){ glVertex2i(а, б);}
    void глВершина(крат а,крат б){ glVertex2s(а, б);}
    void глВершинад(дво а,дво б,дво в){ glVertex3d(cast(GLdouble) а,cast(GLdouble)  б,cast(GLdouble)  в);}
    void глВершина(плав а,плав б,плав в){ glVertex3f(cast(GLfloat) а, cast(GLfloat) б, cast(GLfloat) в);}
    void глВершина(цел а,цел б,цел в){ glVertex3i(а, б, в);}
    void глВершина(крат а,крат б,крат в){ glVertex3s(а, б, в);}
    void глВершинад(дво а,дво б,дво в,дво г){ glVertex4d(cast(GLdouble) а,cast(GLdouble)  б,cast(GLdouble)  в,cast(GLdouble)  г);}
    void глВершина(плав а,плав б,плав в,плав г){ glVertex4f(cast(GLfloat) а, cast(GLfloat) б, cast(GLfloat) в, cast(GLfloat) г);}
    void глВершина(цел а,цел б,цел в,цел г){ glVertex4i(а, б, в, г);}
    void глВершина(крат а,крат б,крат в,крат г){ glVertex4s(а, б, в, г);}
    void глВершина2(дво* а) {glVertex2dv(cast(GLdouble*) а);}
    void глВершина2(плав* а){ glVertex2fv(cast(GLfloat*) а);}
    void глВершина2(цел* а){ glVertex2iv(а);}
    void глВершина2(крат* а) {glVertex2sv(а);}
    void глВершина3(дво* а) {glVertex3dv(cast(GLdouble*) а);}
    void глВершина3(плав* а){ glVertex3fv(cast(GLfloat*) а);}
    void глВершина3(цел* а){ glVertex3iv(а);}
    void глВершина3(крат* а){ glVertex3sv(а);}
    void глВершина4(дво* а){ glVertex4dv(cast(GLdouble*) а);}
    void глВершина4(плав* а){ glVertex4fv(cast(GLfloat*) а);}
    void глВершина4(цел* а){ glVertex4iv(а);}
    void глВершина4(крат* а) {glVertex4sv(а);}
    void глНормаль(байт а,байт б,байт в){ glNormal3b(а, б, в);}
    void глНормальд(дво а,дво б,дво в){ glNormal3d(cast(GLdouble) а,cast(GLdouble)  б,cast(GLdouble)  в);}
    void глНормаль(плав а,плав б,плав в){ glNormal3f(cast(GLfloat) а, cast(GLfloat) б,cast(GLfloat)  в);}
    void глНормаль(цел а,цел б,цел в){ glNormal3i(а, б, в);}
    void глНормаль(крат а,крат б,крат в){ glNormal3s(а, б, в);}
    void глНормаль(байт* а){ glNormal3bv(а);}
    void глНормаль(дво* а){ glNormal3dv(cast(GLdouble*) а);}
    void глНормаль(плав* а){ glNormal3fv(cast(GLfloat*) а);}
    void глНормаль(цел* а) {glNormal3iv(а);}
    void глНормаль(крат* а){ glNormal3sv(а);}
    void глИндексд(дво а){ glIndexd(cast(GLdouble) а);}
    void глИндекс(плав а){ glIndexf(cast(GLfloat) а);}
    void глИндекс(цел а){ glIndexi(а);}
    void глИндекс(крат а){ glIndexs(а);}
    void глИндекс(ббайт а){ glIndexub(а);}
    void глИндекс(дво* а){ glIndexdv(cast(GLdouble*) а);}
    void глИндекс(плав* а){ glIndexfv(cast(GLfloat*) а);}
    void глИндекс(цел* а){ glIndexiv(а);}
    void глИндекс(крат* а){ glIndexsv(а);}
    void глИндекс(ббайт* а) {glIndexubv(а);}
    void глЦвет(байт а,байт б,байт в){ glColor3b(а,б,в);}
    void глЦветд(дво а,дво б,дво в){ glColor3d(cast(GLdouble) а,cast(GLdouble) б,cast(GLdouble) в);}
    void глЦвет(плав а,плав б,плав в){ glColor3f(cast(GLfloat) а,cast(GLfloat) б,cast(GLfloat) в);}
    void глЦвет(цел а,цел б,цел в){ glColor3i(а,б,в);}
    void глЦвет(крат а,крат б,крат в){ glColor3s(а,б,в);}
    void глЦвет(ббайт а,ббайт б,ббайт в){ glColor3ub(а,б,в);}
    void глЦвет(бцел а,бцел б,бцел в){ glColor3ui(а,б,в);}
    void глЦвет(бкрат а,бкрат б,бкрат в){ glColor3us(а,б,в);}
    void глЦвет(байт а,байт б,байт в,байт г){ glColor4b(а,б,в,г);}
    void глЦветд(дво а,дво б,дво в,дво г){ glColor4d(cast(GLdouble) а,cast(GLdouble) б,cast(GLdouble) в,cast(GLdouble) г);}
    void глЦвет(плав а,плав б,плав в,плав г){ glColor4f(cast(GLfloat) а,cast(GLfloat) б,cast(GLfloat) в,cast(GLfloat) г);}
    void глЦвет(цел а,цел б,цел в,цел г){ glColor4i(а,б,в,г);}
    void глЦвет(крат а,крат б,крат в,крат г){ glColor4s(а,б,в,г);}
    void глЦвет(ббайт а,ббайт б,ббайт в,ббайт г){ glColor4ub(а,б,в,г);}
    void глЦвет(бцел а,бцел б,бцел в,бцел г){ glColor4ui(а,б,в,г);}
    void глЦвет(бкрат а,бкрат б,бкрат в,бкрат г){ glColor4us(а,б,в,г);}
    void глЦвет3(байт* а){ glColor3bv(cast(GLbyte*) а);}
    void глЦвет3(дво* а){ glColor3dv(cast(GLdouble*) а);}
    void глЦвет3(плав* а){ glColor3fv(cast(GLfloat*) а);}
    void глЦвет3(цел* а) {glColor3iv(cast(GLint*) а);}
    void глЦвет3(крат* а){ glColor3sv(cast(GLshort*) а);}
    void глЦвет3(ббайт* а){ glColor3ubv(cast(GLubyte*) а);}
    void глЦвет3(бцел* а){ glColor3uiv(cast(GLuint*) а);}
    void глЦвет3(бкрат* а){ glColor3usv(cast(GLushort*) а);}
    void глЦвет4(байт* а){ glColor4bv(cast(GLbyte*) а);}
    void глЦвет4(дво* а){ glColor4dv(cast(GLdouble*) а);}
    void глЦвет4(плав* а){ glColor4fv(cast(GLfloat*) а);}
    void глЦвет4(цел* а){ glColor4iv(cast(GLint*) а);}
    void глЦвет4(крат* а){ glColor4sv(cast(GLshort*) а);}
    void глЦвет4(ббайт* а) {glColor4ubv(cast(GLubyte*) а);}
    void глЦвет4(бцел* а){ glColor4uiv(cast(GLuint*) а);}
    void глЦвет4(бкрат* а){ glColor4usv(cast(GLushort*) а);}
    void глКоордТексд(дво а){ glTexCoord1d(cast(GLdouble) а);}
    void глКоордТекс(плав а){ glTexCoord1f(cast(GLfloat) а);}
    void глКоордТекс(цел а){ glTexCoord1i(cast(GLint) а);}
    void глКоордТекс(крат а){ glTexCoord1s(cast(GLshort) а);}
    void глКоордТексд(дво а,дво б){ glTexCoord2d(cast(GLdouble) а,cast(GLdouble) б);}
    void глКоордТекс(плав а,плав б){ glTexCoord2f(cast(GLfloat) а,cast(GLfloat) б);}
    void глКоордТекс(цел а,цел б){ glTexCoord2i(cast(GLint) а,cast(GLint) б);}
    void глКоордТекс(крат а,крат б){ glTexCoord2s(cast(GLshort) а,cast(GLshort) б);}
    void глКоордТексд(дво а,дво б,дво в){ glTexCoord3d(cast(GLdouble) а,cast(GLdouble) б,cast(GLdouble) в);}
    void глКоордТекс(плав а,плав б,плав в){ glTexCoord3f(cast(GLfloat) а,cast(GLfloat) б,cast(GLfloat) в);}
    void глКоордТекс(цел а,цел б,цел в){ glTexCoord3i(cast(GLint) а,cast(GLint) б,cast(GLint) в);}
    void глКоордТекс(крат а,крат б,крат в){ glTexCoord3s(cast(GLshort) а,cast(GLshort) б,cast(GLshort) в);}
    void глКоордТексд(дво а,дво б,дво в,дво г){ glTexCoord4d(cast(GLdouble) а,cast(GLdouble) б,cast(GLdouble) в,cast(GLdouble) г);}
    void глКоордТекс(плав а,плав б,плав в,плав г){ glTexCoord4f(cast(GLfloat) а,cast(GLfloat) б,cast(GLfloat) в,cast(GLfloat) г);}
    void глКоордТекс(цел а,цел б,цел в,цел г){ glTexCoord4i(а,б,в,г);}
    void глКоордТекс(крат а,крат б,крат в,крат г){ glTexCoord4s(а,б,в,г);}
    void глКоордТекс1(дво* а) {glTexCoord1dv(cast(GLdouble*) а);}
    void глКоордТекс1(плав* а){ glTexCoord1fv(cast(GLfloat*) а);}
    void глКоордТекс1(цел* а){ glTexCoord1iv(а);}
    void глКоордТекс1(крат* а){ glTexCoord1sv(а);}
    void глКоордТекс2(дво* а){ glTexCoord2dv(cast(GLdouble*) а);}
    void глКоордТекс2(плав* а){ glTexCoord2fv(cast(GLfloat*) а);}
    void глКоордТекс2(цел* а){ glTexCoord2iv(а);}
    void глКоордТекс2(крат* а){ glTexCoord2sv(а);}
    void глКоордТекс3(дво* а){ glTexCoord3dv(cast(GLdouble*) а);}
    void глКоордТекс3(плав* а){ glTexCoord3fv(cast(GLfloat*) а);}
    void глКоордТекс3(цел* а){ glTexCoord3iv(а);}
    void глКоордТекс3(крат* а) {glTexCoord3sv(а);}
    void глКоордТекс4(дво* а){ glTexCoord4dv(cast(GLdouble*) а);}
    void глКоордТекс4(плав* а) {glTexCoord4fv(cast(GLfloat*) а);}
    void глКоордТекс4(цел* а){ glTexCoord4iv(а);}
    void глКоордТекс4(крат* а) {glTexCoord4sv(а);}
    void глПозРастрад(дво а,дво б){ glRasterPos2d(cast(GLdouble) а,cast(GLdouble) б);}
    void глПозРастра(плав а,плав б){ glRasterPos2f(cast(GLfloat) а,cast(GLfloat) б);}
    void глПозРастра(цел а,цел б){ glRasterPos2i(а,б);}
    void глПозРастра(крат а,крат б){ glRasterPos2s(а,б);}
    void глПозРастрад(дво а,дво б,дво в){ glRasterPos3d(cast(GLdouble) а,cast(GLdouble) б,cast(GLdouble) в);}
    void глПозРастра(плав а,плав б,плав в){ glRasterPos3f(cast(GLfloat) а,cast(GLfloat) б,cast(GLfloat) в);}
    void глПозРастра(цел а,цел б,цел в) { glRasterPos3i(а,б,в);}
    void глПозРастра(крат а,крат б,крат в){ glRasterPos3s(а,б,в);}
    void глПозРастрад(дво а,дво б,дво в,дво г){ glRasterPos4d(cast(GLdouble) а,cast(GLdouble) б,cast(GLdouble) в,cast(GLdouble) г);}
    void глПозРастра(плав а,плав б,плав в,плав г){ glRasterPos4f(cast(GLfloat) а,cast(GLfloat) б,cast(GLfloat) в,cast(GLfloat) г);}
    void глПозРастра(цел а,цел б,цел в,цел г){ glRasterPos4i(а,б,в,г);}
    void глПозРастра(крат а,крат б,крат в,крат г){ glRasterPos4s(а,б,в,г);}
    void глПозРастра2(дво* а) {glRasterPos2dv(cast(GLdouble*) а);}
    void глПозРастра2(плав* а){ glRasterPos2fv(cast(GLfloat*) а);}
    void глПозРастра2(цел* а) {glRasterPos2iv(а);}
    void глПозРастра2(крат* а){ glRasterPos2sv(а);}
    void глПозРастра3(дво* а){ glRasterPos3dv(cast(GLdouble*) а);}
    void глПозРастра3(плав* а){ glRasterPos3fv(cast(GLfloat*) а);}
    void глПозРастра3(цел* а){ glRasterPos3iv(а);}
    void глПозРастра3(крат* а) {glRasterPos3sv(а);}
    void глПозРастра4(дво* а){ glRasterPos4dv(cast(GLdouble*) а);}
    void глПозРастра4(плав* а){ glRasterPos4fv(cast(GLfloat*) а);}
    void глПозРастра4(цел* а){ glRasterPos4iv(а);}
    void глПозРастра4(крат* а) {glRasterPos4sv(а);}
    void глПрямоугд(дво а,дво б,дво в,дво г){ glRectd(cast(GLdouble) а,cast(GLdouble) б,cast(GLdouble) в,cast(GLdouble) г);}
    void глПрямоуг(плав а,плав б,плав в,плав г){ glRectf(cast(GLfloat) а,cast(GLfloat) б,cast(GLfloat) в,cast(GLfloat) г);}
    void глПрямоуг(цел а,цел б,цел в,цел г){ glRecti(cast(GLint) а,cast(GLint) б,cast(GLint) в,cast(GLint) г);}
    void глПрямоуг(крат а,крат б,крат в,крат г){ glRects(cast(GLshort) а,cast(GLshort) б,cast(GLshort) в,cast(GLshort) г);}
    void глПрямоуг(дво* а, дво* б) {glRectdv(cast(GLdouble*) а,cast(GLdouble*) б);}
    void глПрямоуг(плав* а, плав* б) {glRectfv(cast(GLfloat*) а,cast(GLfloat*) б);}
    void глПрямоуг(цел* а, цел* б) {glRectiv(cast(GLint*) а,cast(GLint*) б);}
    void глПрямоуг(крат* а, крат* б){ glRectsv(cast(GLshort*)а,cast(GLshort*) б);}

    void глМодельТени(Гперечень а){ glShadeModel(cast(GLenum) а);}
    void глСвет(Гперечень а,Гперечень б,плав в){ glLightf(cast(GLenum) а,cast(GLenum) б,cast(GLfloat) в);}
    void глСвет(Гперечень а,Гперечень б,цел в){ glLighti(cast(GLenum) а,cast(GLenum) б,cast(GLint) в);}
    void глСвет(Гперечень а,Гперечень б,плав* в){ glLightfv(cast(GLenum) а,cast(GLenum) б,cast(GLfloat*) в);}
    void глСвет(Гперечень а,Гперечень б,цел* в){ glLightiv(cast(GLenum) а,cast(GLenum) б,cast(GLint*) в);}
    void глДайСвет(Гперечень а,Гперечень б,плав* в) {glGetLightfv(cast(GLenum) а,cast(GLenum) б,cast(GLfloat*) в);}
    void глДайСвет(Гперечень а,Гперечень б,цел* в){ glGetLightiv(cast(GLenum) а,cast(GLenum) б,cast(GLint*) в);}
    void глМодельСвета(Гперечень а,плав б){ glLightModelf(cast(GLenum) а,cast(GLfloat) б);}
    void глМодельСвета(Гперечень а,цел б){ glLightModeli(cast(GLenum) а,cast(GLint) б);}
    void глМодельСвета(Гперечень а,плав* б){ glLightModelfv(cast(GLenum) а,cast(GLfloat*) б);}
    void глМодельСвета(Гперечень а,цел* б) {glLightModeliv(cast(GLenum) а,cast(GLint*) б);}
    void глМатериал(Гперечень а,Гперечень б,плав в){ glMaterialf(cast(GLenum) а,cast(GLenum) б,cast(GLfloat) в);}
    void глМатериал(Гперечень а,Гперечень б,цел в){ glMateriali(cast(GLenum) а,cast(GLenum) б,cast(GLint) в);}
    void глМатериал(Гперечень а,Гперечень б,плав* в){ glMaterialfv(cast(GLenum) а,cast(GLenum) б,cast(GLfloat*) в);}
    void глМатериал(Гперечень а,Гперечень б,цел* в){ glMaterialiv(cast(GLenum) а,cast(GLenum) б,cast(GLint*) в);}
    void глДайМатериал(Гперечень а,Гперечень б,плав* в){ glGetMaterialfv(cast(GLenum) а,cast(GLenum) б,cast(GLfloat*) в);}
    void глДайМатериал(Гперечень а,Гперечень б,цел* в){ glGetMaterialiv(cast(GLenum) а,cast(GLenum) б,cast(GLint*) в);}
    void глМатериалЦвета(Гперечень а,Гперечень б){ glColorMaterial(cast(GLenum) а,cast(GLenum) б);}
	
    void глЗумПикселя(плав а,плав б){ glPixelZoom(cast(GLfloat) а, cast(GLfloat) б);}
    void глСохраниПиксель(Гперечень а,плав б){ glPixelStoref(cast(GLenum) а,cast(GLfloat) б);}
    void глСохраниПиксель(Гперечень а,цел б){ glPixelStorei(cast(GLenum) а,cast(GLint) б);}
    void глПереместиПиксель(Гперечень а,плав б){ glPixelTransferf(cast(GLenum) а,cast(GLfloat) б);}
    void глПереместиПиксель(Гперечень а,цел б){ glPixelTransferi(cast(GLenum) а,cast(GLint) б);}
    void глКартируйПиксель(Гперечень а,цел б,плав* в){ glPixelMapfv(cast(GLenum) а,cast(GLint) б,cast(GLfloat*) в);}
    void глКартируйПиксель(Гперечень а,цел б,бцел* в){ glPixelMapuiv(cast(GLenum) а,cast(GLint) б,в);}
    void глКартируйПиксель(Гперечень а,цел б,бкрат* в){ glPixelMapusv(cast(GLenum) а,cast(GLint) б,в);}
    void глДайКартуПикселя(Гперечень а,плав* б){ glGetPixelMapfv(cast(GLenum) а,cast(GLfloat*) б);}
    void глДайКартуПикселя(Гперечень а,бцел* б){ glGetPixelMapuiv(cast(GLenum) а,б);}
    void глДайКартуПикселя(Гперечень а,бкрат* б){ glGetPixelMapusv(cast(GLenum) а,б);}
    void глБитмап(Гцразм а,Гцразм б,плав в,плав г,плав д,плав е,ббайт* ё){ glBitmap(а,б,cast(GLfloat) в,cast(GLfloat) г,cast(GLfloat) д,cast(GLfloat) е,cast(GLubyte*) ё);}
    void глЧитайПиксели(цел а,цел б,Гцразм в,Гцразм г,Гперечень д,Гперечень е,ук ё) {glReadPixels(а,cast(GLint) б,cast(GLsizei) в,cast(GLsizei) г,cast(GLenum) д,cast(GLenum) е,ё);}
    void глРисуйПиксели(Гцразм а,Гцразм б,Гперечень в,Гперечень г,ук д){ glDrawPixels(cast(GLsizei) а,cast(GLsizei) б,cast(GLenum) в,cast(GLenum) г,д);}
    void глКопируйПиксели(цел а,цел б,Гцразм в,Гцразм г,Гперечень д){ glCopyPixels(cast(GLint) а,cast(GLint) б,cast(GLsizei) в,cast(GLsizei) г,cast(GLenum) д);}

    void глФункцШаблона(Гперечень а,цел б,бцел в){ glStencilFunc(cast(GLenum) а,cast(GLint) б,cast(GLuint) в);}
    void глМаскаШаблона(бцел а){ glStencilMask(cast(GLuint) а);}
    void глОпШаблона(Гперечень а,Гперечень б,Гперечень в){ glStencilOp(cast(GLenum) а,cast(GLenum) б,cast(GLenum) в);}
    void глОчистиШаблон(цел а){ glClearStencil(cast(GLint) а);}

    void глГенТекс(Гперечень а,Гперечень б,дво в){ glTexGend(cast(GLenum) а,cast(GLenum) б,cast(GLdouble) в);}
    void глГенТекс(Гперечень а,Гперечень б,плав в){ glTexGenf(cast(GLenum) а,cast(GLenum) б,cast(GLfloat) в);}
    void глГенТекс(Гперечень а,Гперечень б,цел в){ glTexGeni(cast(GLenum) а,cast(GLenum) б,в);}
    void глГенТекс(Гперечень а,Гперечень б,дво* в){ glTexGendv(cast(GLenum) а,cast(GLenum) б,cast(GLdouble*) в);}
    void глГенТекс(Гперечень а,Гперечень б,плав* в){ glTexGenfv(cast(GLenum) а,cast(GLenum) б,cast(GLfloat*) в);}
    void глГенТекс(Гперечень а,Гперечень б,цел* в){ glTexGeniv(cast(GLenum) а,cast(GLenum) б,в);}
    void глДайГенТекс(Гперечень а,Гперечень б,дво* в){ glGetTexGendv(cast(GLenum) а,cast(GLenum) б,cast(GLdouble*) в);}
    void глДайГенТекс(Гперечень а,Гперечень б,плав* в){ glGetTexGenfv(cast(GLenum) а,cast(GLenum) б,cast(GLfloat*) в);}
    void глДайГенТекс(Гперечень а,Гперечень б,цел* в){ glGetTexGeniv(cast(GLenum) а,cast(GLenum) б,в);}
    void глСредаТекс(Гперечень а,Гперечень б,плав в){ glTexEnvf(cast(GLenum) а,cast(GLenum) б,cast(GLfloat) в);}
    void глСредаТекс(Гперечень а,Гперечень б,цел в){ glTexEnvi(cast(GLenum) а,cast(GLenum) б,в);}
    void глСредаТекс(Гперечень а,Гперечень б,плав* в){ glTexEnvfv(cast(GLenum) а,cast(GLenum) б,cast(GLfloat*) в);}
    void глСредаТекс(Гперечень а,Гперечень б,цел* в){ glTexEnviv(cast(GLenum) а,cast(GLenum) б,в);}
    void глДайСредуТекс(Гперечень а,Гперечень б,плав* в){ glGetTexEnvfv(cast(GLenum) а,cast(GLenum) б,cast(GLfloat*) в);}
    void глДайСредуТекс(Гперечень а,Гперечень б,цел* в){ glGetTexEnviv(cast(GLenum) а,cast(GLenum) б,в);}
    void глПараметрТекс(Гперечень а,Гперечень б,плав в){ glTexParameterf(cast(GLenum) а,cast(GLenum) б,cast(GLfloat) в);}
    void глПараметрТекс(Гперечень а,Гперечень б,цел в){ glTexParameteri(cast(GLenum) а,cast(GLenum) б,в);}
    void глПараметрТекс(Гперечень а,Гперечень б,плав* в){ glTexParameterfv(cast(GLenum) а,cast(GLenum) б,cast(GLfloat*) в);}
    void глПараметрТекс(Гперечень а,Гперечень б,цел* в){ glTexParameteriv(cast(GLenum) а,cast(GLenum) б,cast(GLint*) в);}
    void глДайПараметрТекс(Гперечень а,Гперечень б,плав* в) {glGetTexParameterfv(cast(GLenum) а,cast(GLenum) б,cast(GLfloat*) в);}
    void глДайПараметрТекс(Гперечень а,Гперечень б,цел* в) {glGetTexParameteriv(cast(GLenum) а,cast(GLenum) б,cast(GLint*) в);}
    void глДайПараметрУровняТекс(Гперечень а,цел б,Гперечень в,плав* г){ glGetTexLevelParameterfv(cast(GLenum) а,cast(GLint) б,cast(GLenum) в,cast(GLfloat*) г);}
    void глДайПараметрУровняТекс(Гперечень а,цел б,Гперечень в,цел* г){ glGetTexLevelParameteriv(cast(GLenum) а,б,в,г);}
    void глОбразТекст1М(Гперечень а,цел б,цел в,Гцразм г,цел д,Гперечень е,Гперечень ё,ук ж){ glTexImage1D(cast(GLenum) а,cast(GLint) б,cast(GLint) в,cast(GLsizei) г,cast(GLint) д,cast(GLenum) е,cast(GLenum) ё,ж);}
    void глОбразТекс2М(Гперечень а,цел б,цел в,Гцразм г,Гцразм д,цел е,Гперечень ё,Гперечень ж,ук з) {glTexImage2D(cast(GLenum) а,cast(GLint) б,cast(GLint) в,cast(GLsizei) г,cast(GLsizei) д,cast(GLint) е,cast(GLenum) ё,cast(GLenum) ж,з);}
    void глДайОбразТекс(Гперечень а,цел б,Гперечень в,Гперечень г,ук д){ glGetTexImage(cast(GLenum) а,cast(GLint) б,cast(GLenum) в,cast(GLenum) г,д);}
    void глКарта1(Гперечень а,дво б,дво в,цел  г,цел д,дво* е){ glMap1d(cast(GLenum) а,cast(GLdouble) б,cast(GLdouble) в,cast(GLint) г,cast(GLint) д,cast(GLdouble*) е);}
    void глКарта1(Гперечень а,плав б,плав в,цел г,цел д,плав* е){ glMap1f(cast(GLenum) а,cast(GLfloat) б,cast(GLfloat) в,cast(GLint) г,cast(GLint) д,cast(GLfloat*) е);}
    void глКарта2(Гперечень а,дво б,дво в,цел г,цел д,дво е,дво ё,цел ж,цел з,дво* и) {glMap2d(cast(GLenum) а,cast(GLdouble) б,cast(GLdouble) в,cast(GLint) г,cast(GLint) д,cast(GLdouble) е,cast(GLdouble) ё,cast(GLint) ж,cast(GLint) з,cast(GLdouble*) и);}
    void глКарта2(Гперечень а,плав б,плав в,цел г,цел д,плав е,плав ё,цел ж,цел з,плав* и) {glMap2f(cast(GLenum) а,cast(GLfloat) б,cast(GLfloat) в,г,д,cast(GLfloat) е,cast(GLfloat) ё,cast(GLint) ж,cast(GLint) з,cast(GLfloat*) и);}
    void глДайКарту(Гперечень а,Гперечень б,дво* в){ glGetMapdv(cast(GLenum) а,cast(GLenum) б,cast(GLdouble*) в);}
    void глДайКарту(Гперечень а,Гперечень б,плав* в){ glGetMapfv(cast(GLenum) а,cast(GLenum) б,cast(GLfloat*) в);}
    void глДайКарту(Гперечень а,Гперечень б,цел* в){ glGetMapiv(cast(GLenum) а,cast(GLenum) б,cast(GLint*) в);}
    void глОцениКоорд1(дво а){ glEvalCoord1d(cast(GLdouble) а);}
    void глОцениКоорд1(плав а){ glEvalCoord1f(cast(GLfloat) а);}
    void глОцениКоорд1(дво* а){ glEvalCoord1dv(cast(GLdouble*) а);}
    void глОцениКоорд1(плав* а){ glEvalCoord1fv(cast(GLfloat*) а);}
    void глОцениКоорд2(дво а,дво б){ glEvalCoord2d(cast(GLdouble) а,cast(GLdouble) б);}
    void глОцениКоорд2(плав а,плав б){ glEvalCoord2f(cast(GLfloat) а,cast(GLfloat) б);}
    void глОцениКоорд2(дво* а){ glEvalCoord2dv(cast(GLdouble*) а);}
    void глОцениКоорд2(плав* а){ glEvalCoord2fv(cast(GLfloat*) а);}
    void глСеткаКарты1(цел а,дво б,дво в){ glMapGrid1d(а,cast(GLdouble) б,cast(GLdouble) в);}
    void глСеткаКарты1(цел а,плав б,плав в){ glMapGrid1f(а,cast(GLfloat) б,cast(GLfloat) в);}
    void глСеткаКарты2(цел а,дво б,дво в,цел г,дво д,дво е){ glMapGrid2d(а,cast(GLdouble) б,cast(GLdouble) в,cast(GLint) г,cast(GLdouble) д,cast(GLdouble) е);}
    void глСеткаКарты2(цел а,плав б,плав в,цел г,плав д,плав е){ glMapGrid2f(cast(GLint) а,cast(GLfloat) б,cast(GLfloat) в,cast(GLint) г,cast(GLfloat) д,cast(GLfloat) е);}
    void глОцениТочку1(цел а){ glEvalPoint1(cast(GLint) а);}
    void глОцениТочку2(цел а,цел б){ glEvalPoint2(cast(GLint) а,cast(GLint) б);}
    void глОцениМеш1(Гперечень а,цел б,цел в){ glEvalMesh1(cast(GLenum) а,cast(GLint) б,cast(GLint) в);}
    void глОцениМеш2(Гперечень а,цел б,цел в,цел г,цел д){ glEvalMesh2(cast(GLenum) а,cast(GLint) б,cast(GLint) в,cast(GLint) г,cast(GLint) д);}

    void глТуман(Гперечень а,плав б){ glFogf(cast(GLenum) а,cast(GLfloat) б);}
    void глТуман(Гперечень а,цел б){ glFogi(cast(GLenum) а,cast(GLint) б);}
    void глТуман(Гперечень а,плав* б){ glFogfv(cast(GLenum) а,cast(GLfloat*) б);}
    void глТуман(Гперечень а,цел* б){ glFogiv(cast(GLenum) а,cast(GLint*) б);}

   void глБуферФидбэка(Гцразм а,Гперечень б,плав* в){ glFeedbackBuffer(cast(GLsizei) а,cast(GLenum) б,cast(GLfloat*) в);}
    void глПропуск(плав а){ glPassThrough(cast(GLfloat) а);}
    void глВыбериБуфер(Гцразм а,бцел* б){ glSelectBuffer(cast(GLsizei) а,cast(GLuint*) б);}
    void глИницИмена(){ glInitNames();}
    void глЗагрузиИмя(бцел а){ glLoadName(cast(GLuint) а);}
    void глСуньИмя(бцел а){ glPushName(cast(GLuint) а);}
    void глВыньИмя(){ glPopName();}

    void глГенТекстуры(Гцразм а,бцел* б){ glGenTextures(cast(GLsizei)а,cast(GLuint*) б);}
    void глУдалиТекстуры(Гцразм а,бцел* б){ glDeleteTextures(cast(GLsizei)а,cast(GLuint*) б);}
    void глПривяжиТекстуру(Гперечень а,бцел б){ glBindTexture(cast(GLenum) а,cast(GLuint) б);}
    void глПриоритетТекстурам(Гцразм а,бцел* б,Гклампп* в){ glPrioritizeTextures(cast(GLsizei)а,cast(GLuint*) б,в);}
    Гбул  глРезидентныТекстуры_ли(Гцразм а,бцел* б,Гбул* в){return cast(Гбул) glAreTexturesResident(cast(GLsizei) а,б,в);}
    Гбул  глТекстура_ли(бцел а){ return cast(Гбул) glIsTexture(а);}

    void глПодобразТекст1М(Гперечень а,цел б,цел в,Гцразм г,Гперечень д,Гперечень е,ук ё){ glTexSubImage1D(а,б,в,г,д,е,ё);}
    void глПодобразТекс2М(Гперечень а,цел б,цел в,цел г,Гцразм д,Гцразм е,Гперечень ё,Гперечень ж,ук з){ glTexSubImage2D(а,б,в,г,cast(GLsizei) д,cast(GLsizei) е,ё,ж,з);}
    void глКопируйОбразТекс1М(Гперечень а,цел б,Гперечень в,цел г,цел д,Гцразм е,цел ё){ glCopyTexImage1D(а,б,в,г,д,cast(GLsizei) е,ё);}
    void глКопируйОбразТекст2М(Гперечень а,цел б,Гперечень в,цел г,цел д,Гцразм е,Гцразм ё,цел ж){ glCopyTexImage2D(а,б,в,г,д,cast(GLsizei) е,cast(GLsizei) ё,ж);}
    void глКопируйПодобразТекс1М(Гперечень а,цел б,цел в,цел г,цел д,Гцразм е){ glCopyTexSubImage1D(а,б,в,г,д,cast(GLsizei) е);}
    void глКопируйПодобразТекс2М(Гперечень а,цел б,цел в,цел г,цел д,цел е,Гцразм ё,Гцразм ж){ glCopyTexSubImage2D(а,б,в,г,д,е,cast(GLsizei) ё,cast(GLsizei) ж);}

    void глУкНаВершину(цел а,Гперечень б,Гцразм в, ук г){ glVertexPointer(а,б,cast(GLsizei) в,г);}
    void глУкНаНормаль(Гперечень а,Гцразм б,ук в){ glNormalPointer(а,cast(GLsizei) б,в);}
    void глУкНаЦвет(цел а,Гперечень б,Гцразм в,ук г){ glColorPointer(а,б,cast(GLsizei) в,г);}
    void глУкНаИндекс(Гперечень а,Гцразм б,ук в){ glIndexPointer(а,cast(GLsizei) б,в);}
    void глУкНаКоордТекс(цел а,Гперечень б,Гцразм в,ук г){ glTexCoordPointer(а,б,cast(GLsizei) в,г);}
    void глУкНаФлагКрая(Гцразм а,ук б){ glEdgeFlagPointer(cast(GLsizei) а,б);}
    void глДайУк(Гперечень а,ук* б){ glGetPointerv(а,б);}
    void глЭлементМассива(цел а){ glArrayElement(а);}
    void глРисуйМассивы(Гперечень а,цел б,Гцразм в){ glDrawArrays(а,б,cast(GLsizei) в);}
    void глРисуйЭлементы(Гперечень а,Гцразм б,Гперечень в,ук г){ glDrawElements(а,cast(GLsizei) б,в,г);}
    void глСовместныеМассивы(Гперечень а,Гцразм б,ук в){ glInterleavedArrays(а,cast(GLsizei) б,в);}
	
/////glut
	
 void глутИниц(цел* а= пусто, сим** б = пусто){ glutInit( а,  б);}
 void глутИницПозОкна(цел а, цел б){ glutInitWindowPosition( а, б);}
 void глутИницРазмерОкна(цел а, цел б){ glutInitWindowSize( а, б);}
 void глутИницРежимПоказа(бцел режим){glutInitDisplayMode( режим);}
 void глутИницТекстОкна(сим* а) {glutInitDisplayString( а);}
 void глутГлавныйЦикл() {glutMainLoop();}
 цел глутСоздайОкно(сим* а){return cast(цел) glutCreateWindow( а);}
 цел глутСоздайПодокно(цел а, цел б, цел в, цел г, цел д){return cast(цел) glutCreateSubWindow(а,  б,  в,  г,  д);}
 void глутРазрушьОкно(цел а) {glutDestroyWindow( а);}
 void глутФункцПоказа(сифунк а) {glutDisplayFunc(а);}
 ///////////////
 void глутУстановиОкно(цел а){ glutSetWindow( а);}
 цел глутДайОкно(){return cast(цел) glutGetWindow();}
 void глутУстановиЗагОкна(сим* заг){ glutSetWindowTitle( заг);}
 void глутУстановиЗагПикт(сим* заг){ glutSetIconTitle( заг);}
 void глутПерерисуйОкно(цел а, цел б){ glutReshapeWindow( а,  б);}
 void глутПоместиОкно(цел а, цел б){ glutPositionWindow( а, б);}
 void глутПокажиОкно(){ glutShowWindow();}
 void глутСпрячьОкно() { glutHideWindow();}
 void глутСверниОкно(){ glutIconifyWindow();}
 void глутСуньОкно(){ glutPushWindow();}
 void глутВыньОкно(){ glutPopWindow();}
 void глутПолныйЭкран(){ glutFullScreen();}
 void глутПерепоказОкна(цел а){ glutPostWindowRedisplay(а);}
 void глутПерепоказ(){ glutPostRedisplay();}
 void глутОбменБуферов(){ glutSwapBuffers;}
 void глутУкНаВарп(цел а, цел б){ glutWarpPointer(а, б);}
 void глутУстановиКурсор(цел а) {glutSetCursor(а);}
 void глутУстановиНакладку(){ glutEstablishOverlay();}
 void глутУдалиНакладку(){ glutRemoveOverlay();}
 void глутИспользуйСлой(Гперечень а) {glutUseLayer(cast(GLenum) а);}
 void глутПерепоказНакладки(){ glutPostOverlayRedisplay();}
 void глутПерепоказНакладкиОкна(цел а) {glutPostWindowOverlayRedisplay(а);}
 void глутПокажиНакладку() {glutShowOverlay();}
 void глутСкройНакладку() {glutHideOverlay();}
 цел глутСоздайМеню(сифунк_Ц а){return  glutCreateMenu(а);}
 void глутРазрушьМеню(цел а) {glutDestroyMenu(а);}
 цел глутДайМеню() {return glutGetMenu();}
 void глутУстановиМеню(цел а){ glutSetMenu(а);}
 void глутДобавьЗаписьМеню(сим* а, цел б){ glutAddMenuEntry(а, б);}
 void глутДобавьПодменю(сим* а, цел б){ glutAddSubMenu(а,б);}
 void глутПерейдиВЗаписьМеню(цел а, сим* б, цел в){ glutChangeToMenuEntry(а,б,в);}
 void глутПерейдиВПодменю(цел а, сим* б, цел в){ glutChangeToSubMenu(а,б,в);}
 void глутУдалиЭлементМеню(цел а) {glutRemoveMenuItem(а);}
 void глутПрикрепиМеню(цел а) {glutAttachMenu(а);}
 void глутОткрепиМеню(цел а){ glutDetachMenu(а);}
 void глутФункцТаймера(цел а, сифунк_Ц б, цел в) {glutTimerFunc(а,б,в);}
 void глутФункцБездействия(сифунк а){ glutIdleFunc(а);}
 void глутФункцКлавиатуры(сифунк_СЦЦ а) {glutKeyboardFunc(а);}
 void глутОсобаяФункция(сифунк_ЦЦЦ а){ glutSpecialFunc(а);}
 void глутФункцПерерисовки(сифунк_ЦЦ а){ glutReshapeFunc(а);}
 void глутФункцВидимости(сифунк_Ц а) {glutVisibilityFunc(а);}
 void глутФункцМыши(сифунк_ЦЦЦЦ а){ glutMouseFunc(а);}
 void глутФункцДвижения(сифунк_ЦЦ а){ glutMotionFunc(а);}
 void глутФункцияПассивногоДвижения(сифунк_ЦЦ а){ glutPassiveMotionFunc(а);}
 void глутФункцияВвода(сифунк_Ц а) {glutEntryFunc(а);}
 void глутФункцОтжатияКлавиши(сифунк_СЦЦ а){ glutKeyboardUpFunc(а);}
 void глутОсобаяФункцОтжатия(сифунк_ЦЦЦ а) {glutSpecialUpFunc(а);}
 void глутФункцДжойстика(сифунк_бЦЦЦЦ а, цел б){ glutJoystickFunc(а,б);}
 void глутФункцСостоянияМеню(сифунк_Ц а) {glutMenuStateFunc(а);}
 void глутФункцСтатусаМеню(сифунк_ЦЦЦ а){ glutMenuStatusFunc(а);}
 void глутФункцПоказаНакладки(сифунк а){ glutOverlayDisplayFunc(а);}
 void глутФункцСтатусаОкна(сифунк_Ц а){ glutWindowStatusFunc(а);}
 void глутФункцДвиженияНебесногоТела(сифунк_ЦЦЦ а){ glutSpaceballMotionFunc(а);}
 void глутФункцВращенияНебесногоТела(сифунк_ЦЦЦ а){ glutSpaceballRotateFunc(а);}
 void глутФункцКнопкаНебесногоТела(сифунк_ЦЦ а){ glutSpaceballButtonFunc(а);}
 void глутФункцОкнаКнопки(сифунк_ЦЦ а){ glutButtonBoxFunc(а);}
 void глутФункцАбонентов(сифунк_ЦЦ а){ glutDialsFunc(а);}
 void глутФункцДвиженияТаблет(сифунк_ЦЦ а) {glutTabletMotionFunc(а);}
 void глутФункцКнопкиТаблет(сифунк_ЦЦЦЦ а){ glutTabletButtonFunc(а);}
 цел глутДай(Гперечень а){return  cast(цел) glutGet(а);} 
 цел глутДайУстройство(Гперечень а){return  cast(цел) glutDeviceGet(cast(GLenum) а);}
 цел глутДайМодификаторы(){return cast(цел) glutGetModifiers();}
 цел глутДайСлой(Гперечень а){return cast(цел) glutLayerGet(а);}
 void глутСимволБитмап(ук а, цел б){ glutBitmapCharacter(а, cast(GLint) б);}
 цел глутШиринаБитмап(ук а, цел б){return cast(цел) glutBitmapWidth(а,cast(GLint) б);}
 void глутСимволШтриха(ук а, цел б){ glutStrokeCharacter(а,cast(GLint) б);}
 цел глутШиринаШтриха(ук а, цел б){return cast(цел) glutStrokeWidth(а,cast(GLint) б);}
 цел глутДлинаБитмап(ук а, сим* б){return cast(цел) glutBitmapLength(а, б);}
 цел глутДлинаШтриха(ук а, сим* б){return cast(цел)  glutStrokeLength(а, б);}
 void глутКаркасныйКуб(дво а){ glutWireCube(cast(GLdouble) а);}
 void глутПлотныйКуб(дво а) {glutSolidCube(cast(GLdouble) а);}
 void глутКаркаснаяСфера(дво а, цел б, цел в){ glutWireSphere(cast(GLdouble) а, cast(GLint) б, cast(GLint) в);}
 void глутПлотнаяСфера(дво а, цел б, цел в) {glutSolidSphere(cast(GLdouble) а, cast(GLint) б, cast(GLint) в);}
 void глутКаркасныйКонус(дво а, дво б, цел в, цел г){ glutWireCone(cast(GLdouble) а, cast(GLdouble) б, cast(GLint) в, cast(GLint) г);}
 void глутПлотныйКонус(дво а, дво б, цел в, цел г){ glutSolidCone(cast(GLdouble) а, cast(GLdouble) б, cast(GLint) в, cast(GLint) г);}
 void глутКаркасныйТор(дво а, дво б, цел в, цел г){ glutWireTorus(cast(GLdouble) а, cast(GLdouble) б, cast(GLint) в, cast(GLint) г);}
 void глутПлотныйТор(дво а, дво б, цел в, цел г){ glutSolidTorus(cast(GLdouble) а, cast(GLdouble) б, cast(GLint) в, cast(GLint) г);}
 void глутКаркасныйДодекаэдр(){ glutWireDodecahedron();}
 void глутПлотныйДодекаэдр(){ glutSolidDodecahedron();}
 void глутКаркасныйОктаэдр(){ glutWireOctahedron();}
 void глутПлотныйОктаэдр(){ glutSolidOctahedron();}
 void глутКаркасныйТетраэдр(){ glutWireTetrahedron();}
 void глутПлотныйТетраэдр(){ glutSolidTetrahedron();}
 void глутКаркасныйИкосаэдр(){ glutWireIcosahedron();}
 void глутПлотныйИкосаэдр(){ glutSolidIcosahedron();}
 void глутКаркасныйЧайник(дво а){ glutWireTeapot(cast(GLdouble) а);}
 void глутПлотныйЧайник(дво а){ glutSolidTeapot(cast(GLdouble) а);}
 void глутТекстРежимаИгры(сим* а) {glutGameModeString(а);}
 цел глутВойдиВРежимИгры(){return  glutEnterGameMode();}
 void глутПокиньРежимИгры(){ glutLeaveGameMode();}
 цел глутДайРежимИгры(Гперечень а){return  glutGameModeGet(cast(GLenum) а);}
 цел глутДайПеремерВидео(Гперечень а) {return  glutVideoResizeGet(cast(GLenum) а);}
 void глутУстановиПеремерВидео(){ glutSetupVideoResizing();}
 void глутОстановиПеремерВидео(){ glutStopVideoResizing();}
 void глутПеремерьВидео(цел а, цел б, цел в, цел г){ glutVideoResize(а,б,в,г);}
 void глутПанируйВидео(цел а, цел б, цел в, цел г){ glutVideoPan(а,б,в,г);}
 void глутУстановиЦвет(цел а, плав б, плав в, плав г)
	{ glutSetColor(а,cast(GLfloat) б,cast(GLfloat) в,cast(GLfloat) г);}
 
 плав глутДайЦвет(цел а, цел б){return cast(плав) glutGetColor(cast(GLint) а, cast(GLint) б);}
 void глутКопируйЦветокарту(цел а){ glutCopyColormap(cast(GLint) а);}
 void глутИгнорируйПовторКлавиши(цел а){ glutIgnoreKeyRepeat(cast(GLint) а);}
 void глутУстановиПовторКлавиши(цел а) {glutSetKeyRepeat(cast(GLint) а);}
 void глутФорсируйФункцДжойстика(){ glutForceJoystickFunc();}
 цел глутПоддерживаемыеРасширения(сим* а){return cast(цел) glutExtensionSupported(cast(GLchar*) а);}
 void глутОтчётОбОшибках(){glutReportErrors();}
 
 //GLU
 
  void  глуНачниКривую (GLUnurbs* nurb){gluBeginCurve (cast(GLUnurbs*) nurb);}
 void  глуНачниМногоуг (GLUtesselator* tess)
	{gluBeginPolygon (cast(GLUtesselator*) tess);}
 void  глуНачниПоверхность (GLUnurbs* nurb){gluBeginSurface (cast(GLUnurbs*) nurb);}
 void  глуНачниОбрез (GLUnurbs* nurb){gluBeginTrim (cast(GLUnurbs*) nurb);}
 
 цел  глуПострой1МУровниМипмап (Гперечень цель, цел внутрФормат, Гцразм ширина, Гперечень формат, Гперечень тип, цел уровень, цел ова, цел макс,  ук данные) 
	{return cast(цел) gluBuild1DMipmapLevels (cast(GLenum) цель, cast(GLint) внутрФормат, cast(GLsizei) ширина, cast(GLenum) формат, cast(GLenum) тип, cast(GLint) уровень, cast(GLint) ова, cast(GLint) макс,  данные);}
 
 цел  глуПострой1ММипмапы (Гперечень цель, цел внутрФормат, Гцразм ширина, Гперечень формат, Гперечень тип,  ук данные)
	{return cast(цел) gluBuild1DMipmaps (cast(GLenum) цель, cast(GLint) внутрФормат, cast(GLsizei) ширина, cast(GLenum) формат, cast(GLenum) тип,  данные);}
 
 цел  глуПострой2МУровениМипмап (цел цель, цел внутрФормат, Гцразм ширина, Гцразм высота, Гперечень формат, Гперечень тип, цел уровень, цел ова, цел макс,  ук данные)
	{return cast(цел)gluBuild2DMipmapLevels (cast(GLenum) цель, cast(GLint) внутрФормат, cast(GLsizei) ширина, cast(GLsizei) высота, cast(GLenum) формат, cast(GLenum) тип, cast(GLint) уровень, cast(GLint) ова, cast(GLint) макс,  данные);}
 
 цел  глуПострой2ММипмапы (цел цель, цел внутрФормат, Гцразм ширина, Гцразм высота, Гперечень формат, Гперечень тип,  ук данные)
	{return cast(цел) gluBuild2DMipmaps (cast(GLenum) цель, cast(GLint) внутрФормат, cast(GLsizei) ширина, cast(GLsizei) высота, cast(GLenum) формат, cast(GLenum) тип,данные);}
 
 цел глуПострой3МУровниМипмап(Гперечень цель, цел внутрФормат, Гцразм ширина, Гцразм высота, Гцразм глубина, Гперечень формат, Гперечень тип, цел уровень, цел ова, цел макс,  ук данные)
	{return cast(цел)  gluBuild3DMipmapLevels (cast(GLenum) цель, cast(GLint) внутрФормат, cast(GLsizei) ширина, cast(GLsizei) высота, cast(GLsizei) глубина, cast(GLenum) формат, cast(GLenum) тип, cast(GLint) уровень, cast(GLint) ова, cast(GLint) макс,  данные);}
 
 цел глуПострой3ММипмапы(Гперечень цель, цел внутрФормат, Гцразм ширина, Гцразм высота, Гцразм глубина, Гперечень формат, Гперечень тип,  ук данные)
	{return cast(цел)  gluBuild3DMipmaps (cast(GLenum) цель, cast(GLint) внутрФормат, cast(GLsizei) ширина, cast(GLsizei) высота, cast(GLsizei) глубина, cast(GLenum) формат, cast(GLenum) тип, данные);}
 
 Гбул глуПроверьРасширение(сим *имяРасш,  сим *ткстРасш)
	{return cast(Гбул)  gluCheckExtension ( cast(GLubyte*) имяРасш,  cast(GLubyte*) ткстРасш);}
	
 void глуЦилиндр(Квадр* квад, дво ова, дво верх, дво высота, цел доли, цел пачки)
	{  gluCylinder (cast(GLUquadric*) квад, cast(GLdouble) ова, cast(GLdouble) верх, cast(GLdouble) высота, cast(GLint) доли, cast(GLint) пачки);}
	
 void  глуУдалиОтобразительНурб(Нурб* nurb){gluDeleteNurbsRenderer (cast(GLUnurbs*) nurb);}
 void  глуУдалиКвадр(Квадр *квад){gluDeleteQuadric (cast(GLUquadric*) квад);}
 void  глуУдалиТесс(Тесс *тесс){gluDeleteTess (cast(GLUtesselator*) тесс);}
 
 void  глуДиск(Квадр* квад, дво inner, дво внешний, цел доли, цел loops)
	{gluDisk (cast(GLUquadric*) квад, cast(GLdouble) inner, cast(GLdouble) внешний, cast(GLint) доли, cast(GLint) loops);}
	
 void  глуКонКрив(Нурб* нурб){gluEndCurve (cast(GLUnurbs*) нурб);}
 void  глуКонМногоуг(Тесс *тесс){gluEndPolygon (cast(GLUtesselator*) тесс);}
 void  глуКонПоверхн(Нурб* нурб){gluEndSurface (cast(GLUnurbs*) нурб);}
 void  глуКонОбрез(Нурб* нурб){gluEndTrim (cast(GLUnurbs*) нурб);} 
 сим *глуТкстОш(Гперечень ош){return cast(сим*)  gluErrorString (cast(GLenum) ош);}
  
 void  глуПерспектива(дво fovy, дво aspect, дво zNear, дво zFar)
	{gluPerspective (cast(GLdouble) fovy, cast(GLdouble) aspect, cast(GLdouble) zNear, cast(GLdouble) zFar);}
 void  глуОрто2М(дво лево, дво право, дво низ, дво верх)
	{gluOrtho2D (cast(GLdouble) лево, cast(GLdouble) право, cast(GLdouble) низ, cast(GLdouble) верх);}
 
 ////////////////////
 void  глуДайСвойствоНурб(Нурб* nurb, Гперечень property, плав* данные){gluGetNurbsProperty (cast(GLUnurbs*) nurb, cast(GLenum) property, cast(GLfloat*) данные);}
 
 сим *глуДайТкст(Гперечень имя){return cast(сим *)  gluGetString (cast(GLenum) имя);}
 
 void  глуДайСвойствоТесс(Тесс* тесс, Гперечень какой, дво* данные){gluGetTessProperty (cast(GLUtesselator*) тесс, cast(GLenum) какой, cast(GLdouble*) данные);}
 
 void  глуЗагрузиМатрицыСемплинга(Нурб* нурб, плав* модель, плав* перспектива, цел *вид){gluLoadSamplingMatrices (cast(GLUnurbs*) нурб,  cast(GLfloat*) модель,  cast(GLfloat*) перспектива, cast(GLint*) вид);}
 
 void  глуВидНа(дво глазШ, дво глазВ, дво глазД, дво центрШ, дво центрВ, дво центрД, дво верхШ, дво верхВ, дво верхД){gluLookAt (cast(GLdouble) глазШ, cast(GLdouble) глазВ, cast(GLdouble) глазД, cast(GLdouble) центрШ,cast(GLdouble) центрВ, cast(GLdouble) центрД, cast(GLdouble) верхШ, cast(GLdouble) верхВ, cast(GLdouble) верхД);}
 
 Нурб* глуНовыйОтобразительНурб(){return cast(Нурб*)  gluNewNurbsRenderer ();}
 
 Квадр* глуНовыйКвадрик(){return cast(Квадр*)  gluNewQuadric ();}
 
 Тесс* глуНовыйТесс(){return cast(Тесс*)  gluNewTess ();}
 
 void  глуСледщКонтур(Тесс* тесс, Гперечень тип){gluNextContour (cast(GLUtesselator*) тесс, cast(GLenum) тип);} 
 
 void  глуОбрвызовНурбс(Нурб* нурб, Гперечень какой, сифунк фов){ gluNurbsCallback (cast(GLUnurbs*) нурб, cast(GLenum) какой, фов);}
 
 void  глуДанныеОбрвызоваНурб(Нурб* нурб, ук пользДанн){gluNurbsCallbackData (cast(GLUnurbs*) нурб, cast(GLvoid*) пользДанн);}
 
 void глуДанныеОбрвызоваНурбДОП(Нурб* нурб, ук пользДанн){ gluNurbsCallbackDataEXT (cast(GLUnurbs*) нурб,cast(GLvoid*) пользДанн);}
 
 void  глуКриваяНурб(Нурб* нурб, цел члоуз, плав* узлы, цел страйд, плав* упрэлт, цел порядок, Гперечень тип){gluNurbsCurve (cast(GLUnurbs*) нурб, cast(GLint) члоуз, cast(GLfloat*) узлы,cast(GLint) страйд, cast(GLfloat*) упрэлт, cast(GLint) порядок,cast(GLenum) тип);}
 
 void  глуСвойствоНурб(Нурб* нурб, Гперечень свойство, плав знач){gluNurbsProperty (cast(GLUnurbs*) нурб, cast(GLenum) свойство, cast(GLfloat) знач);}
 
 void  глуПоверхностьНурб(Нурб* нурб, цел члоузс, плав* узлыс, цел члоузт, плав* узлыт, цел пролётс, цел пролётт, плав* упрэлт, цел спорядок, цел тпорядок, Гперечень тип){gluNurbsSurface (cast(GLUnurbs*) нурб, cast(GLint) члоузс, cast(GLfloat*) узлыс, cast(GLint) члоузт, cast(GLfloat*) узлыт, cast(GLint) пролётс, cast(GLint) пролётт, cast(GLfloat*) упрэлт, cast(GLint) спорядок, cast(GLint) тпорядок, cast(GLenum) тип);}
 
 void  глуПолуДиск(Квадр* квад, дво внутр, дво наруж, цел доли, цел петли, дво старт, дво метла){gluPartialDisk (cast(GLUquadric*) квад, cast(GLdouble) внутр, cast(GLdouble) наруж, cast(GLint) доли, cast(GLint) петли, cast(GLdouble) старт, cast(GLdouble) метла);}
 
 ///////////////////////
 void  глуПодбериМатрицу(дво ш, дво в, дво делШ, дво делВ, цел *вьюпорт)
	{gluPickMatrix (cast(GLdouble) ш, cast(GLdouble) в, cast(GLdouble) делШ, cast(GLdouble) делВ, cast(GLint*) вьюпорт);}
	
 цел глуПроекция(дво обШ, дво обВ, дво обД, дво* модель, дво* проекц, цел *вид, дво *окШ, дво *окВ, дво *окД)
	 {
	 return cast(цел)  gluProject (cast(GLdouble) обШ, cast(GLdouble) обВ, cast(GLdouble) обД,  cast(GLdouble*) модель,  cast(GLdouble*) проекц,  cast(GLint*) вид, cast(GLdouble*) окШ, cast(GLdouble*) окВ, cast(GLdouble*) окД);
	 }
 
 /*
 void  gluPwlCurve (cast(GLUnurbs*) нурб, cast(GLint) count, cast(GLfloat*) данные, cast(GLint) stride, cast(GLenum) тип);
 */
 
 void  глуОбрвызовКвадра(Квадр* квад, Гперечень который, сифунк фов) {gluQuadricCallback (cast(GLUquadric*) квад, cast(GLenum) который, фов);}
 
 void глуКвадрСтильРисования(Квадр* квад, Гперечень рис)
	{  gluQuadricDrawStyle (cast(GLUquadric*) квад, cast(GLenum) рис);}
 
 void  глуКвадрНормали(Квадр* квад, Гперечень нормаль)
	{gluQuadricNormals (cast(GLUquadric*) квад, cast(GLenum) нормаль);}
 
 void  глуКвадрОриентация(Квадр* квад, Гперечень ориент){gluQuadricOrientation (cast(GLUquadric*) квад, cast(GLenum) ориент);}
 
 void  глуКвадрТекстура(Квадр* квад, бул текстура)
	{ gluQuadricTexture (cast(GLUquadric*) квад, cast(GLboolean) текстура);}
 /*
 цел cast(GLint)  gluScaleImage (cast(GLenum) формат, GLsizei wIn, GLsizei hIn, cast(GLenum) typeIn,  ук dataIn, GLsizei wOut, GLsizei hOut, cast(GLenum) typeOut, GLvoid* dataOut);
 */
 
 void  глуШар(Квадр* квад, дво радиус, цел доли, цел пачки)
	{ gluSphere (cast(GLUquadric*) квад, cast(GLdouble) радиус, cast(GLint) доли, cast(GLint) пачки);}
 
 void  глуТессНачниКонтур(Тесс* тесс)
	{gluTessBeginContour (cast(GLUtesselator*) тесс);}

 void  глуТессНачниМногогран(Тесс* тесс, ук данные)
	{gluTessBeginPolygon (cast(GLUtesselator*) тесс, cast(GLvoid*) данные);}
 
 void  глуОбрвызовТесс(Тесс* тесс, Гперечень который, сифунк ов){gluTessCallback (cast(GLUtesselator*) тесс, cast(GLenum) который, ов);}
 
 void  глуТессЗавершиКонтур(Тесс* тесс){gluTessEndContour (cast(GLUtesselator*) тесс);}
 
 void  глуТессЗавершиМногогран(Тесс* тесс){gluTessEndPolygon (cast(GLUtesselator*) тесс);}
 
 void  глуТессНормаль(Тесс* тесс, дво значШ, дво значВ, дво значД){gluTessNormal (cast(GLUtesselator*) тесс, cast(GLdouble) значШ, cast(GLdouble) значШ, cast(GLdouble) значД);}
 
 void  глуТессСвойство(Тесс* тесс, Гперечень который, дво данные){gluTessProperty (cast(GLUtesselator*) тесс, cast(GLenum) который, cast(GLdouble) данные);}
 
 void  глуТессВершина(Тесс* тесс, дво *положен, ук данные){gluTessVertex (cast(GLUtesselator*) тесс, cast(GLdouble*) положен, cast(GLvoid*) данные);}
 
 /*
 цел cast(GLint)  gluUnProject (cast(GLdouble) winX, cast(GLdouble) winY, cast(GLdouble) winZ,  cast(GLdouble) *model,  cast(GLdouble) *proj,  cast(GLint) *view, cast(GLdouble)* objX, cast(GLdouble)* objY, cast(GLdouble)* objZ);
 
 
 целcast(GLint)  gluUnProject4 (cast(GLdouble) winX, cast(GLdouble) winY, cast(GLdouble) winZ, cast(GLdouble) clipW,  cast(GLdouble) *model,  cast(GLdouble) *proj,  cast(GLint) *view, cast(GLdouble) nearVal, cast(GLdouble) farVal, cast(GLdouble)* objX, cast(GLdouble)* objY, cast(GLdouble)* objZ, cast(GLdouble)* objW);
 */

/*
version (FREEGLUT_EXTRAS)
{
	 void function() glutMainLoopEvent;
		void function() glutLeaveMainLoop;
		void function(сифунк_ЦЦЦЦ) glutMouseWheelFunc;
		void function(сифунк) glutCloseFunc;
		void function(сифунк) glutWMCloseFunc;
		void function(сифунк) glutMenuDestroyFunc;
		void function(cast(GLenum), cast(GLint)) glutSetOption;
		ук function() glutGetWindowData;
		void function(ук) glutSetWindowData;
		ук function() glutGetMenuData;
		void function(ук) glutSetMenuData;
		cast(GLint) function(ук) glutBitmapHeight;
		cast(GLfloat) function(ук) glutStrokeHeight;
		void function(ук, GLchar*) glutBitmapString;
		void function(ук, GLchar*) glutStrokeString;
		void function() glutWireRhombicDodecahedron;
		void function() glutSolidRhombicDodecahedron;
		void function(cast(GLint), cast(GLdouble)[3], cast(GLdouble)) glutWireSierpinskiSponge;
		void function(cast(GLint), cast(GLdouble)[3], cast(GLdouble)) glutSolidSierpinskiSponge;
		void function(cast(GLdouble), cast(GLdouble), cast(GLint), cast(GLint)) glutWireCylinder;
		void function(cast(GLdouble), cast(GLdouble), cast(GLint), cast(GLint)) glutSolidCylinder;
		GLUTproc function(GLchar*) glutGetProcAddress;

}*/
}

