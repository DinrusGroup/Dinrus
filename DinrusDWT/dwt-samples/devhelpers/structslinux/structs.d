// Author: Frank Benoit
// This prints the sizes of some C struct how they are defined in the c-bindings

import dwt.internal.c.gtk;
import dwt.internal.c.gdk;
import dwt.internal.c.glib_object;
import dwt.internal.c.gmodule;
import dwt.internal.c.pango;
import dwt.internal.c.cairo;
import dwt.internal.c.gl;
import dwt.internal.c.glx;
import dwt.internal.c.gtk_unix_print_2_0;
import dwt.internal.c.Xlib;
import dwt.internal.c.XTest;
import dwt.internal.c.Xrender;

extern(C) int printf( char*, ... );

struct TSizeValue {
	char[] name;
	int size;
} ;

const TSizeValue[] size_values = [
	{ "AtkValueIface", AtkValueIface.sizeof },
	{ "AtkMiscClass", AtkMiscClass.sizeof },
	{ "AtkMisc", AtkMisc.sizeof },
	{ "AtkTableIface", AtkTableIface.sizeof },
	{ "AtkStreamableContentIface", AtkStreamableContentIface.sizeof },
	{ "AtkStateSetClass", AtkStateSetClass.sizeof },
	{ "AtkSelectionIface", AtkSelectionIface.sizeof },
	{ "AtkRelationSetClass", AtkRelationSetClass.sizeof },
	{ "AtkRelationClass", AtkRelationClass.sizeof },
	{ "AtkRelation", AtkRelation.sizeof },
	{ "AtkRegistryClass", AtkRegistryClass.sizeof },
	{ "AtkRegistry", AtkRegistry.sizeof },
	{ "AtkNoOpObjectFactoryClass", AtkNoOpObjectFactoryClass.sizeof },
	{ "AtkNoOpObjectFactory", AtkNoOpObjectFactory.sizeof },
	{ "AtkObjectFactoryClass", AtkObjectFactoryClass.sizeof },
	{ "AtkObjectFactory", AtkObjectFactory.sizeof },
	{ "AtkNoOpObjectClass", AtkNoOpObjectClass.sizeof },
	{ "AtkNoOpObject", AtkNoOpObject.sizeof },
	{ "AtkImageIface", AtkImageIface.sizeof },
	{ "AtkHypertextIface", AtkHypertextIface.sizeof },
	{ "AtkHyperlinkImplIface", AtkHyperlinkImplIface.sizeof },
	{ "AtkHyperlinkClass", AtkHyperlinkClass.sizeof },
	{ "AtkHyperlink", AtkHyperlink.sizeof },
	{ "AtkGObjectAccessibleClass", AtkGObjectAccessibleClass.sizeof },
	{ "AtkGObjectAccessible", AtkGObjectAccessible.sizeof },
	{ "AtkEditableTextIface", AtkEditableTextIface.sizeof },
	{ "AtkTextRange", AtkTextRange.sizeof },
	{ "AtkTextRectangle", AtkTextRectangle.sizeof },
	{ "AtkTextIface", AtkTextIface.sizeof },
	{ "AtkDocumentIface", AtkDocumentIface.sizeof },
	{ "AtkRectangle", AtkRectangle.sizeof },
	{ "AtkComponentIface", AtkComponentIface.sizeof },
	{ "AtkKeyEventStruct", AtkKeyEventStruct.sizeof },
	{ "AtkUtilClass", AtkUtilClass.sizeof },
	{ "AtkUtil", AtkUtil.sizeof },
	{ "AtkActionIface", AtkActionIface.sizeof },
	{ "AtkPropertyValues", AtkPropertyValues.sizeof },
	{ "AtkStateSet", AtkStateSet.sizeof },
	{ "AtkRelationSet", AtkRelationSet.sizeof },
	{ "AtkObjectClass", AtkObjectClass.sizeof },
	{ "AtkObject", AtkObject.sizeof },
	{ "AtkImplementorIface", AtkImplementorIface.sizeof },
	{ "AtkAttribute", AtkAttribute.sizeof },
	{ "cairo_path_t", cairo_path_t.sizeof },
	{ "cairo_path_data_t", cairo_path_data_t.sizeof },
	{ "cairo_font_extents_t", cairo_font_extents_t.sizeof },
	{ "cairo_text_extents_t", cairo_text_extents_t.sizeof },
	{ "cairo_glyph_t", cairo_glyph_t.sizeof },
	{ "cairo_rectangle_list_t", cairo_rectangle_list_t.sizeof },
	{ "cairo_rectangle_t", cairo_rectangle_t.sizeof },
	{ "cairo_user_data_key_t", cairo_user_data_key_t.sizeof },
	{ "cairo_matrix_t", cairo_matrix_t.sizeof },
	{ "GdkWindowObjectClass", GdkWindowObjectClass.sizeof },
	{ "GdkWindowObject", GdkWindowObject.sizeof },
	{ "GdkPointerHooks", GdkPointerHooks.sizeof },
	{ "GdkWindowAttr", GdkWindowAttr.sizeof },
	{ "GdkGeometry", GdkGeometry.sizeof },
	{ "GdkScreenClass", GdkScreenClass.sizeof },
	{ "GdkPixmapObjectClass", GdkPixmapObjectClass.sizeof },
	{ "GdkPixmapObject", GdkPixmapObject.sizeof },
	{ "GdkPangoAttrEmbossColor", GdkPangoAttrEmbossColor.sizeof },
	{ "GdkPangoAttrEmbossed", GdkPangoAttrEmbossed.sizeof },
	{ "GdkPangoAttrStipple", GdkPangoAttrStipple.sizeof },
	{ "GdkPangoRendererClass", GdkPangoRendererClass.sizeof },
	{ "GdkPangoRenderer", GdkPangoRenderer.sizeof },
	{ "GdkDisplayManagerClass", GdkDisplayManagerClass.sizeof },
	{ "GdkKeymapClass", GdkKeymapClass.sizeof },
	{ "GdkKeymap", GdkKeymap.sizeof },
	{ "GdkKeymapKey", GdkKeymapKey.sizeof },
	{ "GdkImageClass", GdkImageClass.sizeof },
	{ "GdkTrapezoid", GdkTrapezoid.sizeof },
	{ "GdkDrawableClass", GdkDrawableClass.sizeof },
	{ "GdkGCClass", GdkGCClass.sizeof },
	{ "GdkGCValues", GdkGCValues.sizeof },
	{ "GdkDisplayPointerHooks", GdkDisplayPointerHooks.sizeof },
	{ "GdkDisplayClass", GdkDisplayClass.sizeof },
	{ "GdkEvent", GdkEvent.sizeof },
	{ "GdkEventGrabBroken", GdkEventGrabBroken.sizeof },
	{ "GdkEventSetting", GdkEventSetting.sizeof },
	{ "GdkEventWindowState", GdkEventWindowState.sizeof },
	{ "GdkEventDND", GdkEventDND.sizeof },
	{ "GdkEventClient", GdkEventClient.sizeof },
	{ "GdkEventProximity", GdkEventProximity.sizeof },
	{ "GdkEventOwnerChange", GdkEventOwnerChange.sizeof },
	{ "GdkEventSelection", GdkEventSelection.sizeof },
	{ "GdkEventProperty", GdkEventProperty.sizeof },
	{ "GdkEventConfigure", GdkEventConfigure.sizeof },
	{ "GdkEventCrossing", GdkEventCrossing.sizeof },
	{ "GdkEventFocus", GdkEventFocus.sizeof },
	{ "GdkEventKey", GdkEventKey.sizeof },
	{ "GdkEventScroll", GdkEventScroll.sizeof },
	{ "GdkEventButton", GdkEventButton.sizeof },
	{ "GdkEventMotion", GdkEventMotion.sizeof },
	{ "GdkEventVisibility", GdkEventVisibility.sizeof },
	{ "GdkEventNoExpose", GdkEventNoExpose.sizeof },
	{ "GdkEventExpose", GdkEventExpose.sizeof },
	{ "GdkEventAny", GdkEventAny.sizeof },
	{ "GdkTimeCoord", GdkTimeCoord.sizeof },
	{ "GdkDevice", GdkDevice.sizeof },
	{ "GdkDeviceAxis", GdkDeviceAxis.sizeof },
	{ "GdkDeviceKey", GdkDeviceKey.sizeof },
	{ "GdkDragContextClass", GdkDragContextClass.sizeof },
	{ "GdkDragContext", GdkDragContext.sizeof },
	{ "GdkPixbufLoaderClass", GdkPixbufLoaderClass.sizeof },
	{ "GdkPixbufLoader", GdkPixbufLoader.sizeof },
	{ "GdkRgbCmap", GdkRgbCmap.sizeof },
	{ "GdkColormapClass", GdkColormapClass.sizeof },
	{ "GdkScreen", GdkScreen.sizeof },
	{ "GdkDisplay", GdkDisplay.sizeof },
	{ "GdkDrawable", GdkDrawable.sizeof },
	{ "GdkVisual", GdkVisual.sizeof },
	{ "GdkImage", GdkImage.sizeof },
	{ "GdkGC", GdkGC.sizeof },
	{ "GdkFont", GdkFont.sizeof },
	{ "GdkCursor", GdkCursor.sizeof },
	{ "GdkColormap", GdkColormap.sizeof },
	{ "GdkColor", GdkColor.sizeof },
	{ "GdkSpan", GdkSpan.sizeof },
	{ "GdkSegment", GdkSegment.sizeof },
	{ "GdkRectangle", GdkRectangle.sizeof },
	{ "GdkPoint", GdkPoint.sizeof },
	{ "GStaticMutex", _GStaticMutex.sizeof },
	{ "GSystemThread", _GSystemThread.sizeof },
	{ "GValueArray", GValueArray.sizeof },
	{ "GTypePluginClass", GTypePluginClass.sizeof },
	{ "GTypeModuleClass", GTypeModuleClass.sizeof },
	{ "GTypeModule", GTypeModule.sizeof },
	{ "GParamSpecGType", GParamSpecGType.sizeof },
	{ "GParamSpecOverride", GParamSpecOverride.sizeof },
	{ "GParamSpecObject", GParamSpecObject.sizeof },
	{ "GParamSpecValueArray", GParamSpecValueArray.sizeof },
	{ "GParamSpecPointer", GParamSpecPointer.sizeof },
	{ "GParamSpecBoxed", GParamSpecBoxed.sizeof },
	{ "GParamSpecParam", GParamSpecParam.sizeof },
	{ "GParamSpecString", GParamSpecString.sizeof },
	{ "GParamSpecDouble", GParamSpecDouble.sizeof },
	{ "GParamSpecFloat", GParamSpecFloat.sizeof },
	{ "GParamSpecFlags", GParamSpecFlags.sizeof },
	{ "GParamSpecEnum", GParamSpecEnum.sizeof },
	{ "GParamSpecUnichar", GParamSpecUnichar.sizeof },
	{ "GParamSpecUInt64", GParamSpecUInt64.sizeof },
	{ "GParamSpecInt64", GParamSpecInt64.sizeof },
	{ "GParamSpecULong", GParamSpecULong.sizeof },
	{ "GParamSpecLong", GParamSpecLong.sizeof },
	{ "GParamSpecUInt", GParamSpecUInt.sizeof },
	{ "GParamSpecInt", GParamSpecInt.sizeof },
	{ "GParamSpecBoolean", GParamSpecBoolean.sizeof },
	{ "GParamSpecUChar", GParamSpecUChar.sizeof },
	{ "GParamSpecChar", GParamSpecChar.sizeof },
	{ "GObjectConstructParam", GObjectConstructParam.sizeof },
	{ "GObjectClass", GObjectClass.sizeof },
	{ "GObject", GObject.sizeof },
	{ "GSignalInvocationHint", GSignalInvocationHint.sizeof },
	{ "GSignalQuery", GSignalQuery.sizeof },
	{ "GCClosure", GCClosure.sizeof },
	{ "GClosureNotifyData", GClosureNotifyData.sizeof },
	{ "GClosure", GClosure.sizeof },
	{ "GParamSpecTypeInfo", GParamSpecTypeInfo.sizeof },
	{ "GParameter", GParameter.sizeof },
	{ "GParamSpecClass", GParamSpecClass.sizeof },
	{ "GParamSpec", GParamSpec.sizeof },
	{ "GFlagsValue", GFlagsValue.sizeof },
	{ "GEnumValue", GEnumValue.sizeof },
	{ "GFlagsClass", GFlagsClass.sizeof },
	{ "GEnumClass", GEnumClass.sizeof },
	{ "GTypeQuery", GTypeQuery.sizeof },
	{ "GTypeValueTable", GTypeValueTable.sizeof },
	{ "GInterfaceInfo", GInterfaceInfo.sizeof },
	{ "GTypeFundamentalInfo", GTypeFundamentalInfo.sizeof },
	{ "GTypeInfo", GTypeInfo.sizeof },
	{ "GTypeInstance", GTypeInstance.sizeof },
	{ "GTypeInterface", GTypeInterface.sizeof },
	{ "GTypeClass", GTypeClass.sizeof },
	{ "GValue", GValue.sizeof },
	{ "GThreadPool", GThreadPool.sizeof },
	{ "GTokenValue", GTokenValue.sizeof },
	{ "GScannerConfig", GScannerConfig.sizeof },
	{ "GScanner", GScanner.sizeof },
	{ "GTuples", GTuples.sizeof },
	{ "GQueue", GQueue.sizeof },
	{ "GOptionEntry", GOptionEntry.sizeof },
	{ "GNode", GNode.sizeof },
	{ "GMarkupParser", GMarkupParser.sizeof },
	{ "GIOFuncs", GIOFuncs.sizeof },
	{ "GIOChannel", GIOChannel.sizeof },
	{ "GString", GString.sizeof },
	{ "GPollFD", GPollFD.sizeof },
	{ "GSourceFuncs", GSourceFuncs.sizeof },
	{ "GSourceCallbackFuncs", GSourceCallbackFuncs.sizeof },
	{ "GSource", GSource.sizeof },
	{ "GSList", GSList.sizeof },
	{ "GHookList", GHookList.sizeof },
	{ "GHook", GHook.sizeof },
	{ "GDate", GDate.sizeof },
	{ "GCompletion", GCompletion.sizeof },
	{ "GList", GList.sizeof },
	{ "GMemVTable", GMemVTable.sizeof },
	{ "GOnce", GOnce.sizeof },
	{ "GStaticRWLock", GStaticRWLock.sizeof },
	{ "GStaticRecMutex", GStaticRecMutex.sizeof },
	{ "GThreadFunctions", GThreadFunctions.sizeof },
	{ "GStaticPrivate", GStaticPrivate.sizeof },
	{ "GThread", GThread.sizeof },
	{ "GTrashStack", GTrashStack.sizeof },
	{ "GDebugKey", GDebugKey.sizeof },
	{ "GError", GError.sizeof },
	{ "GPtrArray", GPtrArray.sizeof },
	{ "GByteArray", GByteArray.sizeof },
	{ "GArray", GArray.sizeof },
	{ "GTimeVal", GTimeVal.sizeof },
	{ "GFloatIEEE754", GFloatIEEE754.sizeof },
	{ "GDoubleIEEE754", GDoubleIEEE754.sizeof },
	{ "GLXEvent", GLXEvent.sizeof },
	{ "GLXPbufferClobberEvent", GLXPbufferClobberEvent.sizeof },
	{ "GtkVSeparatorClass", GtkVSeparatorClass.sizeof },
	{ "GtkVSeparator", GtkVSeparator.sizeof },
	{ "GtkVScaleClass", GtkVScaleClass.sizeof },
	{ "GtkVScale", GtkVScale.sizeof },
	{ "GtkVRulerClass", GtkVRulerClass.sizeof },
	{ "GtkVRuler", GtkVRuler.sizeof },
	{ "GtkVPanedClass", GtkVPanedClass.sizeof },
	{ "GtkVPaned", GtkVPaned.sizeof },
	{ "GtkVolumeButtonClass", GtkVolumeButtonClass.sizeof },
	{ "GtkVButtonBoxClass", GtkVButtonBoxClass.sizeof },
	{ "GtkVButtonBox", GtkVButtonBox.sizeof },
	{ "GtkUIManagerClass", GtkUIManagerClass.sizeof },
	{ "GtkUIManager", GtkUIManager.sizeof },
	{ "GtkTreeStoreClass", GtkTreeStoreClass.sizeof },
	{ "GtkTreeStore", GtkTreeStore.sizeof },
	{ "GtkTreeModelSortClass", GtkTreeModelSortClass.sizeof },
	{ "GtkTreeModelSort", GtkTreeModelSort.sizeof },
	{ "GtkTreeDragDestIface", GtkTreeDragDestIface.sizeof },
	{ "GtkTreeDragSourceIface", GtkTreeDragSourceIface.sizeof },
	{ "GtkToolbarClass", GtkToolbarClass.sizeof },
	{ "GtkToolbar", GtkToolbar.sizeof },
	{ "GtkToolbarChild", GtkToolbarChild.sizeof },
	{ "GtkTipsQueryClass", GtkTipsQueryClass.sizeof },
	{ "GtkTipsQuery", GtkTipsQuery.sizeof },
	{ "GtkTextViewClass", GtkTextViewClass.sizeof },
	{ "GtkTextView", GtkTextView.sizeof },
	{ "GtkTextBufferClass", GtkTextBufferClass.sizeof },
	{ "GtkTextMarkClass", GtkTextMarkClass.sizeof },
	{ "GtkTextMark", GtkTextMark.sizeof },
	{ "GtkTextTagTableClass", GtkTextTagTableClass.sizeof },
	{ "GtkTearoffMenuItemClass", GtkTearoffMenuItemClass.sizeof },
	{ "GtkTearoffMenuItem", GtkTearoffMenuItem.sizeof },
	{ "GtkTableRowCol", GtkTableRowCol.sizeof },
	{ "GtkTableChild", GtkTableChild.sizeof },
	{ "GtkTableClass", GtkTableClass.sizeof },
	{ "GtkTable", GtkTable.sizeof },
	{ "GtkStockItem", GtkStockItem.sizeof },
	{ "GtkStatusIconClass", GtkStatusIconClass.sizeof },
	{ "GtkStatusIcon", GtkStatusIcon.sizeof },
	{ "GtkStatusbarClass", GtkStatusbarClass.sizeof },
	{ "GtkStatusbar", GtkStatusbar.sizeof },
	{ "GtkSpinButtonClass", GtkSpinButtonClass.sizeof },
	{ "GtkSpinButton", GtkSpinButton.sizeof },
	{ "GtkSizeGroupClass", GtkSizeGroupClass.sizeof },
	{ "GtkSizeGroup", GtkSizeGroup.sizeof },
	{ "GtkSeparatorToolItemClass", GtkSeparatorToolItemClass.sizeof },
	{ "GtkSeparatorToolItem", GtkSeparatorToolItem.sizeof },
	{ "GtkSeparatorMenuItemClass", GtkSeparatorMenuItemClass.sizeof },
	{ "GtkSeparatorMenuItem", GtkSeparatorMenuItem.sizeof },
	{ "GtkScrolledWindowClass", GtkScrolledWindowClass.sizeof },
	{ "GtkScrolledWindow", GtkScrolledWindow.sizeof },
	{ "GtkViewportClass", GtkViewportClass.sizeof },
	{ "GtkViewport", GtkViewport.sizeof },
	{ "GtkScaleButtonClass", GtkScaleButtonClass.sizeof },
	{ "GtkScaleButton", GtkScaleButton.sizeof },
	{ "GtkRecentChooserWidgetClass", GtkRecentChooserWidgetClass.sizeof },
	{ "GtkRecentChooserWidget", GtkRecentChooserWidget.sizeof },
	{ "GtkRecentChooserMenuClass", GtkRecentChooserMenuClass.sizeof },
	{ "GtkRecentChooserMenu", GtkRecentChooserMenu.sizeof },
	{ "GtkRecentChooserDialogClass", GtkRecentChooserDialogClass.sizeof },
	{ "GtkRecentChooserDialog", GtkRecentChooserDialog.sizeof },
	{ "GtkRecentChooserIface", GtkRecentChooserIface.sizeof },
	{ "GtkRecentFilterInfo", GtkRecentFilterInfo.sizeof },
	{ "GtkRecentActionClass", GtkRecentActionClass.sizeof },
	{ "GtkRecentAction", GtkRecentAction.sizeof },
	{ "GtkRecentManagerClass", GtkRecentManagerClass.sizeof },
	{ "GtkRecentManager", GtkRecentManager.sizeof },
	{ "GtkRecentData", GtkRecentData.sizeof },
	{ "GtkRadioToolButtonClass", GtkRadioToolButtonClass.sizeof },
	{ "GtkRadioToolButton", GtkRadioToolButton.sizeof },
	{ "GtkToggleToolButtonClass", GtkToggleToolButtonClass.sizeof },
	{ "GtkToggleToolButton", GtkToggleToolButton.sizeof },
	{ "GtkRadioMenuItemClass", GtkRadioMenuItemClass.sizeof },
	{ "GtkRadioMenuItem", GtkRadioMenuItem.sizeof },
	{ "GtkRadioButtonClass", GtkRadioButtonClass.sizeof },
	{ "GtkRadioButton", GtkRadioButton.sizeof },
	{ "GtkRadioActionClass", GtkRadioActionClass.sizeof },
	{ "GtkRadioAction", GtkRadioAction.sizeof },
	{ "GtkToggleActionClass", GtkToggleActionClass.sizeof },
	{ "GtkToggleAction", GtkToggleAction.sizeof },
	{ "GtkProgressBarClass", GtkProgressBarClass.sizeof },
	{ "GtkProgressBar", GtkProgressBar.sizeof },
	{ "GtkProgressClass", GtkProgressClass.sizeof },
	{ "GtkProgress", GtkProgress.sizeof },
	{ "GtkPrintOperation", GtkPrintOperation.sizeof },
	{ "GtkPrintOperationClass", GtkPrintOperationClass.sizeof },
	{ "GtkPrintOperationPreviewIface", GtkPrintOperationPreviewIface.sizeof },
	{ "GtkPageRange", GtkPageRange.sizeof },
	{ "GtkPreviewClass", GtkPreviewClass.sizeof },
	{ "GtkDitherInfo", GtkDitherInfo.sizeof },
	{ "GtkPreviewInfo", GtkPreviewInfo.sizeof },
	{ "GtkPreview", GtkPreview.sizeof },
	{ "GtkPlugClass", GtkPlugClass.sizeof },
	{ "GtkPlug", GtkPlug.sizeof },
	{ "GtkSocketClass", GtkSocketClass.sizeof },
	{ "GtkSocket", GtkSocket.sizeof },
	{ "GtkPixmapClass", GtkPixmapClass.sizeof },
	{ "GtkPixmap", GtkPixmap.sizeof },
	{ "GtkOptionMenuClass", GtkOptionMenuClass.sizeof },
	{ "GtkOptionMenu", GtkOptionMenu.sizeof },
	{ "GtkOldEditableClass", GtkOldEditableClass.sizeof },
	{ "GtkOldEditable", GtkOldEditable.sizeof },
	{ "GtkNotebookClass", GtkNotebookClass.sizeof },
	{ "GtkNotebook", GtkNotebook.sizeof },
	{ "GtkMessageDialogClass", GtkMessageDialogClass.sizeof },
	{ "GtkMessageDialog", GtkMessageDialog.sizeof },
	{ "GtkMenuToolButton", GtkMenuToolButton.sizeof },
	{ "GtkMenuToolButtonClass", GtkMenuToolButtonClass.sizeof },
	{ "GtkToolButtonClass", GtkToolButtonClass.sizeof },
	{ "GtkToolButton", GtkToolButton.sizeof },
	{ "GtkToolItemClass", GtkToolItemClass.sizeof },
	{ "GtkToolItem", GtkToolItem.sizeof },
	{ "GtkTooltipsData", GtkTooltipsData.sizeof },
	{ "GtkTooltipsClass", GtkTooltipsClass.sizeof },
	{ "GtkTooltips", GtkTooltips.sizeof },
	{ "GtkMenuBarClass", GtkMenuBarClass.sizeof },
	{ "GtkMenuBar", GtkMenuBar.sizeof },
	{ "GtkListClass", GtkListClass.sizeof },
	{ "GtkList", GtkList.sizeof },
	{ "GtkListItemClass", GtkListItemClass.sizeof },
	{ "GtkListItem", GtkListItem.sizeof },
	{ "GtkLinkButtonClass", GtkLinkButtonClass.sizeof },
	{ "GtkLinkButton", GtkLinkButton.sizeof },
	{ "GtkLayoutClass", GtkLayoutClass.sizeof },
	{ "GtkLayout", GtkLayout.sizeof },
	{ "GtkInvisibleClass", GtkInvisibleClass.sizeof },
	{ "GtkInvisible", GtkInvisible.sizeof },
	{ "GtkInputDialogClass", GtkInputDialogClass.sizeof },
	{ "GtkInputDialog", GtkInputDialog.sizeof },
	{ "GtkIMMulticontextClass", GtkIMMulticontextClass.sizeof },
	{ "GtkIMMulticontext", GtkIMMulticontext.sizeof },
	{ "GtkIMContextSimpleClass", GtkIMContextSimpleClass.sizeof },
	{ "GtkIMContextSimple", GtkIMContextSimple.sizeof },
	{ "GtkImageMenuItemClass", GtkImageMenuItemClass.sizeof },
	{ "GtkImageMenuItem", GtkImageMenuItem.sizeof },
	{ "GtkIconViewClass", GtkIconViewClass.sizeof },
	{ "GtkIconView", GtkIconView.sizeof },
	{ "GtkIconThemeClass", GtkIconThemeClass.sizeof },
	{ "GtkIconTheme", GtkIconTheme.sizeof },
	{ "GtkIconFactoryClass", GtkIconFactoryClass.sizeof },
	{ "GtkHSeparatorClass", GtkHSeparatorClass.sizeof },
	{ "GtkHSeparator", GtkHSeparator.sizeof },
	{ "GtkSeparatorClass", GtkSeparatorClass.sizeof },
	{ "GtkSeparator", GtkSeparator.sizeof },
	{ "GtkHScaleClass", GtkHScaleClass.sizeof },
	{ "GtkHScale", GtkHScale.sizeof },
	{ "GtkScaleClass", GtkScaleClass.sizeof },
	{ "GtkScale", GtkScale.sizeof },
	{ "GtkHRulerClass", GtkHRulerClass.sizeof },
	{ "GtkHRuler", GtkHRuler.sizeof },
	{ "GtkRulerMetric", GtkRulerMetric.sizeof },
	{ "GtkRulerClass", GtkRulerClass.sizeof },
	{ "GtkRuler", GtkRuler.sizeof },
	{ "GtkHPanedClass", GtkHPanedClass.sizeof },
	{ "GtkHPaned", GtkHPaned.sizeof },
	{ "GtkPanedClass", GtkPanedClass.sizeof },
	{ "GtkPaned", GtkPaned.sizeof },
	{ "GtkHButtonBoxClass", GtkHButtonBoxClass.sizeof },
	{ "GtkHButtonBox", GtkHButtonBox.sizeof },
	{ "GtkHandleBoxClass", GtkHandleBoxClass.sizeof },
	{ "GtkHandleBox", GtkHandleBox.sizeof },
	{ "GtkGammaCurveClass", GtkGammaCurveClass.sizeof },
	{ "GtkGammaCurve", GtkGammaCurve.sizeof },
	{ "GtkFontSelectionDialogClass", GtkFontSelectionDialogClass.sizeof },
	{ "GtkFontSelectionDialog", GtkFontSelectionDialog.sizeof },
	{ "GtkFontSelectionClass", GtkFontSelectionClass.sizeof },
	{ "GtkFontSelection", GtkFontSelection.sizeof },
	{ "GtkFontButtonClass", GtkFontButtonClass.sizeof },
	{ "GtkFontButton", GtkFontButton.sizeof },
	{ "GtkFileChooserWidgetClass", GtkFileChooserWidgetClass.sizeof },
	{ "GtkFileChooserWidget", GtkFileChooserWidget.sizeof },
	{ "GtkFileChooserDialogClass", GtkFileChooserDialogClass.sizeof },
	{ "GtkFileChooserDialog", GtkFileChooserDialog.sizeof },
	{ "GtkFileChooserButtonClass", GtkFileChooserButtonClass.sizeof },
	{ "GtkFileChooserButton", GtkFileChooserButton.sizeof },
	{ "GtkFileFilterInfo", GtkFileFilterInfo.sizeof },
	{ "GtkFixedChild", GtkFixedChild.sizeof },
	{ "GtkFixedClass", GtkFixedClass.sizeof },
	{ "GtkFixed", GtkFixed.sizeof },
	{ "GtkFileSelectionClass", GtkFileSelectionClass.sizeof },
	{ "GtkFileSelection", GtkFileSelection.sizeof },
	{ "GtkExpanderClass", GtkExpanderClass.sizeof },
	{ "GtkExpander", GtkExpander.sizeof },
	{ "GtkEventBoxClass", GtkEventBoxClass.sizeof },
	{ "GtkEventBox", GtkEventBox.sizeof },
	{ "GtkCurveClass", GtkCurveClass.sizeof },
	{ "GtkCurve", GtkCurve.sizeof },
	{ "GtkDrawingAreaClass", GtkDrawingAreaClass.sizeof },
	{ "GtkDrawingArea", GtkDrawingArea.sizeof },
	{ "GtkCTreeNode", GtkCTreeNode.sizeof },
	{ "GtkCTreeRow", GtkCTreeRow.sizeof },
	{ "GtkCTreeClass", GtkCTreeClass.sizeof },
	{ "GtkCTree", GtkCTree.sizeof },
	{ "GtkComboBoxEntryClass", GtkComboBoxEntryClass.sizeof },
	{ "GtkComboBoxEntry", GtkComboBoxEntry.sizeof },
	{ "GtkComboBoxClass", GtkComboBoxClass.sizeof },
	{ "GtkComboBox", GtkComboBox.sizeof },
	{ "GtkTreeSelectionClass", GtkTreeSelectionClass.sizeof },
	{ "GtkTreeSelection", GtkTreeSelection.sizeof },
	{ "GtkTreeViewClass", GtkTreeViewClass.sizeof },
	{ "GtkTreeView", GtkTreeView.sizeof },
	{ "GtkEntryClass", GtkEntryClass.sizeof },
	{ "GtkEntry", GtkEntry.sizeof },
	{ "GtkEntryCompletionClass", GtkEntryCompletionClass.sizeof },
	{ "GtkEntryCompletion", GtkEntryCompletion.sizeof },
	{ "GtkTreeModelFilterClass", GtkTreeModelFilterClass.sizeof },
	{ "GtkTreeModelFilter", GtkTreeModelFilter.sizeof },
	{ "GtkListStoreClass", GtkListStoreClass.sizeof },
	{ "GtkListStore", GtkListStore.sizeof },
	{ "GtkIMContextClass", GtkIMContextClass.sizeof },
	{ "GtkIMContext", GtkIMContext.sizeof },
	{ "GtkEditableClass", GtkEditableClass.sizeof },
	{ "GtkComboClass", GtkComboClass.sizeof },
	{ "GtkCombo", GtkCombo.sizeof },
	{ "GtkHBoxClass", GtkHBoxClass.sizeof },
	{ "GtkHBox", GtkHBox.sizeof },
	{ "GtkColorSelectionDialogClass", GtkColorSelectionDialogClass.sizeof },
	{ "GtkColorSelectionDialog", GtkColorSelectionDialog.sizeof },
	{ "GtkColorSelectionClass", GtkColorSelectionClass.sizeof },
	{ "GtkColorSelection", GtkColorSelection.sizeof },
	{ "GtkVBoxClass", GtkVBoxClass.sizeof },
	{ "GtkVBox", GtkVBox.sizeof },
	{ "GtkColorButtonClass", GtkColorButtonClass.sizeof },
	{ "GtkColorButton", GtkColorButton.sizeof },
	{ "GtkCListDestInfo", GtkCListDestInfo.sizeof },
	{ "GtkCListCellInfo", GtkCListCellInfo.sizeof },
	{ "GtkCellWidget", GtkCellWidget.sizeof },
	{ "GtkCellPixText", GtkCellPixText.sizeof },
	{ "GtkCellPixmap", GtkCellPixmap.sizeof },
	{ "GtkCellText", GtkCellText.sizeof },
	{ "GtkCell", GtkCell.sizeof },
	{ "GtkCListRow", GtkCListRow.sizeof },
	{ "GtkCListColumn", GtkCListColumn.sizeof },
	{ "GtkCListClass", GtkCListClass.sizeof },
	{ "GtkCList", GtkCList.sizeof },
	{ "GtkVScrollbarClass", GtkVScrollbarClass.sizeof },
	{ "GtkVScrollbar", GtkVScrollbar.sizeof },
	{ "GtkHScrollbarClass", GtkHScrollbarClass.sizeof },
	{ "GtkHScrollbar", GtkHScrollbar.sizeof },
	{ "GtkScrollbarClass", GtkScrollbarClass.sizeof },
	{ "GtkScrollbar", GtkScrollbar.sizeof },
	{ "GtkRangeClass", GtkRangeClass.sizeof },
	{ "GtkRange", GtkRange.sizeof },
	{ "GtkTargetPair", GtkTargetPair.sizeof },
	{ "GtkTargetEntry", GtkTargetEntry.sizeof },
	{ "GtkTargetList", GtkTargetList.sizeof },
	{ "GtkTextBuffer", GtkTextBuffer.sizeof },
	{ "GtkTextChildAnchorClass", GtkTextChildAnchorClass.sizeof },
	{ "GtkTextChildAnchor", GtkTextChildAnchor.sizeof },
	{ "GtkTextAppearance", GtkTextAppearance.sizeof },
	{ "GtkTextTagClass", GtkTextTagClass.sizeof },
	{ "GtkTextTag", GtkTextTag.sizeof },
	{ "GtkTextAttributes", GtkTextAttributes.sizeof },
	{ "GtkTextTagTable", GtkTextTagTable.sizeof },
	{ "GtkTextIter", GtkTextIter.sizeof },
	{ "GtkCheckMenuItemClass", GtkCheckMenuItemClass.sizeof },
	{ "GtkCheckMenuItem", GtkCheckMenuItem.sizeof },
	{ "GtkMenuItemClass", GtkMenuItemClass.sizeof },
	{ "GtkMenuItem", GtkMenuItem.sizeof },
	{ "GtkItemClass", GtkItemClass.sizeof },
	{ "GtkItem", GtkItem.sizeof },
	{ "GtkCheckButtonClass", GtkCheckButtonClass.sizeof },
	{ "GtkCheckButton", GtkCheckButton.sizeof },
	{ "GtkToggleButtonClass", GtkToggleButtonClass.sizeof },
	{ "GtkToggleButton", GtkToggleButton.sizeof },
	{ "GtkCellViewClass", GtkCellViewClass.sizeof },
	{ "GtkCellView", GtkCellView.sizeof },
	{ "GtkCellRendererToggleClass", GtkCellRendererToggleClass.sizeof },
	{ "GtkCellRendererToggle", GtkCellRendererToggle.sizeof },
	{ "GtkCellRendererSpinClass", GtkCellRendererSpinClass.sizeof },
	{ "GtkCellRendererSpin", GtkCellRendererSpin.sizeof },
	{ "GtkCellRendererProgressClass", GtkCellRendererProgressClass.sizeof },
	{ "GtkCellRendererProgress", GtkCellRendererProgress.sizeof },
	{ "GtkCellRendererPixbufClass", GtkCellRendererPixbufClass.sizeof },
	{ "GtkCellRendererPixbuf", GtkCellRendererPixbuf.sizeof },
	{ "GtkCellRendererComboClass", GtkCellRendererComboClass.sizeof },
	{ "GtkCellRendererCombo", GtkCellRendererCombo.sizeof },
	{ "GtkCellRendererAccelClass", GtkCellRendererAccelClass.sizeof },
	{ "GtkCellRendererAccel", GtkCellRendererAccel.sizeof },
	{ "GtkCellRendererTextClass", GtkCellRendererTextClass.sizeof },
	{ "GtkCellRendererText", GtkCellRendererText.sizeof },
	{ "GtkCellLayoutIface", GtkCellLayoutIface.sizeof },
	{ "GtkTreeViewColumnClass", GtkTreeViewColumnClass.sizeof },
	{ "GtkTreeViewColumn", GtkTreeViewColumn.sizeof },
	{ "GtkTreeSortableIface", GtkTreeSortableIface.sizeof },
	{ "GtkTreeModelIface", GtkTreeModelIface.sizeof },
	{ "GtkTreeIter", GtkTreeIter.sizeof },
	{ "GtkCellRendererClass", GtkCellRendererClass.sizeof },
	{ "GtkCellRenderer", GtkCellRenderer.sizeof },
	{ "GtkCellEditableIface", GtkCellEditableIface.sizeof },
	{ "GtkCalendarClass", GtkCalendarClass.sizeof },
	{ "GtkCalendar", GtkCalendar.sizeof },
	{ "GtkButtonClass", GtkButtonClass.sizeof },
	{ "GtkButton", GtkButton.sizeof },
	{ "GtkImageIconNameData", GtkImageIconNameData.sizeof },
	{ "GtkImageAnimationData", GtkImageAnimationData.sizeof },
	{ "GtkImageIconSetData", GtkImageIconSetData.sizeof },
	{ "GtkImageStockData", GtkImageStockData.sizeof },
	{ "GtkImagePixbufData", GtkImagePixbufData.sizeof },
	{ "GtkImageImageData", GtkImageImageData.sizeof },
	{ "GtkImagePixmapData", GtkImagePixmapData.sizeof },
	{ "GtkImageClass", GtkImageClass.sizeof },
	{ "GtkImage", GtkImage.sizeof },
	{ "GtkBuildableIface", GtkBuildableIface.sizeof },
	{ "GtkBuilderClass", GtkBuilderClass.sizeof },
	{ "GtkBuilder", GtkBuilder.sizeof },
	{ "GtkBindingArg", GtkBindingArg.sizeof },
	{ "GtkBindingSignal", GtkBindingSignal.sizeof },
	{ "GtkBindingEntry", GtkBindingEntry.sizeof },
	{ "GtkBindingSet", GtkBindingSet.sizeof },
	{ "GtkButtonBoxClass", GtkButtonBoxClass.sizeof },
	{ "GtkButtonBox", GtkButtonBox.sizeof },
	{ "GtkBoxChild", GtkBoxChild.sizeof },
	{ "GtkBoxClass", GtkBoxClass.sizeof },
	{ "GtkBox", GtkBox.sizeof },
	{ "GtkAssistantClass", GtkAssistantClass.sizeof },
	{ "GtkAssistant", GtkAssistant.sizeof },
	{ "GtkAspectFrameClass", GtkAspectFrameClass.sizeof },
	{ "GtkAspectFrame", GtkAspectFrame.sizeof },
	{ "GtkFrameClass", GtkFrameClass.sizeof },
	{ "GtkFrame", GtkFrame.sizeof },
	{ "GtkArrowClass", GtkArrowClass.sizeof },
	{ "GtkArrow", GtkArrow.sizeof },
	{ "GtkAlignmentClass", GtkAlignmentClass.sizeof },
	{ "GtkAlignment", GtkAlignment.sizeof },
	{ "GtkRadioActionEntry", GtkRadioActionEntry.sizeof },
	{ "GtkToggleActionEntry", GtkToggleActionEntry.sizeof },
	{ "GtkActionEntry", GtkActionEntry.sizeof },
	{ "GtkActionGroupClass", GtkActionGroupClass.sizeof },
	{ "GtkActionGroup", GtkActionGroup.sizeof },
	{ "GtkMenuEntry", GtkMenuEntry.sizeof },
	{ "GtkItemFactoryItem", GtkItemFactoryItem.sizeof },
	{ "GtkItemFactoryEntry", GtkItemFactoryEntry.sizeof },
	{ "GtkItemFactoryClass", GtkItemFactoryClass.sizeof },
	{ "GtkItemFactory", GtkItemFactory.sizeof },
	{ "GtkActionClass", GtkActionClass.sizeof },
	{ "GtkAction", GtkAction.sizeof },
	{ "GtkAccessibleClass", GtkAccessibleClass.sizeof },
	{ "GtkAccessible", GtkAccessible.sizeof },
	{ "GtkAccelLabelClass", GtkAccelLabelClass.sizeof },
	{ "GtkAccelLabel", GtkAccelLabel.sizeof },
	{ "GtkLabelClass", GtkLabelClass.sizeof },
	{ "GtkLabel", GtkLabel.sizeof },
	{ "GtkMenuClass", GtkMenuClass.sizeof },
	{ "GtkMenu", GtkMenu.sizeof },
	{ "GtkMenuShellClass", GtkMenuShellClass.sizeof },
	{ "GtkMenuShell", GtkMenuShell.sizeof },
	{ "GtkMiscClass", GtkMiscClass.sizeof },
	{ "GtkMisc", GtkMisc.sizeof },
	{ "GtkAboutDialogClass", GtkAboutDialogClass.sizeof },
	{ "GtkAboutDialog", GtkAboutDialog.sizeof },
	{ "GtkDialogClass", GtkDialogClass.sizeof },
	{ "GtkDialog", GtkDialog.sizeof },
	{ "GtkWindowGroupClass", GtkWindowGroupClass.sizeof },
	{ "GtkWindowGroup", GtkWindowGroup.sizeof },
	{ "GtkWindowClass", GtkWindowClass.sizeof },
	{ "GtkBinClass", GtkBinClass.sizeof },
	{ "GtkBin", GtkBin.sizeof },
	{ "GtkContainerClass", GtkContainerClass.sizeof },
	{ "GtkContainer", GtkContainer.sizeof },
	{ "GtkWindow", GtkWindow.sizeof },
	{ "GtkWidgetShapeInfo", GtkWidgetShapeInfo.sizeof },
	{ "GtkWidgetAuxInfo", GtkWidgetAuxInfo.sizeof },
	{ "GtkWidgetClass", GtkWidgetClass.sizeof },
	{ "GtkSelectionData", GtkSelectionData.sizeof },
	{ "GtkRequisition", GtkRequisition.sizeof },
	{ "GtkSettingsValue", GtkSettingsValue.sizeof },
	{ "GtkSettingsClass", GtkSettingsClass.sizeof },
	{ "GtkRcStyleClass", GtkRcStyleClass.sizeof },
	{ "GtkIconFactory", GtkIconFactory.sizeof },
	{ "GtkWidget", GtkWidget.sizeof },
	{ "GtkSettings", GtkSettings.sizeof },
	{ "GtkRcProperty", GtkRcProperty.sizeof },
	{ "GtkRcStyle", GtkRcStyle.sizeof },
	{ "GtkStyleClass", GtkStyleClass.sizeof },
	{ "GtkStyle", GtkStyle.sizeof },
	{ "GtkBorder", GtkBorder.sizeof },
	{ "GtkAdjustmentClass", GtkAdjustmentClass.sizeof },
	{ "GtkAdjustment", GtkAdjustment.sizeof },
	{ "GtkObjectClass", GtkObjectClass.sizeof },
	{ "GtkTypeInfo", GtkTypeInfo.sizeof },
	{ "GtkObject", GtkObject.sizeof },
	{ "GtkArg", GtkArg.sizeof },
	{ "GtkAccelGroupEntry", GtkAccelGroupEntry.sizeof },
	{ "GtkAccelKey", GtkAccelKey.sizeof },
	{ "GtkAccelGroupClass", GtkAccelGroupClass.sizeof },
	{ "GtkAccelGroup", GtkAccelGroup.sizeof },
	{ "GtkPrintUnixDialogClass", GtkPrintUnixDialogClass.sizeof },
	{ "GtkPrintUnixDialog", GtkPrintUnixDialog.sizeof },
	{ "GtkPrintJobClass", GtkPrintJobClass.sizeof },
	{ "GtkPrintJob", GtkPrintJob.sizeof },
	{ "GtkPrinterClass", GtkPrinterClass.sizeof },
	{ "GtkPrinter", GtkPrinter.sizeof },
	{ "GtkPageSetupUnixDialogClass", GtkPageSetupUnixDialogClass.sizeof },
	{ "GtkPageSetupUnixDialog", GtkPageSetupUnixDialog.sizeof },
	{ "PangoRendererClass", PangoRendererClass.sizeof },
	{ "PangoRenderer", PangoRenderer.sizeof },
	{ "PangoLayoutLine", PangoLayoutLine.sizeof },
	{ "PangoGlyphItem", PangoGlyphItem.sizeof },
	{ "PangoGlyphString", PangoGlyphString.sizeof },
	{ "PangoGlyphInfo", PangoGlyphInfo.sizeof },
	{ "PangoGlyphVisAttr", PangoGlyphVisAttr.sizeof },
	{ "PangoGlyphGeometry", PangoGlyphGeometry.sizeof },
	{ "PangoItem", PangoItem.sizeof },
	{ "PangoAnalysis", PangoAnalysis.sizeof },
	{ "PangoAttrShape", PangoAttrShape.sizeof },
	{ "PangoAttrFontDesc", PangoAttrFontDesc.sizeof },
	{ "PangoAttrColor", PangoAttrColor.sizeof },
	{ "PangoAttrFloat", PangoAttrFloat.sizeof },
	{ "PangoAttrSize", PangoAttrSize.sizeof },
	{ "PangoAttrInt", PangoAttrInt.sizeof },
	{ "PangoAttrLanguage", PangoAttrLanguage.sizeof },
	{ "PangoAttrString", PangoAttrString.sizeof },
	{ "PangoAttrClass", PangoAttrClass.sizeof },
	{ "PangoAttribute", PangoAttribute.sizeof },
	{ "PangoColor", PangoColor.sizeof },
	{ "PangoMatrix", PangoMatrix.sizeof },
	{ "PangoRectangle", PangoRectangle.sizeof },
	{ "PangoLogAttr", PangoLogAttr.sizeof },
	{ "XExtensionVersion", XExtensionVersion.sizeof },
	{ "XButtonState", XButtonState.sizeof },
	{ "XKeyState", XKeyState.sizeof },
	{ "XValuatorState", XValuatorState.sizeof },
	{ "XDeviceState", XDeviceState.sizeof },
	{ "XDeviceTimeCoord", XDeviceTimeCoord.sizeof },
	{ "XEventList", XEventList.sizeof },
	{ "XDevice", XDevice.sizeof },
	{ "XInputClassInfo", XInputClassInfo.sizeof },
	{ "XValuatorInfo", XValuatorInfo.sizeof },
	{ "XAxisInfo", XAxisInfo.sizeof },
	{ "XButtonInfo", XButtonInfo.sizeof },
	{ "XKeyInfo", XKeyInfo.sizeof },
	{ "XDeviceInfo", XDeviceInfo.sizeof },
	{ "XDeviceEnableControl", XDeviceEnableControl.sizeof },
	{ "XDeviceCoreState", XDeviceCoreState.sizeof },
	{ "XDeviceCoreControl", XDeviceCoreControl.sizeof },
	{ "XDeviceAbsAreaControl", XDeviceAbsAreaControl.sizeof },
	{ "XDeviceAbsCalibControl", XDeviceAbsCalibControl.sizeof },
	{ "XDeviceResolutionState", XDeviceResolutionState.sizeof },
	{ "XDeviceResolutionControl", XDeviceResolutionControl.sizeof },
	{ "XDeviceControl", XDeviceControl.sizeof },
	{ "XLedFeedbackControl", XLedFeedbackControl.sizeof },
	{ "XBellFeedbackControl", XBellFeedbackControl.sizeof },
	{ "XIntegerFeedbackControl", XIntegerFeedbackControl.sizeof },
	{ "XStringFeedbackControl", XStringFeedbackControl.sizeof },
	{ "XKbdFeedbackControl", XKbdFeedbackControl.sizeof },
	{ "XPtrFeedbackControl", XPtrFeedbackControl.sizeof },
	{ "XFeedbackControl", XFeedbackControl.sizeof },
	{ "XLedFeedbackState", XLedFeedbackState.sizeof },
	{ "XBellFeedbackState", XBellFeedbackState.sizeof },
	{ "XStringFeedbackState", XStringFeedbackState.sizeof },
	{ "XIntegerFeedbackState", XIntegerFeedbackState.sizeof },
	{ "XPtrFeedbackState", XPtrFeedbackState.sizeof },
	{ "XKbdFeedbackState", XKbdFeedbackState.sizeof },
	{ "XFeedbackState", XFeedbackState.sizeof },
	{ "XDevicePresenceNotifyEvent", XDevicePresenceNotifyEvent.sizeof },
	{ "XChangeDeviceNotifyEvent", XChangeDeviceNotifyEvent.sizeof },
	{ "XDeviceMappingEvent", XDeviceMappingEvent.sizeof },
	{ "XButtonStatus", XButtonStatus.sizeof },
	{ "XKeyStatus", XKeyStatus.sizeof },
	{ "XValuatorStatus", XValuatorStatus.sizeof },
	{ "XDeviceStateNotifyEvent", XDeviceStateNotifyEvent.sizeof },
	{ "XInputClass", XInputClass.sizeof },
	{ "XProximityNotifyEvent", XProximityNotifyEvent.sizeof },
	{ "XDeviceFocusChangeEvent", XDeviceFocusChangeEvent.sizeof },
	{ "XDeviceMotionEvent", XDeviceMotionEvent.sizeof },
	{ "XDeviceButtonEvent", XDeviceButtonEvent.sizeof },
	{ "XDeviceKeyEvent", XDeviceKeyEvent.sizeof },
	{ "XIMValuesList", XIMValuesList.sizeof },
	{ "XIMHotKeyTriggers", XIMHotKeyTriggers.sizeof },
	{ "XIMHotKeyTrigger", XIMHotKeyTrigger.sizeof },
	{ "XIMStatusDrawCallbackStruct", XIMStatusDrawCallbackStruct.sizeof },
	{ "XIMPreeditCaretCallbackStruct", XIMPreeditCaretCallbackStruct.sizeof },
	{ "XIMPreeditDrawCallbackStruct", XIMPreeditDrawCallbackStruct.sizeof },
	{ "XIMStringConversionCallbackStruct", XIMStringConversionCallbackStruct.sizeof },
	{ "XIMStringConversionText", XIMStringConversionText.sizeof },
	{ "XIMPreeditStateNotifyCallbackStruct", XIMPreeditStateNotifyCallbackStruct.sizeof },
	{ "XIMText", XIMText.sizeof },
	{ "XICCallback", XICCallback.sizeof },
	{ "XIMCallback", XIMCallback.sizeof },
	{ "XIMStyles", XIMStyles.sizeof },
	{ "XOMFontInfo", XOMFontInfo.sizeof },
	{ "XOMOrientation", XOMOrientation.sizeof },
	{ "XOMCharSetList", XOMCharSetList.sizeof },
	{ "XwcTextItem", XwcTextItem.sizeof },
	{ "XmbTextItem", XmbTextItem.sizeof },
	{ "XFontSetExtents", XFontSetExtents.sizeof },
	{ "XEDataObject", XEDataObject.sizeof },
	{ "XTextItem16", XTextItem16.sizeof },
	{ "XChar2b", XChar2b.sizeof },
	{ "XTextItem", XTextItem.sizeof },
	{ "XFontStruct", XFontStruct.sizeof },
	{ "XFontProp", XFontProp.sizeof },
	{ "XCharStruct", XCharStruct.sizeof },
	{ "XEvent", XEvent.sizeof },
	{ "XAnyEvent", XAnyEvent.sizeof },
	{ "XErrorEvent", XErrorEvent.sizeof },
	{ "XMappingEvent", XMappingEvent.sizeof },
	{ "XClientMessageEvent", XClientMessageEvent.sizeof },
	{ "XColormapEvent", XColormapEvent.sizeof },
	{ "XSelectionEvent", XSelectionEvent.sizeof },
	{ "XSelectionRequestEvent", XSelectionRequestEvent.sizeof },
	{ "XSelectionClearEvent", XSelectionClearEvent.sizeof },
	{ "XPropertyEvent", XPropertyEvent.sizeof },
	{ "XCirculateRequestEvent", XCirculateRequestEvent.sizeof },
	{ "XCirculateEvent", XCirculateEvent.sizeof },
	{ "XConfigureRequestEvent", XConfigureRequestEvent.sizeof },
	{ "XResizeRequestEvent", XResizeRequestEvent.sizeof },
	{ "XGravityEvent", XGravityEvent.sizeof },
	{ "XConfigureEvent", XConfigureEvent.sizeof },
	{ "XReparentEvent", XReparentEvent.sizeof },
	{ "XMapRequestEvent", XMapRequestEvent.sizeof },
	{ "XMapEvent", XMapEvent.sizeof },
	{ "XUnmapEvent", XUnmapEvent.sizeof },
	{ "XDestroyWindowEvent", XDestroyWindowEvent.sizeof },
	{ "XCreateWindowEvent", XCreateWindowEvent.sizeof },
	{ "XVisibilityEvent", XVisibilityEvent.sizeof },
	{ "XNoExposeEvent", XNoExposeEvent.sizeof },
	{ "XGraphicsExposeEvent", XGraphicsExposeEvent.sizeof },
	{ "XExposeEvent", XExposeEvent.sizeof },
	{ "XKeymapEvent", XKeymapEvent.sizeof },
	{ "XFocusChangeEvent", XFocusChangeEvent.sizeof },
	{ "XCrossingEvent", XCrossingEvent.sizeof },
	{ "XMotionEvent", XMotionEvent.sizeof },
	{ "XButtonEvent", XButtonEvent.sizeof },
	{ "XKeyEvent", XKeyEvent.sizeof },
	{ "XModifierKeymap", XModifierKeymap.sizeof },
	{ "XTimeCoord", XTimeCoord.sizeof },
	{ "XKeyboardState", XKeyboardState.sizeof },
	{ "XKeyboardControl", XKeyboardControl.sizeof },
	{ "XArc", XArc.sizeof },
	{ "XRectangle", XRectangle.sizeof },
	{ "XPoint", XPoint.sizeof },
	{ "XSegment", XSegment.sizeof },
	{ "XColor", XColor.sizeof },
	{ "XWindowChanges", XWindowChanges.sizeof },
	{ "XImage", XImage.sizeof },
	{ "XServerInterpretedAddress", XServerInterpretedAddress.sizeof },
	{ "XHostAddress", XHostAddress.sizeof },
	{ "XWindowAttributes", XWindowAttributes.sizeof },
	{ "XSetWindowAttributes", XSetWindowAttributes.sizeof },
	{ "ScreenFormat", ScreenFormat.sizeof },
	{ "Screen", Screen.sizeof },
	{ "Depth", Depth.sizeof },
	{ "Visual", Visual.sizeof },
	{ "XGCValues", XGCValues.sizeof },
	{ "XPixmapFormatValues", XPixmapFormatValues.sizeof },
	{ "XExtCodes", XExtCodes.sizeof },
	{ "XExtData", XExtData.sizeof },
	{ "XConicalGradient", XConicalGradient.sizeof },
	{ "XRadialGradient", XRadialGradient.sizeof },
	{ "XLinearGradient", XLinearGradient.sizeof },
	{ "XTrap", XTrap.sizeof },
	{ "XSpanFix", XSpanFix.sizeof },
	{ "XAnimCursor", XAnimCursor.sizeof },
	{ "XIndexValue", XIndexValue.sizeof },
	{ "XFilters", XFilters.sizeof },
	{ "XTransform", XTransform.sizeof },
	{ "XTrapezoid", XTrapezoid.sizeof },
	{ "XCircle", XCircle.sizeof },
	{ "XTriangle", XTriangle.sizeof },
	{ "XLineFixed", XLineFixed.sizeof },
	{ "XPointFixed", XPointFixed.sizeof },
	{ "XPointDouble", XPointDouble.sizeof },
	{ "XGlyphElt32", XGlyphElt32.sizeof },
	{ "XGlyphElt16", XGlyphElt16.sizeof },
	{ "XGlyphElt8", XGlyphElt8.sizeof },
	{ "XGlyphInfo", XGlyphInfo.sizeof },
	{ "XRenderColor", XRenderColor.sizeof },
	{ "XRenderPictureAttributes", XRenderPictureAttributes.sizeof },
	{ "XRenderPictFormat", XRenderPictFormat.sizeof },
	{ "XRenderDirectFormat", XRenderDirectFormat.sizeof },
	{ "XStandardColormap", XStandardColormap.sizeof },
	{ "XVisualInfo", XVisualInfo.sizeof },
	{ "XComposeStatus", XComposeStatus.sizeof },
	{ "XClassHint", XClassHint.sizeof },
	{ "XIconSize", XIconSize.sizeof },
	{ "XTextProperty", XTextProperty.sizeof },
	{ "XWMHints", XWMHints.sizeof },
	{ "XSizeHints", XSizeHints.sizeof }
];

int main( char[][] args ){
	foreach( v; size_values ){
		printf( "%.*s\t%d\n", v.name, v.size );
	}
	return 0;
}



