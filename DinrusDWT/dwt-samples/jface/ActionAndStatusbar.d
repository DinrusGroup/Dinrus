/*
DWT/JFace in Action
GUI Design with Eclipse 3.0
Matthew Scarpino, Stephen Holder, Stanford Ng, and Laurent Mihalkovic

ISBN: 1932394273

Publisher: Manning

Port to the D programming language:
    Frank Benoit <benoit@tionex.de>
Added some stuff to play with the statusbar and its progressmonitor

*/
module jface.ActionAndStatusbar;

import dwtx.jface.action.Action;
import dwtx.jface.action.ActionContributionItem;
import dwtx.jface.action.MenuManager;
import dwtx.jface.action.StatusLineManager;
import dwtx.jface.action.ToolBarManager;
import dwtx.jface.resource.ImageDescriptor;
import dwtx.jface.window.ApplicationWindow;
import dwtx.core.runtime.IProgressMonitor;
import dwt.DWT;
import dwt.widgets.Composite;
import dwt.widgets.Control;
import dwt.widgets.Display;

import tango.text.convert.Format;
version(JIVE) import jive.stacktrace;
import dwt.dwthelper.utils;
import dwt.dwthelper.Runnable;

void main() {
    auto swin = new ActionAndStatusbar();
    swin.setBlockOnOpen(true);
    swin.open();
    Display.getCurrent().dispose();
}

public class ActionAndStatusbar : ApplicationWindow {
    StatusLineManager slm;

    StatusAction status_action;

    ActionContributionItem aci;

    public this() {
        super(null);
        slm = new StatusLineManager();
        status_action = new StatusAction(slm);
        aci = new ActionContributionItem(status_action);
        addStatusLine();
        addMenuBar();
        addToolBar(DWT.FLAT | DWT.WRAP);
    }

    protected Control createContents(Composite parent) {
        getShell().setText("Action/Contribution Example");
        parent.setSize(290, 150);
        aci.fill(parent);
        return parent;
    }

    protected MenuManager createMenuManager() {
        MenuManager main_menu = new MenuManager(null);
        MenuManager action_menu = new MenuManager("Menu");
        main_menu.add(action_menu);
        action_menu.add(status_action);
        return main_menu;
    }

    protected ToolBarManager createToolBarManager(int style) {
        ToolBarManager tool_bar_manager = new ToolBarManager(style);
        tool_bar_manager.add(status_action);
        return tool_bar_manager;
    }

    protected StatusLineManager createStatusLineManager() {
        return slm;
    }
}

class StatusAction : Action {
    StatusLineManager statman;

    short triggercount = 0;

    public this(StatusLineManager sm) {
        super("&Trigger@Ctrl+T", AS_PUSH_BUTTON);
        statman = sm;
        setToolTipText("Trigger the Action");
        setImageDescriptor(ImageDescriptor.createFromFile(
            getImportData!("eclipse-icon-red-16.png")));
    }

    public void run() {
        triggercount++;
        statman.setMessage( Format("The status action has fired. Count: {}", triggercount));

        if( triggercount % 5 == 0 ){
            statman.setCancelEnabled(true);
            auto pm = statman.getProgressMonitor();
            pm.setCanceled(false);
            pm.beginTask( "Task", 100 );
            auto runner = new class(pm) Runnable {
                IProgressMonitor pm;
                int w;
                this(IProgressMonitor a){
                    this.pm = a;
                }
                void run(){
                    const incr = 2;
                    this.pm.worked( incr );
                    w += incr;
                    if( w < 100 && !this.pm.isCanceled() ){
                        Display.getCurrent().timerExec( 100, this);
                    }
                    else{
                        this.pm.done();
                    }
                }
            };
            Display.getCurrent().syncExec(runner);
        }
    }
}
