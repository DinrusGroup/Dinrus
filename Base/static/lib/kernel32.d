
	/*******************************************************************************
	*  Файл генерирован автоматически с помощью либпроцессора Динрус               *
	*  Дата:29.1.2015                                           Время: 8 ч. 37 мин.

	*******************************************************************************/

	module lib.kernel32;
	
	import stdrus;
	import sys.WinConsts, sys.WinStructs;
	
	extern(Windows)
{

		alias цел function(ИСКЛУКАЗЫ*) ВЕКТОРНЫЙ_ОБРАБОТЧИК_ИСКЛЮЧЕНИЯ;
		alias проц function( бцел кодОш, бцел члоПеремещБайт, АСИНХРОН *асинх) ПРОЦЕДУРА_АСИНХ_ВЫПОЛНЕНИЯ_ВВ;
		alias проц function(ук, бул) ПРОЦ_ОТВЕТА_ТАЙМЕРА;
		alias проц function(ук) ПРОЦ_СТАРТА_ФИБРЫ;
		alias бцел function(ук) ПРОЦ_СТАРТА_НИТИ;
		alias бцел function(БОЛЬШЕЦЕЛ, БОЛЬШЕЦЕЛ, БОЛЬШЕЦЕЛ, БОЛЬШЕЦЕЛ, бцел, бцел, ук, ук, ук) ПРОЦ_ПРОГРЕССА;
}


	проц грузи(Биб биб)
	{

	
		//вяжи(функция_1)("__hread", биб);

		//вяжи(функция_2)("__hwrite", биб);

		//вяжи(функция_3)("__lclose", биб);

		//вяжи(функция_4)("__lcreat", биб);

		//вяжи(функция_5)("__llseek", биб);

		//вяжи(функция_6)("__lopen", биб);

		//вяжи(функция_7)("__lread", биб);

		//вяжи(функция_8)("__lwrite", биб);

		вяжи(АктивируйАктКткс)("ActivateActCtx", биб);

		вяжи(ДобавьАтомА)("AddAtomA", биб);

		вяжи(ДобавьАтом)("AddAtomW", биб);

		//вяжи(функция_12)("_AddConsoleAliasA", биб);

		//вяжи(функция_13)("_AddConsoleAliasW", биб);

		вяжи(ДобавьЛокальноеАльтернативноеИмяКомпьютераА)("AddLocalAlternateComputerNameA", биб);

		вяжи(ДобавьЛокальноеАльтернативноеИмяКомпьютера)("AddLocalAlternateComputerNameW", биб);

		вяжи(ДобавьСсылАктКткс)("AddRefActCtx", биб);

		вяжи(ДобавьВекторныйОбработчикИсключения)("AddVectoredExceptionHandler", биб);

		вяжи(РазместиФизическиеСтраницыПользователя)("AllocateUserPhysicalPages", биб);

		вяжи(РазместиКонсоль)("AllocConsole", биб);

		вяжи(ФайлВВФцииИспользуютАНЗИ)("AreFileApisANSI", биб);

		вяжи(ПрисвойПроцессДжобОбъекту)("AssignProcessToJobObject", биб);

		вяжи(ПрикрепиКонсоль)("AttachConsole", биб);

		вяжи(БэкапЧитай)("BackupRead", биб);

		вяжи(БэкапСместись)("BackupSeek", биб);

		вяжи(БэкапПиши)("BackupWrite", биб);

		//вяжи(функция_26)("_BaseCheckAppcompatCache", биб);

		//вяжи(функция_27)("_BaseCleanupAppcompatCache", биб);

		//вяжи(функция_28)("_BaseCleanupAppcompatCacheSupport", биб);

		//вяжи(функция_29)("_BaseDumpAppcompatCache", биб);

		//вяжи(функция_30)("_BaseFlushAppcompatCache", биб);

		//вяжи(функция_31)("_BaseInitAppcompatCache", биб);

		//вяжи(функция_32)("_BaseInitAppcompatCacheSupport", биб);

		//вяжи(функция_33)("_BasepCheckWinSaferRestrictions", биб);

		//вяжи(функция_34)("_BaseProcessInitPostImport", биб);

		//вяжи(функция_35)("_BaseQueryModuleData", биб);

		//вяжи(функция_36)("_BaseUpdateAppcompatCache", биб);

		вяжи(Звук)("Beep", биб);

		//вяжи(функция_38)("_BeginUpdateResourceA", биб);

		//вяжи(функция_39)("_BeginUpdateResourceW", биб);

		//вяжи(функция_40)("_BindIoCompletionCallback", биб);

		//вяжи(функция_41)("_BuildCommDCBA", биб);

		//вяжи(функция_42)("_BuildCommDCBAndTimeoutsA", биб);

		//вяжи(функция_43)("_BuildCommDCBAndTimeoutsW", биб);

		//вяжи(функция_44)("_BuildCommDCBW", биб);

		//вяжи(функция_45)("_CallNamedPipeA", биб);

		//вяжи(функция_46)("_CallNamedPipeW", биб);

		//вяжи(функция_47)("_CancelDeviceWakeupRequest", биб);

		//вяжи(функция_48)("_CancelIo", биб);

		//вяжи(функция_49)("_CancelTimerQueueTimer", биб);

		//вяжи(функция_50)("_CancelWaitableTimer", биб);

		//вяжи(функция_51)("_ChangeTimerQueueTimer", биб);

		//вяжи(функция_52)("_CheckNameLegalDOS8Dot3A", биб);

		//вяжи(функция_53)("_CheckNameLegalDOS8Dot3W", биб);

		//вяжи(функция_54)("_CheckRemoteDebuggerPresent", биб);

		//вяжи(функция_55)("_ClearCommBreak", биб);

		//вяжи(функция_56)("_ClearCommError", биб);

		//вяжи(функция_57)("_CloseConsoleHandle", биб);

		//вяжи(функция_58)("_CloseHandle", биб);

		//вяжи(функция_59)("_CloseProfileUserMapping", биб);

		//вяжи(функция_60)("_CmdBatNotification", биб);

		//вяжи(функция_61)("_CommConfigDialogA", биб);

		//вяжи(функция_62)("_CommConfigDialogW", биб);

		//вяжи(функция_63)("_CompareFileTime", биб);

		//вяжи(функция_64)("_CompareStringA", биб);

		//вяжи(функция_65)("_CompareStringW", биб);

		//вяжи(функция_66)("_ConnectNamedPipe", биб);

		//вяжи(функция_67)("_ConsoleMenuControl", биб);

		//вяжи(функция_68)("_ContinueDebugEvent", биб);

		//вяжи(функция_69)("_ConvertDefaultLocale", биб);

		//вяжи(функция_70)("_ConvertFiberToThread", биб);

		//вяжи(функция_71)("_ConvertThreadToFiber", биб);

		//вяжи(функция_72)("_CopyFileA", биб);

		//вяжи(функция_73)("_CopyFileExA", биб);

		//вяжи(функция_74)("_CopyFileExW", биб);

		//вяжи(функция_75)("_CopyFileW", биб);

		//вяжи(функция_76)("_CopyLZFile", биб);

		//вяжи(функция_77)("_CreateActCtxA", биб);

		//вяжи(функция_78)("_CreateActCtxW", биб);

		//вяжи(функция_79)("_CreateConsoleScreenBuffer", биб);

		//вяжи(функция_80)("_CreateDirectoryA", биб);

		//вяжи(функция_81)("_CreateDirectoryExA", биб);

		//вяжи(функция_82)("_CreateDirectoryExW", биб);

		//вяжи(функция_83)("_CreateDirectoryW", биб);

		//вяжи(функция_84)("_CreateEventA", биб);

		//вяжи(функция_85)("_CreateEventW", биб);

		//вяжи(функция_86)("_CreateFiber", биб);

		//вяжи(функция_87)("_CreateFiberEx", биб);

		//вяжи(функция_88)("_CreateFileA", биб);

		//вяжи(функция_89)("_CreateFileMappingA", биб);

		//вяжи(функция_90)("_CreateFileMappingW", биб);

		//вяжи(функция_91)("_CreateFileW", биб);

		//вяжи(функция_92)("_CreateHardLinkA", биб);

		//вяжи(функция_93)("_CreateHardLinkW", биб);

		//вяжи(функция_94)("_CreateIoCompletionPort", биб);

		//вяжи(функция_95)("_CreateJobObjectA", биб);

		//вяжи(функция_96)("_CreateJobObjectW", биб);

		//вяжи(функция_97)("_CreateJobSet", биб);

		//вяжи(функция_98)("_CreateMailslotA", биб);

		//вяжи(функция_99)("_CreateMailslotW", биб);

		//вяжи(функция_100)("_CreateMemoryResourceNotification", биб);

		//вяжи(функция_101)("_CreateMutexA", биб);

		//вяжи(функция_102)("_CreateMutexW", биб);

		//вяжи(функция_103)("_CreateNamedPipeA", биб);

		//вяжи(функция_104)("_CreateNamedPipeW", биб);

		//вяжи(функция_105)("_CreateNlsSecurityDescriptor", биб);

		//вяжи(функция_106)("_CreatePipe", биб);

		//вяжи(функция_107)("_CreateProcessA", биб);

		//вяжи(функция_108)("_CreateProcessInternalA", биб);

		//вяжи(функция_109)("_CreateProcessInternalW", биб);

		//вяжи(функция_110)("_CreateProcessInternalWSecure", биб);

		//вяжи(функция_111)("_CreateProcessW", биб);

		//вяжи(функция_112)("_CreateRemoteThread", биб);

		//вяжи(функция_113)("_CreateSemaphoreA", биб);

		//вяжи(функция_114)("_CreateSemaphoreW", биб);

		//вяжи(функция_115)("_CreateSocketHandle", биб);

		//вяжи(функция_116)("_CreateTapePartition", биб);

		//вяжи(функция_117)("_CreateThread", биб);

		//вяжи(функция_118)("_CreateTimerQueue", биб);

		//вяжи(функция_119)("_CreateTimerQueueTimer", биб);

		//вяжи(функция_120)("_CreateToolhelp32Snapshot", биб);

		//вяжи(функция_121)("_CreateVirtualBuffer", биб);

		//вяжи(функция_122)("_CreateWaitableTimerA", биб);

		//вяжи(функция_123)("_CreateWaitableTimerW", биб);

		//вяжи(функция_124)("_DeactivateActCtx", биб);

		//вяжи(функция_125)("_DebugActiveProcess", биб);

		//вяжи(функция_126)("_DebugActiveProcessStop", биб);

		//вяжи(функция_127)("_DebugBreak", биб);

		//вяжи(функция_128)("_DebugBreakProcess", биб);

		//вяжи(функция_129)("_DebugSetProcessKillOnExit", биб);

		//вяжи(функция_130)("_DecodePointer", биб);

		//вяжи(функция_131)("_DecodeSystemPointer", биб);

		//вяжи(функция_132)("_DefineDosDeviceA", биб);

		//вяжи(функция_133)("_DefineDosDeviceW", биб);

		//вяжи(функция_134)("_DelayLoadFailureHook", биб);

		//вяжи(функция_135)("_DeleteAtom", биб);

		//вяжи(функция_136)("_DeleteCriticalSection", биб);

		//вяжи(функция_137)("_DeleteFiber", биб);

		//вяжи(функция_138)("_DeleteFileA", биб);

		//вяжи(функция_139)("_DeleteFileW", биб);

		//вяжи(функция_140)("_DeleteTimerQueue", биб);

		//вяжи(функция_141)("_DeleteTimerQueueEx", биб);

		//вяжи(функция_142)("_DeleteTimerQueueTimer", биб);

		//вяжи(функция_143)("_DeleteVolumeMountPointA", биб);

		//вяжи(функция_144)("_DeleteVolumeMountPointW", биб);

		//вяжи(функция_145)("_DeviceIoControl", биб);

		//вяжи(функция_146)("_DisableThreadLibraryCalls", биб);

		//вяжи(функция_147)("_DisconnectNamedPipe", биб);

		//вяжи(функция_148)("_DnsHostnameToComputerNameA", биб);

		//вяжи(функция_149)("_DnsHostnameToComputerNameW", биб);

		//вяжи(функция_150)("_DosDateTimeToFileTime", биб);

		//вяжи(функция_151)("_DosPathToSessionPathA", биб);

		//вяжи(функция_152)("_DosPathToSessionPathW", биб);

		//вяжи(функция_153)("_DuplicateConsoleHandle", биб);

		//вяжи(функция_154)("_DuplicateHandle", биб);

		//вяжи(функция_155)("_EncodePointer", биб);

		//вяжи(функция_156)("_EncodeSystemPointer", биб);

		//вяжи(функция_157)("_EndUpdateResourceA", биб);

		//вяжи(функция_158)("_EndUpdateResourceW", биб);

		//вяжи(функция_159)("_EnterCriticalSection", биб);

		//вяжи(функция_160)("_EnumCalendarInfoA", биб);

		//вяжи(функция_161)("_EnumCalendarInfoExA", биб);

		//вяжи(функция_162)("_EnumCalendarInfoExW", биб);

		//вяжи(функция_163)("_EnumCalendarInfoW", биб);

		//вяжи(функция_164)("_EnumDateFormatsA", биб);

		//вяжи(функция_165)("_EnumDateFormatsExA", биб);

		//вяжи(функция_166)("_EnumDateFormatsExW", биб);

		//вяжи(функция_167)("_EnumDateFormatsW", биб);

		//вяжи(функция_168)("_EnumerateLocalComputerNamesA", биб);

		//вяжи(функция_169)("_EnumerateLocalComputerNamesW", биб);

		//вяжи(функция_170)("_EnumLanguageGroupLocalesA", биб);

		//вяжи(функция_171)("_EnumLanguageGroupLocalesW", биб);

		//вяжи(функция_172)("_EnumResourceLanguagesA", биб);

		//вяжи(функция_173)("_EnumResourceLanguagesW", биб);

		//вяжи(функция_174)("_EnumResourceNamesA", биб);

		//вяжи(функция_175)("_EnumResourceNamesW", биб);

		//вяжи(функция_176)("_EnumResourceTypesA", биб);

		//вяжи(функция_177)("_EnumResourceTypesW", биб);

		//вяжи(функция_178)("_EnumSystemCodePagesA", биб);

		//вяжи(функция_179)("_EnumSystemCodePagesW", биб);

		//вяжи(функция_180)("_EnumSystemGeoID", биб);

		//вяжи(функция_181)("_EnumSystemLanguageGroupsA", биб);

		//вяжи(функция_182)("_EnumSystemLanguageGroupsW", биб);

		//вяжи(функция_183)("_EnumSystemLocalesA", биб);

		//вяжи(функция_184)("_EnumSystemLocalesW", биб);

		//вяжи(функция_185)("_EnumTimeFormatsA", биб);

		//вяжи(функция_186)("_EnumTimeFormatsW", биб);

		//вяжи(функция_187)("_EnumUILanguagesA", биб);

		//вяжи(функция_188)("_EnumUILanguagesW", биб);

		//вяжи(функция_189)("_EraseTape", биб);

		//вяжи(функция_190)("_EscapeCommFunction", биб);

		//вяжи(функция_191)("_ExitProcess", биб);

		//вяжи(функция_192)("_ExitThread", биб);

		//вяжи(функция_193)("_ExitVDM", биб);

		//вяжи(функция_194)("_ExpandEnvironmentStringsA", биб);

		//вяжи(функция_195)("_ExpandEnvironmentStringsW", биб);

		//вяжи(функция_196)("_ExpungeConsoleCommandHistoryA", биб);

		//вяжи(функция_197)("_ExpungeConsoleCommandHistoryW", биб);

		//вяжи(функция_198)("_ExtendVirtualBuffer", биб);

		//вяжи(функция_199)("_FatalAppExitA", биб);

		//вяжи(функция_200)("_FatalAppExitW", биб);

		//вяжи(функция_201)("_FatalExit", биб);

		//вяжи(функция_202)("_FileTimeToDosDateTime", биб);

		//вяжи(функция_203)("_FileTimeToLocalFileTime", биб);

		//вяжи(функция_204)("_FileTimeToSystemTime", биб);

		//вяжи(функция_205)("_FillConsoleOutputAttribute", биб);

		//вяжи(функция_206)("_FillConsoleOutputCharacterA", биб);

		//вяжи(функция_207)("_FillConsoleOutputCharacterW", биб);

		//вяжи(функция_208)("_FindActCtxSectionGuid", биб);

		//вяжи(функция_209)("_FindActCtxSectionStringA", биб);

		//вяжи(функция_210)("_FindActCtxSectionStringW", биб);

		//вяжи(функция_211)("_FindAtomA", биб);

		//вяжи(функция_212)("_FindAtomW", биб);

		//вяжи(функция_213)("_FindClose", биб);

		//вяжи(функция_214)("_FindCloseChangeNotification", биб);

		//вяжи(функция_215)("_FindFirstChangeNotificationA", биб);

		//вяжи(функция_216)("_FindFirstChangeNotificationW", биб);

		//вяжи(функция_217)("_FindFirstFileA", биб);

		//вяжи(функция_218)("_FindFirstFileExA", биб);

		//вяжи(функция_219)("_FindFirstFileExW", биб);

		//вяжи(функция_220)("_FindFirstFileW", биб);

		//вяжи(функция_221)("_FindFirstVolumeA", биб);

		//вяжи(функция_222)("_FindFirstVolumeMountPointA", биб);

		//вяжи(функция_223)("_FindFirstVolumeMountPointW", биб);

		//вяжи(функция_224)("_FindFirstVolumeW", биб);

		//вяжи(функция_225)("_FindNextChangeNotification", биб);

		//вяжи(функция_226)("_FindNextFileA", биб);

		//вяжи(функция_227)("_FindNextFileW", биб);

		//вяжи(функция_228)("_FindNextVolumeA", биб);

		//вяжи(функция_229)("_FindNextVolumeMountPointA", биб);

		//вяжи(функция_230)("_FindNextVolumeMountPointW", биб);

		//вяжи(функция_231)("_FindNextVolumeW", биб);

		//вяжи(функция_232)("_FindResourceA", биб);

		//вяжи(функция_233)("_FindResourceExA", биб);

		//вяжи(функция_234)("_FindResourceExW", биб);

		//вяжи(функция_235)("_FindResourceW", биб);

		//вяжи(функция_236)("_FindVolumeClose", биб);

		//вяжи(функция_237)("_FindVolumeMountPointClose", биб);

		//вяжи(функция_238)("_FlushConsoleInputBuffer", биб);

		//вяжи(функция_239)("_FlushFileBuffers", биб);

		//вяжи(функция_240)("_FlushInstructionCache", биб);

		//вяжи(функция_241)("_FlushViewOfFile", биб);

		//вяжи(функция_242)("_FoldStringA", биб);

		//вяжи(функция_243)("_FoldStringW", биб);

		//вяжи(функция_244)("_FormatMessageA", биб);

		//вяжи(функция_245)("_FormatMessageW", биб);

		//вяжи(функция_246)("_FreeConsole", биб);

		//вяжи(функция_247)("_FreeEnvironmentStringsA", биб);

		//вяжи(функция_248)("_FreeEnvironmentStringsW", биб);

		//вяжи(функция_249)("_FreeLibrary", биб);

		//вяжи(функция_250)("_FreeLibraryAndExitThread", биб);

		//вяжи(функция_251)("_FreeResource", биб);

		//вяжи(функция_252)("_FreeUserPhysicalPages", биб);

		//вяжи(функция_253)("_FreeVirtualBuffer", биб);

		//вяжи(функция_254)("_GenerateConsoleCtrlEvent", биб);

		//вяжи(функция_255)("_GetACP", биб);

		//вяжи(функция_256)("_GetAtomNameA", биб);

		//вяжи(функция_257)("_GetAtomNameW", биб);

		//вяжи(функция_258)("_GetBinaryType", биб);

		//вяжи(функция_259)("_GetBinaryTypeA", биб);

		//вяжи(функция_260)("_GetBinaryTypeW", биб);

		//вяжи(функция_261)("_GetCalendarInfoA", биб);

		//вяжи(функция_262)("_GetCalendarInfoW", биб);

		//вяжи(функция_263)("_GetCommandLineA", биб);

		//вяжи(функция_264)("_GetCommandLineW", биб);

		//вяжи(функция_265)("_GetCommConfig", биб);

		//вяжи(функция_266)("_GetCommMask", биб);

		//вяжи(функция_267)("_GetCommModemStatus", биб);

		//вяжи(функция_268)("_GetCommProperties", биб);

		//вяжи(функция_269)("_GetCommState", биб);

		//вяжи(функция_270)("_GetCommTimeouts", биб);

		//вяжи(функция_271)("_GetComPlusPackageInstallStatus", биб);

		//вяжи(функция_272)("_GetCompressedFileSizeA", биб);

		//вяжи(функция_273)("_GetCompressedFileSizeW", биб);

		//вяжи(функция_274)("_GetComputerNameA", биб);

		//вяжи(функция_275)("_GetComputerNameExA", биб);

		//вяжи(функция_276)("_GetComputerNameExW", биб);

		//вяжи(функция_277)("_GetComputerNameW", биб);

		//вяжи(функция_278)("_GetConsoleAliasA", биб);

		//вяжи(функция_279)("_GetConsoleAliasesA", биб);

		//вяжи(функция_280)("_GetConsoleAliasesLengthA", биб);

		//вяжи(функция_281)("_GetConsoleAliasesLengthW", биб);

		//вяжи(функция_282)("_GetConsoleAliasesW", биб);

		//вяжи(функция_283)("_GetConsoleAliasExesA", биб);

		//вяжи(функция_284)("_GetConsoleAliasExesLengthA", биб);

		//вяжи(функция_285)("_GetConsoleAliasExesLengthW", биб);

		//вяжи(функция_286)("_GetConsoleAliasExesW", биб);

		//вяжи(функция_287)("_GetConsoleAliasW", биб);

		//вяжи(функция_288)("_GetConsoleCharType", биб);

		//вяжи(функция_289)("_GetConsoleCommandHistoryA", биб);

		//вяжи(функция_290)("_GetConsoleCommandHistoryLengthA", биб);

		//вяжи(функция_291)("_GetConsoleCommandHistoryLengthW", биб);

		//вяжи(функция_292)("_GetConsoleCommandHistoryW", биб);

		//вяжи(функция_293)("_GetConsoleCP", биб);

		//вяжи(функция_294)("_GetConsoleCursorInfo", биб);

		//вяжи(функция_295)("_GetConsoleCursorMode", биб);

		//вяжи(функция_296)("_GetConsoleDisplayMode", биб);

		//вяжи(функция_297)("_GetConsoleFontInfo", биб);

		//вяжи(функция_298)("_GetConsoleFontSize", биб);

		//вяжи(функция_299)("_GetConsoleHardwareState", биб);

		//вяжи(функция_300)("_GetConsoleInputExeNameA", биб);

		//вяжи(функция_301)("_GetConsoleInputExeNameW", биб);

		//вяжи(функция_302)("_GetConsoleInputWaitHandle", биб);

		//вяжи(функция_303)("_GetConsoleKeyboardLayoutNameA", биб);

		//вяжи(функция_304)("_GetConsoleKeyboardLayoutNameW", биб);

		//вяжи(функция_305)("_GetConsoleMode", биб);

		//вяжи(функция_306)("_GetConsoleNlsMode", биб);

		//вяжи(функция_307)("_GetConsoleOutputCP", биб);

		//вяжи(функция_308)("_GetConsoleProcessList", биб);

		//вяжи(функция_309)("_GetConsoleScreenBufferInfo", биб);

		//вяжи(функция_310)("_GetConsoleSelectionInfo", биб);

		//вяжи(функция_311)("_GetConsoleTitleA", биб);

		//вяжи(функция_312)("_GetConsoleTitleW", биб);

		//вяжи(функция_313)("_GetConsoleWindow", биб);

		//вяжи(функция_314)("_GetCPFileNameFromRegistry", биб);

		//вяжи(функция_315)("_GetCPInfo", биб);

		//вяжи(функция_316)("_GetCPInfoExA", биб);

		//вяжи(функция_317)("_GetCPInfoExW", биб);

		//вяжи(функция_318)("_GetCurrencyFormatA", биб);

		//вяжи(функция_319)("_GetCurrencyFormatW", биб);

		//вяжи(функция_320)("_GetCurrentActCtx", биб);

		//вяжи(функция_321)("_GetCurrentConsoleFont", биб);

		//вяжи(функция_322)("_GetCurrentDirectoryA", биб);

		//вяжи(функция_323)("_GetCurrentDirectoryW", биб);

		//вяжи(функция_324)("_GetCurrentProcess", биб);

		//вяжи(функция_325)("_GetCurrentProcessId", биб);

		//вяжи(функция_326)("_GetCurrentThread", биб);

		//вяжи(функция_327)("_GetCurrentThreadId", биб);

		//вяжи(функция_328)("_GetDateFormatA", биб);

		//вяжи(функция_329)("_GetDateFormatW", биб);

		//вяжи(функция_330)("_GetDefaultCommConfigA", биб);

		//вяжи(функция_331)("_GetDefaultCommConfigW", биб);

		//вяжи(функция_332)("_GetDefaultSortkeySize", биб);

		//вяжи(функция_333)("_GetDevicePowerState", биб);

		//вяжи(функция_334)("_GetDiskFreeSpaceA", биб);

		//вяжи(функция_335)("_GetDiskFreeSpaceExA", биб);

		//вяжи(функция_336)("_GetDiskFreeSpaceExW", биб);

		//вяжи(функция_337)("_GetDiskFreeSpaceW", биб);

		//вяжи(функция_338)("_GetDllDirectoryA", биб);

		//вяжи(функция_339)("_GetDllDirectoryW", биб);

		//вяжи(функция_340)("_GetDriveTypeA", биб);

		//вяжи(функция_341)("_GetDriveTypeW", биб);

		//вяжи(функция_342)("_GetEnvironmentStrings", биб);

		//вяжи(функция_343)("_GetEnvironmentStringsA", биб);

		//вяжи(функция_344)("_GetEnvironmentStringsW", биб);

		//вяжи(функция_345)("_GetEnvironmentVariableA", биб);

		//вяжи(функция_346)("_GetEnvironmentVariableW", биб);

		//вяжи(функция_347)("_GetExitCodeProcess", биб);

		//вяжи(функция_348)("_GetExitCodeThread", биб);

		//вяжи(функция_349)("_GetExpandedNameA", биб);

		//вяжи(функция_350)("_GetExpandedNameW", биб);

		//вяжи(функция_351)("_GetFileAttributesA", биб);

		//вяжи(функция_352)("_GetFileAttributesExA", биб);

		//вяжи(функция_353)("_GetFileAttributesExW", биб);

		//вяжи(функция_354)("_GetFileAttributesW", биб);

		//вяжи(функция_355)("_GetFileInformationByHandle", биб);

		//вяжи(функция_356)("_GetFileSize", биб);

		//вяжи(функция_357)("_GetFileSizeEx", биб);

		//вяжи(функция_358)("_GetFileTime", биб);

		//вяжи(функция_359)("_GetFileType", биб);

		//вяжи(функция_360)("_GetFirmwareEnvironmentVariableA", биб);

		//вяжи(функция_361)("_GetFirmwareEnvironmentVariableW", биб);

		//вяжи(функция_362)("_GetFullPathNameA", биб);

		//вяжи(функция_363)("_GetFullPathNameW", биб);

		//вяжи(функция_364)("_GetGeoInfoA", биб);

		//вяжи(функция_365)("_GetGeoInfoW", биб);

		//вяжи(функция_366)("_GetHandleContext", биб);

		//вяжи(функция_367)("_GetHandleInformation", биб);

		//вяжи(функция_368)("_GetLargestConsoleWindowSize", биб);

		//вяжи(функция_369)("_GetLastError", биб);

		//вяжи(функция_370)("_GetLinguistLangSize", биб);

		//вяжи(функция_371)("_GetLocaleInfoA", биб);

		//вяжи(функция_372)("_GetLocaleInfoW", биб);

		//вяжи(функция_373)("_GetLocalTime", биб);

		//вяжи(функция_374)("_GetLogicalDrives", биб);

		//вяжи(функция_375)("_GetLogicalDriveStringsA", биб);

		//вяжи(функция_376)("_GetLogicalDriveStringsW", биб);

		//вяжи(функция_377)("_GetLogicalProcessorInformation", биб);

		//вяжи(функция_378)("_GetLongPathNameA", биб);

		//вяжи(функция_379)("_GetLongPathNameW", биб);

		//вяжи(функция_380)("_GetMailslotInfo", биб);

		//вяжи(функция_381)("_GetModuleFileNameA", биб);

		//вяжи(функция_382)("_GetModuleFileNameW", биб);

		//вяжи(функция_383)("_GetModuleHandleA", биб);

		//вяжи(функция_384)("_GetModuleHandleExA", биб);

		//вяжи(функция_385)("_GetModuleHandleExW", биб);

		//вяжи(функция_386)("_GetModuleHandleW", биб);

		//вяжи(функция_387)("_GetNamedPipeHandleStateA", биб);

		//вяжи(функция_388)("_GetNamedPipeHandleStateW", биб);

		//вяжи(функция_389)("_GetNamedPipeInfo", биб);

		//вяжи(функция_390)("_GetNativeSystemInfo", биб);

		//вяжи(функция_391)("_GetNextVDMCommand", биб);

		//вяжи(функция_392)("_GetNlsSectionName", биб);

		//вяжи(функция_393)("_GetNumaAvailableMemory", биб);

		//вяжи(функция_394)("_GetNumaAvailableMemoryNode", биб);

		//вяжи(функция_395)("_GetNumaHighestNodeNumber", биб);

		//вяжи(функция_396)("_GetNumaNodeProcessorMask", биб);

		//вяжи(функция_397)("_GetNumaProcessorMap", биб);

		//вяжи(функция_398)("_GetNumaProcessorNode", биб);

		//вяжи(функция_399)("_GetNumberFormatA", биб);

		//вяжи(функция_400)("_GetNumberFormatW", биб);

		//вяжи(функция_401)("_GetNumberOfConsoleFonts", биб);

		//вяжи(функция_402)("_GetNumberOfConsoleInputEvents", биб);

		//вяжи(функция_403)("_GetNumberOfConsoleMouseButtons", биб);

		//вяжи(функция_404)("_GetOEMCP", биб);

		//вяжи(функция_405)("_GetOverlappedResult", биб);

		//вяжи(функция_406)("_GetPriorityClass", биб);

		//вяжи(функция_407)("_GetPrivateProfileIntA", биб);

		//вяжи(функция_408)("_GetPrivateProfileIntW", биб);

		//вяжи(функция_409)("_GetPrivateProfileSectionA", биб);

		//вяжи(функция_410)("_GetPrivateProfileSectionNamesA", биб);

		//вяжи(функция_411)("_GetPrivateProfileSectionNamesW", биб);

		//вяжи(функция_412)("_GetPrivateProfileSectionW", биб);

		//вяжи(функция_413)("_GetPrivateProfileStringA", биб);

		//вяжи(функция_414)("_GetPrivateProfileStringW", биб);

		//вяжи(функция_415)("_GetPrivateProfileStructA", биб);

		//вяжи(функция_416)("_GetPrivateProfileStructW", биб);

		//вяжи(функция_417)("_GetProcAddress", биб);

		//вяжи(функция_418)("_GetProcessAffinityMask", биб);

		//вяжи(функция_419)("_GetProcessDEPPolicy", биб);

		//вяжи(функция_420)("_GetProcessHandleCount", биб);

		//вяжи(функция_421)("_GetProcessHeap", биб);

		//вяжи(функция_422)("_GetProcessHeaps", биб);

		//вяжи(функция_423)("_GetProcessId", биб);

		//вяжи(функция_424)("_GetProcessIoCounters", биб);

		//вяжи(функция_425)("_GetProcessPriorityBoost", биб);

		//вяжи(функция_426)("_GetProcessShutdownParameters", биб);

		//вяжи(функция_427)("_GetProcessTimes", биб);

		//вяжи(функция_428)("_GetProcessVersion", биб);

		//вяжи(функция_429)("_GetProcessWorkingSetSize", биб);

		//вяжи(функция_430)("_GetProfileIntA", биб);

		//вяжи(функция_431)("_GetProfileIntW", биб);

		//вяжи(функция_432)("_GetProfileSectionA", биб);

		//вяжи(функция_433)("_GetProfileSectionW", биб);

		//вяжи(функция_434)("_GetProfileStringA", биб);

		//вяжи(функция_435)("_GetProfileStringW", биб);

		//вяжи(функция_436)("_GetQueuedCompletionStatus", биб);

		//вяжи(функция_437)("_GetShortPathNameA", биб);

		//вяжи(функция_438)("_GetShortPathNameW", биб);

		//вяжи(функция_439)("_GetStartupInfoA", биб);

		//вяжи(функция_440)("_GetStartupInfoW", биб);

		//вяжи(функция_441)("_GetStdHandle", биб);

		//вяжи(функция_442)("_GetStringTypeA", биб);

		//вяжи(функция_443)("_GetStringTypeExA", биб);

		//вяжи(функция_444)("_GetStringTypeExW", биб);

		//вяжи(функция_445)("_GetStringTypeW", биб);

		//вяжи(функция_446)("_GetSystemDefaultLangID", биб);

		//вяжи(функция_447)("_GetSystemDefaultLCID", биб);

		//вяжи(функция_448)("_GetSystemDefaultUILanguage", биб);

		//вяжи(функция_449)("_GetSystemDEPPolicy", биб);

		//вяжи(функция_450)("_GetSystemDirectoryA", биб);

		//вяжи(функция_451)("_GetSystemDirectoryW", биб);

		//вяжи(функция_452)("_GetSystemInfo", биб);

		//вяжи(функция_453)("_GetSystemPowerStatus", биб);

		//вяжи(функция_454)("_GetSystemRegistryQuota", биб);

		//вяжи(функция_455)("_GetSystemTime", биб);

		//вяжи(функция_456)("_GetSystemTimeAdjustment", биб);

		//вяжи(функция_457)("_GetSystemTimeAsFileTime", биб);

		//вяжи(функция_458)("_GetSystemTimes", биб);

		//вяжи(функция_459)("_GetSystemWindowsDirectoryA", биб);

		//вяжи(функция_460)("_GetSystemWindowsDirectoryW", биб);

		//вяжи(функция_461)("_GetSystemWow64DirectoryA", биб);

		//вяжи(функция_462)("_GetSystemWow64DirectoryW", биб);

		//вяжи(функция_463)("_GetTapeParameters", биб);

		//вяжи(функция_464)("_GetTapePosition", биб);

		//вяжи(функция_465)("_GetTapeStatus", биб);

		//вяжи(функция_466)("_GetTempFileNameA", биб);

		//вяжи(функция_467)("_GetTempFileNameW", биб);

		//вяжи(функция_468)("_GetTempPathA", биб);

		//вяжи(функция_469)("_GetTempPathW", биб);

		//вяжи(функция_470)("_GetThreadContext", биб);

		//вяжи(функция_471)("_GetThreadIOPendingFlag", биб);

		//вяжи(функция_472)("_GetThreadLocale", биб);

		//вяжи(функция_473)("_GetThreadPriority", биб);

		//вяжи(функция_474)("_GetThreadPriorityBoost", биб);

		//вяжи(функция_475)("_GetThreadSelectorEntry", биб);

		//вяжи(функция_476)("_GetThreadTimes", биб);

		//вяжи(функция_477)("_GetTickCount", биб);

		//вяжи(функция_478)("_GetTimeFormatA", биб);

		//вяжи(функция_479)("_GetTimeFormatW", биб);

		//вяжи(функция_480)("_GetTimeZoneInformation", биб);

		//вяжи(функция_481)("_GetUserDefaultLangID", биб);

		//вяжи(функция_482)("_GetUserDefaultLCID", биб);

		//вяжи(функция_483)("_GetUserDefaultUILanguage", биб);

		//вяжи(функция_484)("_GetUserGeoID", биб);

		//вяжи(функция_485)("_GetVDMCurrentDirectories", биб);

		//вяжи(функция_486)("_GetVersion", биб);

		//вяжи(функция_487)("_GetVersionExA", биб);

		//вяжи(функция_488)("_GetVersionExW", биб);

		//вяжи(функция_489)("_GetVolumeInformationA", биб);

		//вяжи(функция_490)("_GetVolumeInformationW", биб);

		//вяжи(функция_491)("_GetVolumeNameForVolumeMountPointA", биб);

		//вяжи(функция_492)("_GetVolumeNameForVolumeMountPointW", биб);

		//вяжи(функция_493)("_GetVolumePathNameA", биб);

		//вяжи(функция_494)("_GetVolumePathNamesForVolumeNameA", биб);

		//вяжи(функция_495)("_GetVolumePathNamesForVolumeNameW", биб);

		//вяжи(функция_496)("_GetVolumePathNameW", биб);

		//вяжи(функция_497)("_GetWindowsDirectoryA", биб);

		//вяжи(функция_498)("_GetWindowsDirectoryW", биб);

		//вяжи(функция_499)("_GetWriteWatch", биб);

		//вяжи(функция_500)("_GlobalAddAtomA", биб);

		//вяжи(функция_501)("_GlobalAddAtomW", биб);

		//вяжи(функция_502)("_GlobalAlloc", биб);

		//вяжи(функция_503)("_GlobalCompact", биб);

		//вяжи(функция_504)("_GlobalDeleteAtom", биб);

		//вяжи(функция_505)("_GlobalFindAtomA", биб);

		//вяжи(функция_506)("_GlobalFindAtomW", биб);

		//вяжи(функция_507)("_GlobalFix", биб);

		//вяжи(функция_508)("_GlobalFlags", биб);

		//вяжи(функция_509)("_GlobalFree", биб);

		//вяжи(функция_510)("_GlobalGetAtomNameA", биб);

		//вяжи(функция_511)("_GlobalGetAtomNameW", биб);

		//вяжи(функция_512)("_GlobalHandle", биб);

		//вяжи(функция_513)("_GlobalLock", биб);

		//вяжи(функция_514)("_GlobalMemoryStatus", биб);

		//вяжи(функция_515)("_GlobalMemoryStatusEx", биб);

		//вяжи(функция_516)("_GlobalReAlloc", биб);

		//вяжи(функция_517)("_GlobalSize", биб);

		//вяжи(функция_518)("_GlobalUnfix", биб);

		//вяжи(функция_519)("_GlobalUnlock", биб);

		//вяжи(функция_520)("_GlobalUnWire", биб);

		//вяжи(функция_521)("_GlobalWire", биб);

		//вяжи(функция_522)("_Heap32First", биб);

		//вяжи(функция_523)("_Heap32ListFirst", биб);

		//вяжи(функция_524)("_Heap32ListNext", биб);

		//вяжи(функция_525)("_Heap32Next", биб);

		//вяжи(функция_526)("_HeapAlloc", биб);

		//вяжи(функция_527)("_HeapCompact", биб);

		//вяжи(функция_528)("_HeapCreate", биб);

		//вяжи(функция_529)("_HeapCreateTagsW", биб);

		//вяжи(функция_530)("_HeapDestroy", биб);

		//вяжи(функция_531)("_HeapExtend", биб);

		//вяжи(функция_532)("_HeapFree", биб);

		//вяжи(функция_533)("_HeapLock", биб);

		//вяжи(функция_534)("_HeapQueryInformation", биб);

		//вяжи(функция_535)("_HeapQueryTagW", биб);

		//вяжи(функция_536)("_HeapReAlloc", биб);

		//вяжи(функция_537)("_HeapSetInformation", биб);

		//вяжи(функция_538)("_HeapSize", биб);

		//вяжи(функция_539)("_HeapSummary", биб);

		//вяжи(функция_540)("_HeapUnlock", биб);

		//вяжи(функция_541)("_HeapUsage", биб);

		//вяжи(функция_542)("_HeapValidate", биб);

		//вяжи(функция_543)("_HeapWalk", биб);

		//вяжи(функция_544)("_InitAtomTable", биб);

		//вяжи(функция_545)("_InitializeCriticalSection", биб);

		//вяжи(функция_546)("_InitializeCriticalSectionAndSpinCount", биб);

		//вяжи(функция_547)("_InitializeSListHead", биб);

		//вяжи(функция_548)("_InterlockedCompareExchange", биб);

		//вяжи(функция_549)("_InterlockedDecrement", биб);

		//вяжи(функция_550)("_InterlockedExchange", биб);

		//вяжи(функция_551)("_InterlockedExchangeAdd", биб);

		//вяжи(функция_552)("_InterlockedFlushSList", биб);

		//вяжи(функция_553)("_InterlockedIncrement", биб);

		//вяжи(функция_554)("_InterlockedPopEntrySList", биб);

		//вяжи(функция_555)("_InterlockedPushEntrySList", биб);

		//вяжи(функция_556)("_InvalidateConsoleDIBits", биб);

		//вяжи(функция_557)("_IsBadCodePtr", биб);

		//вяжи(функция_558)("_IsBadHugeReadPtr", биб);

		//вяжи(функция_559)("_IsBadHugeWritePtr", биб);

		//вяжи(функция_560)("_IsBadReadPtr", биб);

		//вяжи(функция_561)("_IsBadStringPtrA", биб);

		//вяжи(функция_562)("_IsBadStringPtrW", биб);

		//вяжи(функция_563)("_IsBadWritePtr", биб);

		//вяжи(функция_564)("_IsDBCSLeadByte", биб);

		//вяжи(функция_565)("_IsDBCSLeadByteEx", биб);

		//вяжи(функция_566)("_IsDebuggerPresent", биб);

		//вяжи(функция_567)("_IsProcessInJob", биб);

		//вяжи(функция_568)("_IsProcessorFeaturePresent", биб);

		//вяжи(функция_569)("_IsSystemResumeAutomatic", биб);

		//вяжи(функция_570)("_IsValidCodePage", биб);

		//вяжи(функция_571)("_IsValidLanguageGroup", биб);

		//вяжи(функция_572)("_IsValidLocale", биб);

		//вяжи(функция_573)("_IsValidUILanguage", биб);

		//вяжи(функция_574)("_IsWow64Process", биб);

		//вяжи(функция_575)("_LCMapStringA", биб);

		//вяжи(функция_576)("_LCMapStringW", биб);

		//вяжи(функция_577)("_LeaveCriticalSection", биб);

		//вяжи(функция_578)("_LoadLibraryA", биб);

		//вяжи(функция_579)("_LoadLibraryExA", биб);

		//вяжи(функция_580)("_LoadLibraryExW", биб);

		//вяжи(функция_581)("_LoadLibraryW", биб);

		//вяжи(функция_582)("_LoadModule", биб);

		//вяжи(функция_583)("_LoadResource", биб);

		//вяжи(функция_584)("_LocalAlloc", биб);

		//вяжи(функция_585)("_LocalCompact", биб);

		//вяжи(функция_586)("_LocalFileTimeToFileTime", биб);

		//вяжи(функция_587)("_LocalFlags", биб);

		//вяжи(функция_588)("_LocalFree", биб);

		//вяжи(функция_589)("_LocalHandle", биб);

		//вяжи(функция_590)("_LocalLock", биб);

		//вяжи(функция_591)("_LocalReAlloc", биб);

		//вяжи(функция_592)("_LocalShrink", биб);

		//вяжи(функция_593)("_LocalSize", биб);

		//вяжи(функция_594)("_LocalUnlock", биб);

		//вяжи(функция_595)("_LockFile", биб);

		//вяжи(функция_596)("_LockFileEx", биб);

		//вяжи(функция_597)("_LockResource", биб);

		//вяжи(функция_598)("_lstrcat", биб);

		//вяжи(функция_599)("_lstrcatA", биб);

		//вяжи(функция_600)("_lstrcatW", биб);

		//вяжи(функция_601)("_lstrcmp", биб);

		//вяжи(функция_602)("_lstrcmpA", биб);

		//вяжи(функция_603)("_lstrcmpi", биб);

		//вяжи(функция_604)("_lstrcmpiA", биб);

		//вяжи(функция_605)("_lstrcmpiW", биб);

		//вяжи(функция_606)("_lstrcmpW", биб);

		//вяжи(функция_607)("_lstrcpy", биб);

		//вяжи(функция_608)("_lstrcpyA", биб);

		//вяжи(функция_609)("_lstrcpyn", биб);

		//вяжи(функция_610)("_lstrcpynA", биб);

		//вяжи(функция_611)("_lstrcpynW", биб);

		//вяжи(функция_612)("_lstrcpyW", биб);

		//вяжи(функция_613)("_lstrlen", биб);

		//вяжи(функция_614)("_lstrlenA", биб);

		//вяжи(функция_615)("_lstrlenW", биб);

		//вяжи(функция_616)("_LZClose", биб);

		//вяжи(функция_617)("_LZCloseFile", биб);

		//вяжи(функция_618)("_LZCopy", биб);

		//вяжи(функция_619)("_LZCreateFileW", биб);

		//вяжи(функция_620)("_LZDone", биб);

		//вяжи(функция_621)("_LZInit", биб);

		//вяжи(функция_622)("_LZOpenFileA", биб);

		//вяжи(функция_623)("_LZOpenFileW", биб);

		//вяжи(функция_624)("_LZRead", биб);

		//вяжи(функция_625)("_LZSeek", биб);

		//вяжи(функция_626)("_LZStart", биб);

		//вяжи(функция_627)("_MapUserPhysicalPages", биб);

		//вяжи(функция_628)("_MapUserPhysicalPagesScatter", биб);

		//вяжи(функция_629)("_MapViewOfFile", биб);

		//вяжи(функция_630)("_MapViewOfFileEx", биб);

		//вяжи(функция_631)("_Module32First", биб);

		//вяжи(функция_632)("_Module32FirstW", биб);

		//вяжи(функция_633)("_Module32Next", биб);

		//вяжи(функция_634)("_Module32NextW", биб);

		//вяжи(функция_635)("_MoveFileA", биб);

		//вяжи(функция_636)("_MoveFileExA", биб);

		//вяжи(функция_637)("_MoveFileExW", биб);

		//вяжи(функция_638)("_MoveFileW", биб);

		//вяжи(функция_639)("_MoveFileWithProgressA", биб);

		//вяжи(функция_640)("_MoveFileWithProgressW", биб);

		//вяжи(функция_641)("_MulDiv", биб);

		//вяжи(функция_642)("_MultiByteToWideChar", биб);

		//вяжи(функция_643)("_NlsConvertIntegerToString", биб);

		//вяжи(функция_644)("_NlsGetCacheUpdateCount", биб);

		//вяжи(функция_645)("_NlsResetProcessLocale", биб);

		//вяжи(функция_646)("_NumaVirtualQueryNode", биб);

		//вяжи(функция_647)("_OpenConsoleW", биб);

		//вяжи(функция_648)("_OpenDataFile", биб);

		//вяжи(функция_649)("_OpenEventA", биб);

		//вяжи(функция_650)("_OpenEventW", биб);

		//вяжи(функция_651)("_OpenFile", биб);

		//вяжи(функция_652)("_OpenFileMappingA", биб);

		//вяжи(функция_653)("_OpenFileMappingW", биб);

		//вяжи(функция_654)("_OpenJobObjectA", биб);

		//вяжи(функция_655)("_OpenJobObjectW", биб);

		//вяжи(функция_656)("_OpenMutexA", биб);

		//вяжи(функция_657)("_OpenMutexW", биб);

		//вяжи(функция_658)("_OpenProcess", биб);

		//вяжи(функция_659)("_OpenProfileUserMapping", биб);

		//вяжи(функция_660)("_OpenSemaphoreA", биб);

		//вяжи(функция_661)("_OpenSemaphoreW", биб);

		//вяжи(функция_662)("_OpenThread", биб);

		//вяжи(функция_663)("_OpenWaitableTimerA", биб);

		//вяжи(функция_664)("_OpenWaitableTimerW", биб);

		//вяжи(функция_665)("_OutputDebugStringA", биб);

		//вяжи(функция_666)("_OutputDebugStringW", биб);

		//вяжи(функция_667)("_PeekConsoleInputA", биб);

		//вяжи(функция_668)("_PeekConsoleInputW", биб);

		//вяжи(функция_669)("_PeekNamedPipe", биб);

		//вяжи(функция_670)("_PostQueuedCompletionStatus", биб);

		//вяжи(функция_671)("_PrepareTape", биб);

		//вяжи(функция_672)("_PrivCopyFileExW", биб);

		//вяжи(функция_673)("_PrivMoveFileIdentityW", биб);

		//вяжи(функция_674)("_Process32First", биб);

		//вяжи(функция_675)("_Process32FirstW", биб);

		//вяжи(функция_676)("_Process32Next", биб);

		//вяжи(функция_677)("_Process32NextW", биб);

		//вяжи(функция_678)("_ProcessIdToSessionId", биб);

		//вяжи(функция_679)("_PulseEvent", биб);

		//вяжи(функция_680)("_PurgeComm", биб);

		//вяжи(функция_681)("_QueryActCtxW", биб);

		//вяжи(функция_682)("_QueryDepthSList", биб);

		//вяжи(функция_683)("_QueryDosDeviceA", биб);

		//вяжи(функция_684)("_QueryDosDeviceW", биб);

		//вяжи(функция_685)("_QueryInformationJobObject", биб);

		//вяжи(функция_686)("_QueryMemoryResourceNotification", биб);

		//вяжи(функция_687)("_QueryPerformanceCounter", биб);

		//вяжи(функция_688)("_QueryPerformanceFrequency", биб);

		//вяжи(функция_689)("_QueryWin31IniFilesMappedToRegistry", биб);

		//вяжи(функция_690)("_QueueUserAPC", биб);

		//вяжи(функция_691)("_QueueUserWorkItem", биб);

		//вяжи(функция_692)("_RaiseException", биб);

		//вяжи(функция_693)("_ReadConsoleA", биб);

		//вяжи(функция_694)("_ReadConsoleInputA", биб);

		//вяжи(функция_695)("_ReadConsoleInputExA", биб);

		//вяжи(функция_696)("_ReadConsoleInputExW", биб);

		//вяжи(функция_697)("_ReadConsoleInputW", биб);

		//вяжи(функция_698)("_ReadConsoleOutputA", биб);

		//вяжи(функция_699)("_ReadConsoleOutputAttribute", биб);

		//вяжи(функция_700)("_ReadConsoleOutputCharacterA", биб);

		//вяжи(функция_701)("_ReadConsoleOutputCharacterW", биб);

		//вяжи(функция_702)("_ReadConsoleOutputW", биб);

		//вяжи(функция_703)("_ReadConsoleW", биб);

		//вяжи(функция_704)("_ReadDirectoryChangesW", биб);

		//вяжи(функция_705)("_ReadFile", биб);

		//вяжи(функция_706)("_ReadFileEx", биб);

		//вяжи(функция_707)("_ReadFileScatter", биб);

		//вяжи(функция_708)("_ReadProcessMemory", биб);

		//вяжи(функция_709)("_RegisterConsoleIME", биб);

		//вяжи(функция_710)("_RegisterConsoleOS2", биб);

		//вяжи(функция_711)("_RegisterConsoleVDM", биб);

		//вяжи(функция_712)("_RegisterWaitForInputIdle", биб);

		//вяжи(функция_713)("_RegisterWaitForSingleObject", биб);

		//вяжи(функция_714)("_RegisterWaitForSingleObjectEx", биб);

		//вяжи(функция_715)("_RegisterWowBaseHandlers", биб);

		//вяжи(функция_716)("_RegisterWowExec", биб);

		//вяжи(функция_717)("_ReleaseActCtx", биб);

		//вяжи(функция_718)("_ReleaseMutex", биб);

		//вяжи(функция_719)("_ReleaseSemaphore", биб);

		//вяжи(функция_720)("_RemoveDirectoryA", биб);

		//вяжи(функция_721)("_RemoveDirectoryW", биб);

		//вяжи(функция_722)("_RemoveLocalAlternateComputerNameA", биб);

		//вяжи(функция_723)("_RemoveLocalAlternateComputerNameW", биб);

		//вяжи(функция_724)("_RemoveVectoredExceptionHandler", биб);

		//вяжи(функция_725)("_ReplaceFile", биб);

		//вяжи(функция_726)("_ReplaceFileA", биб);

		//вяжи(функция_727)("_ReplaceFileW", биб);

		//вяжи(функция_728)("_RequestDeviceWakeup", биб);

		//вяжи(функция_729)("_RequestWakeupLatency", биб);

		//вяжи(функция_730)("_ResetEvent", биб);

		//вяжи(функция_731)("_ResetWriteWatch", биб);

		//вяжи(функция_732)("_RestoreLastError", биб);

		//вяжи(функция_733)("_ResumeThread", биб);

		//вяжи(функция_734)("_RtlCaptureContext", биб);

		//вяжи(функция_735)("_RtlCaptureStackBackTrace", биб);

		//вяжи(функция_736)("_RtlFillMemory", биб);

		//вяжи(функция_737)("_RtlMoveMemory", биб);

		//вяжи(функция_738)("_RtlUnwind", биб);

		//вяжи(функция_739)("_RtlZeroMemory", биб);

		//вяжи(функция_740)("_ScrollConsoleScreenBufferA", биб);

		//вяжи(функция_741)("_ScrollConsoleScreenBufferW", биб);

		//вяжи(функция_742)("_SearchPathA", биб);

		//вяжи(функция_743)("_SearchPathW", биб);

		//вяжи(функция_744)("_SetCalendarInfoA", биб);

		//вяжи(функция_745)("_SetCalendarInfoW", биб);

		//вяжи(функция_746)("_SetClientTimeZoneInformation", биб);

		//вяжи(функция_747)("_SetCommBreak", биб);

		//вяжи(функция_748)("_SetCommConfig", биб);

		//вяжи(функция_749)("_SetCommMask", биб);

		//вяжи(функция_750)("_SetCommState", биб);

		//вяжи(функция_751)("_SetCommTimeouts", биб);

		//вяжи(функция_752)("_SetComPlusPackageInstallStatus", биб);

		//вяжи(функция_753)("_SetComputerNameA", биб);

		//вяжи(функция_754)("_SetComputerNameExA", биб);

		//вяжи(функция_755)("_SetComputerNameExW", биб);

		//вяжи(функция_756)("_SetComputerNameW", биб);

		//вяжи(функция_757)("_SetConsoleActiveScreenBuffer", биб);

		//вяжи(функция_758)("_SetConsoleCommandHistoryMode", биб);

		//вяжи(функция_759)("_SetConsoleCP", биб);

		//вяжи(функция_760)("_SetConsoleCtrlHandler", биб);

		//вяжи(функция_761)("_SetConsoleCursor", биб);

		//вяжи(функция_762)("_SetConsoleCursorInfo", биб);

		//вяжи(функция_763)("_SetConsoleCursorMode", биб);

		//вяжи(функция_764)("_SetConsoleCursorPosition", биб);

		//вяжи(функция_765)("_SetConsoleDisplayMode", биб);

		//вяжи(функция_766)("_SetConsoleFont", биб);

		//вяжи(функция_767)("_SetConsoleHardwareState", биб);

		//вяжи(функция_768)("_SetConsoleIcon", биб);

		//вяжи(функция_769)("_SetConsoleInputExeNameA", биб);

		//вяжи(функция_770)("_SetConsoleInputExeNameW", биб);

		//вяжи(функция_771)("_SetConsoleKeyShortcuts", биб);

		//вяжи(функция_772)("_SetConsoleLocalEUDC", биб);

		//вяжи(функция_773)("_SetConsoleMaximumWindowSize", биб);

		//вяжи(функция_774)("_SetConsoleMenuClose", биб);

		//вяжи(функция_775)("_SetConsoleMode", биб);

		//вяжи(функция_776)("_SetConsoleNlsMode", биб);

		//вяжи(функция_777)("_SetConsoleNumberOfCommandsA", биб);

		//вяжи(функция_778)("_SetConsoleNumberOfCommandsW", биб);

		//вяжи(функция_779)("_SetConsoleOS2OemFormat", биб);

		//вяжи(функция_780)("_SetConsoleOutputCP", биб);

		//вяжи(функция_781)("_SetConsolePalette", биб);

		//вяжи(функция_782)("_SetConsoleScreenBufferSize", биб);

		//вяжи(функция_783)("_SetConsoleTextAttribute", биб);

		//вяжи(функция_784)("_SetConsoleTitleA", биб);

		//вяжи(функция_785)("_SetConsoleTitleW", биб);

		//вяжи(функция_786)("_SetConsoleWindowInfo", биб);

		//вяжи(функция_787)("_SetCPGlobal", биб);

		//вяжи(функция_788)("_SetCriticalSectionSpinCount", биб);

		//вяжи(функция_789)("_SetCurrentDirectoryA", биб);

		//вяжи(функция_790)("_SetCurrentDirectoryW", биб);

		//вяжи(функция_791)("_SetDefaultCommConfigA", биб);

		//вяжи(функция_792)("_SetDefaultCommConfigW", биб);

		//вяжи(функция_793)("_SetDllDirectoryA", биб);

		//вяжи(функция_794)("_SetDllDirectoryW", биб);

		//вяжи(функция_795)("_SetEndOfFile", биб);

		//вяжи(функция_796)("_SetEnvironmentVariableA", биб);

		//вяжи(функция_797)("_SetEnvironmentVariableW", биб);

		//вяжи(функция_798)("_SetErrorMode", биб);

		//вяжи(функция_799)("_SetEvent", биб);

		//вяжи(функция_800)("_SetFileApisToANSI", биб);

		//вяжи(функция_801)("_SetFileApisToOEM", биб);

		//вяжи(функция_802)("_SetFileAttributesA", биб);

		//вяжи(функция_803)("_SetFileAttributesW", биб);

		//вяжи(функция_804)("_SetFilePointer", биб);

		//вяжи(функция_805)("_SetFilePointerEx", биб);

		//вяжи(функция_806)("_SetFileShortNameA", биб);

		//вяжи(функция_807)("_SetFileShortNameW", биб);

		//вяжи(функция_808)("_SetFileTime", биб);

		//вяжи(функция_809)("_SetFileValidData", биб);

		//вяжи(функция_810)("_SetFirmwareEnvironmentVariableA", биб);

		//вяжи(функция_811)("_SetFirmwareEnvironmentVariableW", биб);

		//вяжи(функция_812)("_SetHandleContext", биб);

		//вяжи(функция_813)("_SetHandleCount", биб);

		//вяжи(функция_814)("_SetHandleInformation", биб);

		//вяжи(функция_815)("_SetInformationJobObject", биб);

		//вяжи(функция_816)("_SetLastConsoleEventActive", биб);

		//вяжи(функция_817)("_SetLastError", биб);

		//вяжи(функция_818)("_SetLocaleInfoA", биб);

		//вяжи(функция_819)("_SetLocaleInfoW", биб);

		//вяжи(функция_820)("_SetLocalPrimaryComputerNameA", биб);

		//вяжи(функция_821)("_SetLocalPrimaryComputerNameW", биб);

		//вяжи(функция_822)("_SetLocalTime", биб);

		//вяжи(функция_823)("_SetMailslotInfo", биб);

		//вяжи(функция_824)("_SetMessageWaitingIndicator", биб);

		//вяжи(функция_825)("_SetNamedPipeHandleState", биб);

		//вяжи(функция_826)("_SetPriorityClass", биб);

		//вяжи(функция_827)("_SetProcessAffinityMask", биб);

		//вяжи(функция_828)("_SetProcessDEPPolicy", биб);

		//вяжи(функция_829)("_SetProcessPriorityBoost", биб);

		//вяжи(функция_830)("_SetProcessShutdownParameters", биб);

		//вяжи(функция_831)("_SetProcessWorkingSetSize", биб);

		//вяжи(функция_832)("_SetStdHandle", биб);

		//вяжи(функция_833)("_SetSystemPowerState", биб);

		//вяжи(функция_834)("_SetSystemTime", биб);

		//вяжи(функция_835)("_SetSystemTimeAdjustment", биб);

		//вяжи(функция_836)("_SetTapeParameters", биб);

		//вяжи(функция_837)("_SetTapePosition", биб);

		//вяжи(функция_838)("_SetTermsrvAppInstallMode", биб);

		//вяжи(функция_839)("_SetThreadAffinityMask", биб);

		//вяжи(функция_840)("_SetThreadContext", биб);

		//вяжи(функция_841)("_SetThreadExecutionState", биб);

		//вяжи(функция_842)("_SetThreadIdealProcessor", биб);

		//вяжи(функция_843)("_SetThreadLocale", биб);

		//вяжи(функция_844)("_SetThreadPriority", биб);

		//вяжи(функция_845)("_SetThreadPriorityBoost", биб);

		//вяжи(функция_846)("_SetThreadUILanguage", биб);

		//вяжи(функция_847)("_SetTimerQueueTimer", биб);

		//вяжи(функция_848)("_SetTimeZoneInformation", биб);

		//вяжи(функция_849)("_SetUnhandledExceptionFilter", биб);

		//вяжи(функция_850)("_SetupComm", биб);

		//вяжи(функция_851)("_SetUserGeoID", биб);

		//вяжи(функция_852)("_SetVDMCurrentDirectories", биб);

		//вяжи(функция_853)("_SetVolumeLabelA", биб);

		//вяжи(функция_854)("_SetVolumeLabelW", биб);

		//вяжи(функция_855)("_SetVolumeMountPointA", биб);

		//вяжи(функция_856)("_SetVolumeMountPointW", биб);

		//вяжи(функция_857)("_SetWaitableTimer", биб);

		//вяжи(функция_858)("_ShowConsoleCursor", биб);

		//вяжи(функция_859)("_SignalObjectAndWait", биб);

		//вяжи(функция_860)("_SizeofResource", биб);

		//вяжи(функция_861)("_Sleep", биб);

		//вяжи(функция_862)("_SleepEx", биб);

		//вяжи(функция_863)("_SuspendThread", биб);

		//вяжи(функция_864)("_SwitchToFiber", биб);

		//вяжи(функция_865)("_SwitchToThread", биб);

		//вяжи(функция_866)("_SystemTimeToFileTime", биб);

		//вяжи(функция_867)("_SystemTimeToTzSpecificLocalTime", биб);

		//вяжи(функция_868)("_TerminateJobObject", биб);

		//вяжи(функция_869)("_TerminateProcess", биб);

		//вяжи(функция_870)("_TerminateThread", биб);

		//вяжи(функция_871)("_TermsrvAppInstallMode", биб);

		//вяжи(функция_872)("_Thread32First", биб);

		//вяжи(функция_873)("_Thread32Next", биб);

		//вяжи(функция_874)("_TlsAlloc", биб);

		//вяжи(функция_875)("_TlsFree", биб);

		//вяжи(функция_876)("_TlsGetValue", биб);

		//вяжи(функция_877)("_TlsSetValue", биб);

		//вяжи(функция_878)("_Toolhelp32ReadProcessMemory", биб);

		//вяжи(функция_879)("_TransactNamedPipe", биб);

		//вяжи(функция_880)("_TransmitCommChar", биб);

		//вяжи(функция_881)("_TrimVirtualBuffer", биб);

		//вяжи(функция_882)("_TryEnterCriticalSection", биб);

		//вяжи(функция_883)("_TzSpecificLocalTimeToSystemTime", биб);

		//вяжи(функция_884)("_UnhandledExceptionFilter", биб);

		//вяжи(функция_885)("_UnlockFile", биб);

		//вяжи(функция_886)("_UnlockFileEx", биб);

		//вяжи(функция_887)("_UnmapViewOfFile", биб);

		//вяжи(функция_888)("_UnregisterConsoleIME", биб);

		//вяжи(функция_889)("_UnregisterWait", биб);

		//вяжи(функция_890)("_UnregisterWaitEx", биб);

		//вяжи(функция_891)("_UpdateResourceA", биб);

		//вяжи(функция_892)("_UpdateResourceW", биб);

		//вяжи(функция_893)("_UTRegister", биб);

		//вяжи(функция_894)("_UTUnRegister", биб);

		//вяжи(функция_895)("_ValidateLCType", биб);

		//вяжи(функция_896)("_ValidateLocale", биб);

		//вяжи(функция_897)("_VDMConsoleOperation", биб);

		//вяжи(функция_898)("_VDMOperationStarted", биб);

		//вяжи(функция_899)("_VerifyConsoleIoHandle", биб);

		//вяжи(функция_900)("_VerifyVersionInfoA", биб);

		//вяжи(функция_901)("_VerifyVersionInfoW", биб);

		//вяжи(функция_902)("_VerLanguageNameA", биб);

		//вяжи(функция_903)("_VerLanguageNameW", биб);

		//вяжи(функция_904)("_VerSetConditionMask", биб);

		//вяжи(функция_905)("_VirtualAlloc", биб);

		//вяжи(функция_906)("_VirtualAllocEx", биб);

		//вяжи(функция_907)("_VirtualBufferExceptionHandler", биб);

		//вяжи(функция_908)("_VirtualFree", биб);

		//вяжи(функция_909)("_VirtualFreeEx", биб);

		//вяжи(функция_910)("_VirtualLock", биб);

		//вяжи(функция_911)("_VirtualProtect", биб);

		//вяжи(функция_912)("_VirtualProtectEx", биб);

		//вяжи(функция_913)("_VirtualQuery", биб);

		//вяжи(функция_914)("_VirtualQueryEx", биб);

		//вяжи(функция_915)("_VirtualUnlock", биб);

		//вяжи(функция_916)("_WaitCommEvent", биб);

		//вяжи(функция_917)("_WaitForDebugEvent", биб);

		//вяжи(функция_918)("_WaitForMultipleObjects", биб);

		//вяжи(функция_919)("_WaitForMultipleObjectsEx", биб);

		//вяжи(функция_920)("_WaitForSingleObject", биб);

		//вяжи(функция_921)("_WaitForSingleObjectEx", биб);

		//вяжи(функция_922)("_WaitNamedPipeA", биб);

		//вяжи(функция_923)("_WaitNamedPipeW", биб);

		//вяжи(функция_924)("_WideCharToMultiByte", биб);

		//вяжи(функция_925)("_WinExec", биб);

		//вяжи(функция_926)("_WriteConsoleA", биб);

		//вяжи(функция_927)("_WriteConsoleInputA", биб);

		//вяжи(функция_928)("_WriteConsoleInputVDMA", биб);

		//вяжи(функция_929)("_WriteConsoleInputVDMW", биб);

		//вяжи(функция_930)("_WriteConsoleInputW", биб);

		//вяжи(функция_931)("_WriteConsoleOutputA", биб);

		//вяжи(функция_932)("_WriteConsoleOutputAttribute", биб);

		//вяжи(функция_933)("_WriteConsoleOutputCharacterA", биб);

		//вяжи(функция_934)("_WriteConsoleOutputCharacterW", биб);

		//вяжи(функция_935)("_WriteConsoleOutputW", биб);

		//вяжи(функция_936)("_WriteConsoleW", биб);

		//вяжи(функция_937)("_WriteFile", биб);

		//вяжи(функция_938)("_WriteFileEx", биб);

		//вяжи(функция_939)("_WriteFileGather", биб);

		//вяжи(функция_940)("_WritePrivateProfileSectionA", биб);

		//вяжи(функция_941)("_WritePrivateProfileSectionW", биб);

		//вяжи(функция_942)("_WritePrivateProfileStringA", биб);

		//вяжи(функция_943)("_WritePrivateProfileStringW", биб);

		//вяжи(функция_944)("_WritePrivateProfileStructA", биб);

		//вяжи(функция_945)("_WritePrivateProfileStructW", биб);

		//вяжи(функция_946)("_WriteProcessMemory", биб);

		//вяжи(функция_947)("_WriteProfileSectionA", биб);

		//вяжи(функция_948)("_WriteProfileSectionW", биб);

		//вяжи(функция_949)("_WriteProfileStringA", биб);

		//вяжи(функция_950)("_WriteProfileStringW", биб);

		//вяжи(функция_951)("_WriteTapemark", биб);

		//вяжи(функция_952)("_WTSGetActiveConsoleSessionId", биб);

		//вяжи(функция_953)("_ZombifyActCtx", биб);

		//вяжи(функция_954)("__hwrite", биб);

		//вяжи(функция_955)("__lclose", биб);

		//вяжи(функция_956)("__lcreat", биб);

		//вяжи(функция_957)("__llseek", биб);

		//вяжи(функция_958)("__lopen", биб);

		//вяжи(функция_959)("__lread", биб);

		//вяжи(функция_960)("__lwrite", биб);

		//вяжи(функция_961)("_ActivateActCtx", биб);

		//вяжи(функция_962)("_AddAtomA", биб);

		//вяжи(функция_963)("_AddAtomW", биб);

		//вяжи(функция_964)("_AddConsoleAliasA", биб);

		//вяжи(функция_965)("_AddConsoleAliasW", биб);

		//вяжи(функция_966)("_AddLocalAlternateComputerNameA", биб);

		//вяжи(функция_967)("_AddLocalAlternateComputerNameW", биб);

		//вяжи(функция_968)("_AddRefActCtx", биб);

		//вяжи(функция_969)("_AddVectoredExceptionHandler", биб);

		//вяжи(функция_970)("_AllocateUserPhysicalPages", биб);

		//вяжи(функция_971)("_AllocConsole", биб);

		//вяжи(функция_972)("_AreFileApisANSI", биб);

		//вяжи(функция_973)("_AssignProcessToJobObject", биб);

		//вяжи(функция_974)("_AttachConsole", биб);

		//вяжи(функция_975)("_BackupRead", биб);

		//вяжи(функция_976)("_BackupSeek", биб);

		//вяжи(функция_977)("_BackupWrite", биб);

		//вяжи(функция_978)("_BaseCheckAppcompatCache", биб);

		//вяжи(функция_979)("_BaseCleanupAppcompatCache", биб);

		//вяжи(функция_980)("_BaseCleanupAppcompatCacheSupport", биб);

		//вяжи(функция_981)("_BaseDumpAppcompatCache", биб);

		//вяжи(функция_982)("_BaseFlushAppcompatCache", биб);

		//вяжи(функция_983)("_BaseInitAppcompatCache", биб);

		//вяжи(функция_984)("_BaseInitAppcompatCacheSupport", биб);

		//вяжи(функция_985)("_BasepCheckWinSaferRestrictions", биб);

		//вяжи(функция_986)("_BaseProcessInitPostImport", биб);

		//вяжи(функция_987)("_BaseQueryModuleData", биб);

		//вяжи(функция_988)("_BaseUpdateAppcompatCache", биб);

		//вяжи(функция_989)("_Beep", биб);

		//вяжи(функция_990)("_BeginUpdateResourceA", биб);

		//вяжи(функция_991)("_BeginUpdateResourceW", биб);

		//вяжи(функция_992)("_BindIoCompletionCallback", биб);

		//вяжи(функция_993)("_BuildCommDCBA", биб);

		//вяжи(функция_994)("_BuildCommDCBAndTimeoutsA", биб);

		//вяжи(функция_995)("_BuildCommDCBAndTimeoutsW", биб);

		//вяжи(функция_996)("_BuildCommDCBW", биб);

		//вяжи(функция_997)("_CallNamedPipeA", биб);

		//вяжи(функция_998)("_CallNamedPipeW", биб);

		//вяжи(функция_999)("_CancelDeviceWakeupRequest", биб);

		//вяжи(функция_1000)("_CancelIo", биб);

		//вяжи(функция_1001)("_CancelTimerQueueTimer", биб);

		//вяжи(функция_1002)("_CancelWaitableTimer", биб);

		//вяжи(функция_1003)("_ChangeTimerQueueTimer", биб);

		//вяжи(функция_1004)("_CheckNameLegalDOS8Dot3A", биб);

		//вяжи(функция_1005)("_CheckNameLegalDOS8Dot3W", биб);

		//вяжи(функция_1006)("_CheckRemoteDebuggerPresent", биб);

		//вяжи(функция_1007)("_ClearCommBreak", биб);

		//вяжи(функция_1008)("_ClearCommError", биб);

		//вяжи(функция_1009)("_CloseConsoleHandle", биб);

		//вяжи(функция_1010)("_CloseHandle", биб);

		//вяжи(функция_1011)("_CloseProfileUserMapping", биб);

		//вяжи(функция_1012)("_CmdBatNotification", биб);

		//вяжи(функция_1013)("_CommConfigDialogA", биб);

		//вяжи(функция_1014)("_CommConfigDialogW", биб);

		//вяжи(функция_1015)("_CompareFileTime", биб);

		//вяжи(функция_1016)("_CompareStringA", биб);

		//вяжи(функция_1017)("_CompareStringW", биб);

		//вяжи(функция_1018)("_ConnectNamedPipe", биб);

		//вяжи(функция_1019)("_ConsoleMenuControl", биб);

		//вяжи(функция_1020)("_ContinueDebugEvent", биб);

		//вяжи(функция_1021)("_ConvertDefaultLocale", биб);

		//вяжи(функция_1022)("_ConvertFiberToThread", биб);

		//вяжи(функция_1023)("_ConvertThreadToFiber", биб);

		//вяжи(функция_1024)("_CopyFileA", биб);

		//вяжи(функция_1025)("_CopyFileExA", биб);

		//вяжи(функция_1026)("_CopyFileExW", биб);

		//вяжи(функция_1027)("_CopyFileW", биб);

		//вяжи(функция_1028)("_CopyLZFile", биб);

		//вяжи(функция_1029)("_CreateActCtxA", биб);

		//вяжи(функция_1030)("_CreateActCtxW", биб);

		//вяжи(функция_1031)("_CreateConsoleScreenBuffer", биб);

		//вяжи(функция_1032)("_CreateDirectoryA", биб);

		//вяжи(функция_1033)("_CreateDirectoryExA", биб);

		//вяжи(функция_1034)("_CreateDirectoryExW", биб);

		//вяжи(функция_1035)("_CreateDirectoryW", биб);

		//вяжи(функция_1036)("_CreateEventA", биб);

		//вяжи(функция_1037)("_CreateEventW", биб);

		//вяжи(функция_1038)("_CreateFiber", биб);

		//вяжи(функция_1039)("_CreateFiberEx", биб);

		//вяжи(функция_1040)("_CreateFileA", биб);

		//вяжи(функция_1041)("_CreateFileMappingA", биб);

		//вяжи(функция_1042)("_CreateFileMappingW", биб);

		//вяжи(функция_1043)("_CreateFileW", биб);

		//вяжи(функция_1044)("_CreateHardLinkA", биб);

		//вяжи(функция_1045)("_CreateHardLinkW", биб);

		//вяжи(функция_1046)("_CreateIoCompletionPort", биб);

		//вяжи(функция_1047)("_CreateJobObjectA", биб);

		//вяжи(функция_1048)("_CreateJobObjectW", биб);

		//вяжи(функция_1049)("_CreateJobSet", биб);

		//вяжи(функция_1050)("_CreateMailslotA", биб);

		//вяжи(функция_1051)("_CreateMailslotW", биб);

		//вяжи(функция_1052)("_CreateMemoryResourceNotification", биб);

		//вяжи(функция_1053)("_CreateMutexA", биб);

		//вяжи(функция_1054)("_CreateMutexW", биб);

		//вяжи(функция_1055)("_CreateNamedPipeA", биб);

		//вяжи(функция_1056)("_CreateNamedPipeW", биб);

		//вяжи(функция_1057)("_CreateNlsSecurityDescriptor", биб);

		//вяжи(функция_1058)("_CreatePipe", биб);

		//вяжи(функция_1059)("_CreateProcessA", биб);

		//вяжи(функция_1060)("_CreateProcessInternalA", биб);

		//вяжи(функция_1061)("_CreateProcessInternalW", биб);

		//вяжи(функция_1062)("_CreateProcessInternalWSecure", биб);

		//вяжи(функция_1063)("_CreateProcessW", биб);

		//вяжи(функция_1064)("_CreateRemoteThread", биб);

		//вяжи(функция_1065)("_CreateSemaphoreA", биб);

		//вяжи(функция_1066)("_CreateSemaphoreW", биб);

		//вяжи(функция_1067)("_CreateSocketHandle", биб);

		//вяжи(функция_1068)("_CreateTapePartition", биб);

		//вяжи(функция_1069)("_CreateThread", биб);

		//вяжи(функция_1070)("_CreateTimerQueue", биб);

		//вяжи(функция_1071)("_CreateTimerQueueTimer", биб);

		//вяжи(функция_1072)("_CreateToolhelp32Snapshot", биб);

		//вяжи(функция_1073)("_CreateVirtualBuffer", биб);

		//вяжи(функция_1074)("_CreateWaitableTimerA", биб);

		//вяжи(функция_1075)("_CreateWaitableTimerW", биб);

		//вяжи(функция_1076)("_DeactivateActCtx", биб);

		//вяжи(функция_1077)("_DebugActiveProcess", биб);

		//вяжи(функция_1078)("_DebugActiveProcessStop", биб);

		//вяжи(функция_1079)("_DebugBreak", биб);

		//вяжи(функция_1080)("_DebugBreakProcess", биб);

		//вяжи(функция_1081)("_DebugSetProcessKillOnExit", биб);

		//вяжи(функция_1082)("_DecodePointer", биб);

		//вяжи(функция_1083)("_DecodeSystemPointer", биб);

		//вяжи(функция_1084)("_DefineDosDeviceA", биб);

		//вяжи(функция_1085)("_DefineDosDeviceW", биб);

		//вяжи(функция_1086)("_DelayLoadFailureHook", биб);

		//вяжи(функция_1087)("_DeleteAtom", биб);

		//вяжи(функция_1088)("_DeleteCriticalSection", биб);

		//вяжи(функция_1089)("_DeleteFiber", биб);

		//вяжи(функция_1090)("_DeleteFileA", биб);

		//вяжи(функция_1091)("_DeleteFileW", биб);

		//вяжи(функция_1092)("_DeleteTimerQueue", биб);

		//вяжи(функция_1093)("_DeleteTimerQueueEx", биб);

		//вяжи(функция_1094)("_DeleteTimerQueueTimer", биб);

		//вяжи(функция_1095)("_DeleteVolumeMountPointA", биб);

		//вяжи(функция_1096)("_DeleteVolumeMountPointW", биб);

		//вяжи(функция_1097)("_DeviceIoControl", биб);

		//вяжи(функция_1098)("_DisableThreadLibraryCalls", биб);

		//вяжи(функция_1099)("_DisconnectNamedPipe", биб);

		//вяжи(функция_1100)("_DnsHostnameToComputerNameA", биб);

		//вяжи(функция_1101)("_DnsHostnameToComputerNameW", биб);

		//вяжи(функция_1102)("_DosDateTimeToFileTime", биб);

		//вяжи(функция_1103)("_DosPathToSessionPathA", биб);

		//вяжи(функция_1104)("_DosPathToSessionPathW", биб);

		//вяжи(функция_1105)("_DuplicateConsoleHandle", биб);

		//вяжи(функция_1106)("_DuplicateHandle", биб);

		//вяжи(функция_1107)("_EncodePointer", биб);

		//вяжи(функция_1108)("_EncodeSystemPointer", биб);

		//вяжи(функция_1109)("_EndUpdateResourceA", биб);

		//вяжи(функция_1110)("_EndUpdateResourceW", биб);

		//вяжи(функция_1111)("_EnterCriticalSection", биб);

		//вяжи(функция_1112)("_EnumCalendarInfoA", биб);

		//вяжи(функция_1113)("_EnumCalendarInfoExA", биб);

		//вяжи(функция_1114)("_EnumCalendarInfoExW", биб);

		//вяжи(функция_1115)("_EnumCalendarInfoW", биб);

		//вяжи(функция_1116)("_EnumDateFormatsA", биб);

		//вяжи(функция_1117)("_EnumDateFormatsExA", биб);

		//вяжи(функция_1118)("_EnumDateFormatsExW", биб);

		//вяжи(функция_1119)("_EnumDateFormatsW", биб);

		//вяжи(функция_1120)("_EnumerateLocalComputerNamesA", биб);

		//вяжи(функция_1121)("_EnumerateLocalComputerNamesW", биб);

		//вяжи(функция_1122)("_EnumLanguageGroupLocalesA", биб);

		//вяжи(функция_1123)("_EnumLanguageGroupLocalesW", биб);

		//вяжи(функция_1124)("_EnumResourceLanguagesA", биб);

		//вяжи(функция_1125)("_EnumResourceLanguagesW", биб);

		//вяжи(функция_1126)("_EnumResourceNamesA", биб);

		//вяжи(функция_1127)("_EnumResourceNamesW", биб);

		//вяжи(функция_1128)("_EnumResourceTypesA", биб);

		//вяжи(функция_1129)("_EnumResourceTypesW", биб);

		//вяжи(функция_1130)("_EnumSystemCodePagesA", биб);

		//вяжи(функция_1131)("_EnumSystemCodePagesW", биб);

		//вяжи(функция_1132)("_EnumSystemGeoID", биб);

		//вяжи(функция_1133)("_EnumSystemLanguageGroupsA", биб);

		//вяжи(функция_1134)("_EnumSystemLanguageGroupsW", биб);

		//вяжи(функция_1135)("_EnumSystemLocalesA", биб);

		//вяжи(функция_1136)("_EnumSystemLocalesW", биб);

		//вяжи(функция_1137)("_EnumTimeFormatsA", биб);

		//вяжи(функция_1138)("_EnumTimeFormatsW", биб);

		//вяжи(функция_1139)("_EnumUILanguagesA", биб);

		//вяжи(функция_1140)("_EnumUILanguagesW", биб);

		//вяжи(функция_1141)("_EraseTape", биб);

		//вяжи(функция_1142)("_EscapeCommFunction", биб);

		//вяжи(функция_1143)("_ExitProcess", биб);

		//вяжи(функция_1144)("_ExitThread", биб);

		//вяжи(функция_1145)("_ExitVDM", биб);

		//вяжи(функция_1146)("_ExpandEnvironmentStringsA", биб);

		//вяжи(функция_1147)("_ExpandEnvironmentStringsW", биб);

		//вяжи(функция_1148)("_ExpungeConsoleCommandHistoryA", биб);

		//вяжи(функция_1149)("_ExpungeConsoleCommandHistoryW", биб);

		//вяжи(функция_1150)("_ExtendVirtualBuffer", биб);

		//вяжи(функция_1151)("_FatalAppExitA", биб);

		//вяжи(функция_1152)("_FatalAppExitW", биб);

		//вяжи(функция_1153)("_FatalExit", биб);

		//вяжи(функция_1154)("_FileTimeToDosDateTime", биб);

		//вяжи(функция_1155)("_FileTimeToLocalFileTime", биб);

		//вяжи(функция_1156)("_FileTimeToSystemTime", биб);

		//вяжи(функция_1157)("_FillConsoleOutputAttribute", биб);

		//вяжи(функция_1158)("_FillConsoleOutputCharacterA", биб);

		//вяжи(функция_1159)("_FillConsoleOutputCharacterW", биб);

		//вяжи(функция_1160)("_FindActCtxSectionGuid", биб);

		//вяжи(функция_1161)("_FindActCtxSectionStringA", биб);

		//вяжи(функция_1162)("_FindActCtxSectionStringW", биб);

		//вяжи(функция_1163)("_FindAtomA", биб);

		//вяжи(функция_1164)("_FindAtomW", биб);

		//вяжи(функция_1165)("_FindClose", биб);

		//вяжи(функция_1166)("_FindCloseChangeNotification", биб);

		//вяжи(функция_1167)("_FindFirstChangeNotificationA", биб);

		//вяжи(функция_1168)("_FindFirstChangeNotificationW", биб);

		//вяжи(функция_1169)("_FindFirstFileA", биб);

		//вяжи(функция_1170)("_FindFirstFileExA", биб);

		//вяжи(функция_1171)("_FindFirstFileExW", биб);

		//вяжи(функция_1172)("_FindFirstFileW", биб);

		//вяжи(функция_1173)("_FindFirstVolumeA", биб);

		//вяжи(функция_1174)("_FindFirstVolumeMountPointA", биб);

		//вяжи(функция_1175)("_FindFirstVolumeMountPointW", биб);

		//вяжи(функция_1176)("_FindFirstVolumeW", биб);

		//вяжи(функция_1177)("_FindNextChangeNotification", биб);

		//вяжи(функция_1178)("_FindNextFileA", биб);

		//вяжи(функция_1179)("_FindNextFileW", биб);

		//вяжи(функция_1180)("_FindNextVolumeA", биб);

		//вяжи(функция_1181)("_FindNextVolumeMountPointA", биб);

		//вяжи(функция_1182)("_FindNextVolumeMountPointW", биб);

		//вяжи(функция_1183)("_FindNextVolumeW", биб);

		//вяжи(функция_1184)("_FindResourceA", биб);

		//вяжи(функция_1185)("_FindResourceExA", биб);

		//вяжи(функция_1186)("_FindResourceExW", биб);

		//вяжи(функция_1187)("_FindResourceW", биб);

		//вяжи(функция_1188)("_FindVolumeClose", биб);

		//вяжи(функция_1189)("_FindVolumeMountPointClose", биб);

		//вяжи(функция_1190)("_FlushConsoleInputBuffer", биб);

		//вяжи(функция_1191)("_FlushFileBuffers", биб);

		//вяжи(функция_1192)("_FlushInstructionCache", биб);

		//вяжи(функция_1193)("_FlushViewOfFile", биб);

		//вяжи(функция_1194)("_FoldStringA", биб);

		//вяжи(функция_1195)("_FoldStringW", биб);

		//вяжи(функция_1196)("_FormatMessageA", биб);

		//вяжи(функция_1197)("_FormatMessageW", биб);

		//вяжи(функция_1198)("_FreeConsole", биб);

		//вяжи(функция_1199)("_FreeEnvironmentStringsA", биб);

		//вяжи(функция_1200)("_FreeEnvironmentStringsW", биб);

		//вяжи(функция_1201)("_FreeLibrary", биб);

		//вяжи(функция_1202)("_FreeLibraryAndExitThread", биб);

		//вяжи(функция_1203)("_FreeResource", биб);

		//вяжи(функция_1204)("_FreeUserPhysicalPages", биб);

		//вяжи(функция_1205)("_FreeVirtualBuffer", биб);

		//вяжи(функция_1206)("_GenerateConsoleCtrlEvent", биб);

		//вяжи(функция_1207)("_GetACP", биб);

		//вяжи(функция_1208)("_GetAtomNameA", биб);

		//вяжи(функция_1209)("_GetAtomNameW", биб);

		//вяжи(функция_1210)("_GetBinaryType", биб);

		//вяжи(функция_1211)("_GetBinaryTypeA", биб);

		//вяжи(функция_1212)("_GetBinaryTypeW", биб);

		//вяжи(функция_1213)("_GetCalendarInfoA", биб);

		//вяжи(функция_1214)("_GetCalendarInfoW", биб);

		//вяжи(функция_1215)("_GetCommandLineA", биб);

		//вяжи(функция_1216)("_GetCommandLineW", биб);

		//вяжи(функция_1217)("_GetCommConfig", биб);

		//вяжи(функция_1218)("_GetCommMask", биб);

		//вяжи(функция_1219)("_GetCommModemStatus", биб);

		//вяжи(функция_1220)("_GetCommProperties", биб);

		//вяжи(функция_1221)("_GetCommState", биб);

		//вяжи(функция_1222)("_GetCommTimeouts", биб);

		//вяжи(функция_1223)("_GetComPlusPackageInstallStatus", биб);

		//вяжи(функция_1224)("_GetCompressedFileSizeA", биб);

		//вяжи(функция_1225)("_GetCompressedFileSizeW", биб);

		//вяжи(функция_1226)("_GetComputerNameA", биб);

		//вяжи(функция_1227)("_GetComputerNameExA", биб);

		//вяжи(функция_1228)("_GetComputerNameExW", биб);

		//вяжи(функция_1229)("_GetComputerNameW", биб);

		//вяжи(функция_1230)("_GetConsoleAliasA", биб);

		//вяжи(функция_1231)("_GetConsoleAliasesA", биб);

		//вяжи(функция_1232)("_GetConsoleAliasesLengthA", биб);

		//вяжи(функция_1233)("_GetConsoleAliasesLengthW", биб);

		//вяжи(функция_1234)("_GetConsoleAliasesW", биб);

		//вяжи(функция_1235)("_GetConsoleAliasExesA", биб);

		//вяжи(функция_1236)("_GetConsoleAliasExesLengthA", биб);

		//вяжи(функция_1237)("_GetConsoleAliasExesLengthW", биб);

		//вяжи(функция_1238)("_GetConsoleAliasExesW", биб);

		//вяжи(функция_1239)("_GetConsoleAliasW", биб);

		//вяжи(функция_1240)("_GetConsoleCharType", биб);

		//вяжи(функция_1241)("_GetConsoleCommandHistoryA", биб);

		//вяжи(функция_1242)("_GetConsoleCommandHistoryLengthA", биб);

		//вяжи(функция_1243)("_GetConsoleCommandHistoryLengthW", биб);

		//вяжи(функция_1244)("_GetConsoleCommandHistoryW", биб);

		//вяжи(функция_1245)("_GetConsoleCP", биб);

		//вяжи(функция_1246)("_GetConsoleCursorInfo", биб);

		//вяжи(функция_1247)("_GetConsoleCursorMode", биб);

		//вяжи(функция_1248)("_GetConsoleDisplayMode", биб);

		//вяжи(функция_1249)("_GetConsoleFontInfo", биб);

		//вяжи(функция_1250)("_GetConsoleFontSize", биб);

		//вяжи(функция_1251)("_GetConsoleHardwareState", биб);

		//вяжи(функция_1252)("_GetConsoleInputExeNameA", биб);

		//вяжи(функция_1253)("_GetConsoleInputExeNameW", биб);

		//вяжи(функция_1254)("_GetConsoleInputWaitHandle", биб);

		//вяжи(функция_1255)("_GetConsoleKeyboardLayoutNameA", биб);

		//вяжи(функция_1256)("_GetConsoleKeyboardLayoutNameW", биб);

		//вяжи(функция_1257)("_GetConsoleMode", биб);

		//вяжи(функция_1258)("_GetConsoleNlsMode", биб);

		//вяжи(функция_1259)("_GetConsoleOutputCP", биб);

		//вяжи(функция_1260)("_GetConsoleProcessList", биб);

		//вяжи(функция_1261)("_GetConsoleScreenBufferInfo", биб);

		//вяжи(функция_1262)("_GetConsoleSelectionInfo", биб);

		//вяжи(функция_1263)("_GetConsoleTitleA", биб);

		//вяжи(функция_1264)("_GetConsoleTitleW", биб);

		//вяжи(функция_1265)("_GetConsoleWindow", биб);

		//вяжи(функция_1266)("_GetCPFileNameFromRegistry", биб);

		//вяжи(функция_1267)("_GetCPInfo", биб);

		//вяжи(функция_1268)("_GetCPInfoExA", биб);

		//вяжи(функция_1269)("_GetCPInfoExW", биб);

		//вяжи(функция_1270)("_GetCurrencyFormatA", биб);

		//вяжи(функция_1271)("_GetCurrencyFormatW", биб);

		//вяжи(функция_1272)("_GetCurrentActCtx", биб);

		//вяжи(функция_1273)("_GetCurrentConsoleFont", биб);

		//вяжи(функция_1274)("_GetCurrentDirectoryA", биб);

		//вяжи(функция_1275)("_GetCurrentDirectoryW", биб);

		//вяжи(функция_1276)("_GetCurrentProcess", биб);

		//вяжи(функция_1277)("_GetCurrentProcessId", биб);

		//вяжи(функция_1278)("_GetCurrentThread", биб);

		//вяжи(функция_1279)("_GetCurrentThreadId", биб);

		//вяжи(функция_1280)("_GetDateFormatA", биб);

		//вяжи(функция_1281)("_GetDateFormatW", биб);

		//вяжи(функция_1282)("_GetDefaultCommConfigA", биб);

		//вяжи(функция_1283)("_GetDefaultCommConfigW", биб);

		//вяжи(функция_1284)("_GetDefaultSortkeySize", биб);

		//вяжи(функция_1285)("_GetDevicePowerState", биб);

		//вяжи(функция_1286)("_GetDiskFreeSpaceA", биб);

		//вяжи(функция_1287)("_GetDiskFreeSpaceExA", биб);

		//вяжи(функция_1288)("_GetDiskFreeSpaceExW", биб);

		//вяжи(функция_1289)("_GetDiskFreeSpaceW", биб);

		//вяжи(функция_1290)("_GetDllDirectoryA", биб);

		//вяжи(функция_1291)("_GetDllDirectoryW", биб);

		//вяжи(функция_1292)("_GetDriveTypeA", биб);

		//вяжи(функция_1293)("_GetDriveTypeW", биб);

		//вяжи(функция_1294)("_GetEnvironmentStrings", биб);

		//вяжи(функция_1295)("_GetEnvironmentStringsA", биб);

		//вяжи(функция_1296)("_GetEnvironmentStringsW", биб);

		//вяжи(функция_1297)("_GetEnvironmentVariableA", биб);

		//вяжи(функция_1298)("_GetEnvironmentVariableW", биб);

		//вяжи(функция_1299)("_GetExitCodeProcess", биб);

		//вяжи(функция_1300)("_GetExitCodeThread", биб);

		//вяжи(функция_1301)("_GetExpandedNameA", биб);

		//вяжи(функция_1302)("_GetExpandedNameW", биб);

		//вяжи(функция_1303)("_GetFileAttributesA", биб);

		//вяжи(функция_1304)("_GetFileAttributesExA", биб);

		//вяжи(функция_1305)("_GetFileAttributesExW", биб);

		//вяжи(функция_1306)("_GetFileAttributesW", биб);

		//вяжи(функция_1307)("_GetFileInformationByHandle", биб);

		//вяжи(функция_1308)("_GetFileSize", биб);

		//вяжи(функция_1309)("_GetFileSizeEx", биб);

		//вяжи(функция_1310)("_GetFileTime", биб);

		//вяжи(функция_1311)("_GetFileType", биб);

		//вяжи(функция_1312)("_GetFirmwareEnvironmentVariableA", биб);

		//вяжи(функция_1313)("_GetFirmwareEnvironmentVariableW", биб);

		//вяжи(функция_1314)("_GetFullPathNameA", биб);

		//вяжи(функция_1315)("_GetFullPathNameW", биб);

		//вяжи(функция_1316)("_GetGeoInfoA", биб);

		//вяжи(функция_1317)("_GetGeoInfoW", биб);

		//вяжи(функция_1318)("_GetHandleContext", биб);

		//вяжи(функция_1319)("_GetHandleInformation", биб);

		//вяжи(функция_1320)("_GetLargestConsoleWindowSize", биб);

		//вяжи(функция_1321)("_GetLastError", биб);

		//вяжи(функция_1322)("_GetLinguistLangSize", биб);

		//вяжи(функция_1323)("_GetLocaleInfoA", биб);

		//вяжи(функция_1324)("_GetLocaleInfoW", биб);

		//вяжи(функция_1325)("_GetLocalTime", биб);

		//вяжи(функция_1326)("_GetLogicalDrives", биб);

		//вяжи(функция_1327)("_GetLogicalDriveStringsA", биб);

		//вяжи(функция_1328)("_GetLogicalDriveStringsW", биб);

		//вяжи(функция_1329)("_GetLogicalProcessorInformation", биб);

		//вяжи(функция_1330)("_GetLongPathNameA", биб);

		//вяжи(функция_1331)("_GetLongPathNameW", биб);

		//вяжи(функция_1332)("_GetMailslotInfo", биб);

		//вяжи(функция_1333)("_GetModuleFileNameA", биб);

		//вяжи(функция_1334)("_GetModuleFileNameW", биб);

		//вяжи(функция_1335)("_GetModuleHandleA", биб);

		//вяжи(функция_1336)("_GetModuleHandleExA", биб);

		//вяжи(функция_1337)("_GetModuleHandleExW", биб);

		//вяжи(функция_1338)("_GetModuleHandleW", биб);

		//вяжи(функция_1339)("_GetNamedPipeHandleStateA", биб);

		//вяжи(функция_1340)("_GetNamedPipeHandleStateW", биб);

		//вяжи(функция_1341)("_GetNamedPipeInfo", биб);

		//вяжи(функция_1342)("_GetNativeSystemInfo", биб);

		//вяжи(функция_1343)("_GetNextVDMCommand", биб);

		//вяжи(функция_1344)("_GetNlsSectionName", биб);

		//вяжи(функция_1345)("_GetNumaAvailableMemory", биб);

		//вяжи(функция_1346)("_GetNumaAvailableMemoryNode", биб);

		//вяжи(функция_1347)("_GetNumaHighestNodeNumber", биб);

		//вяжи(функция_1348)("_GetNumaNodeProcessorMask", биб);

		//вяжи(функция_1349)("_GetNumaProcessorMap", биб);

		//вяжи(функция_1350)("_GetNumaProcessorNode", биб);

		//вяжи(функция_1351)("_GetNumberFormatA", биб);

		//вяжи(функция_1352)("_GetNumberFormatW", биб);

		//вяжи(функция_1353)("_GetNumberOfConsoleFonts", биб);

		//вяжи(функция_1354)("_GetNumberOfConsoleInputEvents", биб);

		//вяжи(функция_1355)("_GetNumberOfConsoleMouseButtons", биб);

		//вяжи(функция_1356)("_GetOEMCP", биб);

		//вяжи(функция_1357)("_GetOverlappedResult", биб);

		//вяжи(функция_1358)("_GetPriorityClass", биб);

		//вяжи(функция_1359)("_GetPrivateProfileIntA", биб);

		//вяжи(функция_1360)("_GetPrivateProfileIntW", биб);

		//вяжи(функция_1361)("_GetPrivateProfileSectionA", биб);

		//вяжи(функция_1362)("_GetPrivateProfileSectionNamesA", биб);

		//вяжи(функция_1363)("_GetPrivateProfileSectionNamesW", биб);

		//вяжи(функция_1364)("_GetPrivateProfileSectionW", биб);

		//вяжи(функция_1365)("_GetPrivateProfileStringA", биб);

		//вяжи(функция_1366)("_GetPrivateProfileStringW", биб);

		//вяжи(функция_1367)("_GetPrivateProfileStructA", биб);

		//вяжи(функция_1368)("_GetPrivateProfileStructW", биб);

		//вяжи(функция_1369)("_GetProcAddress", биб);

		//вяжи(функция_1370)("_GetProcessAffinityMask", биб);

		//вяжи(функция_1371)("_GetProcessDEPPolicy", биб);

		//вяжи(функция_1372)("_GetProcessHandleCount", биб);

		//вяжи(функция_1373)("_GetProcessHeap", биб);

		//вяжи(функция_1374)("_GetProcessHeaps", биб);

		//вяжи(функция_1375)("_GetProcessId", биб);

		//вяжи(функция_1376)("_GetProcessIoCounters", биб);

		//вяжи(функция_1377)("_GetProcessPriorityBoost", биб);

		//вяжи(функция_1378)("_GetProcessShutdownParameters", биб);

		//вяжи(функция_1379)("_GetProcessTimes", биб);

		//вяжи(функция_1380)("_GetProcessVersion", биб);

		//вяжи(функция_1381)("_GetProcessWorkingSetSize", биб);

		//вяжи(функция_1382)("_GetProfileIntA", биб);

		//вяжи(функция_1383)("_GetProfileIntW", биб);

		//вяжи(функция_1384)("_GetProfileSectionA", биб);

		//вяжи(функция_1385)("_GetProfileSectionW", биб);

		//вяжи(функция_1386)("_GetProfileStringA", биб);

		//вяжи(функция_1387)("_GetProfileStringW", биб);

		//вяжи(функция_1388)("_GetQueuedCompletionStatus", биб);

		//вяжи(функция_1389)("_GetShortPathNameA", биб);

		//вяжи(функция_1390)("_GetShortPathNameW", биб);

		//вяжи(функция_1391)("_GetStartupInfoA", биб);

		//вяжи(функция_1392)("_GetStartupInfoW", биб);

		//вяжи(функция_1393)("_GetStdHandle", биб);

		//вяжи(функция_1394)("_GetStringTypeA", биб);

		//вяжи(функция_1395)("_GetStringTypeExA", биб);

		//вяжи(функция_1396)("_GetStringTypeExW", биб);

		//вяжи(функция_1397)("_GetStringTypeW", биб);

		//вяжи(функция_1398)("_GetSystemDefaultLangID", биб);

		//вяжи(функция_1399)("_GetSystemDefaultLCID", биб);

		//вяжи(функция_1400)("_GetSystemDefaultUILanguage", биб);

		//вяжи(функция_1401)("_GetSystemDEPPolicy", биб);

		//вяжи(функция_1402)("_GetSystemDirectoryA", биб);

		//вяжи(функция_1403)("_GetSystemDirectoryW", биб);

		//вяжи(функция_1404)("_GetSystemInfo", биб);

		//вяжи(функция_1405)("_GetSystemPowerStatus", биб);

		//вяжи(функция_1406)("_GetSystemRegistryQuota", биб);

		//вяжи(функция_1407)("_GetSystemTime", биб);

		//вяжи(функция_1408)("_GetSystemTimeAdjustment", биб);

		//вяжи(функция_1409)("_GetSystemTimeAsFileTime", биб);

		//вяжи(функция_1410)("_GetSystemTimes", биб);

		//вяжи(функция_1411)("_GetSystemWindowsDirectoryA", биб);

		//вяжи(функция_1412)("_GetSystemWindowsDirectoryW", биб);

		//вяжи(функция_1413)("_GetSystemWow64DirectoryA", биб);

		//вяжи(функция_1414)("_GetSystemWow64DirectoryW", биб);

		//вяжи(функция_1415)("_GetTapeParameters", биб);

		//вяжи(функция_1416)("_GetTapePosition", биб);

		//вяжи(функция_1417)("_GetTapeStatus", биб);

		//вяжи(функция_1418)("_GetTempFileNameA", биб);

		//вяжи(функция_1419)("_GetTempFileNameW", биб);

		//вяжи(функция_1420)("_GetTempPathA", биб);

		//вяжи(функция_1421)("_GetTempPathW", биб);

		//вяжи(функция_1422)("_GetThreadContext", биб);

		//вяжи(функция_1423)("_GetThreadIOPendingFlag", биб);

		//вяжи(функция_1424)("_GetThreadLocale", биб);

		//вяжи(функция_1425)("_GetThreadPriority", биб);

		//вяжи(функция_1426)("_GetThreadPriorityBoost", биб);

		//вяжи(функция_1427)("_GetThreadSelectorEntry", биб);

		//вяжи(функция_1428)("_GetThreadTimes", биб);

		//вяжи(функция_1429)("_GetTickCount", биб);

		//вяжи(функция_1430)("_GetTimeFormatA", биб);

		//вяжи(функция_1431)("_GetTimeFormatW", биб);

		//вяжи(функция_1432)("_GetTimeZoneInformation", биб);

		//вяжи(функция_1433)("_GetUserDefaultLangID", биб);

		//вяжи(функция_1434)("_GetUserDefaultLCID", биб);

		//вяжи(функция_1435)("_GetUserDefaultUILanguage", биб);

		//вяжи(функция_1436)("_GetUserGeoID", биб);

		//вяжи(функция_1437)("_GetVDMCurrentDirectories", биб);

		//вяжи(функция_1438)("_GetVersion", биб);

		//вяжи(функция_1439)("_GetVersionExA", биб);

		//вяжи(функция_1440)("_GetVersionExW", биб);

		//вяжи(функция_1441)("_GetVolumeInformationA", биб);

		//вяжи(функция_1442)("_GetVolumeInformationW", биб);

		//вяжи(функция_1443)("_GetVolumeNameForVolumeMountPointA", биб);

		//вяжи(функция_1444)("_GetVolumeNameForVolumeMountPointW", биб);

		//вяжи(функция_1445)("_GetVolumePathNameA", биб);

		//вяжи(функция_1446)("_GetVolumePathNamesForVolumeNameA", биб);

		//вяжи(функция_1447)("_GetVolumePathNamesForVolumeNameW", биб);

		//вяжи(функция_1448)("_GetVolumePathNameW", биб);

		//вяжи(функция_1449)("_GetWindowsDirectoryA", биб);

		//вяжи(функция_1450)("_GetWindowsDirectoryW", биб);

		//вяжи(функция_1451)("_GetWriteWatch", биб);

		//вяжи(функция_1452)("_GlobalAddAtomA", биб);

		//вяжи(функция_1453)("_GlobalAddAtomW", биб);

		//вяжи(функция_1454)("_GlobalAlloc", биб);

		//вяжи(функция_1455)("_GlobalCompact", биб);

		//вяжи(функция_1456)("_GlobalDeleteAtom", биб);

		//вяжи(функция_1457)("_GlobalFindAtomA", биб);

		//вяжи(функция_1458)("_GlobalFindAtomW", биб);

		//вяжи(функция_1459)("_GlobalFix", биб);

		//вяжи(функция_1460)("_GlobalFlags", биб);

		//вяжи(функция_1461)("_GlobalFree", биб);

		//вяжи(функция_1462)("_GlobalGetAtomNameA", биб);

		//вяжи(функция_1463)("_GlobalGetAtomNameW", биб);

		//вяжи(функция_1464)("_GlobalHandle", биб);

		//вяжи(функция_1465)("_GlobalLock", биб);

		//вяжи(функция_1466)("_GlobalMemoryStatus", биб);

		//вяжи(функция_1467)("_GlobalMemoryStatusEx", биб);

		//вяжи(функция_1468)("_GlobalReAlloc", биб);

		//вяжи(функция_1469)("_GlobalSize", биб);

		//вяжи(функция_1470)("_GlobalUnfix", биб);

		//вяжи(функция_1471)("_GlobalUnlock", биб);

		//вяжи(функция_1472)("_GlobalUnWire", биб);

		//вяжи(функция_1473)("_GlobalWire", биб);

		//вяжи(функция_1474)("_Heap32First", биб);

		//вяжи(функция_1475)("_Heap32ListFirst", биб);

		//вяжи(функция_1476)("_Heap32ListNext", биб);

		//вяжи(функция_1477)("_Heap32Next", биб);

		//вяжи(функция_1478)("_HeapAlloc", биб);

		//вяжи(функция_1479)("_HeapCompact", биб);

		//вяжи(функция_1480)("_HeapCreate", биб);

		//вяжи(функция_1481)("_HeapCreateTagsW", биб);

		//вяжи(функция_1482)("_HeapDestroy", биб);

		//вяжи(функция_1483)("_HeapExtend", биб);

		//вяжи(функция_1484)("_HeapFree", биб);

		//вяжи(функция_1485)("_HeapLock", биб);

		//вяжи(функция_1486)("_HeapQueryInformation", биб);

		//вяжи(функция_1487)("_HeapQueryTagW", биб);

		//вяжи(функция_1488)("_HeapReAlloc", биб);

		//вяжи(функция_1489)("_HeapSetInformation", биб);

		//вяжи(функция_1490)("_HeapSize", биб);

		//вяжи(функция_1491)("_HeapSummary", биб);

		//вяжи(функция_1492)("_HeapUnlock", биб);

		//вяжи(функция_1493)("_HeapUsage", биб);

		//вяжи(функция_1494)("_HeapValidate", биб);

		//вяжи(функция_1495)("_HeapWalk", биб);

		//вяжи(функция_1496)("_InitAtomTable", биб);

		//вяжи(функция_1497)("_InitializeCriticalSection", биб);

		//вяжи(функция_1498)("_InitializeCriticalSectionAndSpinCount", биб);

		//вяжи(функция_1499)("_InitializeSListHead", биб);

		//вяжи(функция_1500)("_InterlockedCompareExchange", биб);

		//вяжи(функция_1501)("_InterlockedDecrement", биб);

		//вяжи(функция_1502)("_InterlockedExchange", биб);

		//вяжи(функция_1503)("_InterlockedExchangeAdd", биб);

		//вяжи(функция_1504)("_InterlockedFlushSList", биб);

		//вяжи(функция_1505)("_InterlockedIncrement", биб);

		//вяжи(функция_1506)("_InterlockedPopEntrySList", биб);

		//вяжи(функция_1507)("_InterlockedPushEntrySList", биб);

		//вяжи(функция_1508)("_InvalidateConsoleDIBits", биб);

		//вяжи(функция_1509)("_IsBadCodePtr", биб);

		//вяжи(функция_1510)("_IsBadHugeReadPtr", биб);

		//вяжи(функция_1511)("_IsBadHugeWritePtr", биб);

		//вяжи(функция_1512)("_IsBadReadPtr", биб);

		//вяжи(функция_1513)("_IsBadStringPtrA", биб);

		//вяжи(функция_1514)("_IsBadStringPtrW", биб);

		//вяжи(функция_1515)("_IsBadWritePtr", биб);

		//вяжи(функция_1516)("_IsDBCSLeadByte", биб);

		//вяжи(функция_1517)("_IsDBCSLeadByteEx", биб);

		//вяжи(функция_1518)("_IsDebuggerPresent", биб);

		//вяжи(функция_1519)("_IsProcessInJob", биб);

		//вяжи(функция_1520)("_IsProcessorFeaturePresent", биб);

		//вяжи(функция_1521)("_IsSystemResumeAutomatic", биб);

		//вяжи(функция_1522)("_IsValidCodePage", биб);

		//вяжи(функция_1523)("_IsValidLanguageGroup", биб);

		//вяжи(функция_1524)("_IsValidLocale", биб);

		//вяжи(функция_1525)("_IsValidUILanguage", биб);

		//вяжи(функция_1526)("_IsWow64Process", биб);

		//вяжи(функция_1527)("_LCMapStringA", биб);

		//вяжи(функция_1528)("_LCMapStringW", биб);

		//вяжи(функция_1529)("_LeaveCriticalSection", биб);

		//вяжи(функция_1530)("_LoadLibraryA", биб);

		//вяжи(функция_1531)("_LoadLibraryExA", биб);

		//вяжи(функция_1532)("_LoadLibraryExW", биб);

		//вяжи(функция_1533)("_LoadLibraryW", биб);

		//вяжи(функция_1534)("_LoadModule", биб);

		//вяжи(функция_1535)("_LoadResource", биб);

		//вяжи(функция_1536)("_LocalAlloc", биб);

		//вяжи(функция_1537)("_LocalCompact", биб);

		//вяжи(функция_1538)("_LocalFileTimeToFileTime", биб);

		//вяжи(функция_1539)("_LocalFlags", биб);

		//вяжи(функция_1540)("_LocalFree", биб);

		//вяжи(функция_1541)("_LocalHandle", биб);

		//вяжи(функция_1542)("_LocalLock", биб);

		//вяжи(функция_1543)("_LocalReAlloc", биб);

		//вяжи(функция_1544)("_LocalShrink", биб);

		//вяжи(функция_1545)("_LocalSize", биб);

		//вяжи(функция_1546)("_LocalUnlock", биб);

		//вяжи(функция_1547)("_LockFile", биб);

		//вяжи(функция_1548)("_LockFileEx", биб);

		//вяжи(функция_1549)("_LockResource", биб);

		//вяжи(функция_1550)("_lstrcat", биб);

		//вяжи(функция_1551)("_lstrcatA", биб);

		//вяжи(функция_1552)("_lstrcatW", биб);

		//вяжи(функция_1553)("_lstrcmp", биб);

		//вяжи(функция_1554)("_lstrcmpA", биб);

		//вяжи(функция_1555)("_lstrcmpi", биб);

		//вяжи(функция_1556)("_lstrcmpiA", биб);

		//вяжи(функция_1557)("_lstrcmpiW", биб);

		//вяжи(функция_1558)("_lstrcmpW", биб);

		//вяжи(функция_1559)("_lstrcpy", биб);

		//вяжи(функция_1560)("_lstrcpyA", биб);

		//вяжи(функция_1561)("_lstrcpyn", биб);

		//вяжи(функция_1562)("_lstrcpynA", биб);

		//вяжи(функция_1563)("_lstrcpynW", биб);

		//вяжи(функция_1564)("_lstrcpyW", биб);

		//вяжи(функция_1565)("_lstrlen", биб);

		//вяжи(функция_1566)("_lstrlenA", биб);

		//вяжи(функция_1567)("_lstrlenW", биб);

		//вяжи(функция_1568)("_LZClose", биб);

		//вяжи(функция_1569)("_LZCloseFile", биб);

		//вяжи(функция_1570)("_LZCopy", биб);

		//вяжи(функция_1571)("_LZCreateFileW", биб);

		//вяжи(функция_1572)("_LZDone", биб);

		//вяжи(функция_1573)("_LZInit", биб);

		//вяжи(функция_1574)("_LZOpenFileA", биб);

		//вяжи(функция_1575)("_LZOpenFileW", биб);

		//вяжи(функция_1576)("_LZRead", биб);

		//вяжи(функция_1577)("_LZSeek", биб);

		//вяжи(функция_1578)("_LZStart", биб);

		//вяжи(функция_1579)("_MapUserPhysicalPages", биб);

		//вяжи(функция_1580)("_MapUserPhysicalPagesScatter", биб);

		//вяжи(функция_1581)("_MapViewOfFile", биб);

		//вяжи(функция_1582)("_MapViewOfFileEx", биб);

		//вяжи(функция_1583)("_Module32First", биб);

		//вяжи(функция_1584)("_Module32FirstW", биб);

		//вяжи(функция_1585)("_Module32Next", биб);

		//вяжи(функция_1586)("_Module32NextW", биб);

		//вяжи(функция_1587)("_MoveFileA", биб);

		//вяжи(функция_1588)("_MoveFileExA", биб);

		//вяжи(функция_1589)("_MoveFileExW", биб);

		//вяжи(функция_1590)("_MoveFileW", биб);

		//вяжи(функция_1591)("_MoveFileWithProgressA", биб);

		//вяжи(функция_1592)("_MoveFileWithProgressW", биб);

		//вяжи(функция_1593)("_MulDiv", биб);

		//вяжи(функция_1594)("_MultiByteToWideChar", биб);

		//вяжи(функция_1595)("_NlsConvertIntegerToString", биб);

		//вяжи(функция_1596)("_NlsGetCacheUpdateCount", биб);

		//вяжи(функция_1597)("_NlsResetProcessLocale", биб);

		//вяжи(функция_1598)("_NumaVirtualQueryNode", биб);

		//вяжи(функция_1599)("_OpenConsoleW", биб);

		//вяжи(функция_1600)("_OpenDataFile", биб);

		//вяжи(функция_1601)("_OpenEventA", биб);

		//вяжи(функция_1602)("_OpenEventW", биб);

		//вяжи(функция_1603)("_OpenFile", биб);

		//вяжи(функция_1604)("_OpenFileMappingA", биб);

		//вяжи(функция_1605)("_OpenFileMappingW", биб);

		//вяжи(функция_1606)("_OpenJobObjectA", биб);

		//вяжи(функция_1607)("_OpenJobObjectW", биб);

		//вяжи(функция_1608)("_OpenMutexA", биб);

		//вяжи(функция_1609)("_OpenMutexW", биб);

		//вяжи(функция_1610)("_OpenProcess", биб);

		//вяжи(функция_1611)("_OpenProfileUserMapping", биб);

		//вяжи(функция_1612)("_OpenSemaphoreA", биб);

		//вяжи(функция_1613)("_OpenSemaphoreW", биб);

		//вяжи(функция_1614)("_OpenThread", биб);

		//вяжи(функция_1615)("_OpenWaitableTimerA", биб);

		//вяжи(функция_1616)("_OpenWaitableTimerW", биб);

		//вяжи(функция_1617)("_OutputDebugStringA", биб);

		//вяжи(функция_1618)("_OutputDebugStringW", биб);

		//вяжи(функция_1619)("_PeekConsoleInputA", биб);

		//вяжи(функция_1620)("_PeekConsoleInputW", биб);

		//вяжи(функция_1621)("_PeekNamedPipe", биб);

		//вяжи(функция_1622)("_PostQueuedCompletionStatus", биб);

		//вяжи(функция_1623)("_PrepareTape", биб);

		//вяжи(функция_1624)("_PrivCopyFileExW", биб);

		//вяжи(функция_1625)("_PrivMoveFileIdentityW", биб);

		//вяжи(функция_1626)("_Process32First", биб);

		//вяжи(функция_1627)("_Process32FirstW", биб);

		//вяжи(функция_1628)("_Process32Next", биб);

		//вяжи(функция_1629)("_Process32NextW", биб);

		//вяжи(функция_1630)("_ProcessIdToSessionId", биб);

		//вяжи(функция_1631)("_PulseEvent", биб);

		//вяжи(функция_1632)("_PurgeComm", биб);

		//вяжи(функция_1633)("_QueryActCtxW", биб);

		//вяжи(функция_1634)("_QueryDepthSList", биб);

		//вяжи(функция_1635)("_QueryDosDeviceA", биб);

		//вяжи(функция_1636)("_QueryDosDeviceW", биб);

		//вяжи(функция_1637)("_QueryInformationJobObject", биб);

		//вяжи(функция_1638)("_QueryMemoryResourceNotification", биб);

		//вяжи(функция_1639)("_QueryPerformanceCounter", биб);

		//вяжи(функция_1640)("_QueryPerformanceFrequency", биб);

		//вяжи(функция_1641)("_QueryWin31IniFilesMappedToRegistry", биб);

		//вяжи(функция_1642)("_QueueUserAPC", биб);

		//вяжи(функция_1643)("_QueueUserWorkItem", биб);

		//вяжи(функция_1644)("_RaiseException", биб);

		//вяжи(функция_1645)("_ReadConsoleA", биб);

		//вяжи(функция_1646)("_ReadConsoleInputA", биб);

		//вяжи(функция_1647)("_ReadConsoleInputExA", биб);

		//вяжи(функция_1648)("_ReadConsoleInputExW", биб);

		//вяжи(функция_1649)("_ReadConsoleInputW", биб);

		//вяжи(функция_1650)("_ReadConsoleOutputA", биб);

		//вяжи(функция_1651)("_ReadConsoleOutputAttribute", биб);

		//вяжи(функция_1652)("_ReadConsoleOutputCharacterA", биб);

		//вяжи(функция_1653)("_ReadConsoleOutputCharacterW", биб);

		//вяжи(функция_1654)("_ReadConsoleOutputW", биб);

		//вяжи(функция_1655)("_ReadConsoleW", биб);

		//вяжи(функция_1656)("_ReadDirectoryChangesW", биб);

		//вяжи(функция_1657)("_ReadFile", биб);

		//вяжи(функция_1658)("_ReadFileEx", биб);

		//вяжи(функция_1659)("_ReadFileScatter", биб);

		//вяжи(функция_1660)("_ReadProcessMemory", биб);

		//вяжи(функция_1661)("_RegisterConsoleIME", биб);

		//вяжи(функция_1662)("_RegisterConsoleOS2", биб);

		//вяжи(функция_1663)("_RegisterConsoleVDM", биб);

		//вяжи(функция_1664)("_RegisterWaitForInputIdle", биб);

		//вяжи(функция_1665)("_RegisterWaitForSingleObject", биб);

		//вяжи(функция_1666)("_RegisterWaitForSingleObjectEx", биб);

		//вяжи(функция_1667)("_RegisterWowBaseHandlers", биб);

		//вяжи(функция_1668)("_RegisterWowExec", биб);

		//вяжи(функция_1669)("_ReleaseActCtx", биб);

		//вяжи(функция_1670)("_ReleaseMutex", биб);

		//вяжи(функция_1671)("_ReleaseSemaphore", биб);

		//вяжи(функция_1672)("_RemoveDirectoryA", биб);

		//вяжи(функция_1673)("_RemoveDirectoryW", биб);

		//вяжи(функция_1674)("_RemoveLocalAlternateComputerNameA", биб);

		//вяжи(функция_1675)("_RemoveLocalAlternateComputerNameW", биб);

		//вяжи(функция_1676)("_RemoveVectoredExceptionHandler", биб);

		//вяжи(функция_1677)("_ReplaceFile", биб);

		//вяжи(функция_1678)("_ReplaceFileA", биб);

		//вяжи(функция_1679)("_ReplaceFileW", биб);

		//вяжи(функция_1680)("_RequestDeviceWakeup", биб);

		//вяжи(функция_1681)("_RequestWakeupLatency", биб);

		//вяжи(функция_1682)("_ResetEvent", биб);

		//вяжи(функция_1683)("_ResetWriteWatch", биб);

		//вяжи(функция_1684)("_RestoreLastError", биб);

		//вяжи(функция_1685)("_ResumeThread", биб);

		//вяжи(функция_1686)("_RtlCaptureContext", биб);

		//вяжи(функция_1687)("_RtlCaptureStackBackTrace", биб);

		//вяжи(функция_1688)("_RtlFillMemory", биб);

		//вяжи(функция_1689)("_RtlMoveMemory", биб);

		//вяжи(функция_1690)("_RtlUnwind", биб);

		//вяжи(функция_1691)("_RtlZeroMemory", биб);

		//вяжи(функция_1692)("_ScrollConsoleScreenBufferA", биб);

		//вяжи(функция_1693)("_ScrollConsoleScreenBufferW", биб);

		//вяжи(функция_1694)("_SearchPathA", биб);

		//вяжи(функция_1695)("_SearchPathW", биб);

		//вяжи(функция_1696)("_SetCalendarInfoA", биб);

		//вяжи(функция_1697)("_SetCalendarInfoW", биб);

		//вяжи(функция_1698)("_SetClientTimeZoneInformation", биб);

		//вяжи(функция_1699)("_SetCommBreak", биб);

		//вяжи(функция_1700)("_SetCommConfig", биб);

		//вяжи(функция_1701)("_SetCommMask", биб);

		//вяжи(функция_1702)("_SetCommState", биб);

		//вяжи(функция_1703)("_SetCommTimeouts", биб);

		//вяжи(функция_1704)("_SetComPlusPackageInstallStatus", биб);

		//вяжи(функция_1705)("_SetComputerNameA", биб);

		//вяжи(функция_1706)("_SetComputerNameExA", биб);

		//вяжи(функция_1707)("_SetComputerNameExW", биб);

		//вяжи(функция_1708)("_SetComputerNameW", биб);

		//вяжи(функция_1709)("_SetConsoleActiveScreenBuffer", биб);

		//вяжи(функция_1710)("_SetConsoleCommandHistoryMode", биб);

		//вяжи(функция_1711)("_SetConsoleCP", биб);

		//вяжи(функция_1712)("_SetConsoleCtrlHandler", биб);

		//вяжи(функция_1713)("_SetConsoleCursor", биб);

		//вяжи(функция_1714)("_SetConsoleCursorInfo", биб);

		//вяжи(функция_1715)("_SetConsoleCursorMode", биб);

		//вяжи(функция_1716)("_SetConsoleCursorPosition", биб);

		//вяжи(функция_1717)("_SetConsoleDisplayMode", биб);

		//вяжи(функция_1718)("_SetConsoleFont", биб);

		//вяжи(функция_1719)("_SetConsoleHardwareState", биб);

		//вяжи(функция_1720)("_SetConsoleIcon", биб);

		//вяжи(функция_1721)("_SetConsoleInputExeNameA", биб);

		//вяжи(функция_1722)("_SetConsoleInputExeNameW", биб);

		//вяжи(функция_1723)("_SetConsoleKeyShortcuts", биб);

		//вяжи(функция_1724)("_SetConsoleLocalEUDC", биб);

		//вяжи(функция_1725)("_SetConsoleMaximumWindowSize", биб);

		//вяжи(функция_1726)("_SetConsoleMenuClose", биб);

		//вяжи(функция_1727)("_SetConsoleMode", биб);

		//вяжи(функция_1728)("_SetConsoleNlsMode", биб);

		//вяжи(функция_1729)("_SetConsoleNumberOfCommandsA", биб);

		//вяжи(функция_1730)("_SetConsoleNumberOfCommandsW", биб);

		//вяжи(функция_1731)("_SetConsoleOS2OemFormat", биб);

		//вяжи(функция_1732)("_SetConsoleOutputCP", биб);

		//вяжи(функция_1733)("_SetConsolePalette", биб);

		//вяжи(функция_1734)("_SetConsoleScreenBufferSize", биб);

		//вяжи(функция_1735)("_SetConsoleTextAttribute", биб);

		//вяжи(функция_1736)("_SetConsoleTitleA", биб);

		//вяжи(функция_1737)("_SetConsoleTitleW", биб);

		//вяжи(функция_1738)("_SetConsoleWindowInfo", биб);

		//вяжи(функция_1739)("_SetCPGlobal", биб);

		//вяжи(функция_1740)("_SetCriticalSectionSpinCount", биб);

		//вяжи(функция_1741)("_SetCurrentDirectoryA", биб);

		//вяжи(функция_1742)("_SetCurrentDirectoryW", биб);

		//вяжи(функция_1743)("_SetDefaultCommConfigA", биб);

		//вяжи(функция_1744)("_SetDefaultCommConfigW", биб);

		//вяжи(функция_1745)("_SetDllDirectoryA", биб);

		//вяжи(функция_1746)("_SetDllDirectoryW", биб);

		//вяжи(функция_1747)("_SetEndOfFile", биб);

		//вяжи(функция_1748)("_SetEnvironmentVariableA", биб);

		//вяжи(функция_1749)("_SetEnvironmentVariableW", биб);

		//вяжи(функция_1750)("_SetErrorMode", биб);

		//вяжи(функция_1751)("_SetEvent", биб);

		//вяжи(функция_1752)("_SetFileApisToANSI", биб);

		//вяжи(функция_1753)("_SetFileApisToOEM", биб);

		//вяжи(функция_1754)("_SetFileAttributesA", биб);

		//вяжи(функция_1755)("_SetFileAttributesW", биб);

		//вяжи(функция_1756)("_SetFilePointer", биб);

		//вяжи(функция_1757)("_SetFilePointerEx", биб);

		//вяжи(функция_1758)("_SetFileShortNameA", биб);

		//вяжи(функция_1759)("_SetFileShortNameW", биб);

		//вяжи(функция_1760)("_SetFileTime", биб);

		//вяжи(функция_1761)("_SetFileValidData", биб);

		//вяжи(функция_1762)("_SetFirmwareEnvironmentVariableA", биб);

		//вяжи(функция_1763)("_SetFirmwareEnvironmentVariableW", биб);

		//вяжи(функция_1764)("_SetHandleContext", биб);

		//вяжи(функция_1765)("_SetHandleCount", биб);

		//вяжи(функция_1766)("_SetHandleInformation", биб);

		//вяжи(функция_1767)("_SetInformationJobObject", биб);

		//вяжи(функция_1768)("_SetLastConsoleEventActive", биб);

		//вяжи(функция_1769)("_SetLastError", биб);

		//вяжи(функция_1770)("_SetLocaleInfoA", биб);

		//вяжи(функция_1771)("_SetLocaleInfoW", биб);

		//вяжи(функция_1772)("_SetLocalPrimaryComputerNameA", биб);

		//вяжи(функция_1773)("_SetLocalPrimaryComputerNameW", биб);

		//вяжи(функция_1774)("_SetLocalTime", биб);

		//вяжи(функция_1775)("_SetMailslotInfo", биб);

		//вяжи(функция_1776)("_SetMessageWaitingIndicator", биб);

		//вяжи(функция_1777)("_SetNamedPipeHandleState", биб);

		//вяжи(функция_1778)("_SetPriorityClass", биб);

		//вяжи(функция_1779)("_SetProcessAffinityMask", биб);

		//вяжи(функция_1780)("_SetProcessDEPPolicy", биб);

		//вяжи(функция_1781)("_SetProcessPriorityBoost", биб);

		//вяжи(функция_1782)("_SetProcessShutdownParameters", биб);

		//вяжи(функция_1783)("_SetProcessWorkingSetSize", биб);

		//вяжи(функция_1784)("_SetStdHandle", биб);

		//вяжи(функция_1785)("_SetSystemPowerState", биб);

		//вяжи(функция_1786)("_SetSystemTime", биб);

		//вяжи(функция_1787)("_SetSystemTimeAdjustment", биб);

		//вяжи(функция_1788)("_SetTapeParameters", биб);

		//вяжи(функция_1789)("_SetTapePosition", биб);

		//вяжи(функция_1790)("_SetTermsrvAppInstallMode", биб);

		//вяжи(функция_1791)("_SetThreadAffinityMask", биб);

		//вяжи(функция_1792)("_SetThreadContext", биб);

		//вяжи(функция_1793)("_SetThreadExecutionState", биб);

		//вяжи(функция_1794)("_SetThreadIdealProcessor", биб);

		//вяжи(функция_1795)("_SetThreadLocale", биб);

		//вяжи(функция_1796)("_SetThreadPriority", биб);

		//вяжи(функция_1797)("_SetThreadPriorityBoost", биб);

		//вяжи(функция_1798)("_SetThreadUILanguage", биб);

		//вяжи(функция_1799)("_SetTimerQueueTimer", биб);

		//вяжи(функция_1800)("_SetTimeZoneInformation", биб);

		//вяжи(функция_1801)("_SetUnhandledExceptionFilter", биб);

		//вяжи(функция_1802)("_SetupComm", биб);

		//вяжи(функция_1803)("_SetUserGeoID", биб);

		//вяжи(функция_1804)("_SetVDMCurrentDirectories", биб);

		//вяжи(функция_1805)("_SetVolumeLabelA", биб);

		//вяжи(функция_1806)("_SetVolumeLabelW", биб);

		//вяжи(функция_1807)("_SetVolumeMountPointA", биб);

		//вяжи(функция_1808)("_SetVolumeMountPointW", биб);

		//вяжи(функция_1809)("_SetWaitableTimer", биб);

		//вяжи(функция_1810)("_ShowConsoleCursor", биб);

		//вяжи(функция_1811)("_SignalObjectAndWait", биб);

		//вяжи(функция_1812)("_SizeofResource", биб);

		//вяжи(функция_1813)("_Sleep", биб);

		//вяжи(функция_1814)("_SleepEx", биб);

		//вяжи(функция_1815)("_SuspendThread", биб);

		//вяжи(функция_1816)("_SwitchToFiber", биб);

		//вяжи(функция_1817)("_SwitchToThread", биб);

		//вяжи(функция_1818)("_SystemTimeToFileTime", биб);

		//вяжи(функция_1819)("_SystemTimeToTzSpecificLocalTime", биб);

		//вяжи(функция_1820)("_TerminateJobObject", биб);

		//вяжи(функция_1821)("_TerminateProcess", биб);

		//вяжи(функция_1822)("_TerminateThread", биб);

		//вяжи(функция_1823)("_TermsrvAppInstallMode", биб);

		//вяжи(функция_1824)("_Thread32First", биб);

		//вяжи(функция_1825)("_Thread32Next", биб);

		//вяжи(функция_1826)("_TlsAlloc", биб);

		//вяжи(функция_1827)("_TlsFree", биб);

		//вяжи(функция_1828)("_TlsGetValue", биб);

		//вяжи(функция_1829)("_TlsSetValue", биб);

		//вяжи(функция_1830)("_Toolhelp32ReadProcessMemory", биб);

		//вяжи(функция_1831)("_TransactNamedPipe", биб);

		//вяжи(функция_1832)("_TransmitCommChar", биб);

		//вяжи(функция_1833)("_TrimVirtualBuffer", биб);

		//вяжи(функция_1834)("_TryEnterCriticalSection", биб);

		//вяжи(функция_1835)("_TzSpecificLocalTimeToSystemTime", биб);

		//вяжи(функция_1836)("_UnhandledExceptionFilter", биб);

		//вяжи(функция_1837)("_UnlockFile", биб);

		//вяжи(функция_1838)("_UnlockFileEx", биб);

		//вяжи(функция_1839)("_UnmapViewOfFile", биб);

		//вяжи(функция_1840)("_UnregisterConsoleIME", биб);

		//вяжи(функция_1841)("_UnregisterWait", биб);

		//вяжи(функция_1842)("_UnregisterWaitEx", биб);

		//вяжи(функция_1843)("_UpdateResourceA", биб);

		//вяжи(функция_1844)("_UpdateResourceW", биб);

		//вяжи(функция_1845)("_UTRegister", биб);

		//вяжи(функция_1846)("_UTUnRegister", биб);

		//вяжи(функция_1847)("_ValidateLCType", биб);

		//вяжи(функция_1848)("_ValidateLocale", биб);

		//вяжи(функция_1849)("_VDMConsoleOperation", биб);

		//вяжи(функция_1850)("_VDMOperationStarted", биб);

		//вяжи(функция_1851)("_VerifyConsoleIoHandle", биб);

		//вяжи(функция_1852)("_VerifyVersionInfoA", биб);

		//вяжи(функция_1853)("_VerifyVersionInfoW", биб);

		//вяжи(функция_1854)("_VerLanguageNameA", биб);

		//вяжи(функция_1855)("_VerLanguageNameW", биб);

		//вяжи(функция_1856)("_VerSetConditionMask", биб);

		//вяжи(функция_1857)("_VirtualAlloc", биб);

		//вяжи(функция_1858)("_VirtualAllocEx", биб);

		//вяжи(функция_1859)("_VirtualBufferExceptionHandler", биб);

		//вяжи(функция_1860)("_VirtualFree", биб);

		//вяжи(функция_1861)("_VirtualFreeEx", биб);

		//вяжи(функция_1862)("_VirtualLock", биб);

		//вяжи(функция_1863)("_VirtualProtect", биб);

		//вяжи(функция_1864)("_VirtualProtectEx", биб);

		//вяжи(функция_1865)("_VirtualQuery", биб);

		//вяжи(функция_1866)("_VirtualQueryEx", биб);

		//вяжи(функция_1867)("_VirtualUnlock", биб);

		//вяжи(функция_1868)("_WaitCommEvent", биб);

		//вяжи(функция_1869)("_WaitForDebugEvent", биб);

		//вяжи(функция_1870)("_WaitForMultipleObjects", биб);

		//вяжи(функция_1871)("_WaitForMultipleObjectsEx", биб);

		//вяжи(функция_1872)("_WaitForSingleObject", биб);

		//вяжи(функция_1873)("_WaitForSingleObjectEx", биб);

		//вяжи(функция_1874)("_WaitNamedPipeA", биб);

		//вяжи(функция_1875)("_WaitNamedPipeW", биб);

		//вяжи(функция_1876)("_WideCharToMultiByte", биб);

		//вяжи(функция_1877)("_WinExec", биб);

		//вяжи(функция_1878)("_WriteConsoleA", биб);

		//вяжи(функция_1879)("_WriteConsoleInputA", биб);

		//вяжи(функция_1880)("_WriteConsoleInputVDMA", биб);

		//вяжи(функция_1881)("_WriteConsoleInputVDMW", биб);

		//вяжи(функция_1882)("_WriteConsoleInputW", биб);

		//вяжи(функция_1883)("_WriteConsoleOutputA", биб);

		//вяжи(функция_1884)("_WriteConsoleOutputAttribute", биб);

		//вяжи(функция_1885)("_WriteConsoleOutputCharacterA", биб);

		//вяжи(функция_1886)("_WriteConsoleOutputCharacterW", биб);

		//вяжи(функция_1887)("_WriteConsoleOutputW", биб);

		//вяжи(функция_1888)("_WriteConsoleW", биб);

		//вяжи(функция_1889)("_WriteFile", биб);

		//вяжи(функция_1890)("_WriteFileEx", биб);

		//вяжи(функция_1891)("_WriteFileGather", биб);

		//вяжи(функция_1892)("_WritePrivateProfileSectionA", биб);

		//вяжи(функция_1893)("_WritePrivateProfileSectionW", биб);

		//вяжи(функция_1894)("_WritePrivateProfileStringA", биб);

		//вяжи(функция_1895)("_WritePrivateProfileStringW", биб);

		//вяжи(функция_1896)("_WritePrivateProfileStructA", биб);

		//вяжи(функция_1897)("_WritePrivateProfileStructW", биб);

		//вяжи(функция_1898)("_WriteProcessMemory", биб);

		//вяжи(функция_1899)("_WriteProfileSectionA", биб);

		//вяжи(функция_1900)("_WriteProfileSectionW", биб);

		//вяжи(функция_1901)("_WriteProfileStringA", биб);

		//вяжи(функция_1902)("_WriteProfileStringW", биб);

		//вяжи(функция_1903)("_WriteTapemark", биб);

		//вяжи(функция_1904)("_WTSGetActiveConsoleSessionId", биб);

		//вяжи(функция_1905)("_ZombifyActCtx", биб);

	}

ЖанБибгр KERNEL32;

		static this()
		{
			KERNEL32.заряжай("kernel32.dll", &грузи );
			KERNEL32.загружай();
		}

	extern(Windows)
	{


		//проц function(   ) функция_1; 

		//проц function(   ) функция_2; 

		//проц function(   ) функция_3; 

		//проц function(   ) функция_4; 

		//проц function(   ) функция_5; 

		//проц function(   ) функция_6; 

		//проц function(   ) функция_7; 

		//проц function(   ) функция_8; 

		бул function(ук актКткст, бцел** куки)
		АктивируйАктКткс; 

		АТОМ function(ткст атом)
		ДобавьАтомА; 

		АТОМ function(шткст атом)
		ДобавьАтом; 

		//проц function(   ) функция_12; 

		//проц function(   ) функция_13; 

		ПОшибка function(ткст днсИмяХоста, бцел флаги = 0) ДобавьЛокальноеАльтернативноеИмяКомпьютераА; 

		ПОшибка function(шткст днсИмяХоста, бцел флаги = 0) ДобавьЛокальноеАльтернативноеИмяКомпьютера; 

		проц function(ук актКткст)
		ДобавьСсылАктКткс; 

		ук function(бцел первОбр, ВЕКТОРНЫЙ_ОБРАБОТЧИК_ИСКЛЮЧЕНИЯ векОбрИскл) ДобавьВекторныйОбработчикИсключения; 

		проц function(ук процесс, бцел *члоСтр, бцел *члоФреймовСтр) РазместиФизическиеСтраницыПользователя; 

		бул function()
		РазместиКонсоль; 

		бул function()
		ФайлВВФцииИспользуютАНЗИ; 

		//проц function(   ) ПрисвойПроцессДжобОбъекту; 

		//проц function(   ) ПрикрепиКонсоль; 

		//проц function(   ) БэкапЧитай; 

		//проц function(   ) БэкапСместись; 

		//проц function(   ) БэкапПиши; 

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

		бул function(бцел герц, бцел мсек)
		Звук; 

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

		//проц function(   ) функция_48; 

		//проц function(   ) функция_49; 

		//проц function(   ) функция_50; 

		//проц function(   ) функция_51; 

		//проц function(   ) функция_52; 

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

		//проц function(   ) функция_147; 

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

		//проц function(   ) функция_248; 

		//проц function(   ) функция_249; 

		//проц function(   ) функция_250; 

		//проц function(   ) функция_251; 

		//проц function(   ) функция_252; 

		//проц function(   ) функция_253; 

		//проц function(   ) функция_254; 

		//проц function(   ) функция_255; 

		//проц function(   ) функция_256; 

		//проц function(   ) функция_257; 

		//проц function(   ) функция_258; 

		//проц function(   ) функция_259; 

		//проц function(   ) функция_260; 

		//проц function(   ) функция_261; 

		//проц function(   ) функция_262; 

		//проц function(   ) функция_263; 

		//проц function(   ) функция_264; 

		//проц function(   ) функция_265; 

		//проц function(   ) функция_266; 

		//проц function(   ) функция_267; 

		//проц function(   ) функция_268; 

		//проц function(   ) функция_269; 

		//проц function(   ) функция_270; 

		//проц function(   ) функция_271; 

		//проц function(   ) функция_272; 

		//проц function(   ) функция_273; 

		//проц function(   ) функция_274; 

		//проц function(   ) функция_275; 

		//проц function(   ) функция_276; 

		//проц function(   ) функция_277; 

		//проц function(   ) функция_278; 

		//проц function(   ) функция_279; 

		//проц function(   ) функция_280; 

		//проц function(   ) функция_281; 

		//проц function(   ) функция_282; 

		//проц function(   ) функция_283; 

		//проц function(   ) функция_284; 

		//проц function(   ) функция_285; 

		//проц function(   ) функция_286; 

		//проц function(   ) функция_287; 

		//проц function(   ) функция_288; 

		//проц function(   ) функция_289; 

		//проц function(   ) функция_290; 

		//проц function(   ) функция_291; 

		//проц function(   ) функция_292; 

		//проц function(   ) функция_293; 

		//проц function(   ) функция_294; 

		//проц function(   ) функция_295; 

		//проц function(   ) функция_296; 

		//проц function(   ) функция_297; 

		//проц function(   ) функция_298; 

		//проц function(   ) функция_299; 

		//проц function(   ) функция_300; 

		//проц function(   ) функция_301; 

		//проц function(   ) функция_302; 

		//проц function(   ) функция_303; 

		//проц function(   ) функция_304; 

		//проц function(   ) функция_305; 

		//проц function(   ) функция_306; 

		//проц function(   ) функция_307; 

		//проц function(   ) функция_308; 

		//проц function(   ) функция_309; 

		//проц function(   ) функция_310; 

		//проц function(   ) функция_311; 

		//проц function(   ) функция_312; 

		//проц function(   ) функция_313; 

		//проц function(   ) функция_314; 

		//проц function(   ) функция_315; 

		//проц function(   ) функция_316; 

		//проц function(   ) функция_317; 

		//проц function(   ) функция_318; 

		//проц function(   ) функция_319; 

		//проц function(   ) функция_320; 

		//проц function(   ) функция_321; 

		//проц function(   ) функция_322; 

		//проц function(   ) функция_323; 

		//проц function(   ) функция_324; 

		//проц function(   ) функция_325; 

		//проц function(   ) функция_326; 

		//проц function(   ) функция_327; 

		//проц function(   ) функция_328; 

		//проц function(   ) функция_329; 

		//проц function(   ) функция_330; 

		//проц function(   ) функция_331; 

		//проц function(   ) функция_332; 

		//проц function(   ) функция_333; 

		//проц function(   ) функция_334; 

		//проц function(   ) функция_335; 

		//проц function(   ) функция_336; 

		//проц function(   ) функция_337; 

		//проц function(   ) функция_338; 

		//проц function(   ) функция_339; 

		//проц function(   ) функция_340; 

		//проц function(   ) функция_341; 

		//проц function(   ) функция_342; 

		//проц function(   ) функция_343; 

		//проц function(   ) функция_344; 

		//проц function(   ) функция_345; 

		//проц function(   ) функция_346; 

		//проц function(   ) функция_347; 

		//проц function(   ) функция_348; 

		//проц function(   ) функция_349; 

		//проц function(   ) функция_350; 

		//проц function(   ) функция_351; 

		//проц function(   ) функция_352; 

		//проц function(   ) функция_353; 

		//проц function(   ) функция_354; 

		//проц function(   ) функция_355; 

		//проц function(   ) функция_356; 

		//проц function(   ) функция_357; 

		//проц function(   ) функция_358; 

		//проц function(   ) функция_359; 

		//проц function(   ) функция_360; 

		//проц function(   ) функция_361; 

		//проц function(   ) функция_362; 

		//проц function(   ) функция_363; 

		//проц function(   ) функция_364; 

		//проц function(   ) функция_365; 

		//проц function(   ) функция_366; 

		//проц function(   ) функция_367; 

		//проц function(   ) функция_368; 

		//проц function(   ) функция_369; 

		//проц function(   ) функция_370; 

		//проц function(   ) функция_371; 

		//проц function(   ) функция_372; 

		//проц function(   ) функция_373; 

		//проц function(   ) функция_374; 

		//проц function(   ) функция_375; 

		//проц function(   ) функция_376; 

		//проц function(   ) функция_377; 

		//проц function(   ) функция_378; 

		//проц function(   ) функция_379; 

		//проц function(   ) функция_380; 

		//проц function(   ) функция_381; 

		//проц function(   ) функция_382; 

		//проц function(   ) функция_383; 

		//проц function(   ) функция_384; 

		//проц function(   ) функция_385; 

		//проц function(   ) функция_386; 

		//проц function(   ) функция_387; 

		//проц function(   ) функция_388; 

		//проц function(   ) функция_389; 

		//проц function(   ) функция_390; 

		//проц function(   ) функция_391; 

		//проц function(   ) функция_392; 

		//проц function(   ) функция_393; 

		//проц function(   ) функция_394; 

		//проц function(   ) функция_395; 

		//проц function(   ) функция_396; 

		//проц function(   ) функция_397; 

		//проц function(   ) функция_398; 

		//проц function(   ) функция_399; 

		//проц function(   ) функция_400; 

		//проц function(   ) функция_401; 

		//проц function(   ) функция_402; 

		//проц function(   ) функция_403; 

		//проц function(   ) функция_404; 

		//проц function(   ) функция_405; 

		//проц function(   ) функция_406; 

		//проц function(   ) функция_407; 

		//проц function(   ) функция_408; 

		//проц function(   ) функция_409; 

		//проц function(   ) функция_410; 

		//проц function(   ) функция_411; 

		//проц function(   ) функция_412; 

		//проц function(   ) функция_413; 

		//проц function(   ) функция_414; 

		//проц function(   ) функция_415; 

		//проц function(   ) функция_416; 

		//проц function(   ) функция_417; 

		//проц function(   ) функция_418; 

		//проц function(   ) функция_419; 

		//проц function(   ) функция_420; 

		//проц function(   ) функция_421; 

		//проц function(   ) функция_422; 

		//проц function(   ) функция_423; 

		//проц function(   ) функция_424; 

		//проц function(   ) функция_425; 

		//проц function(   ) функция_426; 

		//проц function(   ) функция_427; 

		//проц function(   ) функция_428; 

		//проц function(   ) функция_429; 

		//проц function(   ) функция_430; 

		//проц function(   ) функция_431; 

		//проц function(   ) функция_432; 

		//проц function(   ) функция_433; 

		//проц function(   ) функция_434; 

		//проц function(   ) функция_435; 

		//проц function(   ) функция_436; 

		//проц function(   ) функция_437; 

		//проц function(   ) функция_438; 

		//проц function(   ) функция_439; 

		//проц function(   ) функция_440; 

		//проц function(   ) функция_441; 

		//проц function(   ) функция_442; 

		//проц function(   ) функция_443; 

		//проц function(   ) функция_444; 

		//проц function(   ) функция_445; 

		//проц function(   ) функция_446; 

		//проц function(   ) функция_447; 

		//проц function(   ) функция_448; 

		//проц function(   ) функция_449; 

		//проц function(   ) функция_450; 

		//проц function(   ) функция_451; 

		//проц function(   ) функция_452; 

		//проц function(   ) функция_453; 

		//проц function(   ) функция_454; 

		//проц function(   ) функция_455; 

		//проц function(   ) функция_456; 

		//проц function(   ) функция_457; 

		//проц function(   ) функция_458; 

		//проц function(   ) функция_459; 

		//проц function(   ) функция_460; 

		//проц function(   ) функция_461; 

		//проц function(   ) функция_462; 

		//проц function(   ) функция_463; 

		//проц function(   ) функция_464; 

		//проц function(   ) функция_465; 

		//проц function(   ) функция_466; 

		//проц function(   ) функция_467; 

		//проц function(   ) функция_468; 

		//проц function(   ) функция_469; 

		//проц function(   ) функция_470; 

		//проц function(   ) функция_471; 

		//проц function(   ) функция_472; 

		//проц function(   ) функция_473; 

		//проц function(   ) функция_474; 

		//проц function(   ) функция_475; 

		//проц function(   ) функция_476; 

		//проц function(   ) функция_477; 

		//проц function(   ) функция_478; 

		//проц function(   ) функция_479; 

		//проц function(   ) функция_480; 

		//проц function(   ) функция_481; 

		//проц function(   ) функция_482; 

		//проц function(   ) функция_483; 

		//проц function(   ) функция_484; 

		//проц function(   ) функция_485; 

		//проц function(   ) функция_486; 

		//проц function(   ) функция_487; 

		//проц function(   ) функция_488; 

		//проц function(   ) функция_489; 

		//проц function(   ) функция_490; 

		//проц function(   ) функция_491; 

		//проц function(   ) функция_492; 

		//проц function(   ) функция_493; 

		//проц function(   ) функция_494; 

		//проц function(   ) функция_495; 

		//проц function(   ) функция_496; 

		//проц function(   ) функция_497; 

		//проц function(   ) функция_498; 

		//проц function(   ) функция_499; 

		//проц function(   ) функция_500; 

		//проц function(   ) функция_501; 

		//проц function(   ) функция_502; 

		//проц function(   ) функция_503; 

		//проц function(   ) функция_504; 

		//проц function(   ) функция_505; 

		//проц function(   ) функция_506; 

		//проц function(   ) функция_507; 

		//проц function(   ) функция_508; 

		//проц function(   ) функция_509; 

		//проц function(   ) функция_510; 

		//проц function(   ) функция_511; 

		//проц function(   ) функция_512; 

		//проц function(   ) функция_513; 

		//проц function(   ) функция_514; 

		//проц function(   ) функция_515; 

		//проц function(   ) функция_516; 

		//проц function(   ) функция_517; 

		//проц function(   ) функция_518; 

		//проц function(   ) функция_519; 

		//проц function(   ) функция_520; 

		//проц function(   ) функция_521; 

		//проц function(   ) функция_522; 

		//проц function(   ) функция_523; 

		//проц function(   ) функция_524; 

		//проц function(   ) функция_525; 

		//проц function(   ) функция_526; 

		//проц function(   ) функция_527; 

		//проц function(   ) функция_528; 

		//проц function(   ) функция_529; 

		//проц function(   ) функция_530; 

		//проц function(   ) функция_531; 

		//проц function(   ) функция_532; 

		//проц function(   ) функция_533; 

		//проц function(   ) функция_534; 

		//проц function(   ) функция_535; 

		//проц function(   ) функция_536; 

		//проц function(   ) функция_537; 

		//проц function(   ) функция_538; 

		//проц function(   ) функция_539; 

		//проц function(   ) функция_540; 

		//проц function(   ) функция_541; 

		//проц function(   ) функция_542; 

		//проц function(   ) функция_543; 

		//проц function(   ) функция_544; 

		//проц function(   ) функция_545; 

		//проц function(   ) функция_546; 

		//проц function(   ) функция_547; 

		//проц function(   ) функция_548; 

		//проц function(   ) функция_549; 

		//проц function(   ) функция_550; 

		//проц function(   ) функция_551; 

		//проц function(   ) функция_552; 

		//проц function(   ) функция_553; 

		//проц function(   ) функция_554; 

		//проц function(   ) функция_555; 

		//проц function(   ) функция_556; 

		//проц function(   ) функция_557; 

		//проц function(   ) функция_558; 

		//проц function(   ) функция_559; 

		//проц function(   ) функция_560; 

		//проц function(   ) функция_561; 

		//проц function(   ) функция_562; 

		//проц function(   ) функция_563; 

		//проц function(   ) функция_564; 

		//проц function(   ) функция_565; 

		//проц function(   ) функция_566; 

		//проц function(   ) функция_567; 

		//проц function(   ) функция_568; 

		//проц function(   ) функция_569; 

		//проц function(   ) функция_570; 

		//проц function(   ) функция_571; 

		//проц function(   ) функция_572; 

		//проц function(   ) функция_573; 

		//проц function(   ) функция_574; 

		//проц function(   ) функция_575; 

		//проц function(   ) функция_576; 

		//проц function(   ) функция_577; 

		//проц function(   ) функция_578; 

		//проц function(   ) функция_579; 

		//проц function(   ) функция_580; 

		//проц function(   ) функция_581; 

		//проц function(   ) функция_582; 

		//проц function(   ) функция_583; 

		//проц function(   ) функция_584; 

		//проц function(   ) функция_585; 

		//проц function(   ) функция_586; 

		//проц function(   ) функция_587; 

		//проц function(   ) функция_588; 

		//проц function(   ) функция_589; 

		//проц function(   ) функция_590; 

		//проц function(   ) функция_591; 

		//проц function(   ) функция_592; 

		//проц function(   ) функция_593; 

		//проц function(   ) функция_594; 

		//проц function(   ) функция_595; 

		//проц function(   ) функция_596; 

		//проц function(   ) функция_597; 

		//проц function(   ) функция_598; 

		//проц function(   ) функция_599; 

		//проц function(   ) функция_600; 

		//проц function(   ) функция_601; 

		//проц function(   ) функция_602; 

		//проц function(   ) функция_603; 

		//проц function(   ) функция_604; 

		//проц function(   ) функция_605; 

		//проц function(   ) функция_606; 

		//проц function(   ) функция_607; 

		//проц function(   ) функция_608; 

		//проц function(   ) функция_609; 

		//проц function(   ) функция_610; 

		//проц function(   ) функция_611; 

		//проц function(   ) функция_612; 

		//проц function(   ) функция_613; 

		//проц function(   ) функция_614; 

		//проц function(   ) функция_615; 

		//проц function(   ) функция_616; 

		//проц function(   ) функция_617; 

		//проц function(   ) функция_618; 

		//проц function(   ) функция_619; 

		//проц function(   ) функция_620; 

		//проц function(   ) функция_621; 

		//проц function(   ) функция_622; 

		//проц function(   ) функция_623; 

		//проц function(   ) функция_624; 

		//проц function(   ) функция_625; 

		//проц function(   ) функция_626; 

		//проц function(   ) функция_627; 

		//проц function(   ) функция_628; 

		//проц function(   ) функция_629; 

		//проц function(   ) функция_630; 

		//проц function(   ) функция_631; 

		//проц function(   ) функция_632; 

		//проц function(   ) функция_633; 

		//проц function(   ) функция_634; 

		//проц function(   ) функция_635; 

		//проц function(   ) функция_636; 

		//проц function(   ) функция_637; 

		//проц function(   ) функция_638; 

		//проц function(   ) функция_639; 

		//проц function(   ) функция_640; 

		//проц function(   ) функция_641; 

		//проц function(   ) функция_642; 

		//проц function(   ) функция_643; 

		//проц function(   ) функция_644; 

		//проц function(   ) функция_645; 

		//проц function(   ) функция_646; 

		//проц function(   ) функция_647; 

		//проц function(   ) функция_648; 

		//проц function(   ) функция_649; 

		//проц function(   ) функция_650; 

		//проц function(   ) функция_651; 

		//проц function(   ) функция_652; 

		//проц function(   ) функция_653; 

		//проц function(   ) функция_654; 

		//проц function(   ) функция_655; 

		//проц function(   ) функция_656; 

		//проц function(   ) функция_657; 

		//проц function(   ) функция_658; 

		//проц function(   ) функция_659; 

		//проц function(   ) функция_660; 

		//проц function(   ) функция_661; 

		//проц function(   ) функция_662; 

		//проц function(   ) функция_663; 

		//проц function(   ) функция_664; 

		//проц function(   ) функция_665; 

		//проц function(   ) функция_666; 

		//проц function(   ) функция_667; 

		//проц function(   ) функция_668; 

		//проц function(   ) функция_669; 

		//проц function(   ) функция_670; 

		//проц function(   ) функция_671; 

		//проц function(   ) функция_672; 

		//проц function(   ) функция_673; 

		//проц function(   ) функция_674; 

		//проц function(   ) функция_675; 

		//проц function(   ) функция_676; 

		//проц function(   ) функция_677; 

		//проц function(   ) функция_678; 

		//проц function(   ) функция_679; 

		//проц function(   ) функция_680; 

		//проц function(   ) функция_681; 

		//проц function(   ) функция_682; 

		//проц function(   ) функция_683; 

		//проц function(   ) функция_684; 

		//проц function(   ) функция_685; 

		//проц function(   ) функция_686; 

		//проц function(   ) функция_687; 

		//проц function(   ) функция_688; 

		//проц function(   ) функция_689; 

		//проц function(   ) функция_690; 

		//проц function(   ) функция_691; 

		//проц function(   ) функция_692; 

		//проц function(   ) функция_693; 

		//проц function(   ) функция_694; 

		//проц function(   ) функция_695; 

		//проц function(   ) функция_696; 

		//проц function(   ) функция_697; 

		//проц function(   ) функция_698; 

		//проц function(   ) функция_699; 

		//проц function(   ) функция_700; 

		//проц function(   ) функция_701; 

		//проц function(   ) функция_702; 

		//проц function(   ) функция_703; 

		//проц function(   ) функция_704; 

		//проц function(   ) функция_705; 

		//проц function(   ) функция_706; 

		//проц function(   ) функция_707; 

		//проц function(   ) функция_708; 

		//проц function(   ) функция_709; 

		//проц function(   ) функция_710; 

		//проц function(   ) функция_711; 

		//проц function(   ) функция_712; 

		//проц function(   ) функция_713; 

		//проц function(   ) функция_714; 

		//проц function(   ) функция_715; 

		//проц function(   ) функция_716; 

		//проц function(   ) функция_717; 

		//проц function(   ) функция_718; 

		//проц function(   ) функция_719; 

		//проц function(   ) функция_720; 

		//проц function(   ) функция_721; 

		//проц function(   ) функция_722; 

		//проц function(   ) функция_723; 

		//проц function(   ) функция_724; 

		//проц function(   ) функция_725; 

		//проц function(   ) функция_726; 

		//проц function(   ) функция_727; 

		//проц function(   ) функция_728; 

		//проц function(   ) функция_729; 

		//проц function(   ) функция_730; 

		//проц function(   ) функция_731; 

		//проц function(   ) функция_732; 

		//проц function(   ) функция_733; 

		//проц function(   ) функция_734; 

		//проц function(   ) функция_735; 

		//проц function(   ) функция_736; 

		//проц function(   ) функция_737; 

		//проц function(   ) функция_738; 

		//проц function(   ) функция_739; 

		//проц function(   ) функция_740; 

		//проц function(   ) функция_741; 

		//проц function(   ) функция_742; 

		//проц function(   ) функция_743; 

		//проц function(   ) функция_744; 

		//проц function(   ) функция_745; 

		//проц function(   ) функция_746; 

		//проц function(   ) функция_747; 

		//проц function(   ) функция_748; 

		//проц function(   ) функция_749; 

		//проц function(   ) функция_750; 

		//проц function(   ) функция_751; 

		//проц function(   ) функция_752; 

		//проц function(   ) функция_753; 

		//проц function(   ) функция_754; 

		//проц function(   ) функция_755; 

		//проц function(   ) функция_756; 

		//проц function(   ) функция_757; 

		//проц function(   ) функция_758; 

		//проц function(   ) функция_759; 

		//проц function(   ) функция_760; 

		//проц function(   ) функция_761; 

		//проц function(   ) функция_762; 

		//проц function(   ) функция_763; 

		//проц function(   ) функция_764; 

		//проц function(   ) функция_765; 

		//проц function(   ) функция_766; 

		//проц function(   ) функция_767; 

		//проц function(   ) функция_768; 

		//проц function(   ) функция_769; 

		//проц function(   ) функция_770; 

		//проц function(   ) функция_771; 

		//проц function(   ) функция_772; 

		//проц function(   ) функция_773; 

		//проц function(   ) функция_774; 

		//проц function(   ) функция_775; 

		//проц function(   ) функция_776; 

		//проц function(   ) функция_777; 

		//проц function(   ) функция_778; 

		//проц function(   ) функция_779; 

		//проц function(   ) функция_780; 

		//проц function(   ) функция_781; 

		//проц function(   ) функция_782; 

		//проц function(   ) функция_783; 

		//проц function(   ) функция_784; 

		//проц function(   ) функция_785; 

		//проц function(   ) функция_786; 

		//проц function(   ) функция_787; 

		//проц function(   ) функция_788; 

		//проц function(   ) функция_789; 

		//проц function(   ) функция_790; 

		//проц function(   ) функция_791; 

		//проц function(   ) функция_792; 

		//проц function(   ) функция_793; 

		//проц function(   ) функция_794; 

		//проц function(   ) функция_795; 

		//проц function(   ) функция_796; 

		//проц function(   ) функция_797; 

		//проц function(   ) функция_798; 

		//проц function(   ) функция_799; 

		//проц function(   ) функция_800; 

		//проц function(   ) функция_801; 

		//проц function(   ) функция_802; 

		//проц function(   ) функция_803; 

		//проц function(   ) функция_804; 

		//проц function(   ) функция_805; 

		//проц function(   ) функция_806; 

		//проц function(   ) функция_807; 

		//проц function(   ) функция_808; 

		//проц function(   ) функция_809; 

		//проц function(   ) функция_810; 

		//проц function(   ) функция_811; 

		//проц function(   ) функция_812; 

		//проц function(   ) функция_813; 

		//проц function(   ) функция_814; 

		//проц function(   ) функция_815; 

		//проц function(   ) функция_816; 

		//проц function(   ) функция_817; 

		//проц function(   ) функция_818; 

		//проц function(   ) функция_819; 

		//проц function(   ) функция_820; 

		//проц function(   ) функция_821; 

		//проц function(   ) функция_822; 

		//проц function(   ) функция_823; 

		//проц function(   ) функция_824; 

		//проц function(   ) функция_825; 

		//проц function(   ) функция_826; 

		//проц function(   ) функция_827; 

		//проц function(   ) функция_828; 

		//проц function(   ) функция_829; 

		//проц function(   ) функция_830; 

		//проц function(   ) функция_831; 

		//проц function(   ) функция_832; 

		//проц function(   ) функция_833; 

		//проц function(   ) функция_834; 

		//проц function(   ) функция_835; 

		//проц function(   ) функция_836; 

		//проц function(   ) функция_837; 

		//проц function(   ) функция_838; 

		//проц function(   ) функция_839; 

		//проц function(   ) функция_840; 

		//проц function(   ) функция_841; 

		//проц function(   ) функция_842; 

		//проц function(   ) функция_843; 

		//проц function(   ) функция_844; 

		//проц function(   ) функция_845; 

		//проц function(   ) функция_846; 

		//проц function(   ) функция_847; 

		//проц function(   ) функция_848; 

		//проц function(   ) функция_849; 

		//проц function(   ) функция_850; 

		//проц function(   ) функция_851; 

		//проц function(   ) функция_852; 

		//проц function(   ) функция_853; 

		//проц function(   ) функция_854; 

		//проц function(   ) функция_855; 

		//проц function(   ) функция_856; 

		//проц function(   ) функция_857; 

		//проц function(   ) функция_858; 

		//проц function(   ) функция_859; 

		//проц function(   ) функция_860; 

		//проц function(   ) функция_861; 

		//проц function(   ) функция_862; 

		//проц function(   ) функция_863; 

		//проц function(   ) функция_864; 

		//проц function(   ) функция_865; 

		//проц function(   ) функция_866; 

		//проц function(   ) функция_867; 

		//проц function(   ) функция_868; 

		//проц function(   ) функция_869; 

		//проц function(   ) функция_870; 

		//проц function(   ) функция_871; 

		//проц function(   ) функция_872; 

		//проц function(   ) функция_873; 

		//проц function(   ) функция_874; 

		//проц function(   ) функция_875; 

		//проц function(   ) функция_876; 

		//проц function(   ) функция_877; 

		//проц function(   ) функция_878; 

		//проц function(   ) функция_879; 

		//проц function(   ) функция_880; 

		//проц function(   ) функция_881; 

		//проц function(   ) функция_882; 

		//проц function(   ) функция_883; 

		//проц function(   ) функция_884; 

		//проц function(   ) функция_885; 

		//проц function(   ) функция_886; 

		//проц function(   ) функция_887; 

		//проц function(   ) функция_888; 

		//проц function(   ) функция_889; 

		//проц function(   ) функция_890; 

		//проц function(   ) функция_891; 

		//проц function(   ) функция_892; 

		//проц function(   ) функция_893; 

		//проц function(   ) функция_894; 

		//проц function(   ) функция_895; 

		//проц function(   ) функция_896; 

		//проц function(   ) функция_897; 

		//проц function(   ) функция_898; 

		//проц function(   ) функция_899; 

		//проц function(   ) функция_900; 

		//проц function(   ) функция_901; 

		//проц function(   ) функция_902; 

		//проц function(   ) функция_903; 

		//проц function(   ) функция_904; 

		//проц function(   ) функция_905; 

		//проц function(   ) функция_906; 

		//проц function(   ) функция_907; 

		//проц function(   ) функция_908; 

		//проц function(   ) функция_909; 

		//проц function(   ) функция_910; 

		//проц function(   ) функция_911; 

		//проц function(   ) функция_912; 

		//проц function(   ) функция_913; 

		//проц function(   ) функция_914; 

		//проц function(   ) функция_915; 

		//проц function(   ) функция_916; 

		//проц function(   ) функция_917; 

		//проц function(   ) функция_918; 

		//проц function(   ) функция_919; 

		//проц function(   ) функция_920; 

		//проц function(   ) функция_921; 

		//проц function(   ) функция_922; 

		//проц function(   ) функция_923; 

		//проц function(   ) функция_924; 

		//проц function(   ) функция_925; 

		//проц function(   ) функция_926; 

		//проц function(   ) функция_927; 

		//проц function(   ) функция_928; 

		//проц function(   ) функция_929; 

		//проц function(   ) функция_930; 

		//проц function(   ) функция_931; 

		//проц function(   ) функция_932; 

		//проц function(   ) функция_933; 

		//проц function(   ) функция_934; 

		//проц function(   ) функция_935; 

		//проц function(   ) функция_936; 

		//проц function(   ) функция_937; 

		//проц function(   ) функция_938; 

		//проц function(   ) функция_939; 

		//проц function(   ) функция_940; 

		//проц function(   ) функция_941; 

		//проц function(   ) функция_942; 

		//проц function(   ) функция_943; 

		//проц function(   ) функция_944; 

		//проц function(   ) функция_945; 

		//проц function(   ) функция_946; 

		//проц function(   ) функция_947; 

		//проц function(   ) функция_948; 

		//проц function(   ) функция_949; 

		//проц function(   ) функция_950; 

		//проц function(   ) функция_951; 

		//проц function(   ) функция_952; 

		//проц function(   ) функция_953; 

		//проц function(   ) функция_954; 

		//проц function(   ) функция_955; 

		//проц function(   ) функция_956; 

		//проц function(   ) функция_957; 

		//проц function(   ) функция_958; 

		//проц function(   ) функция_959; 

		//проц function(   ) функция_960; 

		//проц function(   ) функция_961; 

		//проц function(   ) функция_962; 

		//проц function(   ) функция_963; 

		//проц function(   ) функция_964; 

		//проц function(   ) функция_965; 

		//проц function(   ) функция_966; 

		//проц function(   ) функция_967; 

		//проц function(   ) функция_968; 

		//проц function(   ) функция_969; 

		//проц function(   ) функция_970; 

		//проц function(   ) функция_971; 

		//проц function(   ) функция_972; 

		//проц function(   ) функция_973; 

		//проц function(   ) функция_974; 

		//проц function(   ) функция_975; 

		//проц function(   ) функция_976; 

		//проц function(   ) функция_977; 

		//проц function(   ) функция_978; 

		//проц function(   ) функция_979; 

		//проц function(   ) функция_980; 

		//проц function(   ) функция_981; 

		//проц function(   ) функция_982; 

		//проц function(   ) функция_983; 

		//проц function(   ) функция_984; 

		//проц function(   ) функция_985; 

		//проц function(   ) функция_986; 

		//проц function(   ) функция_987; 

		//проц function(   ) функция_988; 

		//проц function(   ) функция_989; 

		//проц function(   ) функция_990; 

		//проц function(   ) функция_991; 

		//проц function(   ) функция_992; 

		//проц function(   ) функция_993; 

		//проц function(   ) функция_994; 

		//проц function(   ) функция_995; 

		//проц function(   ) функция_996; 

		//проц function(   ) функция_997; 

		//проц function(   ) функция_998; 

		//проц function(   ) функция_999; 

		//проц function(   ) функция_1000; 

		//проц function(   ) функция_1001; 

		//проц function(   ) функция_1002; 

		//проц function(   ) функция_1003; 

		//проц function(   ) функция_1004; 

		//проц function(   ) функция_1005; 

		//проц function(   ) функция_1006; 

		//проц function(   ) функция_1007; 

		//проц function(   ) функция_1008; 

		//проц function(   ) функция_1009; 

		//проц function(   ) функция_1010; 

		//проц function(   ) функция_1011; 

		//проц function(   ) функция_1012; 

		//проц function(   ) функция_1013; 

		//проц function(   ) функция_1014; 

		//проц function(   ) функция_1015; 

		//проц function(   ) функция_1016; 

		//проц function(   ) функция_1017; 

		//проц function(   ) функция_1018; 

		//проц function(   ) функция_1019; 

		//проц function(   ) функция_1020; 

		//проц function(   ) функция_1021; 

		//проц function(   ) функция_1022; 

		//проц function(   ) функция_1023; 

		//проц function(   ) функция_1024; 

		//проц function(   ) функция_1025; 

		//проц function(   ) функция_1026; 

		//проц function(   ) функция_1027; 

		//проц function(   ) функция_1028; 

		//проц function(   ) функция_1029; 

		//проц function(   ) функция_1030; 

		//проц function(   ) функция_1031; 

		//проц function(   ) функция_1032; 

		//проц function(   ) функция_1033; 

		//проц function(   ) функция_1034; 

		//проц function(   ) функция_1035; 

		//проц function(   ) функция_1036; 

		//проц function(   ) функция_1037; 

		//проц function(   ) функция_1038; 

		//проц function(   ) функция_1039; 

		//проц function(   ) функция_1040; 

		//проц function(   ) функция_1041; 

		//проц function(   ) функция_1042; 

		//проц function(   ) функция_1043; 

		//проц function(   ) функция_1044; 

		//проц function(   ) функция_1045; 

		//проц function(   ) функция_1046; 

		//проц function(   ) функция_1047; 

		//проц function(   ) функция_1048; 

		//проц function(   ) функция_1049; 

		//проц function(   ) функция_1050; 

		//проц function(   ) функция_1051; 

		//проц function(   ) функция_1052; 

		//проц function(   ) функция_1053; 

		//проц function(   ) функция_1054; 

		//проц function(   ) функция_1055; 

		//проц function(   ) функция_1056; 

		//проц function(   ) функция_1057; 

		//проц function(   ) функция_1058; 

		//проц function(   ) функция_1059; 

		//проц function(   ) функция_1060; 

		//проц function(   ) функция_1061; 

		//проц function(   ) функция_1062; 

		//проц function(   ) функция_1063; 

		//проц function(   ) функция_1064; 

		//проц function(   ) функция_1065; 

		//проц function(   ) функция_1066; 

		//проц function(   ) функция_1067; 

		//проц function(   ) функция_1068; 

		//проц function(   ) функция_1069; 

		//проц function(   ) функция_1070; 

		//проц function(   ) функция_1071; 

		//проц function(   ) функция_1072; 

		//проц function(   ) функция_1073; 

		//проц function(   ) функция_1074; 

		//проц function(   ) функция_1075; 

		//проц function(   ) функция_1076; 

		//проц function(   ) функция_1077; 

		//проц function(   ) функция_1078; 

		//проц function(   ) функция_1079; 

		//проц function(   ) функция_1080; 

		//проц function(   ) функция_1081; 

		//проц function(   ) функция_1082; 

		//проц function(   ) функция_1083; 

		//проц function(   ) функция_1084; 

		//проц function(   ) функция_1085; 

		//проц function(   ) функция_1086; 

		//проц function(   ) функция_1087; 

		//проц function(   ) функция_1088; 

		//проц function(   ) функция_1089; 

		//проц function(   ) функция_1090; 

		//проц function(   ) функция_1091; 

		//проц function(   ) функция_1092; 

		//проц function(   ) функция_1093; 

		//проц function(   ) функция_1094; 

		//проц function(   ) функция_1095; 

		//проц function(   ) функция_1096; 

		//проц function(   ) функция_1097; 

		//проц function(   ) функция_1098; 

		//проц function(   ) функция_1099; 

		//проц function(   ) функция_1100; 

		//проц function(   ) функция_1101; 

		//проц function(   ) функция_1102; 

		//проц function(   ) функция_1103; 

		//проц function(   ) функция_1104; 

		//проц function(   ) функция_1105; 

		//проц function(   ) функция_1106; 

		//проц function(   ) функция_1107; 

		//проц function(   ) функция_1108; 

		//проц function(   ) функция_1109; 

		//проц function(   ) функция_1110; 

		//проц function(   ) функция_1111; 

		//проц function(   ) функция_1112; 

		//проц function(   ) функция_1113; 

		//проц function(   ) функция_1114; 

		//проц function(   ) функция_1115; 

		//проц function(   ) функция_1116; 

		//проц function(   ) функция_1117; 

		//проц function(   ) функция_1118; 

		//проц function(   ) функция_1119; 

		//проц function(   ) функция_1120; 

		//проц function(   ) функция_1121; 

		//проц function(   ) функция_1122; 

		//проц function(   ) функция_1123; 

		//проц function(   ) функция_1124; 

		//проц function(   ) функция_1125; 

		//проц function(   ) функция_1126; 

		//проц function(   ) функция_1127; 

		//проц function(   ) функция_1128; 

		//проц function(   ) функция_1129; 

		//проц function(   ) функция_1130; 

		//проц function(   ) функция_1131; 

		//проц function(   ) функция_1132; 

		//проц function(   ) функция_1133; 

		//проц function(   ) функция_1134; 

		//проц function(   ) функция_1135; 

		//проц function(   ) функция_1136; 

		//проц function(   ) функция_1137; 

		//проц function(   ) функция_1138; 

		//проц function(   ) функция_1139; 

		//проц function(   ) функция_1140; 

		//проц function(   ) функция_1141; 

		//проц function(   ) функция_1142; 

		//проц function(   ) функция_1143; 

		//проц function(   ) функция_1144; 

		//проц function(   ) функция_1145; 

		//проц function(   ) функция_1146; 

		//проц function(   ) функция_1147; 

		//проц function(   ) функция_1148; 

		//проц function(   ) функция_1149; 

		//проц function(   ) функция_1150; 

		//проц function(   ) функция_1151; 

		//проц function(   ) функция_1152; 

		//проц function(   ) функция_1153; 

		//проц function(   ) функция_1154; 

		//проц function(   ) функция_1155; 

		//проц function(   ) функция_1156; 

		//проц function(   ) функция_1157; 

		//проц function(   ) функция_1158; 

		//проц function(   ) функция_1159; 

		//проц function(   ) функция_1160; 

		//проц function(   ) функция_1161; 

		//проц function(   ) функция_1162; 

		//проц function(   ) функция_1163; 

		//проц function(   ) функция_1164; 

		//проц function(   ) функция_1165; 

		//проц function(   ) функция_1166; 

		//проц function(   ) функция_1167; 

		//проц function(   ) функция_1168; 

		//проц function(   ) функция_1169; 

		//проц function(   ) функция_1170; 

		//проц function(   ) функция_1171; 

		//проц function(   ) функция_1172; 

		//проц function(   ) функция_1173; 

		//проц function(   ) функция_1174; 

		//проц function(   ) функция_1175; 

		//проц function(   ) функция_1176; 

		//проц function(   ) функция_1177; 

		//проц function(   ) функция_1178; 

		//проц function(   ) функция_1179; 

		//проц function(   ) функция_1180; 

		//проц function(   ) функция_1181; 

		//проц function(   ) функция_1182; 

		//проц function(   ) функция_1183; 

		//проц function(   ) функция_1184; 

		//проц function(   ) функция_1185; 

		//проц function(   ) функция_1186; 

		//проц function(   ) функция_1187; 

		//проц function(   ) функция_1188; 

		//проц function(   ) функция_1189; 

		//проц function(   ) функция_1190; 

		//проц function(   ) функция_1191; 

		//проц function(   ) функция_1192; 

		//проц function(   ) функция_1193; 

		//проц function(   ) функция_1194; 

		//проц function(   ) функция_1195; 

		//проц function(   ) функция_1196; 

		//проц function(   ) функция_1197; 

		//проц function(   ) функция_1198; 

		//проц function(   ) функция_1199; 

		//проц function(   ) функция_1200; 

		//проц function(   ) функция_1201; 

		//проц function(   ) функция_1202; 

		//проц function(   ) функция_1203; 

		//проц function(   ) функция_1204; 

		//проц function(   ) функция_1205; 

		//проц function(   ) функция_1206; 

		//проц function(   ) функция_1207; 

		//проц function(   ) функция_1208; 

		//проц function(   ) функция_1209; 

		//проц function(   ) функция_1210; 

		//проц function(   ) функция_1211; 

		//проц function(   ) функция_1212; 

		//проц function(   ) функция_1213; 

		//проц function(   ) функция_1214; 

		//проц function(   ) функция_1215; 

		//проц function(   ) функция_1216; 

		//проц function(   ) функция_1217; 

		//проц function(   ) функция_1218; 

		//проц function(   ) функция_1219; 

		//проц function(   ) функция_1220; 

		//проц function(   ) функция_1221; 

		//проц function(   ) функция_1222; 

		//проц function(   ) функция_1223; 

		//проц function(   ) функция_1224; 

		//проц function(   ) функция_1225; 

		//проц function(   ) функция_1226; 

		//проц function(   ) функция_1227; 

		//проц function(   ) функция_1228; 

		//проц function(   ) функция_1229; 

		//проц function(   ) функция_1230; 

		//проц function(   ) функция_1231; 

		//проц function(   ) функция_1232; 

		//проц function(   ) функция_1233; 

		//проц function(   ) функция_1234; 

		//проц function(   ) функция_1235; 

		//проц function(   ) функция_1236; 

		//проц function(   ) функция_1237; 

		//проц function(   ) функция_1238; 

		//проц function(   ) функция_1239; 

		//проц function(   ) функция_1240; 

		//проц function(   ) функция_1241; 

		//проц function(   ) функция_1242; 

		//проц function(   ) функция_1243; 

		//проц function(   ) функция_1244; 

		//проц function(   ) функция_1245; 

		//проц function(   ) функция_1246; 

		//проц function(   ) функция_1247; 

		//проц function(   ) функция_1248; 

		//проц function(   ) функция_1249; 

		//проц function(   ) функция_1250; 

		//проц function(   ) функция_1251; 

		//проц function(   ) функция_1252; 

		//проц function(   ) функция_1253; 

		//проц function(   ) функция_1254; 

		//проц function(   ) функция_1255; 

		//проц function(   ) функция_1256; 

		//проц function(   ) функция_1257; 

		//проц function(   ) функция_1258; 

		//проц function(   ) функция_1259; 

		//проц function(   ) функция_1260; 

		//проц function(   ) функция_1261; 

		//проц function(   ) функция_1262; 

		//проц function(   ) функция_1263; 

		//проц function(   ) функция_1264; 

		//проц function(   ) функция_1265; 

		//проц function(   ) функция_1266; 

		//проц function(   ) функция_1267; 

		//проц function(   ) функция_1268; 

		//проц function(   ) функция_1269; 

		//проц function(   ) функция_1270; 

		//проц function(   ) функция_1271; 

		//проц function(   ) функция_1272; 

		//проц function(   ) функция_1273; 

		//проц function(   ) функция_1274; 

		//проц function(   ) функция_1275; 

		//проц function(   ) функция_1276; 

		//проц function(   ) функция_1277; 

		//проц function(   ) функция_1278; 

		//проц function(   ) функция_1279; 

		//проц function(   ) функция_1280; 

		//проц function(   ) функция_1281; 

		//проц function(   ) функция_1282; 

		//проц function(   ) функция_1283; 

		//проц function(   ) функция_1284; 

		//проц function(   ) функция_1285; 

		//проц function(   ) функция_1286; 

		//проц function(   ) функция_1287; 

		//проц function(   ) функция_1288; 

		//проц function(   ) функция_1289; 

		//проц function(   ) функция_1290; 

		//проц function(   ) функция_1291; 

		//проц function(   ) функция_1292; 

		//проц function(   ) функция_1293; 

		//проц function(   ) функция_1294; 

		//проц function(   ) функция_1295; 

		//проц function(   ) функция_1296; 

		//проц function(   ) функция_1297; 

		//проц function(   ) функция_1298; 

		//проц function(   ) функция_1299; 

		//проц function(   ) функция_1300; 

		//проц function(   ) функция_1301; 

		//проц function(   ) функция_1302; 

		//проц function(   ) функция_1303; 

		//проц function(   ) функция_1304; 

		//проц function(   ) функция_1305; 

		//проц function(   ) функция_1306; 

		//проц function(   ) функция_1307; 

		//проц function(   ) функция_1308; 

		//проц function(   ) функция_1309; 

		//проц function(   ) функция_1310; 

		//проц function(   ) функция_1311; 

		//проц function(   ) функция_1312; 

		//проц function(   ) функция_1313; 

		//проц function(   ) функция_1314; 

		//проц function(   ) функция_1315; 

		//проц function(   ) функция_1316; 

		//проц function(   ) функция_1317; 

		//проц function(   ) функция_1318; 

		//проц function(   ) функция_1319; 

		//проц function(   ) функция_1320; 

		//проц function(   ) функция_1321; 

		//проц function(   ) функция_1322; 

		//проц function(   ) функция_1323; 

		//проц function(   ) функция_1324; 

		//проц function(   ) функция_1325; 

		//проц function(   ) функция_1326; 

		//проц function(   ) функция_1327; 

		//проц function(   ) функция_1328; 

		//проц function(   ) функция_1329; 

		//проц function(   ) функция_1330; 

		//проц function(   ) функция_1331; 

		//проц function(   ) функция_1332; 

		//проц function(   ) функция_1333; 

		//проц function(   ) функция_1334; 

		//проц function(   ) функция_1335; 

		//проц function(   ) функция_1336; 

		//проц function(   ) функция_1337; 

		//проц function(   ) функция_1338; 

		//проц function(   ) функция_1339; 

		//проц function(   ) функция_1340; 

		//проц function(   ) функция_1341; 

		//проц function(   ) функция_1342; 

		//проц function(   ) функция_1343; 

		//проц function(   ) функция_1344; 

		//проц function(   ) функция_1345; 

		//проц function(   ) функция_1346; 

		//проц function(   ) функция_1347; 

		//проц function(   ) функция_1348; 

		//проц function(   ) функция_1349; 

		//проц function(   ) функция_1350; 

		//проц function(   ) функция_1351; 

		//проц function(   ) функция_1352; 

		//проц function(   ) функция_1353; 

		//проц function(   ) функция_1354; 

		//проц function(   ) функция_1355; 

		//проц function(   ) функция_1356; 

		//проц function(   ) функция_1357; 

		//проц function(   ) функция_1358; 

		//проц function(   ) функция_1359; 

		//проц function(   ) функция_1360; 

		//проц function(   ) функция_1361; 

		//проц function(   ) функция_1362; 

		//проц function(   ) функция_1363; 

		//проц function(   ) функция_1364; 

		//проц function(   ) функция_1365; 

		//проц function(   ) функция_1366; 

		//проц function(   ) функция_1367; 

		//проц function(   ) функция_1368; 

		//проц function(   ) функция_1369; 

		//проц function(   ) функция_1370; 

		//проц function(   ) функция_1371; 

		//проц function(   ) функция_1372; 

		//проц function(   ) функция_1373; 

		//проц function(   ) функция_1374; 

		//проц function(   ) функция_1375; 

		//проц function(   ) функция_1376; 

		//проц function(   ) функция_1377; 

		//проц function(   ) функция_1378; 

		//проц function(   ) функция_1379; 

		//проц function(   ) функция_1380; 

		//проц function(   ) функция_1381; 

		//проц function(   ) функция_1382; 

		//проц function(   ) функция_1383; 

		//проц function(   ) функция_1384; 

		//проц function(   ) функция_1385; 

		//проц function(   ) функция_1386; 

		//проц function(   ) функция_1387; 

		//проц function(   ) функция_1388; 

		//проц function(   ) функция_1389; 

		//проц function(   ) функция_1390; 

		//проц function(   ) функция_1391; 

		//проц function(   ) функция_1392; 

		//проц function(   ) функция_1393; 

		//проц function(   ) функция_1394; 

		//проц function(   ) функция_1395; 

		//проц function(   ) функция_1396; 

		//проц function(   ) функция_1397; 

		//проц function(   ) функция_1398; 

		//проц function(   ) функция_1399; 

		//проц function(   ) функция_1400; 

		//проц function(   ) функция_1401; 

		//проц function(   ) функция_1402; 

		//проц function(   ) функция_1403; 

		//проц function(   ) функция_1404; 

		//проц function(   ) функция_1405; 

		//проц function(   ) функция_1406; 

		//проц function(   ) функция_1407; 

		//проц function(   ) функция_1408; 

		//проц function(   ) функция_1409; 

		//проц function(   ) функция_1410; 

		//проц function(   ) функция_1411; 

		//проц function(   ) функция_1412; 

		//проц function(   ) функция_1413; 

		//проц function(   ) функция_1414; 

		//проц function(   ) функция_1415; 

		//проц function(   ) функция_1416; 

		//проц function(   ) функция_1417; 

		//проц function(   ) функция_1418; 

		//проц function(   ) функция_1419; 

		//проц function(   ) функция_1420; 

		//проц function(   ) функция_1421; 

		//проц function(   ) функция_1422; 

		//проц function(   ) функция_1423; 

		//проц function(   ) функция_1424; 

		//проц function(   ) функция_1425; 

		//проц function(   ) функция_1426; 

		//проц function(   ) функция_1427; 

		//проц function(   ) функция_1428; 

		//проц function(   ) функция_1429; 

		//проц function(   ) функция_1430; 

		//проц function(   ) функция_1431; 

		//проц function(   ) функция_1432; 

		//проц function(   ) функция_1433; 

		//проц function(   ) функция_1434; 

		//проц function(   ) функция_1435; 

		//проц function(   ) функция_1436; 

		//проц function(   ) функция_1437; 

		//проц function(   ) функция_1438; 

		//проц function(   ) функция_1439; 

		//проц function(   ) функция_1440; 

		//проц function(   ) функция_1441; 

		//проц function(   ) функция_1442; 

		//проц function(   ) функция_1443; 

		//проц function(   ) функция_1444; 

		//проц function(   ) функция_1445; 

		//проц function(   ) функция_1446; 

		//проц function(   ) функция_1447; 

		//проц function(   ) функция_1448; 

		//проц function(   ) функция_1449; 

		//проц function(   ) функция_1450; 

		//проц function(   ) функция_1451; 

		//проц function(   ) функция_1452; 

		//проц function(   ) функция_1453; 

		//проц function(   ) функция_1454; 

		//проц function(   ) функция_1455; 

		//проц function(   ) функция_1456; 

		//проц function(   ) функция_1457; 

		//проц function(   ) функция_1458; 

		//проц function(   ) функция_1459; 

		//проц function(   ) функция_1460; 

		//проц function(   ) функция_1461; 

		//проц function(   ) функция_1462; 

		//проц function(   ) функция_1463; 

		//проц function(   ) функция_1464; 

		//проц function(   ) функция_1465; 

		//проц function(   ) функция_1466; 

		//проц function(   ) функция_1467; 

		//проц function(   ) функция_1468; 

		//проц function(   ) функция_1469; 

		//проц function(   ) функция_1470; 

		//проц function(   ) функция_1471; 

		//проц function(   ) функция_1472; 

		//проц function(   ) функция_1473; 

		//проц function(   ) функция_1474; 

		//проц function(   ) функция_1475; 

		//проц function(   ) функция_1476; 

		//проц function(   ) функция_1477; 

		//проц function(   ) функция_1478; 

		//проц function(   ) функция_1479; 

		//проц function(   ) функция_1480; 

		//проц function(   ) функция_1481; 

		//проц function(   ) функция_1482; 

		//проц function(   ) функция_1483; 

		//проц function(   ) функция_1484; 

		//проц function(   ) функция_1485; 

		//проц function(   ) функция_1486; 

		//проц function(   ) функция_1487; 

		//проц function(   ) функция_1488; 

		//проц function(   ) функция_1489; 

		//проц function(   ) функция_1490; 

		//проц function(   ) функция_1491; 

		//проц function(   ) функция_1492; 

		//проц function(   ) функция_1493; 

		//проц function(   ) функция_1494; 

		//проц function(   ) функция_1495; 

		//проц function(   ) функция_1496; 

		//проц function(   ) функция_1497; 

		//проц function(   ) функция_1498; 

		//проц function(   ) функция_1499; 

		//проц function(   ) функция_1500; 

		//проц function(   ) функция_1501; 

		//проц function(   ) функция_1502; 

		//проц function(   ) функция_1503; 

		//проц function(   ) функция_1504; 

		//проц function(   ) функция_1505; 

		//проц function(   ) функция_1506; 

		//проц function(   ) функция_1507; 

		//проц function(   ) функция_1508; 

		//проц function(   ) функция_1509; 

		//проц function(   ) функция_1510; 

		//проц function(   ) функция_1511; 

		//проц function(   ) функция_1512; 

		//проц function(   ) функция_1513; 

		//проц function(   ) функция_1514; 

		//проц function(   ) функция_1515; 

		//проц function(   ) функция_1516; 

		//проц function(   ) функция_1517; 

		//проц function(   ) функция_1518; 

		//проц function(   ) функция_1519; 

		//проц function(   ) функция_1520; 

		//проц function(   ) функция_1521; 

		//проц function(   ) функция_1522; 

		//проц function(   ) функция_1523; 

		//проц function(   ) функция_1524; 

		//проц function(   ) функция_1525; 

		//проц function(   ) функция_1526; 

		//проц function(   ) функция_1527; 

		//проц function(   ) функция_1528; 

		//проц function(   ) функция_1529; 

		//проц function(   ) функция_1530; 

		//проц function(   ) функция_1531; 

		//проц function(   ) функция_1532; 

		//проц function(   ) функция_1533; 

		//проц function(   ) функция_1534; 

		//проц function(   ) функция_1535; 

		//проц function(   ) функция_1536; 

		//проц function(   ) функция_1537; 

		//проц function(   ) функция_1538; 

		//проц function(   ) функция_1539; 

		//проц function(   ) функция_1540; 

		//проц function(   ) функция_1541; 

		//проц function(   ) функция_1542; 

		//проц function(   ) функция_1543; 

		//проц function(   ) функция_1544; 

		//проц function(   ) функция_1545; 

		//проц function(   ) функция_1546; 

		//проц function(   ) функция_1547; 

		//проц function(   ) функция_1548; 

		//проц function(   ) функция_1549; 

		//проц function(   ) функция_1550; 

		//проц function(   ) функция_1551; 

		//проц function(   ) функция_1552; 

		//проц function(   ) функция_1553; 

		//проц function(   ) функция_1554; 

		//проц function(   ) функция_1555; 

		//проц function(   ) функция_1556; 

		//проц function(   ) функция_1557; 

		//проц function(   ) функция_1558; 

		//проц function(   ) функция_1559; 

		//проц function(   ) функция_1560; 

		//проц function(   ) функция_1561; 

		//проц function(   ) функция_1562; 

		//проц function(   ) функция_1563; 

		//проц function(   ) функция_1564; 

		//проц function(   ) функция_1565; 

		//проц function(   ) функция_1566; 

		//проц function(   ) функция_1567; 

		//проц function(   ) функция_1568; 

		//проц function(   ) функция_1569; 

		//проц function(   ) функция_1570; 

		//проц function(   ) функция_1571; 

		//проц function(   ) функция_1572; 

		//проц function(   ) функция_1573; 

		//проц function(   ) функция_1574; 

		//проц function(   ) функция_1575; 

		//проц function(   ) функция_1576; 

		//проц function(   ) функция_1577; 

		//проц function(   ) функция_1578; 

		//проц function(   ) функция_1579; 

		//проц function(   ) функция_1580; 

		//проц function(   ) функция_1581; 

		//проц function(   ) функция_1582; 

		//проц function(   ) функция_1583; 

		//проц function(   ) функция_1584; 

		//проц function(   ) функция_1585; 

		//проц function(   ) функция_1586; 

		//проц function(   ) функция_1587; 

		//проц function(   ) функция_1588; 

		//проц function(   ) функция_1589; 

		//проц function(   ) функция_1590; 

		//проц function(   ) функция_1591; 

		//проц function(   ) функция_1592; 

		//проц function(   ) функция_1593; 

		//проц function(   ) функция_1594; 

		//проц function(   ) функция_1595; 

		//проц function(   ) функция_1596; 

		//проц function(   ) функция_1597; 

		//проц function(   ) функция_1598; 

		//проц function(   ) функция_1599; 

		//проц function(   ) функция_1600; 

		//проц function(   ) функция_1601; 

		//проц function(   ) функция_1602; 

		//проц function(   ) функция_1603; 

		//проц function(   ) функция_1604; 

		//проц function(   ) функция_1605; 

		//проц function(   ) функция_1606; 

		//проц function(   ) функция_1607; 

		//проц function(   ) функция_1608; 

		//проц function(   ) функция_1609; 

		//проц function(   ) функция_1610; 

		//проц function(   ) функция_1611; 

		//проц function(   ) функция_1612; 

		//проц function(   ) функция_1613; 

		//проц function(   ) функция_1614; 

		//проц function(   ) функция_1615; 

		//проц function(   ) функция_1616; 

		//проц function(   ) функция_1617; 

		//проц function(   ) функция_1618; 

		//проц function(   ) функция_1619; 

		//проц function(   ) функция_1620; 

		//проц function(   ) функция_1621; 

		//проц function(   ) функция_1622; 

		//проц function(   ) функция_1623; 

		//проц function(   ) функция_1624; 

		//проц function(   ) функция_1625; 

		//проц function(   ) функция_1626; 

		//проц function(   ) функция_1627; 

		//проц function(   ) функция_1628; 

		//проц function(   ) функция_1629; 

		//проц function(   ) функция_1630; 

		//проц function(   ) функция_1631; 

		//проц function(   ) функция_1632; 

		//проц function(   ) функция_1633; 

		//проц function(   ) функция_1634; 

		//проц function(   ) функция_1635; 

		//проц function(   ) функция_1636; 

		//проц function(   ) функция_1637; 

		//проц function(   ) функция_1638; 

		//проц function(   ) функция_1639; 

		//проц function(   ) функция_1640; 

		//проц function(   ) функция_1641; 

		//проц function(   ) функция_1642; 

		//проц function(   ) функция_1643; 

		//проц function(   ) функция_1644; 

		//проц function(   ) функция_1645; 

		//проц function(   ) функция_1646; 

		//проц function(   ) функция_1647; 

		//проц function(   ) функция_1648; 

		//проц function(   ) функция_1649; 

		//проц function(   ) функция_1650; 

		//проц function(   ) функция_1651; 

		//проц function(   ) функция_1652; 

		//проц function(   ) функция_1653; 

		//проц function(   ) функция_1654; 

		//проц function(   ) функция_1655; 

		//проц function(   ) функция_1656; 

		//проц function(   ) функция_1657; 

		//проц function(   ) функция_1658; 

		//проц function(   ) функция_1659; 

		//проц function(   ) функция_1660; 

		//проц function(   ) функция_1661; 

		//проц function(   ) функция_1662; 

		//проц function(   ) функция_1663; 

		//проц function(   ) функция_1664; 

		//проц function(   ) функция_1665; 

		//проц function(   ) функция_1666; 

		//проц function(   ) функция_1667; 

		//проц function(   ) функция_1668; 

		//проц function(   ) функция_1669; 

		//проц function(   ) функция_1670; 

		//проц function(   ) функция_1671; 

		//проц function(   ) функция_1672; 

		//проц function(   ) функция_1673; 

		//проц function(   ) функция_1674; 

		//проц function(   ) функция_1675; 

		//проц function(   ) функция_1676; 

		//проц function(   ) функция_1677; 

		//проц function(   ) функция_1678; 

		//проц function(   ) функция_1679; 

		//проц function(   ) функция_1680; 

		//проц function(   ) функция_1681; 

		//проц function(   ) функция_1682; 

		//проц function(   ) функция_1683; 

		//проц function(   ) функция_1684; 

		//проц function(   ) функция_1685; 

		//проц function(   ) функция_1686; 

		//проц function(   ) функция_1687; 

		//проц function(   ) функция_1688; 

		//проц function(   ) функция_1689; 

		//проц function(   ) функция_1690; 

		//проц function(   ) функция_1691; 

		//проц function(   ) функция_1692; 

		//проц function(   ) функция_1693; 

		//проц function(   ) функция_1694; 

		//проц function(   ) функция_1695; 

		//проц function(   ) функция_1696; 

		//проц function(   ) функция_1697; 

		//проц function(   ) функция_1698; 

		//проц function(   ) функция_1699; 

		//проц function(   ) функция_1700; 

		//проц function(   ) функция_1701; 

		//проц function(   ) функция_1702; 

		//проц function(   ) функция_1703; 

		//проц function(   ) функция_1704; 

		//проц function(   ) функция_1705; 

		//проц function(   ) функция_1706; 

		//проц function(   ) функция_1707; 

		//проц function(   ) функция_1708; 

		//проц function(   ) функция_1709; 

		//проц function(   ) функция_1710; 

		//проц function(   ) функция_1711; 

		//проц function(   ) функция_1712; 

		//проц function(   ) функция_1713; 

		//проц function(   ) функция_1714; 

		//проц function(   ) функция_1715; 

		//проц function(   ) функция_1716; 

		//проц function(   ) функция_1717; 

		//проц function(   ) функция_1718; 

		//проц function(   ) функция_1719; 

		//проц function(   ) функция_1720; 

		//проц function(   ) функция_1721; 

		//проц function(   ) функция_1722; 

		//проц function(   ) функция_1723; 

		//проц function(   ) функция_1724; 

		//проц function(   ) функция_1725; 

		//проц function(   ) функция_1726; 

		//проц function(   ) функция_1727; 

		//проц function(   ) функция_1728; 

		//проц function(   ) функция_1729; 

		//проц function(   ) функция_1730; 

		//проц function(   ) функция_1731; 

		//проц function(   ) функция_1732; 

		//проц function(   ) функция_1733; 

		//проц function(   ) функция_1734; 

		//проц function(   ) функция_1735; 

		//проц function(   ) функция_1736; 

		//проц function(   ) функция_1737; 

		//проц function(   ) функция_1738; 

		//проц function(   ) функция_1739; 

		//проц function(   ) функция_1740; 

		//проц function(   ) функция_1741; 

		//проц function(   ) функция_1742; 

		//проц function(   ) функция_1743; 

		//проц function(   ) функция_1744; 

		//проц function(   ) функция_1745; 

		//проц function(   ) функция_1746; 

		//проц function(   ) функция_1747; 

		//проц function(   ) функция_1748; 

		//проц function(   ) функция_1749; 

		//проц function(   ) функция_1750; 

		//проц function(   ) функция_1751; 

		//проц function(   ) функция_1752; 

		//проц function(   ) функция_1753; 

		//проц function(   ) функция_1754; 

		//проц function(   ) функция_1755; 

		//проц function(   ) функция_1756; 

		//проц function(   ) функция_1757; 

		//проц function(   ) функция_1758; 

		//проц function(   ) функция_1759; 

		//проц function(   ) функция_1760; 

		//проц function(   ) функция_1761; 

		//проц function(   ) функция_1762; 

		//проц function(   ) функция_1763; 

		//проц function(   ) функция_1764; 

		//проц function(   ) функция_1765; 

		//проц function(   ) функция_1766; 

		//проц function(   ) функция_1767; 

		//проц function(   ) функция_1768; 

		//проц function(   ) функция_1769; 

		//проц function(   ) функция_1770; 

		//проц function(   ) функция_1771; 

		//проц function(   ) функция_1772; 

		//проц function(   ) функция_1773; 

		//проц function(   ) функция_1774; 

		//проц function(   ) функция_1775; 

		//проц function(   ) функция_1776; 

		//проц function(   ) функция_1777; 

		//проц function(   ) функция_1778; 

		//проц function(   ) функция_1779; 

		//проц function(   ) функция_1780; 

		//проц function(   ) функция_1781; 

		//проц function(   ) функция_1782; 

		//проц function(   ) функция_1783; 

		//проц function(   ) функция_1784; 

		//проц function(   ) функция_1785; 

		//проц function(   ) функция_1786; 

		//проц function(   ) функция_1787; 

		//проц function(   ) функция_1788; 

		//проц function(   ) функция_1789; 

		//проц function(   ) функция_1790; 

		//проц function(   ) функция_1791; 

		//проц function(   ) функция_1792; 

		//проц function(   ) функция_1793; 

		//проц function(   ) функция_1794; 

		//проц function(   ) функция_1795; 

		//проц function(   ) функция_1796; 

		//проц function(   ) функция_1797; 

		//проц function(   ) функция_1798; 

		//проц function(   ) функция_1799; 

		//проц function(   ) функция_1800; 

		//проц function(   ) функция_1801; 

		//проц function(   ) функция_1802; 

		//проц function(   ) функция_1803; 

		//проц function(   ) функция_1804; 

		//проц function(   ) функция_1805; 

		//проц function(   ) функция_1806; 

		//проц function(   ) функция_1807; 

		//проц function(   ) функция_1808; 

		//проц function(   ) функция_1809; 

		//проц function(   ) функция_1810; 

		//проц function(   ) функция_1811; 

		//проц function(   ) функция_1812; 

		//проц function(   ) функция_1813; 

		//проц function(   ) функция_1814; 

		//проц function(   ) функция_1815; 

		//проц function(   ) функция_1816; 

		//проц function(   ) функция_1817; 

		//проц function(   ) функция_1818; 

		//проц function(   ) функция_1819; 

		//проц function(   ) функция_1820; 

		//проц function(   ) функция_1821; 

		//проц function(   ) функция_1822; 

		//проц function(   ) функция_1823; 

		//проц function(   ) функция_1824; 

		//проц function(   ) функция_1825; 

		//проц function(   ) функция_1826; 

		//проц function(   ) функция_1827; 

		//проц function(   ) функция_1828; 

		//проц function(   ) функция_1829; 

		//проц function(   ) функция_1830; 

		//проц function(   ) функция_1831; 

		//проц function(   ) функция_1832; 

		//проц function(   ) функция_1833; 

		//проц function(   ) функция_1834; 

		//проц function(   ) функция_1835; 

		//проц function(   ) функция_1836; 

		//проц function(   ) функция_1837; 

		//проц function(   ) функция_1838; 

		//проц function(   ) функция_1839; 

		//проц function(   ) функция_1840; 

		//проц function(   ) функция_1841; 

		//проц function(   ) функция_1842; 

		//проц function(   ) функция_1843; 

		//проц function(   ) функция_1844; 

		//проц function(   ) функция_1845; 

		//проц function(   ) функция_1846; 

		//проц function(   ) функция_1847; 

		//проц function(   ) функция_1848; 

		//проц function(   ) функция_1849; 

		//проц function(   ) функция_1850; 

		//проц function(   ) функция_1851; 

		//проц function(   ) функция_1852; 

		//проц function(   ) функция_1853; 

		//проц function(   ) функция_1854; 

		//проц function(   ) функция_1855; 

		//проц function(   ) функция_1856; 

		//проц function(   ) функция_1857; 

		//проц function(   ) функция_1858; 

		//проц function(   ) функция_1859; 

		//проц function(   ) функция_1860; 

		//проц function(   ) функция_1861; 

		//проц function(   ) функция_1862; 

		//проц function(   ) функция_1863; 

		//проц function(   ) функция_1864; 

		//проц function(   ) функция_1865; 

		//проц function(   ) функция_1866; 

		//проц function(   ) функция_1867; 

		//проц function(   ) функция_1868; 

		//проц function(   ) функция_1869; 

		//проц function(   ) функция_1870; 

		//проц function(   ) функция_1871; 

		//проц function(   ) функция_1872; 

		//проц function(   ) функция_1873; 

		//проц function(   ) функция_1874; 

		//проц function(   ) функция_1875; 

		//проц function(   ) функция_1876; 

		//проц function(   ) функция_1877; 

		//проц function(   ) функция_1878; 

		//проц function(   ) функция_1879; 

		//проц function(   ) функция_1880; 

		//проц function(   ) функция_1881; 

		//проц function(   ) функция_1882; 

		//проц function(   ) функция_1883; 

		//проц function(   ) функция_1884; 

		//проц function(   ) функция_1885; 

		//проц function(   ) функция_1886; 

		//проц function(   ) функция_1887; 

		//проц function(   ) функция_1888; 

		//проц function(   ) функция_1889; 

		//проц function(   ) функция_1890; 

		//проц function(   ) функция_1891; 

		//проц function(   ) функция_1892; 

		//проц function(   ) функция_1893; 

		//проц function(   ) функция_1894; 

		//проц function(   ) функция_1895; 

		//проц function(   ) функция_1896; 

		//проц function(   ) функция_1897; 

		//проц function(   ) функция_1898; 

		//проц function(   ) функция_1899; 

		//проц function(   ) функция_1900; 

		//проц function(   ) функция_1901; 

		//проц function(   ) функция_1902; 

		//проц function(   ) функция_1903; 

		//проц function(   ) функция_1904; 

		//проц function(   ) функция_1905; 

	}

проц main()
{
Звук(50, 5000);
}