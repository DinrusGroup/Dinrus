/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/arraytypes.d, _arraytypes.d)
 * Documentation:  https://dlang.org/phobos/dmd_arraytypes.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/arraytypes.d
 */

module dmd.arraytypes;

import dmd.dclass;
import dmd.declaration;
import dmd.dmodule;
import dmd.дсимвол;
import dmd.dtemplate;
import drc.ast.Expression;
import dmd.func;
import drc.lexer.Identifier;
import dmd.init;
import dmd.mtype;
import util.array;
import drc.ast.Node;
import dmd.инструкция;

alias  МассивДРК!(сим*) Strings;
alias  МассивДРК!(Идентификатор2) Идентификаторы;
alias  МассивДРК!(ПараметрШаблона2) ПараметрыШаблона;
alias  МассивДРК!(Выражение) Выражения;
alias  МассивДРК!(Инструкция2) Инструкции;
alias  МассивДРК!(КлассОснова2*) КлассыОсновы;
alias  МассивДРК!(ClassDeclaration) ClassDeclarations;
alias  МассивДРК!(ДСимвол) Дсимволы;
alias  МассивДРК!(КорневойОбъект) Объекты;
alias  МассивДРК!(DtorDeclaration) DtorDeclarations;
alias  МассивДРК!(FuncDeclaration) FuncDeclarations;
alias  МассивДРК!(Параметр2) Параметры;
alias  МассивДРК!(Инициализатор) Инициализаторы;
alias  МассивДРК!(VarDeclaration) VarDeclarations;
alias  МассивДРК!(Тип) Types;
alias  МассивДРК!(Уловитель) Уловители;
alias  МассивДРК!(StaticDtorDeclaration) StaticDtorDeclarations;
alias  МассивДРК!(SharedStaticDtorDeclaration) SharedStaticDtorDeclarations;
alias  МассивДРК!(AliasDeclaration) AliasDeclarations;
alias  МассивДРК!(Module) Modules;
alias  МассивДРК!(CaseStatement) CaseStatements;
alias  МассивДРК!(ScopeStatement) ScopeStatements;
alias  МассивДРК!(GotoCaseStatement) GotoCaseStatements;
alias  МассивДРК!(ReturnStatement) ReturnStatements;
alias  МассивДРК!(GotoStatement) GotoStatements;
alias  МассивДРК!(TemplateInstance) TemplateInstances;
alias  МассивДРК!(Гарант) Гаранты;
