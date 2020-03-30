/**
 * Documentation:  https://dlang.org/phobos/dmd_permissivevisitor.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/permissivevisitor.d
 */

module drc.ast.PermissiveVisitor;

import drc.ast.ParsetimeVisitor;

/** PermissiveVisitor overrides all the посети methods in  the родитель class
  * that assert(0) in order to facilitate the traversal of subsets of the AST.
  * It does not implement any visiting logic.
  */
/*extern(C++)*/ class PermissiveVisitor(AST): ВизиторВремениРазбора!(AST)
{
    alias ВизиторВремениРазбора!(AST).посети посети;

    override проц посети(AST.ДСимвол){}
    override проц посети(AST.Параметр2){}
    override проц посети(AST.Инструкция2){}
    override проц посети(AST.Тип){}
    override проц посети(AST.Выражение){}
    override проц посети(AST.ПараметрШаблона2){}
    override проц посети(AST.Condition){}
    override проц посети(AST.Инициализатор){}
}
