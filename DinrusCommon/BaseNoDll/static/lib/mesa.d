module lib.mesa;

alias extern (/**/C) проц function(сим, цел, цел) сифунк_СЦЦ;
alias extern (/**/C) проц function() сифунк;
alias extern (/**/C) проц function(ббайт, цел, цел) сифунк_бБЦЦ;
alias extern (/**/C) проц function(цел) сифунк_Ц;
alias extern (/**/C) проц function(цел, цел) сифунк_ЦЦ;
alias extern (/**/C) проц function(цел, цел, цел) сифунк_ЦЦЦ;
alias extern (/**/C) проц function(цел, цел, цел, цел) сифунк_ЦЦЦЦ;
alias extern (/**/C) проц function(бцел, цел, цел, цел) сифунк_бЦЦЦЦ;



alias uint      GLenum;
alias ббайт     GLboolean;
alias uint      GLbitfield;
alias void      GLvoid;
alias byte      GLbyte;
alias short     GLshort;
alias int       GLint;
alias ббайт     GLubyte;
alias бкрат    GLushort;
alias uint      GLuint;
alias int       GLsizei;
alias float     GLfloat;
alias float     GLclampf;
alias double    GLdouble;
alias double    GLclampd;
alias char      GLchar;
alias ptrdiff_t GLintptr;
alias ptrdiff_t GLsizeiptr;

// Boolean values
enum : GLboolean
{
    GL_FALSE    = 0x0,
    GL_TRUE    = 0x1,
}

alias бцел      Гперечень;
alias ббайт     Гбул;
alias бцел      Гбитполе;
alias цел       Гцразм;
alias плав     Гклампп;
alias дво    Гклампд;
alias т_дельтаук Гцелук;
alias т_дельтаук Гцразмук;

// Булевы значения
enum : Гбул
{
    г_нет    = 0x0,
    г_да    = 0x1,
}

struct GLUnurbs { }
alias GLUnurbs Нурб;
struct GLUquadric { }
alias GLUquadric Квадр;
struct GLUtesselator { }
alias GLUtesselator Тесс;

alias GLUnurbs GLUnurbsObj;
alias GLUquadric GLUquadricObj;
alias GLUtesselator GLUtesselatorObj;
alias GLUtesselator GLUtriangulatorObj;

extern(D)
{

    проц глОчистиИндекс(плав а) {glClearIndex(cast(GLfloat) а);}
    проц глЦветОчистки(Гклампп а,Гклампп б,Гклампп в,Гклампп г) { glClearColor(cast(GLclampf) а, cast(GLclampf) б, cast(GLclampf) в, cast(GLclampf) г);}
    проц глОчисти(Гбитполе а) {glClear(cast(GLbitfield) а);}
    проц глМаскаИндекса(бцел а) { glIndexMask(cast(GLuint) а);}
    проц глМаскаЦвета(Гбул а,Гбул б,Гбул в,Гбул г){ glColorMask(cast(GLboolean) а, cast(GLboolean) б,cast(GLboolean) в,cast(GLboolean) г);}
    проц глФункцАльфы(Гперечень а,Гклампп б){ glAlphaFunc(cast(GLenum) а,cast(GLclampf) б);}
    проц глФункцСмеси(Гперечень а,Гперечень б){ glBlendFunc(cast(GLenum) а, cast(GLenum) б);}
    проц глЛогическаяОп(Гперечень а){ glLogicOp(cast(GLenum) а);}
    проц глПрофиль(Гперечень а){ glCullFace(cast(GLenum) а);}
    проц глФас(Гперечень а){ glFrontFace(cast(GLenum) а);}
    проц глРазмерТочки(плав а){ glPointSize(cast(GLfloat) а);}
    проц глШиринаЛинии(плав а){ glLineWidth(cast(GLfloat) а);}
    проц глПолоскаЛиний(цел а,бкрат б){ glLineStipple(cast(GLint) а, cast(GLushort) б);}
    проц глРежимМногоуг(Гперечень а,Гперечень б){ glPolygonMode(cast(GLenum) а,cast(GLenum) б);}
    проц глСмещениеМногоуг(плав а,плав б){ glPolygonOffset(cast(GLfloat) а,cast(GLfloat) б);}
    проц глПолоскаМногоуг(ббайт* а){ glPolygonStipple(cast(GLubyte*) а);}
    проц глДайПолоскуМногоуг(ббайт* а){ glGetPolygonStipple(cast(GLubyte*) а);}
    проц глФлагКрая(Гбул а){ glEdgeFlag(cast(GLboolean) а);}
    проц глФлагКрая(Гбул* а){glEdgeFlagv(cast(GLboolean*) а);}
    проц глНожницы(цел а,цел б,Гцразм в,Гцразм г){ glScissor(cast(GLint) а, cast(GLint) б,cast(GLsizei) в,cast(GLsizei) г);}
    проц глОПлоскостьОбрезки(Гперечень а,дво* б) {glClipPlane(cast(GLenum) а, cast(GLdouble*) б);}
    проц глДайПлоскостьОбрезки(Гперечень а,дво* б){ glGetClipPlane(cast(GLenum) а,cast(GLdouble*) б);}
    проц глБуфРис(Гперечень а){ glDrawBuffer(cast(GLenum) а);}
    проц глБуфЧтения(Гперечень а){ glReadBuffer(cast(GLenum) а);}
    проц глВключи(Гперечень а){ glEnable(cast(GLenum) а);}
    проц глОтключи(Гперечень а){ glDisable(cast(GLenum) а);}
    Гбул  глВключен_ли(Гперечень а){return cast(Гбул)  glIsEnabled(cast(GLenum) а);}
    проц глВключиСостояниеКлиента(Гперечень а){ glEnableClientState(cast(GLenum) а);}
    проц глОтключиСостояниеКлиента(Гперечень а){ glDisableClientState(cast(GLenum) а);}
    проц глДайБул(Гперечень а,Гбул* б){ glGetBooleanv(cast(GLenum) а,cast(GLboolean*) б);}
    проц глДайДво(Гперечень а,дво* б){ glGetDoublev(cast(GLenum) а, cast(GLdouble*) б);}
    проц глДайПлав(Гперечень а,плав* б){ glGetFloatv(cast(GLenum) а,cast(GLfloat*) б);}
    проц глДайЦел(Гперечень а,цел* б){ glGetIntegerv(cast(GLenum) а,cast(GLint*) б);}
    проц глСуньАтриб(Гбитполе а){ glPushAttrib(cast(GLbitfield) а);}
    проц глВыньАтриб(){ glPopAttrib();}
    проц глСуньАтрибКлиента(Гбитполе а){ glPushClientAttrib(cast(GLbitfield) а);}
    проц глВыньАтрибКлиента() {glPopClientAttrib();}
    цел глРежимОтображения(Гперечень а){return cast(цел) glRenderMode(cast(GLenum) а);}
    Гперечень глДайОшибку(){return cast(Гперечень)  glGetError();}
    сим* глДайТекст(Гперечень а){return cast(сим*)  glGetString(cast(GLenum) а);}
    проц глФиниш(){ glFinish();}
    проц глСлей(){ glFlush();}
    проц глПодсказка(Гперечень а,Гперечень б){ glHint(cast(GLenum) а, cast(GLenum) б);}

    проц глОчистиДаль(Гклампд а){ glClearDepth(cast(GLclampd) а);}
    проц глФункцДали(Гперечень а){ glDepthFunc(cast(GLenum) а);}
    проц глМаскаДали(Гбул а){ glDepthMask(cast(GLboolean) а);}
    проц глДиапазонДали(Гклампд а,Гклампд б){ glDepthRange(cast(GLclampd) а,cast(GLclampd) б);}

    проц глОчистиАккум(плав а,плав б,плав в,плав г){ glClearAccum(cast(GLfloat) а, cast(GLfloat) б,cast(GLfloat) в, cast(GLfloat) г);}
    проц глАккум(Гперечень а,плав б){ glAccum(cast(GLenum) а, cast(GLfloat) б);}

    проц глРежимМатр(Гперечень а){ glMatrixMode(cast(GLenum) а);}
    проц глОрто(дво а,дво б,дво в,дво г,дво д,дво е){ glOrtho(cast(GLdouble) а,cast(GLdouble) б,cast(GLdouble) в,cast(GLdouble) г,cast(GLdouble) д, cast(GLdouble) е);}
    проц глФруструм(дво а,дво б,дво в,дво г,дво д,дво е){ glFrustum(cast(GLdouble) а,cast(GLdouble) б,cast(GLdouble) в,cast(GLdouble) г,cast(GLdouble) д,cast(GLdouble) е);}
    проц глВьюпорт(цел а,цел б,Гцразм в,Гцразм г){ glViewport(cast(GLint) а, cast(GLint) б, в, г);}
    проц глСуньМатр(){ glPushMatrix();}
    проц глВыньМатр(){ glPopMatrix();}
    проц глЗагрузиИдент() {glLoadIdentity();}
    проц глЗагрузиМатр(дво* а) {glLoadMatrixd(cast(GLdouble*) а);}
    проц глЗагрузиМатр(плав* а){ glLoadMatrixf(cast(GLfloat*) а);}
    проц глУмножьМатр(дво* а){ glMultMatrixd(cast(GLdouble*) а);}
    проц глУмножьМатр(плав* а){ glMultMatrixf(cast(GLfloat*) а);}
    проц глВращайд(дво а,дво б,дво в,дво г){ glRotated(cast(GLdouble) а,cast(GLdouble)  б,cast(GLdouble)  в,cast(GLdouble)  г);}
    проц глВращай(плав а,плав б,плав в,плав г){ glRotatef(cast(GLfloat) а, cast(GLfloat) б, cast(GLfloat) в, cast(GLfloat) г);}
    проц глМасштабируйд(дво а,дво б,дво в){ glScaled(cast(GLdouble) а,cast(GLdouble)  б,cast(GLdouble)  в);}
    проц глМасштабируй(плав а,плав б,плав в){ glScalef(cast(GLfloat) а, cast(GLfloat) б, cast(GLfloat) в);}
    проц глПеренесид(дво а,дво б,дво в){ glTranslated(cast(GLdouble) а,cast(GLdouble)  б,cast(GLdouble)  в);}
    проц глПеренеси(плав а,плав б,плав в){ glTranslatef(cast(GLfloat) а, cast(GLfloat) б,cast(GLfloat)  в);}

    Гбул  глСписок_ли(бцел а){return cast(Гбул)  glIsList(а);}
    проц глУдалиСписки(бцел а,Гцразм б){ glDeleteLists(а, б);}
    бцел глГенСписки(Гцразм а){return  cast(бцел) glGenLists(а);}
    проц глНовСписок(бцел а,Гперечень б){ glNewList(а, cast(GLenum) б);}
    проц глКонецСписка(){ glEndList();}
    проц глВызовиСписок(бцел а){ glCallList(а);}
    проц глВызовиСписки(Гцразм а,Гперечень б,ук в){ glCallLists(а, cast(GLenum) б, в);}
    проц глОваСписка(бцел а){ glListBase(а);}

    проц глНачни(Гперечень а){ glBegin(cast(GLenum) а);}
    проц глСтоп(){ glEnd();}
    проц глВершинад(дво а,дво б){ glVertex2d(cast(GLdouble) а,cast(GLdouble)  б);}
    проц глВершина(плав а,плав б){ glVertex2f(cast(GLfloat) а,cast(GLfloat) б);}
    проц глВершина(цел а,цел б){ glVertex2i(а, б);}
    проц глВершина(крат а,крат б){ glVertex2s(а, б);}
    проц глВершинад(дво а,дво б,дво в){ glVertex3d(cast(GLdouble) а,cast(GLdouble)  б,cast(GLdouble)  в);}
    проц глВершина(плав а,плав б,плав в){ glVertex3f(cast(GLfloat) а, cast(GLfloat) б, cast(GLfloat) в);}
    проц глВершина(цел а,цел б,цел в){ glVertex3i(а, б, в);}
    проц глВершина(крат а,крат б,крат в){ glVertex3s(а, б, в);}
    проц глВершинад(дво а,дво б,дво в,дво г){ glVertex4d(cast(GLdouble) а,cast(GLdouble)  б,cast(GLdouble)  в,cast(GLdouble)  г);}
    проц глВершина(плав а,плав б,плав в,плав г){ glVertex4f(cast(GLfloat) а, cast(GLfloat) б, cast(GLfloat) в, cast(GLfloat) г);}
    проц глВершина(цел а,цел б,цел в,цел г){ glVertex4i(а, б, в, г);}
    проц глВершина(крат а,крат б,крат в,крат г){ glVertex4s(а, б, в, г);}
    проц глВершина2(дво* а) {glVertex2dv(cast(GLdouble*) а);}
    проц глВершина2(плав* а){ glVertex2fv(cast(GLfloat*) а);}
    проц глВершина2(цел* а){ glVertex2iv(а);}
    проц глВершина2(крат* а) {glVertex2sv(а);}
    проц глВершина3(дво* а) {glVertex3dv(cast(GLdouble*) а);}
    проц глВершина3(плав* а){ glVertex3fv(cast(GLfloat*) а);}
    проц глВершина3(цел* а){ glVertex3iv(а);}
    проц глВершина3(крат* а){ glVertex3sv(а);}
    проц глВершина4(дво* а){ glVertex4dv(cast(GLdouble*) а);}
    проц глВершина4(плав* а){ glVertex4fv(cast(GLfloat*) а);}
    проц глВершина4(цел* а){ glVertex4iv(а);}
    проц глВершина4(крат* а) {glVertex4sv(а);}
    проц глНормаль(байт а,байт б,байт в){ glNormal3b(а, б, в);}
    проц глНормальд(дво а,дво б,дво в){ glNormal3d(cast(GLdouble) а,cast(GLdouble)  б,cast(GLdouble)  в);}
    проц глНормаль(плав а,плав б,плав в){ glNormal3f(cast(GLfloat) а, cast(GLfloat) б,cast(GLfloat)  в);}
    проц глНормаль(цел а,цел б,цел в){ glNormal3i(а, б, в);}
    проц глНормаль(крат а,крат б,крат в){ glNormal3s(а, б, в);}
    проц глНормаль(байт* а){ glNormal3bv(а);}
    проц глНормаль(дво* а){ glNormal3dv(cast(GLdouble*) а);}
    проц глНормаль(плав* а){ glNormal3fv(cast(GLfloat*) а);}
    проц глНормаль(цел* а) {glNormal3iv(а);}
    проц глНормаль(крат* а){ glNormal3sv(а);}
    проц глИндексд(дво а){ glIndexd(cast(GLdouble) а);}
    проц глИндекс(плав а){ glIndexf(cast(GLfloat) а);}
    проц глИндекс(цел а){ glIndexi(а);}
    проц глИндекс(крат а){ glIndexs(а);}
    проц глИндекс(ббайт а){ glIndexub(а);}
    проц глИндекс(дво* а){ glIndexdv(cast(GLdouble*) а);}
    проц глИндекс(плав* а){ glIndexfv(cast(GLfloat*) а);}
    проц глИндекс(цел* а){ glIndexiv(а);}
    проц глИндекс(крат* а){ glIndexsv(а);}
    проц глИндекс(ббайт* а) {glIndexubv(а);}
    проц глЦвет(байт а,байт б,байт в){ glColor3b(а,б,в);}
    проц глЦветд(дво а,дво б,дво в){ glColor3d(cast(GLdouble) а,cast(GLdouble) б,cast(GLdouble) в);}
    проц глЦвет(плав а,плав б,плав в){ glColor3f(cast(GLfloat) а,cast(GLfloat) б,cast(GLfloat) в);}
    проц глЦвет(цел а,цел б,цел в){ glColor3i(а,б,в);}
    проц глЦвет(крат а,крат б,крат в){ glColor3s(а,б,в);}
    проц глЦвет(ббайт а,ббайт б,ббайт в){ glColor3ub(а,б,в);}
    проц глЦвет(бцел а,бцел б,бцел в){ glColor3ui(а,б,в);}
    проц глЦвет(бкрат а,бкрат б,бкрат в){ glColor3us(а,б,в);}
    проц глЦвет(байт а,байт б,байт в,байт г){ glColor4b(а,б,в,г);}
    проц глЦветд(дво а,дво б,дво в,дво г){ glColor4d(cast(GLdouble) а,cast(GLdouble) б,cast(GLdouble) в,cast(GLdouble) г);}
    проц глЦвет(плав а,плав б,плав в,плав г){ glColor4f(cast(GLfloat) а,cast(GLfloat) б,cast(GLfloat) в,cast(GLfloat) г);}
    проц глЦвет(цел а,цел б,цел в,цел г){ glColor4i(а,б,в,г);}
    проц глЦвет(крат а,крат б,крат в,крат г){ glColor4s(а,б,в,г);}
    проц глЦвет(ббайт а,ббайт б,ббайт в,ббайт г){ glColor4ub(а,б,в,г);}
    проц глЦвет(бцел а,бцел б,бцел в,бцел г){ glColor4ui(а,б,в,г);}
    проц глЦвет(бкрат а,бкрат б,бкрат в,бкрат г){ glColor4us(а,б,в,г);}
    проц глЦвет3(байт* а){ glColor3bv(cast(GLbyte*) а);}
    проц глЦвет3(дво* а){ glColor3dv(cast(GLdouble*) а);}
    проц глЦвет3(плав* а){ glColor3fv(cast(GLfloat*) а);}
    проц глЦвет3(цел* а) {glColor3iv(cast(GLint*) а);}
    проц глЦвет3(крат* а){ glColor3sv(cast(GLshort*) а);}
    проц глЦвет3(ббайт* а){ glColor3ubv(cast(GLubyte*) а);}
    проц глЦвет3(бцел* а){ glColor3uiv(cast(GLuint*) а);}
    проц глЦвет3(бкрат* а){ glColor3usv(cast(GLushort*) а);}
    проц глЦвет4(байт* а){ glColor4bv(cast(GLbyte*) а);}
    проц глЦвет4(дво* а){ glColor4dv(cast(GLdouble*) а);}
    проц глЦвет4(плав* а){ glColor4fv(cast(GLfloat*) а);}
    проц глЦвет4(цел* а){ glColor4iv(cast(GLint*) а);}
    проц глЦвет4(крат* а){ glColor4sv(cast(GLshort*) а);}
    проц глЦвет4(ббайт* а) {glColor4ubv(cast(GLubyte*) а);}
    проц глЦвет4(бцел* а){ glColor4uiv(cast(GLuint*) а);}
    проц глЦвет4(бкрат* а){ glColor4usv(cast(GLushort*) а);}
    проц глКоордТексд(дво а){ glTexCoord1d(cast(GLdouble) а);}
    проц глКоордТекс(плав а){ glTexCoord1f(cast(GLfloat) а);}
    проц глКоордТекс(цел а){ glTexCoord1i(cast(GLint) а);}
    проц глКоордТекс(крат а){ glTexCoord1s(cast(GLshort) а);}
    проц глКоордТексд(дво а,дво б){ glTexCoord2d(cast(GLdouble) а,cast(GLdouble) б);}
    проц глКоордТекс(плав а,плав б){ glTexCoord2f(cast(GLfloat) а,cast(GLfloat) б);}
    проц глКоордТекс(цел а,цел б){ glTexCoord2i(cast(GLint) а,cast(GLint) б);}
    проц глКоордТекс(крат а,крат б){ glTexCoord2s(cast(GLshort) а,cast(GLshort) б);}
    проц глКоордТексд(дво а,дво б,дво в){ glTexCoord3d(cast(GLdouble) а,cast(GLdouble) б,cast(GLdouble) в);}
    проц глКоордТекс(плав а,плав б,плав в){ glTexCoord3f(cast(GLfloat) а,cast(GLfloat) б,cast(GLfloat) в);}
    проц глКоордТекс(цел а,цел б,цел в){ glTexCoord3i(cast(GLint) а,cast(GLint) б,cast(GLint) в);}
    проц глКоордТекс(крат а,крат б,крат в){ glTexCoord3s(cast(GLshort) а,cast(GLshort) б,cast(GLshort) в);}
    проц глКоордТексд(дво а,дво б,дво в,дво г){ glTexCoord4d(cast(GLdouble) а,cast(GLdouble) б,cast(GLdouble) в,cast(GLdouble) г);}
    проц глКоордТекс(плав а,плав б,плав в,плав г){ glTexCoord4f(cast(GLfloat) а,cast(GLfloat) б,cast(GLfloat) в,cast(GLfloat) г);}
    проц глКоордТекс(цел а,цел б,цел в,цел г){ glTexCoord4i(а,б,в,г);}
    проц глКоордТекс(крат а,крат б,крат в,крат г){ glTexCoord4s(а,б,в,г);}
    проц глКоордТекс1(дво* а) {glTexCoord1dv(cast(GLdouble*) а);}
    проц глКоордТекс1(плав* а){ glTexCoord1fv(cast(GLfloat*) а);}
    проц глКоордТекс1(цел* а){ glTexCoord1iv(а);}
    проц глКоордТекс1(крат* а){ glTexCoord1sv(а);}
    проц глКоордТекс2(дво* а){ glTexCoord2dv(cast(GLdouble*) а);}
    проц глКоордТекс2(плав* а){ glTexCoord2fv(cast(GLfloat*) а);}
    проц глКоордТекс2(цел* а){ glTexCoord2iv(а);}
    проц глКоордТекс2(крат* а){ glTexCoord2sv(а);}
    проц глКоордТекс3(дво* а){ glTexCoord3dv(cast(GLdouble*) а);}
    проц глКоордТекс3(плав* а){ glTexCoord3fv(cast(GLfloat*) а);}
    проц глКоордТекс3(цел* а){ glTexCoord3iv(а);}
    проц глКоордТекс3(крат* а) {glTexCoord3sv(а);}
    проц глКоордТекс4(дво* а){ glTexCoord4dv(cast(GLdouble*) а);}
    проц глКоордТекс4(плав* а) {glTexCoord4fv(cast(GLfloat*) а);}
    проц глКоордТекс4(цел* а){ glTexCoord4iv(а);}
    проц глКоордТекс4(крат* а) {glTexCoord4sv(а);}
    проц глПозРастрад(дво а,дво б){ glRasterPos2d(cast(GLdouble) а,cast(GLdouble) б);}
    проц глПозРастра(плав а,плав б){ glRasterPos2f(cast(GLfloat) а,cast(GLfloat) б);}
    проц глПозРастра(цел а,цел б){ glRasterPos2i(а,б);}
    проц глПозРастра(крат а,крат б){ glRasterPos2s(а,б);}
    проц глПозРастрад(дво а,дво б,дво в){ glRasterPos3d(cast(GLdouble) а,cast(GLdouble) б,cast(GLdouble) в);}
    проц глПозРастра(плав а,плав б,плав в){ glRasterPos3f(cast(GLfloat) а,cast(GLfloat) б,cast(GLfloat) в);}
    проц глПозРастра(цел а,цел б,цел в) { glRasterPos3i(а,б,в);}
    проц глПозРастра(крат а,крат б,крат в){ glRasterPos3s(а,б,в);}
    проц глПозРастрад(дво а,дво б,дво в,дво г){ glRasterPos4d(cast(GLdouble) а,cast(GLdouble) б,cast(GLdouble) в,cast(GLdouble) г);}
    проц глПозРастра(плав а,плав б,плав в,плав г){ glRasterPos4f(cast(GLfloat) а,cast(GLfloat) б,cast(GLfloat) в,cast(GLfloat) г);}
    проц глПозРастра(цел а,цел б,цел в,цел г){ glRasterPos4i(а,б,в,г);}
    проц глПозРастра(крат а,крат б,крат в,крат г){ glRasterPos4s(а,б,в,г);}
    проц глПозРастра2(дво* а) {glRasterPos2dv(cast(GLdouble*) а);}
    проц глПозРастра2(плав* а){ glRasterPos2fv(cast(GLfloat*) а);}
    проц глПозРастра2(цел* а) {glRasterPos2iv(а);}
    проц глПозРастра2(крат* а){ glRasterPos2sv(а);}
    проц глПозРастра3(дво* а){ glRasterPos3dv(cast(GLdouble*) а);}
    проц глПозРастра3(плав* а){ glRasterPos3fv(cast(GLfloat*) а);}
    проц глПозРастра3(цел* а){ glRasterPos3iv(а);}
    проц глПозРастра3(крат* а) {glRasterPos3sv(а);}
    проц глПозРастра4(дво* а){ glRasterPos4dv(cast(GLdouble*) а);}
    проц глПозРастра4(плав* а){ glRasterPos4fv(cast(GLfloat*) а);}
    проц глПозРастра4(цел* а){ glRasterPos4iv(а);}
    проц глПозРастра4(крат* а) {glRasterPos4sv(а);}
    проц глПрямоугд(дво а,дво б,дво в,дво г){ glRectd(cast(GLdouble) а,cast(GLdouble) б,cast(GLdouble) в,cast(GLdouble) г);}
    проц глПрямоуг(плав а,плав б,плав в,плав г){ glRectf(cast(GLfloat) а,cast(GLfloat) б,cast(GLfloat) в,cast(GLfloat) г);}
    проц глПрямоуг(цел а,цел б,цел в,цел г){ glRecti(cast(GLint) а,cast(GLint) б,cast(GLint) в,cast(GLint) г);}
    проц глПрямоуг(крат а,крат б,крат в,крат г){ glRects(cast(GLshort) а,cast(GLshort) б,cast(GLshort) в,cast(GLshort) г);}
    проц глПрямоуг(дво* а, дво* б) {glRectdv(cast(GLdouble*) а,cast(GLdouble*) б);}
    проц глПрямоуг(плав* а, плав* б) {glRectfv(cast(GLfloat*) а,cast(GLfloat*) б);}
    проц глПрямоуг(цел* а, цел* б) {glRectiv(cast(GLint*) а,cast(GLint*) б);}
    проц глПрямоуг(крат* а, крат* б){ glRectsv(cast(GLshort*)а,cast(GLshort*) б);}

    проц глМодельТени(Гперечень а){ glShadeModel(cast(GLenum) а);}
    проц глСвет(Гперечень а,Гперечень б,плав в){ glLightf(cast(GLenum) а,cast(GLenum) б,cast(GLfloat) в);}
    проц глСвет(Гперечень а,Гперечень б,цел в){ glLighti(cast(GLenum) а,cast(GLenum) б,cast(GLint) в);}
    проц глСвет(Гперечень а,Гперечень б,плав* в){ glLightfv(cast(GLenum) а,cast(GLenum) б,cast(GLfloat*) в);}
    проц глСвет(Гперечень а,Гперечень б,цел* в){ glLightiv(cast(GLenum) а,cast(GLenum) б,cast(GLint*) в);}
    проц глДайСвет(Гперечень а,Гперечень б,плав* в) {glGetLightfv(cast(GLenum) а,cast(GLenum) б,cast(GLfloat*) в);}
    проц глДайСвет(Гперечень а,Гперечень б,цел* в){ glGetLightiv(cast(GLenum) а,cast(GLenum) б,cast(GLint*) в);}
    проц глМодельСвета(Гперечень а,плав б){ glLightModelf(cast(GLenum) а,cast(GLfloat) б);}
    проц глМодельСвета(Гперечень а,цел б){ glLightModeli(cast(GLenum) а,cast(GLint) б);}
    проц глМодельСвета(Гперечень а,плав* б){ glLightModelfv(cast(GLenum) а,cast(GLfloat*) б);}
    проц глМодельСвета(Гперечень а,цел* б) {glLightModeliv(cast(GLenum) а,cast(GLint*) б);}
    проц глМатериал(Гперечень а,Гперечень б,плав в){ glMaterialf(cast(GLenum) а,cast(GLenum) б,cast(GLfloat) в);}
    проц глМатериал(Гперечень а,Гперечень б,цел в){ glMateriali(cast(GLenum) а,cast(GLenum) б,cast(GLint) в);}
    проц глМатериал(Гперечень а,Гперечень б,плав* в){ glMaterialfv(cast(GLenum) а,cast(GLenum) б,cast(GLfloat*) в);}
    проц глМатериал(Гперечень а,Гперечень б,цел* в){ glMaterialiv(cast(GLenum) а,cast(GLenum) б,cast(GLint*) в);}
    проц глДайМатериал(Гперечень а,Гперечень б,плав* в){ glGetMaterialfv(cast(GLenum) а,cast(GLenum) б,cast(GLfloat*) в);}
    проц глДайМатериал(Гперечень а,Гперечень б,цел* в){ glGetMaterialiv(cast(GLenum) а,cast(GLenum) б,cast(GLint*) в);}
    проц глМатериалЦвета(Гперечень а,Гперечень б){ glColorMaterial(cast(GLenum) а,cast(GLenum) б);}
	
    проц глЗумПикселя(плав а,плав б){ glPixelZoom(cast(GLfloat) а, cast(GLfloat) б);}
    проц глСохраниПиксель(Гперечень а,плав б){ glPixelStoref(cast(GLenum) а,cast(GLfloat) б);}
    проц глСохраниПиксель(Гперечень а,цел б){ glPixelStorei(cast(GLenum) а,cast(GLint) б);}
    проц глПереместиПиксель(Гперечень а,плав б){ glPixelTransferf(cast(GLenum) а,cast(GLfloat) б);}
    проц глПереместиПиксель(Гперечень а,цел б){ glPixelTransferi(cast(GLenum) а,cast(GLint) б);}
    проц глКартируйПиксель(Гперечень а,цел б,плав* в){ glPixelMapfv(cast(GLenum) а,cast(GLint) б,cast(GLfloat*) в);}
    проц глКартируйПиксель(Гперечень а,цел б,бцел* в){ glPixelMapuiv(cast(GLenum) а,cast(GLint) б,в);}
    проц глКартируйПиксель(Гперечень а,цел б,бкрат* в){ glPixelMapusv(cast(GLenum) а,cast(GLint) б,в);}
    проц глДайКартуПикселя(Гперечень а,плав* б){ glGetPixelMapfv(cast(GLenum) а,cast(GLfloat*) б);}
    проц глДайКартуПикселя(Гперечень а,бцел* б){ glGetPixelMapuiv(cast(GLenum) а,б);}
    проц глДайКартуПикселя(Гперечень а,бкрат* б){ glGetPixelMapusv(cast(GLenum) а,б);}
    проц глБитмап(Гцразм а,Гцразм б,плав в,плав г,плав д,плав е,ббайт* ё){ glBitmap(а,б,cast(GLfloat) в,cast(GLfloat) г,cast(GLfloat) д,cast(GLfloat) е,cast(GLubyte*) ё);}
    проц глЧитайПиксели(цел а,цел б,Гцразм в,Гцразм г,Гперечень д,Гперечень е,ук ё) {glReadPixels(а,cast(GLint) б,cast(GLsizei) в,cast(GLsizei) г,cast(GLenum) д,cast(GLenum) е,ё);}
    проц глРисуйПиксели(Гцразм а,Гцразм б,Гперечень в,Гперечень г,ук д){ glDrawPixels(cast(GLsizei) а,cast(GLsizei) б,cast(GLenum) в,cast(GLenum) г,д);}
    проц глКопируйПиксели(цел а,цел б,Гцразм в,Гцразм г,Гперечень д){ glCopyPixels(cast(GLint) а,cast(GLint) б,cast(GLsizei) в,cast(GLsizei) г,cast(GLenum) д);}

    проц глФункцШаблона(Гперечень а,цел б,бцел в){ glStencilFunc(cast(GLenum) а,cast(GLint) б,cast(GLuint) в);}
    проц глМаскаШаблона(бцел а){ glStencilMask(cast(GLuint) а);}
    проц глОпШаблона(Гперечень а,Гперечень б,Гперечень в){ glStencilOp(cast(GLenum) а,cast(GLenum) б,cast(GLenum) в);}
    проц глОчистиШаблон(цел а){ glClearStencil(cast(GLint) а);}

    проц глГенТекс(Гперечень а,Гперечень б,дво в){ glTexGend(cast(GLenum) а,cast(GLenum) б,cast(GLdouble) в);}
    проц глГенТекс(Гперечень а,Гперечень б,плав в){ glTexGenf(cast(GLenum) а,cast(GLenum) б,cast(GLfloat) в);}
    проц глГенТекс(Гперечень а,Гперечень б,цел в){ glTexGeni(cast(GLenum) а,cast(GLenum) б,в);}
    проц глГенТекс(Гперечень а,Гперечень б,дво* в){ glTexGendv(cast(GLenum) а,cast(GLenum) б,cast(GLdouble*) в);}
    проц глГенТекс(Гперечень а,Гперечень б,плав* в){ glTexGenfv(cast(GLenum) а,cast(GLenum) б,cast(GLfloat*) в);}
    проц глГенТекс(Гперечень а,Гперечень б,цел* в){ glTexGeniv(cast(GLenum) а,cast(GLenum) б,в);}
    проц глДайГенТекс(Гперечень а,Гперечень б,дво* в){ glGetTexGendv(cast(GLenum) а,cast(GLenum) б,cast(GLdouble*) в);}
    проц глДайГенТекс(Гперечень а,Гперечень б,плав* в){ glGetTexGenfv(cast(GLenum) а,cast(GLenum) б,cast(GLfloat*) в);}
    проц глДайГенТекс(Гперечень а,Гперечень б,цел* в){ glGetTexGeniv(cast(GLenum) а,cast(GLenum) б,в);}
    проц глСредаТекс(Гперечень а,Гперечень б,плав в){ glTexEnvf(cast(GLenum) а,cast(GLenum) б,cast(GLfloat) в);}
    проц глСредаТекс(Гперечень а,Гперечень б,цел в){ glTexEnvi(cast(GLenum) а,cast(GLenum) б,в);}
    проц глСредаТекс(Гперечень а,Гперечень б,плав* в){ glTexEnvfv(cast(GLenum) а,cast(GLenum) б,cast(GLfloat*) в);}
    проц глСредаТекс(Гперечень а,Гперечень б,цел* в){ glTexEnviv(cast(GLenum) а,cast(GLenum) б,в);}
    проц глДайСредуТекс(Гперечень а,Гперечень б,плав* в){ glGetTexEnvfv(cast(GLenum) а,cast(GLenum) б,cast(GLfloat*) в);}
    проц глДайСредуТекс(Гперечень а,Гперечень б,цел* в){ glGetTexEnviv(cast(GLenum) а,cast(GLenum) б,в);}
    проц глПараметрТекс(Гперечень а,Гперечень б,плав в){ glTexParameterf(cast(GLenum) а,cast(GLenum) б,cast(GLfloat) в);}
    проц глПараметрТекс(Гперечень а,Гперечень б,цел в){ glTexParameteri(cast(GLenum) а,cast(GLenum) б,в);}
    проц глПараметрТекс(Гперечень а,Гперечень б,плав* в){ glTexParameterfv(cast(GLenum) а,cast(GLenum) б,cast(GLfloat*) в);}
    проц глПараметрТекс(Гперечень а,Гперечень б,цел* в){ glTexParameteriv(cast(GLenum) а,cast(GLenum) б,cast(GLint*) в);}
    проц глДайПараметрТекс(Гперечень а,Гперечень б,плав* в) {glGetTexParameterfv(cast(GLenum) а,cast(GLenum) б,cast(GLfloat*) в);}
    проц глДайПараметрТекс(Гперечень а,Гперечень б,цел* в) {glGetTexParameteriv(cast(GLenum) а,cast(GLenum) б,cast(GLint*) в);}
    проц глДайПараметрУровняТекс(Гперечень а,цел б,Гперечень в,плав* г){ glGetTexLevelParameterfv(cast(GLenum) а,cast(GLint) б,cast(GLenum) в,cast(GLfloat*) г);}
    проц глДайПараметрУровняТекс(Гперечень а,цел б,Гперечень в,цел* г){ glGetTexLevelParameteriv(cast(GLenum) а,б,в,г);}
    проц глОбразТекст1М(Гперечень а,цел б,цел в,Гцразм г,цел д,Гперечень е,Гперечень ё,ук ж){ glTexImage1D(cast(GLenum) а,cast(GLint) б,cast(GLint) в,cast(GLsizei) г,cast(GLint) д,cast(GLenum) е,cast(GLenum) ё,ж);}
    проц глОбразТекс2М(Гперечень а,цел б,цел в,Гцразм г,Гцразм д,цел е,Гперечень ё,Гперечень ж,ук з) {glTexImage2D(cast(GLenum) а,cast(GLint) б,cast(GLint) в,cast(GLsizei) г,cast(GLsizei) д,cast(GLint) е,cast(GLenum) ё,cast(GLenum) ж,з);}
    проц глДайОбразТекс(Гперечень а,цел б,Гперечень в,Гперечень г,ук д){ glGetTexImage(cast(GLenum) а,cast(GLint) б,cast(GLenum) в,cast(GLenum) г,д);}
    проц глКарта1(Гперечень а,дво б,дво в,цел  г,цел д,дво* е){ glMap1d(cast(GLenum) а,cast(GLdouble) б,cast(GLdouble) в,cast(GLint) г,cast(GLint) д,cast(GLdouble*) е);}
    проц глКарта1(Гперечень а,плав б,плав в,цел г,цел д,плав* е){ glMap1f(cast(GLenum) а,cast(GLfloat) б,cast(GLfloat) в,cast(GLint) г,cast(GLint) д,cast(GLfloat*) е);}
    проц глКарта2(Гперечень а,дво б,дво в,цел г,цел д,дво е,дво ё,цел ж,цел з,дво* и) {glMap2d(cast(GLenum) а,cast(GLdouble) б,cast(GLdouble) в,cast(GLint) г,cast(GLint) д,cast(GLdouble) е,cast(GLdouble) ё,cast(GLint) ж,cast(GLint) з,cast(GLdouble*) и);}
    проц глКарта2(Гперечень а,плав б,плав в,цел г,цел д,плав е,плав ё,цел ж,цел з,плав* и) {glMap2f(cast(GLenum) а,cast(GLfloat) б,cast(GLfloat) в,г,д,cast(GLfloat) е,cast(GLfloat) ё,cast(GLint) ж,cast(GLint) з,cast(GLfloat*) и);}
    проц глДайКарту(Гперечень а,Гперечень б,дво* в){ glGetMapdv(cast(GLenum) а,cast(GLenum) б,cast(GLdouble*) в);}
    проц глДайКарту(Гперечень а,Гперечень б,плав* в){ glGetMapfv(cast(GLenum) а,cast(GLenum) б,cast(GLfloat*) в);}
    проц глДайКарту(Гперечень а,Гперечень б,цел* в){ glGetMapiv(cast(GLenum) а,cast(GLenum) б,cast(GLint*) в);}
    проц глОцениКоорд1(дво а){ glEvalCoord1d(cast(GLdouble) а);}
    проц глОцениКоорд1(плав а){ glEvalCoord1f(cast(GLfloat) а);}
    проц глОцениКоорд1(дво* а){ glEvalCoord1dv(cast(GLdouble*) а);}
    проц глОцениКоорд1(плав* а){ glEvalCoord1fv(cast(GLfloat*) а);}
    проц глОцениКоорд2(дво а,дво б){ glEvalCoord2d(cast(GLdouble) а,cast(GLdouble) б);}
    проц глОцениКоорд2(плав а,плав б){ glEvalCoord2f(cast(GLfloat) а,cast(GLfloat) б);}
    проц глОцениКоорд2(дво* а){ glEvalCoord2dv(cast(GLdouble*) а);}
    проц глОцениКоорд2(плав* а){ glEvalCoord2fv(cast(GLfloat*) а);}
    проц глСеткаКарты1(цел а,дво б,дво в){ glMapGrid1d(а,cast(GLdouble) б,cast(GLdouble) в);}
    проц глСеткаКарты1(цел а,плав б,плав в){ glMapGrid1f(а,cast(GLfloat) б,cast(GLfloat) в);}
    проц глСеткаКарты2(цел а,дво б,дво в,цел г,дво д,дво е){ glMapGrid2d(а,cast(GLdouble) б,cast(GLdouble) в,cast(GLint) г,cast(GLdouble) д,cast(GLdouble) е);}
    проц глСеткаКарты2(цел а,плав б,плав в,цел г,плав д,плав е){ glMapGrid2f(cast(GLint) а,cast(GLfloat) б,cast(GLfloat) в,cast(GLint) г,cast(GLfloat) д,cast(GLfloat) е);}
    проц глОцениТочку1(цел а){ glEvalPoint1(cast(GLint) а);}
    проц глОцениТочку2(цел а,цел б){ glEvalPoint2(cast(GLint) а,cast(GLint) б);}
    проц глОцениМеш1(Гперечень а,цел б,цел в){ glEvalMesh1(cast(GLenum) а,cast(GLint) б,cast(GLint) в);}
    проц глОцениМеш2(Гперечень а,цел б,цел в,цел г,цел д){ glEvalMesh2(cast(GLenum) а,cast(GLint) б,cast(GLint) в,cast(GLint) г,cast(GLint) д);}

    проц глТуман(Гперечень а,плав б){ glFogf(cast(GLenum) а,cast(GLfloat) б);}
    проц глТуман(Гперечень а,цел б){ glFogi(cast(GLenum) а,cast(GLint) б);}
    проц глТуман(Гперечень а,плав* б){ glFogfv(cast(GLenum) а,cast(GLfloat*) б);}
    проц глТуман(Гперечень а,цел* б){ glFogiv(cast(GLenum) а,cast(GLint*) б);}

   проц глБуферФидбэка(Гцразм а,Гперечень б,плав* в){ glFeedbackBuffer(cast(GLsizei) а,cast(GLenum) б,cast(GLfloat*) в);}
    проц глПропуск(плав а){ glPassThrough(cast(GLfloat) а);}
    проц глВыбериБуфер(Гцразм а,бцел* б){ glSelectBuffer(cast(GLsizei) а,cast(GLuint*) б);}
    проц глИницИмена(){ glInitNames();}
    проц глЗагрузиИмя(бцел а){ glLoadName(cast(GLuint) а);}
    проц глСуньИмя(бцел а){ glPushName(cast(GLuint) а);}
    проц глВыньИмя(){ glPopName();}

    проц глГенТекстуры(Гцразм а,бцел* б){ glGenTextures(cast(GLsizei)а,cast(GLuint*) б);}
    проц глУдалиТекстуры(Гцразм а,бцел* б){ glDeleteTextures(cast(GLsizei)а,cast(GLuint*) б);}
    проц глПривяжиТекстуру(Гперечень а,бцел б){ glBindTexture(cast(GLenum) а,cast(GLuint) б);}
    проц глПриоритетТекстурам(Гцразм а,бцел* б,Гклампп* в){ glPrioritizeTextures(cast(GLsizei)а,cast(GLuint*) б,в);}
    Гбул  глРезидентныТекстуры_ли(Гцразм а,бцел* б,Гбул* в){return cast(Гбул) glAreTexturesResident(cast(GLsizei) а,б,в);}
    Гбул  глТекстура_ли(бцел а){ return cast(Гбул) glIsTexture(а);}

    проц глПодобразТекст1М(Гперечень а,цел б,цел в,Гцразм г,Гперечень д,Гперечень е,ук ё){ glTexSubImage1D(а,б,в,г,д,е,ё);}
    проц глПодобразТекс2М(Гперечень а,цел б,цел в,цел г,Гцразм д,Гцразм е,Гперечень ё,Гперечень ж,ук з){ glTexSubImage2D(а,б,в,г,cast(GLsizei) д,cast(GLsizei) е,ё,ж,з);}
    проц глКопируйОбразТекс1М(Гперечень а,цел б,Гперечень в,цел г,цел д,Гцразм е,цел ё){ glCopyTexImage1D(а,б,в,г,д,cast(GLsizei) е,ё);}
    проц глКопируйОбразТекст2М(Гперечень а,цел б,Гперечень в,цел г,цел д,Гцразм е,Гцразм ё,цел ж){ glCopyTexImage2D(а,б,в,г,д,cast(GLsizei) е,cast(GLsizei) ё,ж);}
    проц глКопируйПодобразТекс1М(Гперечень а,цел б,цел в,цел г,цел д,Гцразм е){ glCopyTexSubImage1D(а,б,в,г,д,cast(GLsizei) е);}
    проц глКопируйПодобразТекс2М(Гперечень а,цел б,цел в,цел г,цел д,цел е,Гцразм ё,Гцразм ж){ glCopyTexSubImage2D(а,б,в,г,д,е,cast(GLsizei) ё,cast(GLsizei) ж);}

    проц глУкНаВершину(цел а,Гперечень б,Гцразм в, ук г){ glVertexPointer(а,б,cast(GLsizei) в,г);}
    проц глУкНаНормаль(Гперечень а,Гцразм б,ук в){ glNormalPointer(а,cast(GLsizei) б,в);}
    проц глУкНаЦвет(цел а,Гперечень б,Гцразм в,ук г){ glColorPointer(а,б,cast(GLsizei) в,г);}
    проц глУкНаИндекс(Гперечень а,Гцразм б,ук в){ glIndexPointer(а,cast(GLsizei) б,в);}
    проц глУкНаКоордТекс(цел а,Гперечень б,Гцразм в,ук г){ glTexCoordPointer(а,б,cast(GLsizei) в,г);}
    проц глУкНаФлагКрая(Гцразм а,ук б){ glEdgeFlagPointer(cast(GLsizei) а,б);}
    проц глДайУк(Гперечень а,ук* б){ glGetPointerv(а,б);}
    проц глЭлементМассива(цел а){ glArrayElement(а);}
    проц глРисуйМассивы(Гперечень а,цел б,Гцразм в){ glDrawArrays(а,б,cast(GLsizei) в);}
    проц глРисуйЭлементы(Гперечень а,Гцразм б,Гперечень в,ук г){ glDrawElements(а,cast(GLsizei) б,в,г);}
    проц глСовместныеМассивы(Гперечень а,Гцразм б,ук в){ glInterleavedArrays(а,cast(GLsizei) б,в);}

/////glut
	
 проц глутИниц(цел* а, сим** б){ glutInit( а,  б);}
 проц глутИницПозОкна(цел а, цел б){ glutInitWindowPosition( а, б);}
 проц глутИницРазмерОкна(цел а, цел б){ glutInitWindowSize( а, б);}
 проц глутИницРежимПоказа(цел а){ glutInitDisplayMode(cast(uint) а);}
 проц глутИницТекстОкна(сим* а) {glutInitDisplayString( а);}
 проц глутГлавныйЦикл() {glutMainLoop();}
 цел глутСоздайОкно(сим* а){return cast(цел) glutCreateWindow( а);}
 цел глутСоздайПодокно(цел а, цел б, цел в, цел г, цел д){return cast(цел) glutCreateSubWindow(а,  б,  в,  г,  д);}
 проц глутРазрушьОкно(цел а) {glutDestroyWindow( а);}
 проц глутФункцПоказа(сифунк а) {glutDisplayFunc(а);}
 ///////////////
 проц глутУстановиОкно(цел а){ glutSetWindow( а);}
 цел глутДайОкно(){return cast(цел) glutGetWindow();}
 проц глутУстановиЗагОкна(сим* заг){ glutSetWindowTitle( заг);}
 проц глутУстановиЗагПикт(сим* заг){ glutSetIconTitle( заг);}
 проц глутПерерисуйОкно(цел а, цел б){ glutReshapeWindow( а,  б);}
 проц глутПоместиОкно(цел а, цел б){ glutPositionWindow( а, б);}
 проц глутПокажиОкно(){ glutShowWindow();}
 проц глутСпрячьОкно() { glutHideWindow();}
 проц глутСверниОкно(){ glutIconifyWindow();}
 проц глутСуньОкно(){ glutPushWindow();}
 проц глутВыньОкно(){ glutPopWindow();}
 проц глутПолныйЭкран(){ glutFullScreen();}
 проц глутПерепоказОкна(цел а){ glutPostWindowRedisplay(а);}
 проц глутПерепоказ(){ glutPostRedisplay();}
 проц глутОбменБуферов(){ glutSwapBuffers;}
 проц глутУкНаВарп(цел а, цел б){ glutWarpPointer(а, б);}
 проц глутУстановиКурсор(цел а) {glutSetCursor(а);}
 проц глутУстановиНакладку(){ glutEstablishOverlay();}
 проц глутУдалиНакладку(){ glutRemoveOverlay();}
 проц глутИспользуйСлой(Гперечень а) {glutUseLayer(cast(GLenum) а);}
 проц глутПерепоказНакладки(){ glutPostOverlayRedisplay();}
 проц глутПерепоказНакладкиОкна(цел а) {glutPostWindowOverlayRedisplay(а);}
 проц глутПокажиНакладку() {glutShowOverlay();}
 проц глутСкройНакладку() {glutHideOverlay();}
 цел глутСоздайМеню(сифунк_Ц а){return  glutCreateMenu(а);}
 проц глутРазрушьМеню(цел а) {glutDestroyMenu(а);}
 цел глутДайМеню() {return glutGetMenu();}
 проц глутУстановиМеню(цел а){ glutSetMenu(а);}
 проц глутДобавьЗаписьМеню(сим* а, цел б){ glutAddMenuEntry(а, б);}
 проц глутДобавьПодменю(сим* а, цел б){ glutAddSubMenu(а,б);}
 проц глутПерейдиВЗаписьМеню(цел а, сим* б, цел в){ glutChangeToMenuEntry(а,б,в);}
 проц глутПерейдиВПодменю(цел а, сим* б, цел в){ glutChangeToSubMenu(а,б,в);}
 проц глутУдалиЭлементМеню(цел а) {glutRemoveMenuItem(а);}
 проц глутПрикрепиМеню(цел а) {glutAttachMenu(а);}
 проц глутОткрепиМеню(цел а){ glutDetachMenu(а);}
 проц глутФункцТаймера(цел а, сифунк_Ц б, цел в) {glutTimerFunc(а,б,в);}
 проц глутФункцБездействия(сифунк а){ glutIdleFunc(а);}
 проц глутФункцКлавиатуры(сифунк_СЦЦ а) {glutKeyboardFunc(а);}
 проц глутОсобаяФункция(сифунк_ЦЦЦ а){ glutSpecialFunc(а);}
 проц глутФункцПерерисовки(сифунк_ЦЦ а){ glutReshapeFunc(а);}
 проц глутФункцВидимости(сифунк_Ц а) {glutVisibilityFunc(а);}
 проц глутФункцМыши(сифунк_ЦЦЦЦ а){ glutMouseFunc(а);}
 проц глутФункцДвижения(сифунк_ЦЦ а){ glutMotionFunc(а);}
 проц глутФункцияПассивногоДвижения(сифунк_ЦЦ а){ glutPassiveMotionFunc(а);}
 проц глутФункцияВвода(сифунк_Ц а) {glutEntryFunc(а);}
 проц глутФункцОтжатияКлавиши(сифунк_СЦЦ а){ glutKeyboardUpFunc(а);}
 проц глутОсобаяФункцОтжатия(сифунк_ЦЦЦ а) {glutSpecialUpFunc(а);}
 проц глутФункцДжойстика(сифунк_бЦЦЦЦ а, цел б){ glutJoystickFunc(а,б);}
 проц глутФункцСостоянияМеню(сифунк_Ц а) {glutMenuStateFunc(а);}
 проц глутФункцСтатусаМеню(сифунк_ЦЦЦ а){ glutMenuStatusFunc(а);}
 проц глутФункцПоказаНакладки(сифунк а){ glutOverlayDisplayFunc(а);}
 проц глутФункцСтатусаОкна(сифунк_Ц а){ glutWindowStatusFunc(а);}
 проц глутФункцДвиженияНебесногоТела(сифунк_ЦЦЦ а){ glutSpaceballMotionFunc(а);}
 проц глутФункцВращенияНебесногоТела(сифунк_ЦЦЦ а){ glutSpaceballRotateFunc(а);}
 проц глутФункцКнопкаНебесногоТела(сифунк_ЦЦ а){ glutSpaceballButtonFunc(а);}
 проц глутФункцОкнаКнопки(сифунк_ЦЦ а){ glutButtonBoxFunc(а);}
 проц глутФункцАбонентов(сифунк_ЦЦ а){ glutDialsFunc(а);}
 проц глутФункцДвиженияТаблет(сифунк_ЦЦ а) {glutTabletMotionFunc(а);}
 проц глутФункцКнопкиТаблет(сифунк_ЦЦЦЦ а){ glutTabletButtonFunc(а);}
 цел глутДай(Гперечень а){return  cast(цел) glutGet(а);} 
 цел глутДайУстройство(Гперечень а){return  cast(цел) glutDeviceGet(cast(GLenum) а);}
 цел глутДайМодификаторы(){return cast(цел) glutGetModifiers();}
 цел глутДайСлой(Гперечень а){return cast(цел) glutLayerGet(а);}
 проц глутСимволБитмап(ук а, цел б){ glutBitmapCharacter(а, cast(GLint) б);}
 цел глутШиринаБитмап(ук а, цел б){return cast(цел) glutBitmapWidth(а,cast(GLint) б);}
 проц глутСимволШтриха(ук а, цел б){ glutStrokeCharacter(а,cast(GLint) б);}
 цел глутШиринаШтриха(ук а, цел б){return cast(цел) glutStrokeWidth(а,cast(GLint) б);}
 цел глутДлинаБитмап(ук а, сим* б){return cast(цел) glutBitmapLength(а, б);}
 цел глутДлинаШтриха(ук а, сим* б){return cast(цел)  glutStrokeLength(а, б);}
 проц глутКаркасныйКуб(дво а){ glutWireCube(cast(GLdouble) а);}
 проц глутПлотныйКуб(дво а) {glutSolidCube(cast(GLdouble) а);}
 проц глутКаркаснаяСфера(дво а, цел б, цел в){ glutWireSphere(cast(GLdouble) а, cast(GLint) б, cast(GLint) в);}
 проц глутПлотнаяСфера(дво а, цел б, цел в) {glutSolidSphere(cast(GLdouble) а, cast(GLint) б, cast(GLint) в);}
 проц глутКаркасныйКонус(дво а, дво б, цел в, цел г){ glutWireCone(cast(GLdouble) а, cast(GLdouble) б, cast(GLint) в, cast(GLint) г);}
 проц глутПлотныйКонус(дво а, дво б, цел в, цел г){ glutSolidCone(cast(GLdouble) а, cast(GLdouble) б, cast(GLint) в, cast(GLint) г);}
 проц глутКаркасныйТор(дво а, дво б, цел в, цел г){ glutWireTorus(cast(GLdouble) а, cast(GLdouble) б, cast(GLint) в, cast(GLint) г);}
 проц глутПлотныйТор(дво а, дво б, цел в, цел г){ glutSolidTorus(cast(GLdouble) а, cast(GLdouble) б, cast(GLint) в, cast(GLint) г);}
 проц глутКаркасныйДодекаэдр(){ glutWireDodecahedron();}
 проц глутПлотныйДодекаэдр(){ glutSolidDodecahedron();}
 проц глутКаркасныйОктаэдр(){ glutWireOctahedron();}
 проц глутПлотныйОктаэдр(){ glutSolidOctahedron();}
 проц глутКаркасныйТетраэдр(){ glutWireTetrahedron();}
 проц глутПлотныйТетраэдр(){ glutSolidTetrahedron();}
 проц глутКаркасныйИкосаэдр(){ glutWireIcosahedron();}
 проц глутПлотныйИкосаэдр(){ glutSolidIcosahedron();}
 проц глутКаркасныйЧайник(дво а){ glutWireTeapot(cast(GLdouble) а);}
 проц глутПлотныйЧайник(дво а){ glutSolidTeapot(cast(GLdouble) а);}
 проц глутТекстРежимаИгры(сим* а) {glutGameModeString(а);}
 цел глутВойдиВРежимИгры(){return  glutEnterGameMode();}
 проц глутПокиньРежимИгры(){ glutLeaveGameMode();}
 цел глутДайРежимИгры(Гперечень а){return  glutGameModeGet(cast(GLenum) а);}
 цел глутДайПеремерВидео(Гперечень а) {return  glutVideoResizeGet(cast(GLenum) а);}
 проц глутУстановиПеремерВидео(){ glutSetupVideoResizing();}
 проц глутОстановиПеремерВидео(){ glutStopVideoResizing();}
 проц глутПеремерьВидео(цел а, цел б, цел в, цел г){ glutVideoResize(а,б,в,г);}
 проц глутПанируйВидео(цел а, цел б, цел в, цел г){ glutVideoPan(а,б,в,г);}
 проц глутУстановиЦвет(цел а, плав б, плав в, плав г)
	{ glutSetColor(а,cast(GLfloat) б,cast(GLfloat) в,cast(GLfloat) г);}
 
 плав глутДайЦвет(цел а, цел б){return cast(плав) glutGetColor(cast(GLint) а, cast(GLint) б);}
 проц глутКопируйЦветокарту(цел а){ glutCopyColormap(cast(GLint) а);}
 проц глутИгнорируйПовторКлавиши(цел а){ glutIgnoreKeyRepeat(cast(GLint) а);}
 проц глутУстановиПовторКлавиши(цел а) {glutSetKeyRepeat(cast(GLint) а);}
 проц глутФорсируйФункцДжойстика(){ glutForceJoystickFunc();}
 цел глутПоддерживаемыеРасширения(сим* а){return cast(цел) glutExtensionSupported(cast(GLchar*) а);}
 проц глутОтчётОбОшибках(){glutReportErrors();}
 
 //GLU
 
  проц  глуНачниКривую (GLUnurbs* nurb){gluBeginCurve (cast(GLUnurbs*) nurb);}
 проц  глуНачниМногоуг (GLUtesselator* tess)
	{gluBeginPolygon (cast(GLUtesselator*) tess);}
 проц  глуНачниПоверхность (GLUnurbs* nurb){gluBeginSurface (cast(GLUnurbs*) nurb);}
 проц  глуНачниОбрез (GLUnurbs* nurb){gluBeginTrim (cast(GLUnurbs*) nurb);}
 
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
	
 проц глуЦилиндр(Квадр* квад, дво ова, дво верх, дво высота, цел доли, цел пачки)
	{  gluCylinder (cast(GLUquadric*) квад, cast(GLdouble) ова, cast(GLdouble) верх, cast(GLdouble) высота, cast(GLint) доли, cast(GLint) пачки);}
	
 проц  глуУдалиОтобразительНурб(Нурб* nurb){gluDeleteNurbsRenderer (cast(GLUnurbs*) nurb);}
 проц  глуУдалиКвадр(Квадр *квад){gluDeleteQuadric (cast(GLUquadric*) квад);}
 проц  глуУдалиТесс(Тесс *тесс){gluDeleteTess (cast(GLUtesselator*) тесс);}
 
 проц  глуДиск(Квадр* квад, дво inner, дво внешний, цел доли, цел loops)
	{gluDisk (cast(GLUquadric*) квад, cast(GLdouble) inner, cast(GLdouble) внешний, cast(GLint) доли, cast(GLint) loops);}
	
 проц  глуКонКрив(Нурб* нурб){gluEndCurve (cast(GLUnurbs*) нурб);}
 проц  глуКонМногоуг(Тесс *тесс){gluEndPolygon (cast(GLUtesselator*) тесс);}
 проц  глуКонПоверхн(Нурб* нурб){gluEndSurface (cast(GLUnurbs*) нурб);}
 проц  глуКонОбрез(Нурб* нурб){gluEndTrim (cast(GLUnurbs*) нурб);} 
 сим *глуТкстОш(Гперечень ош){return cast(сим*)  gluErrorString (cast(GLenum) ош);}
  
 проц  глуПерспектива(дво fovy, дво aspect, дво zNear, дво zFar)
	{gluPerspective (cast(GLdouble) fovy, cast(GLdouble) aspect, cast(GLdouble) zNear, cast(GLdouble) zFar);}
 проц  глуОрто2М(дво лево, дво право, дво низ, дво верх)
	{gluOrtho2D (cast(GLdouble) лево, cast(GLdouble) право, cast(GLdouble) низ, cast(GLdouble) верх);}
 
 ////////////////////
 проц  глуДайСвойствоНурб(Нурб* nurb, Гперечень property, плав* данные){gluGetNurbsProperty (cast(GLUnurbs*) nurb, cast(GLenum) property, cast(GLfloat*) данные);}
 
 сим *глуДайТкст(Гперечень имя){return cast(сим *)  gluGetString (cast(GLenum) имя);}
 
 проц  глуДайСвойствоТесс(Тесс* тесс, Гперечень какой, дво* данные){gluGetTessProperty (cast(GLUtesselator*) тесс, cast(GLenum) какой, cast(GLdouble*) данные);}
 
 проц  глуЗагрузиМатрицыСемплинга(Нурб* нурб, плав* модель, плав* перспектива, цел *вид){gluLoadSamplingMatrices (cast(GLUnurbs*) нурб,  cast(GLfloat*) модель,  cast(GLfloat*) перспектива, cast(GLint*) вид);}
 
 проц  глуВидНа(дво глазШ, дво глазВ, дво глазД, дво центрШ, дво центрВ, дво центрД, дво верхШ, дво верхВ, дво верхД){gluLookAt (cast(GLdouble) глазШ, cast(GLdouble) глазВ, cast(GLdouble) глазД, cast(GLdouble) центрШ,cast(GLdouble) центрВ, cast(GLdouble) центрД, cast(GLdouble) верхШ, cast(GLdouble) верхВ, cast(GLdouble) верхД);}
 
 Нурб* глуНовыйОтобразительНурб(){return cast(Нурб*)  gluNewNurbsRenderer ();}
 
 Квадр* глуНовыйКвадрик(){return cast(Квадр*)  gluNewQuadric ();}
 
 Тесс* глуНовыйТесс(){return cast(Тесс*)  gluNewTess ();}
 
 проц  глуСледщКонтур(Тесс* тесс, Гперечень тип){gluNextContour (cast(GLUtesselator*) тесс, cast(GLenum) тип);} 
 
 проц  глуОбрвызовНурбс(Нурб* нурб, Гперечень какой, сифунк фов){ gluNurbsCallback (cast(GLUnurbs*) нурб, cast(GLenum) какой, фов);}
 
 проц  глуДанныеОбрвызоваНурб(Нурб* нурб, ук пользДанн){gluNurbsCallbackData (cast(GLUnurbs*) нурб, cast(GLvoid*) пользДанн);}
 
 проц глуДанныеОбрвызоваНурбДОП(Нурб* нурб, ук пользДанн){ gluNurbsCallbackDataEXT (cast(GLUnurbs*) нурб,cast(GLvoid*) пользДанн);}
 
 проц  глуКриваяНурб(Нурб* нурб, цел члоуз, плав* узлы, цел страйд, плав* упрэлт, цел порядок, Гперечень тип){gluNurbsCurve (cast(GLUnurbs*) нурб, cast(GLint) члоуз, cast(GLfloat*) узлы,cast(GLint) страйд, cast(GLfloat*) упрэлт, cast(GLint) порядок,cast(GLenum) тип);}
 
 проц  глуСвойствоНурб(Нурб* нурб, Гперечень свойство, плав знач){gluNurbsProperty (cast(GLUnurbs*) нурб, cast(GLenum) свойство, cast(GLfloat) знач);}
 
 проц  глуПоверхностьНурб(Нурб* нурб, цел члоузс, плав* узлыс, цел члоузт, плав* узлыт, цел пролётс, цел пролётт, плав* упрэлт, цел спорядок, цел тпорядок, Гперечень тип){gluNurbsSurface (cast(GLUnurbs*) нурб, cast(GLint) члоузс, cast(GLfloat*) узлыс, cast(GLint) члоузт, cast(GLfloat*) узлыт, cast(GLint) пролётс, cast(GLint) пролётт, cast(GLfloat*) упрэлт, cast(GLint) спорядок, cast(GLint) тпорядок, cast(GLenum) тип);}
 
 проц  глуПолуДиск(Квадр* квад, дво внутр, дво наруж, цел доли, цел петли, дво старт, дво метла){gluPartialDisk (cast(GLUquadric*) квад, cast(GLdouble) внутр, cast(GLdouble) наруж, cast(GLint) доли, cast(GLint) петли, cast(GLdouble) старт, cast(GLdouble) метла);}
 
 ///////////////////////
 проц  глуПодбериМатрицу(дво ш, дво в, дво делШ, дво делВ, цел *вьюпорт)
	{gluPickMatrix (cast(GLdouble) ш, cast(GLdouble) в, cast(GLdouble) делШ, cast(GLdouble) делВ, cast(GLint*) вьюпорт);}
	
 цел глуПроекция(дво обШ, дво обВ, дво обД, дво* модель, дво* проекц, цел *вид, дво *окШ, дво *окВ, дво *окД)
	 {
	 return cast(цел)  gluProject (cast(GLdouble) обШ, cast(GLdouble) обВ, cast(GLdouble) обД,  cast(GLdouble*) модель,  cast(GLdouble*) проекц,  cast(GLint*) вид, cast(GLdouble*) окШ, cast(GLdouble*) окВ, cast(GLdouble*) окД);
	 }
 
 /*
 проц  gluPwlCurve (cast(GLUnurbs*) нурб, cast(GLint) count, cast(GLfloat*) данные, cast(GLint) stride, cast(GLenum) тип);
 */
 
 проц  глуОбрвызовКвадра(Квадр* квад, Гперечень который, сифунк фов) {gluQuadricCallback (cast(GLUquadric*) квад, cast(GLenum) который, фов);}
 
 проц глуКвадрСтильРисования(Квадр* квад, Гперечень рис)
	{  gluQuadricDrawStyle (cast(GLUquadric*) квад, cast(GLenum) рис);}
 
 проц  глуКвадрНормали(Квадр* квад, Гперечень нормаль)
	{gluQuadricNormals (cast(GLUquadric*) квад, cast(GLenum) нормаль);}
 
 проц  глуКвадрОриентация(Квадр* квад, Гперечень ориент){gluQuadricOrientation (cast(GLUquadric*) квад, cast(GLenum) ориент);}
 
 проц  глуКвадрТекстура(Квадр* квад, бул текстура)
	{ gluQuadricTexture (cast(GLUquadric*) квад, cast(GLboolean) текстура);}
 /*
 цел cast(GLint)  gluScaleImage (cast(GLenum) формат, GLsizei wIn, GLsizei hIn, cast(GLenum) typeIn,  ук dataIn, GLsizei wOut, GLsizei hOut, cast(GLenum) typeOut, GLvoid* dataOut);
 */
 
 проц  глуШар(Квадр* квад, дво радиус, цел доли, цел пачки)
	{ gluSphere (cast(GLUquadric*) квад, cast(GLdouble) радиус, cast(GLint) доли, cast(GLint) пачки);}
 
 проц  глуТессНачниКонтур(Тесс* тесс)
	{gluTessBeginContour (cast(GLUtesselator*) тесс);}

 проц  глуТессНачниМногогран(Тесс* тесс, ук данные)
	{gluTessBeginPolygon (cast(GLUtesselator*) тесс, cast(GLvoid*) данные);}
 
 проц  глуОбрвызовТесс(Тесс* тесс, Гперечень который, сифунк ов){gluTessCallback (cast(GLUtesselator*) тесс, cast(GLenum) который, ов);}
 
 проц  глуТессЗавершиКонтур(Тесс* тесс){gluTessEndContour (cast(GLUtesselator*) тесс);}
 
 проц  глуТессЗавершиМногогран(Тесс* тесс){gluTessEndPolygon (cast(GLUtesselator*) тесс);}
 
 проц  глуТессНормаль(Тесс* тесс, дво значШ, дво значВ, дво значД){gluTessNormal (cast(GLUtesselator*) тесс, cast(GLdouble) значШ, cast(GLdouble) значШ, cast(GLdouble) значД);}
 
 проц  глуТессСвойство(Тесс* тесс, Гперечень который, дво данные){gluTessProperty (cast(GLUtesselator*) тесс, cast(GLenum) который, cast(GLdouble) данные);}
 
 проц  глуТессВершина(Тесс* тесс, дво *положен, ук данные){gluTessVertex (cast(GLUtesselator*) тесс, cast(GLdouble*) положен, cast(GLvoid*) данные);}
 
 /*
 цел cast(GLint)  gluUnProject (cast(GLdouble) winX, cast(GLdouble) winY, cast(GLdouble) winZ,  cast(GLdouble) *model,  cast(GLdouble) *proj,  cast(GLint) *view, cast(GLdouble)* objX, cast(GLdouble)* objY, cast(GLdouble)* objZ);
 
 
 целcast(GLint)  gluUnProject4 (cast(GLdouble) winX, cast(GLdouble) winY, cast(GLdouble) winZ, cast(GLdouble) clipW,  cast(GLdouble) *model,  cast(GLdouble) *proj,  cast(GLint) *view, cast(GLdouble) nearVal, cast(GLdouble) farVal, cast(GLdouble)* objX, cast(GLdouble)* objY, cast(GLdouble)* objZ, cast(GLdouble)* objW);
 */

/*
version (FREEGLUT_EXTRAS)
{
	 проц function() glutMainLoopEvent;
		проц function() glutLeaveMainLoop;
		проц function(сифунк_ЦЦЦЦ) glutMouseWheelFunc;
		проц function(сифунк) glutCloseFunc;
		проц function(сифунк) glutWMCloseFunc;
		проц function(сифунк) glutMenuDestroyFunc;
		проц function(cast(GLenum), cast(GLint)) glutSetOption;
		ук function() glutGetWindowData;
		проц function(ук) glutSetWindowData;
		ук function() glutGetMenuData;
		проц function(ук) glutSetMenuData;
		cast(GLint) function(ук) glutBitmapHeight;
		cast(GLfloat) function(ук) glutStrokeHeight;
		проц function(ук, GLchar*) glutBitmapString;
		проц function(ук, GLchar*) glutStrokeString;
		проц function() glutWireRhombicDodecahedron;
		проц function() glutSolidRhombicDodecahedron;
		проц function(cast(GLint), cast(GLdouble)[3], cast(GLdouble)) glutWireSierpinskiSponge;
		проц function(cast(GLint), cast(GLdouble)[3], cast(GLdouble)) glutSolidSierpinskiSponge;
		проц function(cast(GLdouble), cast(GLdouble), cast(GLint), cast(GLint)) glutWireCylinder;
		проц function(cast(GLdouble), cast(GLdouble), cast(GLint), cast(GLint)) glutSolidCylinder;
		GLUTproc function(GLchar*) glutGetProcAddress;

}*/
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

	 проц  gluBeginCurve (GLUnurbs* нурб);
	 проц  gluBeginPolygon (GLUtesselator* tess);
	 проц  gluBeginSurface (GLUnurbs* нурб);
	 проц  gluBeginTrim (GLUnurbs* нурб);
	
	 GLint  gluBuild1DMipmaps (GLenum цель, GLint внутрФормат, GLsizei ширина, GLenum формат, GLenum тип,  ук данные);
	 
	 GLint  gluBuild2DMipmaps (GLenum цель, GLint внутрФормат, GLsizei ширина, GLsizei высота, GLenum формат, GLenum тип,  ук данные);
	 
	 
	 
	 проц  gluCylinder (GLUquadric* квад, GLdouble ова, GLdouble верх, GLdouble высота, GLint доли, GLint пачки);
	 проц  gluDeleteNurbsRenderer (GLUnurbs* нурб);
	 проц  gluDeleteQuadric (GLUquadric* квад);
	 проц  gluDeleteTess (GLUtesselator* tess);
	 проц  gluDisk (GLUquadric* квад, GLdouble inner, GLdouble внешний, GLint доли, GLint loops);
	 проц  gluEndCurve (GLUnurbs* нурб);
	 проц  gluEndPolygon (GLUtesselator* tess);
	 проц  gluEndSurface (GLUnurbs* нурб);
	 проц  gluEndTrim (GLUnurbs* нурб);
	  GLubyte *  gluErrorString (GLenum error);
	 проц  gluGetNurbsProperty (GLUnurbs* нурб, GLenum property, GLfloat* данные);
	  GLubyte *  gluGetString (GLenum имя);
	 проц  gluGetTessProperty (GLUtesselator* tess, GLenum which, GLdouble* данные);
	 проц  gluLoadSamplingMatrices (GLUnurbs* нурб,  GLfloat *model,  GLfloat *perspective,  GLint *view);
	 проц  gluLookAt (GLdouble eyeX, GLdouble eyeY, GLdouble eyeZ, GLdouble centerX, GLdouble centerY, GLdouble centerZ, GLdouble upX, GLdouble upY, GLdouble upZ);
	 GLUnurbs*  gluNewNurbsRenderer ();
	 GLUquadric*  gluNewQuadric ();
	 GLUtesselator*  gluNewTess ();
	 проц  gluNextContour (GLUtesselator* tess, GLenum тип);
	 проц  gluNurbsCallback (GLUnurbs* нурб, GLenum which, сифунк CallBackFunc);
	 проц  gluNurbsCallbackData (GLUnurbs* нурб, GLvoid* userData);
	 проц  gluNurbsCallbackDataEXT (GLUnurbs* нурб, GLvoid* userData);
	 проц  gluNurbsCurve (GLUnurbs* нурб, GLint knotCount, GLfloat *knots, GLint stride, GLfloat *control, GLint order, GLenum тип);
	 проц  gluNurbsProperty (GLUnurbs* нурб, GLenum property, GLfloat value);
	 проц  gluNurbsSurface (GLUnurbs* нурб, GLint sKnotCount, GLfloat* sKnots, GLint tKnotCount, GLfloat* tKnots, GLint sStride, GLint tStride, GLfloat* control, GLint sOrder, GLint tOrder, GLenum тип);
	 проц  gluOrtho2D (GLdouble left, GLdouble right, GLdouble bottom, GLdouble верх);
	 проц  gluPartialDisk (GLUquadric* квад, GLdouble inner, GLdouble внешний, GLint доли, GLint loops, GLdouble start, GLdouble sweep);
	 проц  gluPerspective (GLdouble fovy, GLdouble aspect, GLdouble zNear, GLdouble zFar);
	 проц  gluPickMatrix (GLdouble x, GLdouble y, GLdouble delX, GLdouble delY, GLint *viewport);
	 GLint  gluProject (GLdouble objX, GLdouble objY, GLdouble objZ,  GLdouble *model,  GLdouble *proj,  GLint *view, GLdouble* winX, GLdouble* winY, GLdouble* winZ);
	 проц  gluPwlCurve (GLUnurbs* нурб, GLint count, GLfloat* данные, GLint stride, GLenum тип);
	 проц  gluQuadricCallback (GLUquadric* квад, GLenum which, сифунк CallBackFunc);
	 проц  gluQuadricDrawStyle (GLUquadric* квад, GLenum draw);
	 проц  gluQuadricNormals (GLUquadric* квад, GLenum normal);
	 проц  gluQuadricOrientation (GLUquadric* квад, GLenum orientation);
	 проц  gluQuadricTexture (GLUquadric* квад, GLboolean texture);
	 GLint  gluScaleImage (GLenum формат, GLsizei wIn, GLsizei hIn, GLenum typeIn,  ук dataIn, GLsizei wOut, GLsizei hOut, GLenum typeOut, GLvoid* dataOut);
	 проц  gluSphere (GLUquadric* квад, GLdouble radius, GLint доли, GLint пачки);
	 проц  gluTessBeginContour (GLUtesselator* tess);
	 проц  gluTessBeginPolygon (GLUtesselator* tess, GLvoid* данные);
	 проц  gluTessCallback (GLUtesselator* tess, GLenum which, сифунк CallBackFunc);
	 проц  gluTessEndContour (GLUtesselator* tess);
	 проц  gluTessEndPolygon (GLUtesselator* tess);
	 проц  gluTessNormal (GLUtesselator* tess, GLdouble valueX, GLdouble valueY, GLdouble valueZ);
	 проц  gluTessProperty (GLUtesselator* tess, GLenum which, GLdouble данные);
	 проц  gluTessVertex (GLUtesselator* tess, GLdouble *location, GLvoid* данные);
	 GLint  gluUnProject (GLdouble winX, GLdouble winY, GLdouble winZ,  GLdouble *model,  GLdouble *proj,  GLint *view, GLdouble* objX, GLdouble* objY, GLdouble* objZ);
	 GLint  gluUnProject4 (GLdouble winX, GLdouble winY, GLdouble winZ, GLdouble clipW,  GLdouble *model,  GLdouble *proj,  GLint *view, GLdouble nearVal, GLdouble farVal, GLdouble* objX, GLdouble* objY, GLdouble* objZ, GLdouble* objW);
 }

extern  (C)

{


проц glutReportErrors();
int glutExtensionSupported(char *имя);
проц    glutIgnoreKeyRepeat(int ignore);
проц    glutSetKeyRepeat(int repeatMode);
проц    glutForceJoystickFunc();
int glutGetModifiers();
int glutLayerGet(GLenum тип);
int    glutBitmapLength(ук font, сим *string);
 int    glutStrokeLength(ук font,  сим *string);
проц glutMenuStatusFunc(сифунк_ЦЦЦ);
проц glutOverlayDisplayFunc(сифунк);
проц glutWindowStatusFunc(сифунк_Ц);
проц glutGameModeString(char*);
int  glutEnterGameMode();
проц glutLeaveGameMode();
int glutGameModeGet(GLenum);

  int    glutVideoResizeGet(GLenum);
  проц    glutSetupVideoResizing();
  проц    glutStopVideoResizing();
  проц    glutVideoResize(int x, int y, int ширина, int высота);
  проц    glutVideoPan(int x, int y, int ширина, int высота);
/*
 * Miscellaneous
 */

 проц  glClearIndex( GLfloat c );
 проц  glClearColor( GLclampf red, GLclampf green, GLclampf blue, GLclampf alpha );
 проц  glClear( GLbitfield mask );
 проц  glIndexMask( GLuint mask );
 проц  glColorMask( GLboolean red, GLboolean green, GLboolean blue, GLboolean alpha );
 проц  glAlphaFunc( GLenum func, GLclampf reference );
 проц  glBlendFunc( GLenum sfactor, GLenum dfactor );
 проц  glLogicOp( GLenum opcode );
 проц  glCullFace( GLenum mode );
 проц  glFrontFace( GLenum mode );
 проц  glPointSize( GLfloat размер );
 проц  glLineWidth( GLfloat ширина );
 проц  glLineStipple( GLint factor, GLushort pattern );
 проц  glPolygonMode( GLenum face, GLenum mode );
 проц  glPolygonOffset( GLfloat factor, GLfloat units );
 проц  glPolygonStipple(  GLubyte *mask );
 проц  glGetPolygonStipple( GLubyte *mask );
 проц  glEdgeFlag( GLboolean flag );
 проц  glEdgeFlagv(  GLboolean *flag );
 проц  glScissor( GLint x, GLint y, GLsizei ширина, GLsizei высота);
 проц  glClipPlane( GLenum plane,  GLdouble *equation );
 проц  glGetClipPlane( GLenum plane, GLdouble *equation );
 проц  glDrawBuffer( GLenum mode );
 проц  glReadBuffer( GLenum mode );
 проц  glEnable( GLenum cap );
 проц  glDisable( GLenum cap );
 GLboolean  glIsEnabled( GLenum cap );
 проц  glEnableClientState( GLenum cap );  /* 1.1 */
 проц  glDisableClientState( GLenum cap );  /* 1.1 */
 проц  glGetBooleanv( GLenum pname, GLboolean *парамы );
 проц  glGetDoublev( GLenum pname, GLdouble *парамы );
 проц  glGetFloatv( GLenum pname, GLfloat *парамы );
 проц  glGetIntegerv( GLenum pname, GLint *парамы );
 проц  glPushAttrib( GLbitfield mask );
 проц  glPopAttrib();
 проц  glPushClientAttrib( GLbitfield mask );  /* 1.1 */
 проц  glPopClientAttrib();  /* 1.1 */
 GLint  glRenderMode( GLenum mode );
 GLenum  glGetError();
  GLubyte *  glGetString( GLenum имя );
 проц  glFinish();
 проц  glFlush();
 проц  glHint( GLenum цель, GLenum mode );

/*
 * Depth Buffer
 */

 проц  glClearDepth( GLclampd глубина );
 проц  glDepthFunc( GLenum func );
 проц  glDepthMask( GLboolean flag );
 проц  glDepthRange( GLclampd near_val, GLclampd far_val );

/*
 * Accumulation Buffer
 */

 проц  glClearAccum( GLfloat red, GLfloat green, GLfloat blue, GLfloat alpha );
 проц  glAccum( GLenum op, GLfloat value );

/*
 * Transformation
 */

 проц  glMatrixMode( GLenum mode );
 проц  glOrtho( GLdouble left, GLdouble right,
                                 GLdouble bottom, GLdouble верх,
                                 GLdouble near_val, GLdouble far_val );
 проц  glFrustum( GLdouble left, GLdouble right,
                                   GLdouble bottom, GLdouble верх,
                                   GLdouble near_val, GLdouble far_val );
 проц  glViewport( GLint x, GLint y,
                                    GLsizei ширина, GLsizei высота );
 проц  glPushMatrix();
 проц  glPopMatrix();
 проц  glLoadIdentity();
 проц  glLoadMatrixd(  GLdouble *m );
 проц  glLoadMatrixf(  GLfloat *m );
 проц  glMultMatrixd(  GLdouble *m );
 проц  glMultMatrixf(  GLfloat *m );
 проц  glRotated( GLdouble angle,
                                   GLdouble x, GLdouble y, GLdouble z );
 проц  glRotatef( GLfloat angle,
                                   GLfloat x, GLfloat y, GLfloat z );
 проц  glScaled( GLdouble x, GLdouble y, GLdouble z );
 проц  glScalef( GLfloat x, GLfloat y, GLfloat z );
 проц  glTranslated( GLdouble x, GLdouble y, GLdouble z );
 проц  glTranslatef( GLfloat x, GLfloat y, GLfloat z );

/*
 * Display Lists
 */

 GLboolean  glIsList( GLuint list );
 проц  glDeleteLists( GLuint list, GLsizei range );
 GLuint  glGenLists( GLsizei range );
 проц  glNewList( GLuint list, GLenum mode );
 проц  glEndList();
 проц  glCallList( GLuint list );
 проц  glCallLists( GLsizei n, GLenum тип,
                                      GLvoid *lists );
 проц  glListBase( GLuint ова );


/*
 * Drawing Functions
 */

 проц  glBegin( GLenum mode );
 проц  glEnd();

 проц  glVertex2d( GLdouble x, GLdouble y );
 проц  glVertex2f( GLfloat x, GLfloat y );
 проц  glVertex2i( GLint x, GLint y );
 проц  glVertex2s( GLshort x, GLshort y );

 проц  glVertex3d( GLdouble x, GLdouble y, GLdouble z );
 проц  glVertex3f( GLfloat x, GLfloat y, GLfloat z );
 проц  glVertex3i( GLint x, GLint y, GLint z );
 проц  glVertex3s( GLshort x, GLshort y, GLshort z );

 проц  glVertex4d( GLdouble x, GLdouble y, GLdouble z, GLdouble w );
 проц  glVertex4f( GLfloat x, GLfloat y, GLfloat z, GLfloat w );
 проц  glVertex4i( GLint x, GLint y, GLint z, GLint w );
 проц  glVertex4s( GLshort x, GLshort y, GLshort z, GLshort w );

 проц  glVertex2dv(  GLdouble *v );
 проц  glVertex2fv(  GLfloat *v );
 проц  glVertex2iv(  GLint *v );
 проц  glVertex2sv(  GLshort *v );

 проц  glVertex3dv(  GLdouble *v );
 проц  glVertex3fv(  GLfloat *v );
 проц  glVertex3iv(  GLint *v );
 проц  glVertex3sv(  GLshort *v );

 проц  glVertex4dv(  GLdouble *v );
 проц  glVertex4fv(  GLfloat *v );
 проц  glVertex4iv(  GLint *v );
 проц  glVertex4sv(  GLshort *v );


 проц  glNormal3b( GLbyte nx, GLbyte ny, GLbyte nz );
 проц  glNormal3d( GLdouble nx, GLdouble ny, GLdouble nz );
 проц  glNormal3f( GLfloat nx, GLfloat ny, GLfloat nz );
 проц  glNormal3i( GLint nx, GLint ny, GLint nz );
 проц  glNormal3s( GLshort nx, GLshort ny, GLshort nz );

 проц  glNormal3bv(  GLbyte *v );
 проц  glNormal3dv(  GLdouble *v );
 проц  glNormal3fv(  GLfloat *v );
 проц  glNormal3iv(  GLint *v );
 проц  glNormal3sv(  GLshort *v );


 проц  glIndexd( GLdouble c );
 проц  glIndexf( GLfloat c );
 проц  glIndexi( GLint c );
 проц  glIndexs( GLshort c );
 проц  glIndexub( GLubyte c );  /* 1.1 */

 проц  glIndexdv(  GLdouble *c );
 проц  glIndexfv(  GLfloat *c );
 проц  glIndexiv(  GLint *c );
 проц  glIndexsv(  GLshort *c );
 проц  glIndexubv(  GLubyte *c );  /* 1.1 */

 проц  glColor3b( GLbyte red, GLbyte green, GLbyte blue );
 проц  glColor3d( GLdouble red, GLdouble green, GLdouble blue );
 проц  glColor3f( GLfloat red, GLfloat green, GLfloat blue );
 проц  glColor3i( GLint red, GLint green, GLint blue );
 проц  glColor3s( GLshort red, GLshort green, GLshort blue );
 проц  glColor3ub( GLubyte red, GLubyte green, GLubyte blue );
 проц  glColor3ui( GLuint red, GLuint green, GLuint blue );
 проц  glColor3us( GLushort red, GLushort green, GLushort blue );

 проц  glColor4b( GLbyte red, GLbyte green,
                                   GLbyte blue, GLbyte alpha );
 проц  glColor4d( GLdouble red, GLdouble green,
                                   GLdouble blue, GLdouble alpha );
 проц  glColor4f( GLfloat red, GLfloat green,
                                   GLfloat blue, GLfloat alpha );
 проц  glColor4i( GLint red, GLint green,
                                   GLint blue, GLint alpha );
 проц  glColor4s( GLshort red, GLshort green,
                                   GLshort blue, GLshort alpha );
 проц  glColor4ub( GLubyte red, GLubyte green,
                                    GLubyte blue, GLubyte alpha );
 проц  glColor4ui( GLuint red, GLuint green,
                                    GLuint blue, GLuint alpha );
 проц  glColor4us( GLushort red, GLushort green,
                                    GLushort blue, GLushort alpha );


 проц  glColor3bv(  GLbyte *v );
 проц  glColor3dv(  GLdouble *v );
 проц  glColor3fv(  GLfloat *v );
 проц  glColor3iv(  GLint *v );
 проц  glColor3sv(  GLshort *v );
 проц  glColor3ubv(  GLubyte *v );
 проц  glColor3uiv(  GLuint *v );
 проц  glColor3usv(  GLushort *v );

 проц  glColor4bv(  GLbyte *v );
 проц  glColor4dv(  GLdouble *v );
 проц  glColor4fv(  GLfloat *v );
 проц  glColor4iv(  GLint *v );
 проц  glColor4sv(  GLshort *v );
 проц  glColor4ubv(  GLubyte *v );
 проц  glColor4uiv(  GLuint *v );
 проц  glColor4usv(  GLushort *v );


 проц  glTexCoord1d( GLdouble s );
 проц  glTexCoord1f( GLfloat s );
 проц  glTexCoord1i( GLint s );
 проц  glTexCoord1s( GLshort s );

 проц  glTexCoord2d( GLdouble s, GLdouble t );
 проц  glTexCoord2f( GLfloat s, GLfloat t );
 проц  glTexCoord2i( GLint s, GLint t );
 проц  glTexCoord2s( GLshort s, GLshort t );

 проц  glTexCoord3d( GLdouble s, GLdouble t, GLdouble r );
 проц  glTexCoord3f( GLfloat s, GLfloat t, GLfloat r );
 проц  glTexCoord3i( GLint s, GLint t, GLint r );
 проц  glTexCoord3s( GLshort s, GLshort t, GLshort r );

 проц  glTexCoord4d( GLdouble s, GLdouble t, GLdouble r, GLdouble q );
 проц  glTexCoord4f( GLfloat s, GLfloat t, GLfloat r, GLfloat q );
 проц  glTexCoord4i( GLint s, GLint t, GLint r, GLint q );
 проц  glTexCoord4s( GLshort s, GLshort t, GLshort r, GLshort q );

 проц  glTexCoord1dv(  GLdouble *v );
 проц  glTexCoord1fv(  GLfloat *v );
 проц  glTexCoord1iv(  GLint *v );
 проц  glTexCoord1sv(  GLshort *v );

 проц  glTexCoord2dv(  GLdouble *v );
 проц  glTexCoord2fv(  GLfloat *v );
 проц  glTexCoord2iv(  GLint *v );
 проц  glTexCoord2sv(  GLshort *v );

 проц  glTexCoord3dv(  GLdouble *v );
 проц  glTexCoord3fv(  GLfloat *v );
 проц  glTexCoord3iv(  GLint *v );
 проц  glTexCoord3sv(  GLshort *v );

 проц  glTexCoord4dv(  GLdouble *v );
 проц  glTexCoord4fv(  GLfloat *v );
 проц  glTexCoord4iv(  GLint *v );
 проц  glTexCoord4sv(  GLshort *v );


 проц  glRasterPos2d( GLdouble x, GLdouble y );
 проц  glRasterPos2f( GLfloat x, GLfloat y );
 проц  glRasterPos2i( GLint x, GLint y );
 проц  glRasterPos2s( GLshort x, GLshort y );

 проц  glRasterPos3d( GLdouble x, GLdouble y, GLdouble z );
 проц  glRasterPos3f( GLfloat x, GLfloat y, GLfloat z );
 проц  glRasterPos3i( GLint x, GLint y, GLint z );
 проц  glRasterPos3s( GLshort x, GLshort y, GLshort z );

 проц  glRasterPos4d( GLdouble x, GLdouble y, GLdouble z, GLdouble w );
 проц  glRasterPos4f( GLfloat x, GLfloat y, GLfloat z, GLfloat w );
 проц  glRasterPos4i( GLint x, GLint y, GLint z, GLint w );
 проц  glRasterPos4s( GLshort x, GLshort y, GLshort z, GLshort w );

 проц  glRasterPos2dv(  GLdouble *v );
 проц  glRasterPos2fv(  GLfloat *v );
 проц  glRasterPos2iv(  GLint *v );
 проц  glRasterPos2sv(  GLshort *v );

 проц  glRasterPos3dv(  GLdouble *v );
 проц  glRasterPos3fv(  GLfloat *v );
 проц  glRasterPos3iv(  GLint *v );
 проц  glRasterPos3sv(  GLshort *v );

 проц  glRasterPos4dv(  GLdouble *v );
 проц  glRasterPos4fv(  GLfloat *v );
 проц  glRasterPos4iv(  GLint *v );
 проц  glRasterPos4sv(  GLshort *v );


 проц  glRectd( GLdouble x1, GLdouble y1, GLdouble x2, GLdouble y2 );
 проц  glRectf( GLfloat x1, GLfloat y1, GLfloat x2, GLfloat y2 );
 проц  glRecti( GLint x1, GLint y1, GLint x2, GLint y2 );
 проц  glRects( GLshort x1, GLshort y1, GLshort x2, GLshort y2 );


 проц  glRectdv(  GLdouble *v1,  GLdouble *v2 );
 проц  glRectfv(  GLfloat *v1,  GLfloat *v2 );
 проц  glRectiv(  GLint *v1,  GLint *v2 );
 проц  glRectsv(  GLshort *v1,  GLshort *v2 );

/*
 * Vertex Arrays  (1.1)
 */

 проц  glVertexPointer( GLint размер, GLenum тип,
                                       GLsizei stride,  GLvoid *ptr );

 проц  glNormalPointer( GLenum тип, GLsizei stride,
                                        GLvoid *ptr );

 проц  glColorPointer( GLint размер, GLenum тип,
                                      GLsizei stride,  GLvoid *ptr );

 проц  glIndexPointer( GLenum тип, GLsizei stride,
                                       GLvoid *ptr );

 проц  glTexCoordPointer( GLint размер, GLenum тип,
                                         GLsizei stride,  GLvoid *ptr );

 проц  glEdgeFlagPointer( GLsizei stride,  GLvoid *ptr );
 проц  glGetPointerv( GLenum pname, GLvoid **парамы );
 проц  glArrayElement( GLint i );
 проц  glDrawArrays( GLenum mode, GLint first, GLsizei count );
 проц  glDrawElements( GLenum mode, GLsizei count,
                                      GLenum тип,  GLvoid *indices );

 проц  glInterleavedArrays( GLenum формат, GLsizei stride,
                                            GLvoid *pointer );

/*
 * Lighting
 */

 проц  glShadeModel( GLenum mode );
 проц  glLightf( GLenum light, GLenum pname, GLfloat param );
 проц  glLighti( GLenum light, GLenum pname, GLint param );
 проц  glLightfv( GLenum light, GLenum pname,
                                  GLfloat *парамы );
 проц  glLightiv( GLenum light, GLenum pname,
                                  GLint *парамы );
 проц  glGetLightfv( GLenum light, GLenum pname,
                                    GLfloat *парамы );
 проц  glGetLightiv( GLenum light, GLenum pname,
                                    GLint *парамы );
 проц  glLightModelf( GLenum pname, GLfloat param );
 проц  glLightModeli( GLenum pname, GLint param );
 проц  glLightModelfv( GLenum pname,  GLfloat *парамы );
 проц  glLightModeliv( GLenum pname,  GLint *парамы );
 проц  glMaterialf( GLenum face, GLenum pname, GLfloat param );
 проц  glMateriali( GLenum face, GLenum pname, GLint param );
 проц  glMaterialfv( GLenum face, GLenum pname,  GLfloat *парамы );
 проц  glMaterialiv( GLenum face, GLenum pname,  GLint *парамы );
 проц  glGetMaterialfv( GLenum face, GLenum pname, GLfloat *парамы );
 проц  glGetMaterialiv( GLenum face, GLenum pname, GLint *парамы );
 проц  glColorMaterial( GLenum face, GLenum mode );


/*
 * Raster functions
 */

 проц  glPixelZoom( GLfloat xfactor, GLfloat yfactor );

 проц  glPixelStoref( GLenum pname, GLfloat param );
 проц  glPixelStorei( GLenum pname, GLint param );

 проц  glPixelTransferf( GLenum pname, GLfloat param );
 проц  glPixelTransferi( GLenum pname, GLint param );

 проц  glPixelMapfv( GLenum map, GLsizei mapsize,
                                     GLfloat *values );
 проц  glPixelMapuiv( GLenum map, GLsizei mapsize,
                                      GLuint *values );
 проц  glPixelMapusv( GLenum map, GLsizei mapsize,
                                      GLushort *values );

 проц  glGetPixelMapfv( GLenum map, GLfloat *values );
 проц  glGetPixelMapuiv( GLenum map, GLuint *values );
 проц  glGetPixelMapusv( GLenum map, GLushort *values );

 проц  glBitmap( GLsizei ширина, GLsizei высота,
                                GLfloat xorig, GLfloat yorig,
                                GLfloat xmove, GLfloat ymove,
                                 GLubyte *bitmap );

 проц  glReadPixels( GLint x, GLint y,
                                    GLsizei ширина, GLsizei высота,
                                    GLenum формат, GLenum тип,
                                    GLvoid *pixels );

 проц  glDrawPixels( GLsizei ширина, GLsizei высота,
                                    GLenum формат, GLenum тип,
                                     GLvoid *pixels );

 проц  glCopyPixels( GLint x, GLint y,
                                    GLsizei ширина, GLsizei высота,
                                    GLenum тип );

/*
 * Stenciling
 */

 проц  glStencilFunc( GLenum func, GLint reference, GLuint mask );

 проц  glStencilMask( GLuint mask );

 проц  glStencilOp( GLenum fail, GLenum zfail, GLenum zpass );

 проц  glClearStencil( GLint s );



/*
 * Texture mapping
 */

 проц  glTexGend( GLenum coord, GLenum pname, GLdouble param );
 проц  glTexGenf( GLenum coord, GLenum pname, GLfloat param );
 проц  glTexGeni( GLenum coord, GLenum pname, GLint param );

 проц  glTexGendv( GLenum coord, GLenum pname,  GLdouble *парамы );
 проц  glTexGenfv( GLenum coord, GLenum pname,  GLfloat *парамы );
 проц  glTexGeniv( GLenum coord, GLenum pname,  GLint *парамы );

 проц  glGetTexGendv( GLenum coord, GLenum pname, GLdouble *парамы );
 проц  glGetTexGenfv( GLenum coord, GLenum pname, GLfloat *парамы );
 проц  glGetTexGeniv( GLenum coord, GLenum pname, GLint *парамы );


 проц  glTexEnvf( GLenum цель, GLenum pname, GLfloat param );
 проц  glTexEnvi( GLenum цель, GLenum pname, GLint param );

 проц  glTexEnvfv( GLenum цель, GLenum pname,  GLfloat *парамы );
 проц  glTexEnviv( GLenum цель, GLenum pname,  GLint *парамы );

 проц  glGetTexEnvfv( GLenum цель, GLenum pname, GLfloat *парамы );
 проц  glGetTexEnviv( GLenum цель, GLenum pname, GLint *парамы );


 проц  glTexParameterf( GLenum цель, GLenum pname, GLfloat param );
 проц  glTexParameteri( GLenum цель, GLenum pname, GLint param );

 проц  glTexParameterfv( GLenum цель, GLenum pname,
                                           GLfloat *парамы );
 проц  glTexParameteriv( GLenum цель, GLenum pname,
                                           GLint *парамы );

 проц  glGetTexParameterfv( GLenum цель,
                                           GLenum pname, GLfloat *парамы);
 проц  glGetTexParameteriv( GLenum цель,
                                           GLenum pname, GLint *парамы );

 проц  glGetTexLevelParameterfv( GLenum цель, GLint уровень,
                                                GLenum pname, GLfloat *парамы );
 проц  glGetTexLevelParameteriv( GLenum цель, GLint уровень,
                                                GLenum pname, GLint *парамы );


 проц  glTexImage1D( GLenum цель, GLint уровень,
                                    GLint внутрФормат,
                                    GLsizei ширина, GLint border,
                                    GLenum формат, GLenum тип,
                                     GLvoid *pixels );

 проц  glTexImage2D( GLenum цель, GLint уровень,
                                    GLint внутрФормат,
                                    GLsizei ширина, GLsizei высота,
                                    GLint border, GLenum формат, GLenum тип,
                                     GLvoid *pixels );

 проц  glGetTexImage( GLenum цель, GLint уровень,
                                     GLenum формат, GLenum тип,
                                     GLvoid *pixels );


/* 1.1 functions */

 проц  glGenTextures( GLsizei n, GLuint *textures );

 проц  glDeleteTextures( GLsizei n,  GLuint *textures);

 проц  glBindTexture( GLenum цель, GLuint texture );

 проц  glPrioritizeTextures( GLsizei n,
                                             GLuint *textures,
                                             GLclampf *priorities );

 GLboolean  glAreTexturesResident( GLsizei n,
                                                   GLuint *textures,
                                                  GLboolean *residences );

 GLboolean  glIsTexture( GLuint texture );

 проц  glTexSubImage1D( GLenum цель, GLint уровень,
                                       GLint xoffset,
                                       GLsizei ширина, GLenum формат,
                                       GLenum тип,  GLvoid *pixels );


 проц  glTexSubImage2D( GLenum цель, GLint уровень,
                                       GLint xoffset, GLint yoffset,
                                       GLsizei ширина, GLsizei высота,
                                       GLenum формат, GLenum тип,
                                        GLvoid *pixels );

 проц  glCopyTexImage1D( GLenum цель, GLint уровень,
                                        GLenum internalformat,
                                        GLint x, GLint y,
                                        GLsizei ширина, GLint border );

 проц  glCopyTexImage2D( GLenum цель, GLint уровень,
                                        GLenum internalformat,
                                        GLint x, GLint y,
                                        GLsizei ширина, GLsizei высота,
                                        GLint border );

 проц  glCopyTexSubImage1D( GLenum цель, GLint уровень,
                                           GLint xoffset, GLint x, GLint y,
                                           GLsizei ширина );

 проц  glCopyTexSubImage2D( GLenum цель, GLint уровень,
                                           GLint xoffset, GLint yoffset,
                                           GLint x, GLint y,
                                           GLsizei ширина, GLsizei высота );


/*
 * Evaluators
 */

 проц  glMap1d( GLenum цель, GLdouble u1, GLdouble u2,
                               GLint stride,
                               GLint order,  GLdouble *points );
 проц  glMap1f( GLenum цель, GLfloat u1, GLfloat u2,
                               GLint stride,
                               GLint order,  GLfloat *points );

 проц  glMap2d( GLenum цель,
		     GLdouble u1, GLdouble u2, GLint ustride, GLint uorder,
		     GLdouble v1, GLdouble v2, GLint vstride, GLint vorder,
		      GLdouble *points );
 проц  glMap2f( GLenum цель,
		     GLfloat u1, GLfloat u2, GLint ustride, GLint uorder,
		     GLfloat v1, GLfloat v2, GLint vstride, GLint vorder,
		      GLfloat *points );

 проц  glGetMapdv( GLenum цель, GLenum query, GLdouble *v );
 проц  glGetMapfv( GLenum цель, GLenum query, GLfloat *v );
 проц  glGetMapiv( GLenum цель, GLenum query, GLint *v );

 проц  glEvalCoord1d( GLdouble u );
 проц  glEvalCoord1f( GLfloat u );

 проц  glEvalCoord1dv(  GLdouble *u );
 проц  glEvalCoord1fv(  GLfloat *u );

 проц  glEvalCoord2d( GLdouble u, GLdouble v );
 проц  glEvalCoord2f( GLfloat u, GLfloat v );

 проц  glEvalCoord2dv(  GLdouble *u );
 проц  glEvalCoord2fv(  GLfloat *u );

 проц  glMapGrid1d( GLint un, GLdouble u1, GLdouble u2 );
 проц  glMapGrid1f( GLint un, GLfloat u1, GLfloat u2 );

 проц  glMapGrid2d( GLint un, GLdouble u1, GLdouble u2,
                                   GLint vn, GLdouble v1, GLdouble v2 );
 проц  glMapGrid2f( GLint un, GLfloat u1, GLfloat u2,
                                   GLint vn, GLfloat v1, GLfloat v2 );

 проц  glEvalPoint1( GLint i );

 проц  glEvalPoint2( GLint i, GLint j );

 проц  glEvalMesh1( GLenum mode, GLint i1, GLint i2 );

 проц  glEvalMesh2( GLenum mode, GLint i1, GLint i2, GLint j1, GLint j2 );


/*
 * Fog
 */

 проц  glFogf( GLenum pname, GLfloat param );

 проц  glFogi( GLenum pname, GLint param );

 проц  glFogfv( GLenum pname,  GLfloat *парамы );

 проц  glFogiv( GLenum pname,  GLint *парамы );


/*
 * Selection and Feedback
 */

 проц  glFeedbackBuffer( GLsizei размер, GLenum тип, GLfloat *буфер );

 проц  glPassThrough( GLfloat token );

 проц  glSelectBuffer( GLsizei размер, GLuint *буфер );

 проц  glInitNames();

 проц  glLoadName( GLuint имя );

 проц  glPushName( GLuint имя );

 проц  glPopName();



/*
 * OpenGL 1.2
 */

 проц  glDrawRangeElements( GLenum mode, GLuint start,
	GLuint end, GLsizei count, GLenum тип,  GLvoid *indices );

 проц  glTexImage3D( GLenum цель, GLint уровень,
                                      GLint внутрФормат,
                                      GLsizei ширина, GLsizei высота,
                                      GLsizei глубина, GLint border,
                                      GLenum формат, GLenum тип,
                                       GLvoid *pixels );

 проц  glTexSubImage3D( GLenum цель, GLint уровень,
                                         GLint xoffset, GLint yoffset,
                                         GLint zoffset, GLsizei ширина,
                                         GLsizei высота, GLsizei глубина,
                                         GLenum формат,
                                         GLenum тип,  GLvoid *pixels);

 проц  glCopyTexSubImage3D( GLenum цель, GLint уровень,
                                             GLint xoffset, GLint yoffset,
                                             GLint zoffset, GLint x,
                                             GLint y, GLsizei ширина,
                                             GLsizei высота );

											 
 проц  glColorTable( GLenum цель, GLenum internalformat,
                                    GLsizei ширина, GLenum формат,
                                    GLenum тип,  GLvoid *table );
 проц  glColorSubTable( GLenum цель,
                                       GLsizei start, GLsizei count,
                                       GLenum формат, GLenum тип,
                                        GLvoid *данные );
 проц  glColorTableParameteriv(GLenum цель, GLenum pname,
                                               GLint *парамы);
 проц  glColorTableParameterfv(GLenum цель, GLenum pname,
                                               GLfloat *парамы);
 проц  glCopyColorSubTable( GLenum цель, GLsizei start,
                                           GLint x, GLint y, GLsizei ширина );
 проц  glCopyColorTable( GLenum цель, GLenum internalformat,
                                        GLint x, GLint y, GLsizei ширина );
 проц  glGetColorTable( GLenum цель, GLenum формат,
                                       GLenum тип, GLvoid *table );
 проц  glGetColorTableParameterfv( GLenum цель, GLenum pname,
                                                  GLfloat *парамы );
 проц  glGetColorTableParameteriv( GLenum цель, GLenum pname,
                                                  GLint *парамы );
 проц  glBlendEquation( GLenum mode );
 проц  glBlendColor( GLclampf red, GLclampf green,
                                    GLclampf blue, GLclampf alpha );
 проц  glHistogram( GLenum цель, GLsizei ширина,
				   GLenum internalformat, GLboolean sink );
 проц  glResetHistogram( GLenum цель );
 проц  glGetHistogram( GLenum цель, GLboolean reset,
				      GLenum формат, GLenum тип,
				      GLvoid *values );
 проц  glGetHistogramParameterfv( GLenum цель, GLenum pname,
						 GLfloat *парамы );
 проц  glGetHistogramParameteriv( GLenum цель, GLenum pname,
						 GLint *парамы );
 проц  glMinmax( GLenum цель, GLenum internalformat,
				GLboolean sink );
 проц  glResetMinmax( GLenum цель );
 проц  glGetMinmax( GLenum цель, GLboolean reset,
                                   GLenum формат, GLenum типы,
                                   GLvoid *values );
 проц  glGetMinmaxParameterfv( GLenum цель, GLenum pname,
					      GLfloat *парамы );
 проц  glGetMinmaxParameteriv( GLenum цель, GLenum pname,
					      GLint *парамы );
 проц  glConvolutionFilter1D( GLenum цель,
	GLenum internalformat, GLsizei ширина, GLenum формат, GLenum тип,
	 GLvoid *image );
 проц  glConvolutionFilter2D( GLenum цель,
	GLenum internalformat, GLsizei ширина, GLsizei высота, GLenum формат,
	GLenum тип,  GLvoid *image );
 проц  glConvolutionParameterf( GLenum цель, GLenum pname,
	GLfloat парамы );
 проц  glConvolutionParameterfv( GLenum цель, GLenum pname,
	 GLfloat *парамы );
 проц  glConvolutionParameteri( GLenum цель, GLenum pname,
	GLint парамы );
 проц  glConvolutionParameteriv( GLenum цель, GLenum pname,
	 GLint *парамы );
 проц  glCopyConvolutionFilter1D( GLenum цель,
	GLenum internalformat, GLint x, GLint y, GLsizei ширина );
 проц  glCopyConvolutionFilter2D( GLenum цель,
	GLenum internalformat, GLint x, GLint y, GLsizei ширина,
	GLsizei высота);
 проц  glGetConvolutionFilter( GLenum цель, GLenum формат,
	GLenum тип, GLvoid *image );
 проц  glGetConvolutionParameterfv( GLenum цель, GLenum pname,
	GLfloat *парамы );
 проц  glGetConvolutionParameteriv( GLenum цель, GLenum pname,
	GLint *парамы );
 проц  glSeparableFilter2D( GLenum цель,
	GLenum internalformat, GLsizei ширина, GLsizei высота, GLenum формат,
	GLenum тип,  GLvoid *row,  GLvoid *column );

 проц  glGetSeparableFilter( GLenum цель, GLenum формат,
	GLenum тип, GLvoid *row, GLvoid *column, GLvoid *span );


/*
 * OpenGL 1.3
 */

 проц  glActiveTexture( GLenum texture );

 проц  glClientActiveTexture( GLenum texture );

 проц  glCompressedTexImage1D( GLenum цель, GLint уровень, GLenum internalformat, GLsizei ширина, GLint border, GLsizei imageSize,  GLvoid *данные );

 проц  glCompressedTexImage2D( GLenum цель, GLint уровень, GLenum internalformat, GLsizei ширина, GLsizei высота, GLint border, GLsizei imageSize,  GLvoid *данные );

 проц  glCompressedTexImage3D( GLenum цель, GLint уровень, GLenum internalformat, GLsizei ширина, GLsizei высота, GLsizei глубина, GLint border, GLsizei imageSize,  GLvoid *данные );

 проц  glCompressedTexSubImage1D( GLenum цель, GLint уровень, GLint xoffset, GLsizei ширина, GLenum формат, GLsizei imageSize,  GLvoid *данные );

 проц  glCompressedTexSubImage2D( GLenum цель, GLint уровень, GLint xoffset, GLint yoffset, GLsizei ширина, GLsizei высота, GLenum формат, GLsizei imageSize,  GLvoid *данные );

 проц  glCompressedTexSubImage3D( GLenum цель, GLint уровень, GLint xoffset, GLint yoffset, GLint zoffset, GLsizei ширина, GLsizei высота, GLsizei глубина, GLenum формат, GLsizei imageSize,  GLvoid *данные );

 проц  glGetCompressedTexImage( GLenum цель, GLint lod, GLvoid *img );

 проц  glMultiTexCoord1d( GLenum цель, GLdouble s );

 проц  glMultiTexCoord1dv( GLenum цель,  GLdouble *v );

 проц  glMultiTexCoord1f( GLenum цель, GLfloat s );

 проц  glMultiTexCoord1fv( GLenum цель,  GLfloat *v );

 проц  glMultiTexCoord1i( GLenum цель, GLint s );

 проц  glMultiTexCoord1iv( GLenum цель,  GLint *v );

 проц  glMultiTexCoord1s( GLenum цель, GLshort s );

 проц  glMultiTexCoord1sv( GLenum цель,  GLshort *v );

 проц  glMultiTexCoord2d( GLenum цель, GLdouble s, GLdouble t );

 проц  glMultiTexCoord2dv( GLenum цель,  GLdouble *v );

 проц  glMultiTexCoord2f( GLenum цель, GLfloat s, GLfloat t );

 проц  glMultiTexCoord2fv( GLenum цель,  GLfloat *v );

 проц  glMultiTexCoord2i( GLenum цель, GLint s, GLint t );

 проц  glMultiTexCoord2iv( GLenum цель,  GLint *v );

 проц  glMultiTexCoord2s( GLenum цель, GLshort s, GLshort t );

 проц  glMultiTexCoord2sv( GLenum цель,  GLshort *v );

 проц  glMultiTexCoord3d( GLenum цель, GLdouble s, GLdouble t, GLdouble r );

 проц  glMultiTexCoord3dv( GLenum цель,  GLdouble *v );

 проц  glMultiTexCoord3f( GLenum цель, GLfloat s, GLfloat t, GLfloat r );

 проц  glMultiTexCoord3fv( GLenum цель,  GLfloat *v );

 проц  glMultiTexCoord3i( GLenum цель, GLint s, GLint t, GLint r );

 проц  glMultiTexCoord3iv( GLenum цель,  GLint *v );

 проц  glMultiTexCoord3s( GLenum цель, GLshort s, GLshort t, GLshort r );

 проц  glMultiTexCoord3sv( GLenum цель,  GLshort *v );

 проц  glMultiTexCoord4d( GLenum цель, GLdouble s, GLdouble t, GLdouble r, GLdouble q );

 проц  glMultiTexCoord4dv( GLenum цель,  GLdouble *v );

 проц  glMultiTexCoord4f( GLenum цель, GLfloat s, GLfloat t, GLfloat r, GLfloat q );

 проц  glMultiTexCoord4fv( GLenum цель,  GLfloat *v );

 проц  glMultiTexCoord4i( GLenum цель, GLint s, GLint t, GLint r, GLint q );

 проц  glMultiTexCoord4iv( GLenum цель,  GLint *v );

 проц  glMultiTexCoord4s( GLenum цель, GLshort s, GLshort t, GLshort r, GLshort q );

 проц  glMultiTexCoord4sv( GLenum цель,  GLshort *v );


 проц  glLoadTransposeMatrixd(  GLdouble m[16] );

 проц  glLoadTransposeMatrixf(  GLfloat m[16] );

 проц  glMultTransposeMatrixd(  GLdouble m[16] );

 проц  glMultTransposeMatrixf(  GLfloat m[16] );

 проц  glSampleCoverage( GLclampf value, GLboolean invert );

 
 проц  glActiveTextureARB(GLenum texture);
 проц  glClientActiveTextureARB(GLenum texture);
 проц  glMultiTexCoord1dARB(GLenum цель, GLdouble s);
 проц  glMultiTexCoord1dvARB(GLenum цель,  GLdouble *v);
 проц  glMultiTexCoord1fARB(GLenum цель, GLfloat s);
 проц  glMultiTexCoord1fvARB(GLenum цель,  GLfloat *v);
 проц  glMultiTexCoord1iARB(GLenum цель, GLint s);
 проц  glMultiTexCoord1ivARB(GLenum цель,  GLint *v);
 проц  glMultiTexCoord1sARB(GLenum цель, GLshort s);
 проц  glMultiTexCoord1svARB(GLenum цель,  GLshort *v);
 проц  glMultiTexCoord2dARB(GLenum цель, GLdouble s, GLdouble t);
 проц  glMultiTexCoord2dvARB(GLenum цель,  GLdouble *v);
 проц  glMultiTexCoord2fARB(GLenum цель, GLfloat s, GLfloat t);
 проц  glMultiTexCoord2fvARB(GLenum цель,  GLfloat *v);
 проц  glMultiTexCoord2iARB(GLenum цель, GLint s, GLint t);
 проц  glMultiTexCoord2ivARB(GLenum цель,  GLint *v);
 проц  glMultiTexCoord2sARB(GLenum цель, GLshort s, GLshort t);
 проц  glMultiTexCoord2svARB(GLenum цель,  GLshort *v);
 проц  glMultiTexCoord3dARB(GLenum цель, GLdouble s, GLdouble t, GLdouble r);
 проц  glMultiTexCoord3dvARB(GLenum цель,  GLdouble *v);
 проц  glMultiTexCoord3fARB(GLenum цель, GLfloat s, GLfloat t, GLfloat r);
 проц  glMultiTexCoord3fvARB(GLenum цель,  GLfloat *v);
 проц  glMultiTexCoord3iARB(GLenum цель, GLint s, GLint t, GLint r);
 проц  glMultiTexCoord3ivARB(GLenum цель,  GLint *v);
 проц  glMultiTexCoord3sARB(GLenum цель, GLshort s, GLshort t, GLshort r);
 проц  glMultiTexCoord3svARB(GLenum цель,  GLshort *v);
 проц  glMultiTexCoord4dARB(GLenum цель, GLdouble s, GLdouble t, GLdouble r, GLdouble q);
 проц  glMultiTexCoord4dvARB(GLenum цель,  GLdouble *v);
 проц  glMultiTexCoord4fARB(GLenum цель, GLfloat s, GLfloat t, GLfloat r, GLfloat q);
 проц  glMultiTexCoord4fvARB(GLenum цель,  GLfloat *v);
 проц  glMultiTexCoord4iARB(GLenum цель, GLint s, GLint t, GLint r, GLint q);
 проц  glMultiTexCoord4ivARB(GLenum цель,  GLint *v);
 проц  glMultiTexCoord4sARB(GLenum цель, GLshort s, GLshort t, GLshort r, GLshort q);
 проц  glMultiTexCoord4svARB(GLenum цель,  GLshort *v);
 
 
/* GLUT initialization sub-API. */

 проц  glutInit(int *argcp, char **argv);

 проц glutInitDisplayMode(uint mode);

 проц  glutInitWindowPosition(int x, int y);
 проц  glutInitWindowSize(int ширина, int высота);
 проц  glutMainLoop();

/* GLUT window sub-API. */
 int  glutCreateWindow( char *title);

 int  glutCreateSubWindow(int win, int x, int y, int ширина, int высота);
 проц  glutDestroyWindow(int win);
 проц  glutPostRedisplay();

 проц  glutSwapBuffers();
 int  glutGetWindow();
 проц  glutSetWindow(int win);
 проц  glutSetWindowTitle( char *title);
 проц  glutSetIconTitle( char *title);
 проц  glutPositionWindow(int x, int y);
 проц  glutReshapeWindow(int ширина, int высота);
 проц  glutPopWindow();
 проц  glutPushWindow();
 проц  glutIconifyWindow();
 проц  glutShowWindow();
 проц  glutHideWindow();
 проц glutFullScreen();
/* GLUT overlay sub-API. */
 проц  glutEstablishOverlay();
 проц  glutRemoveOverlay();
 проц  glutUseLayer(GLenum layer);
 проц  glutPostOverlayRedisplay();

/* GLUT menu sub-API. */
 int  glutCreateMenu(сифунк_Ц);

 проц  glutDestroyMenu(int menu);
 int  glutGetMenu();
 проц  glutSetMenu(int menu);
 проц  glutAddMenuEntry( char *label, int value);
 проц  glutAddSubMenu( char *label, int submenu);
 проц  glutChangeToMenuEntry(int item,  char *label, int value);
 проц  glutChangeToSubMenu(int item,  char *label, int submenu);
 проц  glutRemoveMenuItem(int item);
 проц  glutAttachMenu(int button);
 проц  glutDetachMenu(int button);

/* GLUT window callback sub-API. */
 проц  glutDisplayFunc(сифунк);
 проц  glutReshapeFunc(сифунк_ЦЦ);
 проц  glutKeyboardFunc(сифунк_СЦЦ);
 проц  glutMouseFunc(сифунк_ЦЦЦЦ);
 проц  glutMotionFunc(сифунк_ЦЦ);
 проц  glutPassiveMotionFunc(сифунк_ЦЦ);
 проц  glutEntryFunc(сифунк_Ц);
 проц  glutVisibilityFunc(сифунк_Ц);
 проц  glutIdleFunc(сифунк);
 проц  glutTimerFunc(uint millis, сифунк_Ц, int value);
 проц  glutMenuStateFunc(сифунк_Ц);


/* GLUT color index sub-API. */
 проц  glutSetColor(int ndx, GLfloat red, GLfloat green, GLfloat blue);
 GLfloat  glutGetColor(int ndx, int component);
 проц  glutCopyColormap(int win);

/* GLUT state retrieval sub-API. */
 int  glutGet(GLenum тип);
 int  glutDeviceGet(GLenum тип);


/* GLUT font sub-API */
 проц  glutBitmapCharacter(ук font, int character);
 int  glutBitmapWidth(ук font, int character);
 проц  glutStrokeCharacter(ук font, int character);
 int  glutStrokeWidth(ук font, int character);


/* GLUT pre-built models sub-API */
 проц  glutWireSphere(GLdouble radius, GLint доли, GLint пачки);
 проц  glutSolidSphere(GLdouble radius, GLint доли, GLint пачки);
 проц  glutWireCone(GLdouble ова, GLdouble высота, GLint доли, GLint пачки);
 проц  glutSolidCone(GLdouble ова, GLdouble высота, GLint доли, GLint пачки);
 проц  glutWireCube(GLdouble размер);
 проц  glutSolidCube(GLdouble размер);
 проц  glutWireTorus(GLdouble innerRadius, GLdouble outerRadius, GLint sides, GLint rings);
 проц  glutSolidTorus(GLdouble innerRadius, GLdouble outerRadius, GLint sides, GLint rings);
 проц  glutWireDodecahedron();
 проц  glutSolidDodecahedron();
 проц  glutWireTeapot(GLdouble размер);
 проц  glutSolidTeapot(GLdouble размер);
 проц  glutWireOctahedron();
 проц  glutSolidOctahedron();
 проц  glutWireTetrahedron();
 проц  glutSolidTetrahedron();
 проц  glutWireIcosahedron();
 проц  glutSolidIcosahedron();
 
 проц glutInitDisplayString(GLchar* а);
 
 проц glutPostWindowRedisplay(int win);
 проц  glutWarpPointer(int x, int y);
  проц  glutSetCursor(int cursor);
  проц  glutPostWindowOverlayRedisplay(int win);
  проц glutShowOverlay();
проц  glutHideOverlay();

 проц  glutSpecialFunc(сифунк_ЦЦЦ);
 проц  glutSpaceballMotionFunc(сифунк_ЦЦЦ);
 проц  glutSpaceballRotateFunc(сифунк_ЦЦЦ);
 проц  glutSpaceballButtonFunc(сифунк_ЦЦ);
 проц  glutButtonBoxFunc(сифунк_ЦЦ);
 проц  glutDialsFunc(сифунк_ЦЦ);
 проц  glutTabletMotionFunc(сифунк_ЦЦ);
 проц  glutTabletButtonFunc(сифунк_ЦЦЦЦ);
 
 проц  glutKeyboardUpFunc(сифунк_СЦЦ);
 проц  glutSpecialUpFunc(сифунк_ЦЦЦ);
 проц  glutJoystickFunc(сифунк_бЦЦЦЦ, int pollInterval);
 

}