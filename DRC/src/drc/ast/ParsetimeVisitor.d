/**
 * Documentation:  https://dlang.org/phobos/dmd_parsetimevisitor.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/parsetimevisitor.d
 */

module drc.ast.ParsetimeVisitor;

/** Базовый и dumm визитор, реализующий метод "посети" для каждого узла АСД,
  * реализованного в АСД. Этот визитор является родителем строгого, транзитивного
  * и пермиссивного визиторов.
  */
 class ВизиторВремениРазбора(AST)
{
public:
    проц посети(AST.ДСимвол) { assert(0); }
    проц посети(AST.Параметр2) { assert(0); }
    проц посети(AST.Инструкция2) { assert(0); }
    проц посети(AST.Тип) { assert(0); }
    проц посети(AST.Выражение) { assert(0); }
    проц посети(AST.ПараметрШаблона2) { assert(0); }
    проц посети(AST.Condition) { assert(0); }
    проц посети(AST.Инициализатор) { assert(0); }

    //=======================================================================================
    // Дсимволы
    проц посети(AST.AliasThis s) { посети(cast(AST.ДСимвол)s); }
    проц посети(AST.Declaration s) { посети(cast(AST.ДСимвол)s); }
    проц посети(AST.ScopeDsymbol s) { посети(cast(AST.ДСимвол)s); }
    проц посети(AST.Импорт s) { посети(cast(AST.ДСимвол)s); }
    проц посети(AST.AttribDeclaration s) { посети(cast(AST.ДСимвол)s); }
    проц посети(AST.StaticAssert s) { посети(cast(AST.ДСимвол)s); }
    проц посети(AST.DebugSymbol s) { посети(cast(AST.ДСимвол)s); }
    проц посети(AST.VersionSymbol s) { посети(cast(AST.ДСимвол)s); }

    // ScopeDsymbols
    проц посети(AST.Package s) { посети(cast(AST.ScopeDsymbol)s); }
    проц посети(AST.EnumDeclaration s) { посети(cast(AST.ScopeDsymbol)s); }
    проц посети(AST.AggregateDeclaration s) { посети(cast(AST.ScopeDsymbol)s); }
    проц посети(AST.TemplateDeclaration s) { посети(cast(AST.ScopeDsymbol)s); }
    проц посети(AST.TemplateInstance s) { посети(cast(AST.ScopeDsymbol)s); }
    проц посети(AST.Nspace s) { посети(cast(AST.ScopeDsymbol)s); }

    //=========================================================================================
    // Declarations
    проц посети(AST.VarDeclaration s) { посети(cast(AST.Declaration)s); }
    проц посети(AST.FuncDeclaration s) { посети(cast(AST.Declaration)s); }
    проц посети(AST.AliasDeclaration s) { посети(cast(AST.Declaration)s); }
    проц посети(AST.TupleDeclaration s) { посети(cast(AST.Declaration)s); }

    // FuncDeclarations
    проц посети(AST.FuncLiteralDeclaration s) { посети(cast(AST.FuncDeclaration)s); }
    проц посети(AST.PostBlitDeclaration s) { посети(cast(AST.FuncDeclaration)s); }
    проц посети(AST.CtorDeclaration s) { посети(cast(AST.FuncDeclaration)s); }
    проц посети(AST.DtorDeclaration s) { посети(cast(AST.FuncDeclaration)s); }
    проц посети(AST.InvariantDeclaration s) { посети(cast(AST.FuncDeclaration)s); }
    проц посети(AST.UnitTestDeclaration s) { посети(cast(AST.FuncDeclaration)s); }
    проц посети(AST.NewDeclaration s) { посети(cast(AST.FuncDeclaration)s); }
    проц посети(AST.StaticCtorDeclaration s) { посети(cast(AST.FuncDeclaration)s); }
    проц посети(AST.StaticDtorDeclaration s) { посети(cast(AST.FuncDeclaration)s); }
    проц посети(AST.SharedStaticCtorDeclaration s) { посети(cast(AST.StaticCtorDeclaration)s); }
    проц посети(AST.SharedStaticDtorDeclaration s) { посети(cast(AST.StaticDtorDeclaration)s); }

    // AttribDeclarations
    проц посети(AST.CompileDeclaration s) { посети(cast(AST.AttribDeclaration)s); }
    проц посети(AST.UserAttributeDeclaration s) { посети(cast(AST.AttribDeclaration)s); }
    проц посети(AST.LinkDeclaration s) { посети(cast(AST.AttribDeclaration)s); }
    проц посети(AST.AnonDeclaration s) { посети(cast(AST.AttribDeclaration)s); }
    проц посети(AST.AlignDeclaration s) { посети(cast(AST.AttribDeclaration)s); }
    проц посети(AST.CPPMangleDeclaration s) { посети(cast(AST.AttribDeclaration)s); }
    проц посети(AST.CPPNamespaceDeclaration s) { посети(cast(AST.AttribDeclaration)s); }
    проц посети(AST.ProtDeclaration s) { посети(cast(AST.AttribDeclaration)s); }
    проц посети(AST.PragmaDeclaration s) { посети(cast(AST.AttribDeclaration)s); }
    проц посети(AST.StorageClassDeclaration s) { посети(cast(AST.AttribDeclaration)s); }
    проц посети(AST.ConditionalDeclaration s) { посети(cast(AST.AttribDeclaration)s); }
    проц посети(AST.StaticForeachDeclaration s) { посети(cast(AST.AttribDeclaration)s); }

    //==============================================================================================
    // Miscellaneous
    проц посети(AST.DeprecatedDeclaration s) { посети(cast(AST.StorageClassDeclaration)s); }
    проц посети(AST.StaticIfDeclaration s) { посети(cast(AST.ConditionalDeclaration)s); }
    проц посети(AST.EnumMember s) { посети(cast(AST.VarDeclaration)s); }
    проц посети(AST.Module s) { посети(cast(AST.Package)s); }
    проц посети(AST.StructDeclaration s) { посети(cast(AST.AggregateDeclaration)s); }
    проц посети(AST.UnionDeclaration s) { посети(cast(AST.StructDeclaration)s); }
    проц посети(AST.ClassDeclaration s) { посети(cast(AST.AggregateDeclaration)s); }
    проц посети(AST.InterfaceDeclaration s) { посети(cast(AST.ClassDeclaration)s); }
    проц посети(AST.TemplateMixin s) { посети(cast(AST.TemplateInstance)s); }

    //============================================================================================
    // Инструкции
    проц посети(AST.ImportStatement s) { посети(cast(AST.Инструкция2)s); }
    проц посети(AST.ScopeStatement s) { посети(cast(AST.Инструкция2)s); }
    проц посети(AST.ReturnStatement s) { посети(cast(AST.Инструкция2)s); }
    проц посети(AST.LabelStatement s) { посети(cast(AST.Инструкция2)s); }
    проц посети(AST.StaticAssertStatement s) { посети(cast(AST.Инструкция2)s); }
    проц посети(AST.CompileStatement s) { посети(cast(AST.Инструкция2)s); }
    проц посети(AST.WhileStatement s) { посети(cast(AST.Инструкция2)s); }
    проц посети(AST.ForStatement s) { посети(cast(AST.Инструкция2)s); }
    проц посети(AST.DoStatement s) { посети(cast(AST.Инструкция2)s); }
    проц посети(AST.ForeachRangeStatement s) { посети(cast(AST.Инструкция2)s); }
    проц посети(AST.ForeachStatement s) { посети(cast(AST.Инструкция2)s); }
    проц посети(AST.IfStatement s) { посети(cast(AST.Инструкция2)s); }
    проц посети(AST.ScopeGuardStatement s) { посети(cast(AST.Инструкция2)s); }
    проц посети(AST.ConditionalStatement s) { посети(cast(AST.Инструкция2)s); }
    проц посети(AST.StaticForeachStatement s) { посети(cast(AST.Инструкция2)s); }
    проц посети(AST.PragmaStatement s) { посети(cast(AST.Инструкция2)s); }
    проц посети(AST.SwitchStatement s) { посети(cast(AST.Инструкция2)s); }
    проц посети(AST.CaseRangeStatement s) { посети(cast(AST.Инструкция2)s); }
    проц посети(AST.CaseStatement s) { посети(cast(AST.Инструкция2)s); }
    проц посети(AST.DefaultStatement s) { посети(cast(AST.Инструкция2)s); }
    проц посети(AST.BreakStatement s) { посети(cast(AST.Инструкция2)s); }
    проц посети(AST.ContinueStatement s) { посети(cast(AST.Инструкция2)s); }
    проц посети(AST.GotoDefaultStatement s) { посети(cast(AST.Инструкция2)s); }
    проц посети(AST.GotoCaseStatement s) { посети(cast(AST.Инструкция2)s); }
    проц посети(AST.GotoStatement s) { посети(cast(AST.Инструкция2)s); }
    проц посети(AST.SynchronizedStatement s) { посети(cast(AST.Инструкция2)s); }
    проц посети(AST.WithStatement s) { посети(cast(AST.Инструкция2)s); }
    проц посети(AST.TryCatchStatement s) { посети(cast(AST.Инструкция2)s); }
    проц посети(AST.TryFinallyStatement s) { посети(cast(AST.Инструкция2)s); }
    проц посети(AST.ThrowStatement s) { посети(cast(AST.Инструкция2)s); }
    проц посети(AST.AsmStatement s) { посети(cast(AST.Инструкция2)s); }
    проц посети(AST.ExpStatement s) { посети(cast(AST.Инструкция2)s); }
    проц посети(AST.CompoundStatement s) { посети(cast(AST.Инструкция2)s); }

    // CompoundStatements
    проц посети(AST.CompoundDeclarationStatement s) { посети(cast(AST.CompoundStatement)s); }
    проц посети(AST.CompoundAsmStatement s) { посети(cast(AST.CompoundStatement)s); }

    // AsmStatements
    проц посети(AST.InlineAsmStatement s) { посети(cast(AST.AsmStatement)s); }
    проц посети(AST.GccAsmStatement s) { посети(cast(AST.AsmStatement)s); }

    //=========================================================================================
    // Types
    проц посети(AST.TypeBasic t) { посети(cast(AST.Тип)t); }
    проц посети(AST.TypeError t) { посети(cast(AST.Тип)t); }
    проц посети(AST.TypeNull t) { посети(cast(AST.Тип)t); }
    проц посети(AST.TypeVector t) { посети(cast(AST.Тип)t); }
    проц посети(AST.TypeEnum t) { посети(cast(AST.Тип)t); }
    проц посети(AST.КортежТипов t) { посети(cast(AST.Тип)t); }
    проц посети(AST.TypeClass t) { посети(cast(AST.Тип)t); }
    проц посети(AST.TypeStruct t) { посети(cast(AST.Тип)t); }
    проц посети(AST.TypeNext t) { посети(cast(AST.Тип)t); }
    проц посети(AST.TypeQualified t) { посети(cast(AST.Тип)t); }
    проц посети(AST.TypeTraits t) { посети(cast(AST.Тип)t); }

    // TypeNext
    проц посети(AST.TypeReference t) { посети(cast(AST.TypeNext)t); }
    проц посети(AST.TypeSlice t) { посети(cast(AST.TypeNext)t); }
    проц посети(AST.TypeDelegate t) { посети(cast(AST.TypeNext)t); }
    проц посети(AST.TypePointer t) { посети(cast(AST.TypeNext)t); }
    проц посети(AST.TypeFunction t) { посети(cast(AST.TypeNext)t); }
    проц посети(AST.TypeArray t) { посети(cast(AST.TypeNext)t); }

    // TypeArray
    проц посети(AST.TypeDArray t) { посети(cast(AST.TypeArray)t); }
    проц посети(AST.TypeAArray t) { посети(cast(AST.TypeArray)t); }
    проц посети(AST.TypeSArray t) { посети(cast(AST.TypeArray)t); }

    // TypeQualified
    проц посети(AST.TypeIdentifier t) { посети(cast(AST.TypeQualified)t); }
    проц посети(AST.TypeReturn t) { посети(cast(AST.TypeQualified)t); }
    проц посети(AST.TypeTypeof t) { посети(cast(AST.TypeQualified)t); }
    проц посети(AST.TypeInstance t) { посети(cast(AST.TypeQualified)t); }

    //=================================================================================
    // Выражения
    проц посети(AST.DeclarationExp e) { посети(cast(AST.Выражение)e); }
    проц посети(AST.IntegerExp e) { посети(cast(AST.Выражение)e); }
    проц посети(AST.NewAnonClassExp e) { посети(cast(AST.Выражение)e); }
    проц посети(AST.IsExp e) { посети(cast(AST.Выражение)e); }
    проц посети(AST.RealExp e) { посети(cast(AST.Выражение)e); }
    проц посети(AST.NullExp e) { посети(cast(AST.Выражение)e); }
    проц посети(AST.TypeidExp e) { посети(cast(AST.Выражение)e); }
    проц посети(AST.TraitsExp e) { посети(cast(AST.Выражение)e); }
    проц посети(AST.StringExp e) { посети(cast(AST.Выражение)e); }
    проц посети(AST.NewExp e) { посети(cast(AST.Выражение)e); }
    проц посети(AST.AssocArrayLiteralExp e) { посети(cast(AST.Выражение)e); }
    проц посети(AST.ArrayLiteralExp e) { посети(cast(AST.Выражение)e); }
    проц посети(AST.CompileExp e) { посети(cast(AST.Выражение)e); }
    проц посети(AST.FuncExp e) { посети(cast(AST.Выражение)e); }
    проц посети(AST.IntervalExp e) { посети(cast(AST.Выражение)e); }
    проц посети(AST.TypeExp e) { посети(cast(AST.Выражение)e); }
    проц посети(AST.ScopeExp e) { посети(cast(AST.Выражение)e); }
    проц посети(AST.IdentifierExp e) { посети(cast(AST.Выражение)e); }
    проц посети(AST.UnaExp e) { посети(cast(AST.Выражение)e); }
    проц посети(AST.DefaultInitExp e) { посети(cast(AST.Выражение)e); }
    проц посети(AST.BinExp e) { посети(cast(AST.Выражение)e); }
    проц посети(AST.DsymbolExp e) { посети(cast(AST.Выражение)e); }
    проц посети(AST.TemplateExp e) { посети(cast(AST.Выражение)e); }
    проц посети(AST.SymbolExp e) { посети(cast(AST.Выражение)e); }
    проц посети(AST.TupleExp e) { посети(cast(AST.Выражение)e); }
    проц посети(AST.ThisExp e) { посети(cast(AST.Выражение)e); }

    // Miscellaneous
    проц посети(AST.VarExp e) { посети(cast(AST.SymbolExp)e); }
    проц посети(AST.DollarExp e) { посети(cast(AST.IdentifierExp)e); }
    проц посети(AST.SuperExp e) { посети(cast(AST.ThisExp)e); }

    // UnaExp
    проц посети(AST.AddrExp e) { посети(cast(AST.UnaExp)e); }
    проц посети(AST.PreExp e) { посети(cast(AST.UnaExp)e); }
    проц посети(AST.PtrExp e) { посети(cast(AST.UnaExp)e); }
    проц посети(AST.NegExp e) { посети(cast(AST.UnaExp)e); }
    проц посети(AST.UAddExp e) { посети(cast(AST.UnaExp)e); }
    проц посети(AST.NotExp e) { посети(cast(AST.UnaExp)e); }
    проц посети(AST.ComExp e) { посети(cast(AST.UnaExp)e); }
    проц посети(AST.DeleteExp e) { посети(cast(AST.UnaExp)e); }
    проц посети(AST.CastExp e) { посети(cast(AST.UnaExp)e); }
    проц посети(AST.CallExp e) { посети(cast(AST.UnaExp)e); }
    проц посети(AST.DotIdExp e) { посети(cast(AST.UnaExp)e); }
    проц посети(AST.AssertExp e) { посети(cast(AST.UnaExp)e); }
    проц посети(AST.ImportExp e) { посети(cast(AST.UnaExp)e); }
    проц посети(AST.DotTemplateInstanceExp e) { посети(cast(AST.UnaExp)e); }
    проц посети(AST.ArrayExp e) { посети(cast(AST.UnaExp)e); }

    // DefaultInitExp
    проц посети(AST.FuncInitExp e) { посети(cast(AST.DefaultInitExp)e); }
    проц посети(AST.PrettyFuncInitExp e) { посети(cast(AST.DefaultInitExp)e); }
    проц посети(AST.FileInitExp e) { посети(cast(AST.DefaultInitExp)e); }
    проц посети(AST.LineInitExp e) { посети(cast(AST.DefaultInitExp)e); }
    проц посети(AST.ModuleInitExp e) { посети(cast(AST.DefaultInitExp)e); }

    // BinExp
    проц посети(AST.CommaExp e) { посети(cast(AST.BinExp)e); }
    проц посети(AST.PostExp e) { посети(cast(AST.BinExp)e); }
    проц посети(AST.PowExp e) { посети(cast(AST.BinExp)e); }
    проц посети(AST.MulExp e) { посети(cast(AST.BinExp)e); }
    проц посети(AST.DivExp e) { посети(cast(AST.BinExp)e); }
    проц посети(AST.ModExp e) { посети(cast(AST.BinExp)e); }
    проц посети(AST.AddExp e) { посети(cast(AST.BinExp)e); }
    проц посети(AST.MinExp e) { посети(cast(AST.BinExp)e); }
    проц посети(AST.CatExp e) { посети(cast(AST.BinExp)e); }
    проц посети(AST.ShlExp e) { посети(cast(AST.BinExp)e); }
    проц посети(AST.ShrExp e) { посети(cast(AST.BinExp)e); }
    проц посети(AST.UshrExp e) { посети(cast(AST.BinExp)e); }
    проц посети(AST.EqualExp e) { посети(cast(AST.BinExp)e); }
    проц посети(AST.InExp e) { посети(cast(AST.BinExp)e); }
    проц посети(AST.IdentityExp e) { посети(cast(AST.BinExp)e); }
    проц посети(AST.CmpExp e) { посети(cast(AST.BinExp)e); }
    проц посети(AST.AndExp e) { посети(cast(AST.BinExp)e); }
    проц посети(AST.XorExp e) { посети(cast(AST.BinExp)e); }
    проц посети(AST.OrExp e) { посети(cast(AST.BinExp)e); }
    проц посети(AST.LogicalExp e) { посети(cast(AST.BinExp)e); }
    проц посети(AST.CondExp e) { посети(cast(AST.BinExp)e); }
    проц посети(AST.AssignExp e) { посети(cast(AST.BinExp)e); }
    проц посети(AST.BinAssignExp e) { посети(cast(AST.BinExp)e); }

    // BinAssignExp
    проц посети(AST.AddAssignExp e) { посети(cast(AST.BinAssignExp)e); }
    проц посети(AST.MinAssignExp e) { посети(cast(AST.BinAssignExp)e); }
    проц посети(AST.MulAssignExp e) { посети(cast(AST.BinAssignExp)e); }
    проц посети(AST.DivAssignExp e) { посети(cast(AST.BinAssignExp)e); }
    проц посети(AST.ModAssignExp e) { посети(cast(AST.BinAssignExp)e); }
    проц посети(AST.PowAssignExp e) { посети(cast(AST.BinAssignExp)e); }
    проц посети(AST.AndAssignExp e) { посети(cast(AST.BinAssignExp)e); }
    проц посети(AST.OrAssignExp e) { посети(cast(AST.BinAssignExp)e); }
    проц посети(AST.XorAssignExp e) { посети(cast(AST.BinAssignExp)e); }
    проц посети(AST.ShlAssignExp e) { посети(cast(AST.BinAssignExp)e); }
    проц посети(AST.ShrAssignExp e) { посети(cast(AST.BinAssignExp)e); }
    проц посети(AST.UshrAssignExp e) { посети(cast(AST.BinAssignExp)e); }
    проц посети(AST.CatAssignExp e) { посети(cast(AST.BinAssignExp)e); }

    //===============================================================================
    // ПараметрШаблона2
    проц посети(AST.TemplateAliasParameter tp) { посети(cast(AST.ПараметрШаблона2)tp); }
    проц посети(AST.TemplateTypeParameter tp) { посети(cast(AST.ПараметрШаблона2)tp); }
    проц посети(AST.TemplateTupleParameter tp) { посети(cast(AST.ПараметрШаблона2)tp); }
    проц посети(AST.TemplateValueParameter tp) { посети(cast(AST.ПараметрШаблона2)tp); }

    проц посети(AST.TemplateThisParameter tp) { посети(cast(AST.TemplateTypeParameter)tp); }

    //===============================================================================
    // Condition
    проц посети(AST.StaticIfCondition c) { посети(cast(AST.Condition)c); }
    проц посети(AST.DVCondition c) { посети(cast(AST.Condition)c); }
    проц посети(AST.DebugCondition c) { посети(cast(AST.DVCondition)c); }
    проц посети(AST.VersionCondition c) { посети(cast(AST.DVCondition)c); }

    //===============================================================================
    // Инициализатор
    проц посети(AST.ExpInitializer i) { посети(cast(AST.Инициализатор)i); }
    проц посети(AST.StructInitializer i) { посети(cast(AST.Инициализатор)i); }
    проц посети(AST.ArrayInitializer i) { посети(cast(AST.Инициализатор)i); }
    проц посети(AST.VoidInitializer i) { посети(cast(AST.Инициализатор)i); }
}
