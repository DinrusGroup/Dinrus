/*******************************************************************************
 * Copyright (c) 2000, 2006 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     IBM Corporation - initial API and implementation
 * Port to the D programming language:
 *     Frank Benoit <benoit@tionex.de>
 *******************************************************************************/
module dwtx.jface.text.templates.persistence.TemplateStore;

import dwtx.jface.text.templates.persistence.TemplatePersistenceData; // packageimport
import dwtx.jface.text.templates.persistence.TemplateReaderWriter; // packageimport
import dwtx.jface.text.templates.persistence.TemplatePersistenceMessages; // packageimport

import dwt.dwthelper.utils;
import dwtx.dwtxhelper.Collection;
import dwtx.dwtxhelper.StringWriter;
import dwtx.dwtxhelper.StringReader;

import dwtx.core.runtime.Assert;
import dwtx.jface.preference.IPersistentPreferenceStore;
import dwtx.jface.preference.IPreferenceStore;
import dwtx.jface.text.templates.ContextTypeRegistry;
import dwtx.jface.text.templates.Template;
import dwtx.jface.text.templates.TemplateException;
import dwtx.jface.util.IPropertyChangeListener;
import dwtx.jface.util.PropertyChangeEvent;

/**
 * A collection of templates. Clients may instantiate this class. In order to
 * load templates contributed using the <code>dwtx.ui.editors.templates</code>
 * extension point, use a <code>ContributionTemplateStore</code>.
 *
 * @since 3.0
 */
public class TemplateStore {
    /** The stored templates. */
    private const List fTemplates;
    /** The preference store. */
    private IPreferenceStore fPreferenceStore;
    /**
     * The key into <code>fPreferenceStore</code> the value of which holds custom templates
     * encoded as XML.
     */
    private String fKey;
    /**
     * The context type registry, or <code>null</code> if all templates regardless
     * of context type should be loaded.
     */
    private ContextTypeRegistry fRegistry;
    /**
     * Set to <code>true</code> if property change events should be ignored (e.g. during writing
     * to the preference store).
     *
     * @since 3.2
     */
    private bool fIgnorePreferenceStoreChanges= false;
    /**
     * The property listener, if any is registered, <code>null</code> otherwise.
     *
     * @since 3.2
     */
    private IPropertyChangeListener fPropertyListener;


    /**
     * Creates a new template store.
     *
     * @param store the preference store in which to store custom templates
     *        under <code>key</code>
     * @param key the key into <code>store</code> where to store custom
     *        templates
     */
    public this(IPreferenceStore store, String key) {
        fTemplates= new ArrayList();

        Assert.isNotNull(cast(Object)store);
        Assert.isNotNull(key);
        fPreferenceStore= store;
        fKey= key;
    }

    /**
     * Creates a new template store with a context type registry. Only templates
     * that specify a context type contained in the registry will be loaded by
     * this store if the registry is not <code>null</code>.
     *
     * @param registry a context type registry, or <code>null</code> if all
     *        templates should be loaded
     * @param store the preference store in which to store custom templates
     *        under <code>key</code>
     * @param key the key into <code>store</code> where to store custom
     *        templates
     */
    public this(ContextTypeRegistry registry, IPreferenceStore store, String key) {
        this(store, key);
        fRegistry= registry;
    }

    /**
     * Loads the templates from contributions and preferences.
     *
     * @throws IOException if loading fails.
     */
    public void load()  {
        fTemplates.clear();
        loadContributedTemplates();
        loadCustomTemplates();
    }

    /**
     * Starts listening for property changes on the preference store. If the configured preference
     * key changes, the template store is {@link #load() reloaded}. Call
     * {@link #stopListeningForPreferenceChanges()} to remove any listener and stop the
     * auto-updating behavior.
     *
     * @since 3.2
     */
    public final void startListeningForPreferenceChanges() {
        if (fPropertyListener is null) {
            fPropertyListener= new class()  IPropertyChangeListener {
                public void propertyChange(PropertyChangeEvent event) {
                    /*
                     * Don't load if we are in the process of saving ourselves. We are in sync anyway after the
                     * save operation, and clients may trigger reloading by listening to preference store
                     * updates.
                     */
                    if (!fIgnorePreferenceStoreChanges && fKey.equals(event.getProperty()))
                        try {
                            load();
                        } catch (IOException x) {
                            handleException(x);
                        }
                }
            };
            fPreferenceStore.addPropertyChangeListener(fPropertyListener);
        }

    }

    /**
     * Stops the auto-updating behavior started by calling
     * {@link #startListeningForPreferenceChanges()}.
     *
     * @since 3.2
     */
    public final void stopListeningForPreferenceChanges() {
        if (fPropertyListener !is null) {
            fPreferenceStore.removePropertyChangeListener(fPropertyListener);
            fPropertyListener= null;
        }
    }

    /**
     * Handles an {@link IOException} thrown during reloading the preferences due to a preference
     * store update. The default is to write to stderr.
     *
     * @param x the exception
     * @since 3.2
     */
    protected void handleException(IOException x) {
        ExceptionPrintStackTrace(x);
    }

    /**
     * Hook method to load contributed templates. Contributed templates are superseded
     * by customized versions of user added templates stored in the preferences.
     * <p>
     * The default implementation does nothing.</p>
     *
     * @throws IOException if loading fails
     */
    protected void loadContributedTemplates()  {
    }

    /**
     * Adds a template to the internal store. The added templates must have
     * a unique id.
     *
     * @param data the template data to add
     */
    protected void internalAdd(TemplatePersistenceData data) {
        if (!data.isCustom()) {
            // check if the added template is not a duplicate id
            String id= data.getId();
            for (Iterator it= fTemplates.iterator(); it.hasNext();) {
                TemplatePersistenceData d2= cast(TemplatePersistenceData) it.next();
                if (d2.getId() !is null && d2.getId().equals(id))
                    return;
            }
            fTemplates.add(data);
        }
    }

    /**
     * Saves the templates to the preferences.
     *
     * @throws IOException if the templates cannot be written
     */
    public void save()  {
        ArrayList custom= new ArrayList();
        for (Iterator it= fTemplates.iterator(); it.hasNext();) {
            TemplatePersistenceData data= cast(TemplatePersistenceData) it.next();
            if (data.isCustom() && !(data.isUserAdded() && data.isDeleted())) // don't save deleted user-added templates
                custom.add(data);
        }

        StringWriter output= new StringWriter();
        TemplateReaderWriter writer= new TemplateReaderWriter();
        writer.save(arraycast!(TemplatePersistenceData)( custom.toArray()), output);

        fIgnorePreferenceStoreChanges= true;
        try {
            fPreferenceStore.setValue(fKey, output.toString());
            if ( cast(IPersistentPreferenceStore)fPreferenceStore )
                (cast(IPersistentPreferenceStore)fPreferenceStore).save();
        } finally {
            fIgnorePreferenceStoreChanges= false;
        }
    }

    /**
     * Adds a template encapsulated in its persistent form.
     *
     * @param data the template to add
     */
    public void add(TemplatePersistenceData data) {

        if (!validateTemplate(data.getTemplate()))
            return;

        if (data.isUserAdded()) {
            fTemplates.add(data);
        } else {
            for (Iterator it= fTemplates.iterator(); it.hasNext();) {
                TemplatePersistenceData d2= cast(TemplatePersistenceData) it.next();
                if (d2.getId() !is null && d2.getId().equals(data.getId())) {
                    d2.setTemplate(data.getTemplate());
                    d2.setDeleted(data.isDeleted());
                    d2.setEnabled(data.isEnabled());
                    return;
                }
            }

            // add an id which is not contributed as add-on
            if (data.getTemplate() !is null) {
                TemplatePersistenceData newData= new TemplatePersistenceData(data.getTemplate(), data.isEnabled());
                fTemplates.add(newData);
            }
        }
    }

    /**
     * Removes a template from the store.
     *
     * @param data the template to remove
     */
    public void delete_(TemplatePersistenceData data) {
        if (data.isUserAdded())
            fTemplates.remove(data);
        else
            data.setDeleted(true);
    }

    /**
     * Restores all contributed templates that have been deleted.
     */
    public void restoreDeleted() {
        for (Iterator it= fTemplates.iterator(); it.hasNext();) {
            TemplatePersistenceData data= cast(TemplatePersistenceData) it.next();
            if (data.isDeleted())
                data.setDeleted(false);
        }
    }

    /**
     * Deletes all user-added templates and reverts all contributed templates.
     */
    public void restoreDefaults() {
        try {
            fIgnorePreferenceStoreChanges= true;
            fPreferenceStore.setToDefault(fKey);
        } finally {
            fIgnorePreferenceStoreChanges= false;
        }
        try {
            load();
        } catch (IOException x) {
            // can't log from jface-text
            ExceptionPrintStackTrace(x);
        }
    }

    /**
     * Returns all enabled templates.
     *
     * @return all enabled templates
     */
    public Template[] getTemplates() {
        return getTemplates(null);
    }

    /**
     * Returns all enabled templates for the given context type.
     *
     * @param contextTypeId the id of the context type of the requested templates, or <code>null</code> if all templates should be returned
     * @return all enabled templates for the given context type
     */
    public Template[] getTemplates(String contextTypeId) {
        List templates= new ArrayList();
        for (Iterator it= fTemplates.iterator(); it.hasNext();) {
            TemplatePersistenceData data= cast(TemplatePersistenceData) it.next();
            if (data.isEnabled() && !data.isDeleted() && (contextTypeId is null || contextTypeId.equals(data.getTemplate().getContextTypeId())))
                templates.add(data.getTemplate());
        }

        return arraycast!(Template)( templates.toArray());
    }

    /**
     * Returns the first enabled template that matches the name.
     *
     * @param name the name of the template searched for
     * @return the first enabled template that matches both name and context type id, or <code>null</code> if none is found
     */
    public Template findTemplate(String name) {
        return findTemplate(name, null);
    }

    /**
     * Returns the first enabled template that matches both name and context type id.
     *
     * @param name the name of the template searched for
     * @param contextTypeId the context type id to clip unwanted templates, or <code>null</code> if any context type is OK
     * @return the first enabled template that matches both name and context type id, or <code>null</code> if none is found
     */
    public Template findTemplate(String name, String contextTypeId) {
        Assert.isNotNull(name);

        for (Iterator it= fTemplates.iterator(); it.hasNext();) {
            TemplatePersistenceData data= cast(TemplatePersistenceData) it.next();
            Template template_= data.getTemplate();
            if (data.isEnabled() && !data.isDeleted()
                    && (contextTypeId is null || contextTypeId.equals(template_.getContextTypeId()))
                    && name.equals(template_.getName()))
                return template_;
        }

        return null;
    }

    /**
     * Returns the first enabled template that matches the given template id.
     *
     * @param id the id of the template searched for
     * @return the first enabled template that matches id, or <code>null</code> if none is found
     * @since 3.1
     */
    public Template findTemplateById(String id) {
        TemplatePersistenceData data= getTemplateData(id);
        if (data !is null && !data.isDeleted())
            return data.getTemplate();

        return null;
    }

    /**
     * Returns all template data.
     *
     * @param includeDeleted whether to include deleted data
     * @return all template data, whether enabled or not
     */
    public TemplatePersistenceData[] getTemplateData(bool includeDeleted) {
        List datas= new ArrayList();
        for (Iterator it= fTemplates.iterator(); it.hasNext();) {
            TemplatePersistenceData data= cast(TemplatePersistenceData) it.next();
            if (includeDeleted || !data.isDeleted())
                datas.add(data);
        }

        return arraycast!(TemplatePersistenceData)( datas.toArray());
    }

    /**
     * Returns the template data of the template with id <code>id</code> or
     * <code>null</code> if no such template can be found.
     *
     * @param id the id of the template data
     * @return the template data of the template with id <code>id</code> or <code>null</code>
     * @since 3.1
     */
    public TemplatePersistenceData getTemplateData(String id) {
        Assert.isNotNull(id);
        for (Iterator it= fTemplates.iterator(); it.hasNext();) {
            TemplatePersistenceData data= cast(TemplatePersistenceData) it.next();
            if (id.equals(data.getId()))
                return data;
        }

        return null;
    }

    private void loadCustomTemplates()  {
        String pref= fPreferenceStore.getString(fKey);
        if (pref !is null && pref.trim().length() > 0) {
            Reader input= new StringReader(pref);
            TemplateReaderWriter reader= new TemplateReaderWriter();
            TemplatePersistenceData[] datas= reader.read(input);
            for (int i= 0; i < datas.length; i++) {
                TemplatePersistenceData data= datas[i];
                add(data);
            }
        }
    }

    /**
     * Validates a template against the context type registered in the context
     * type registry. Returns always <code>true</code> if no registry is
     * present.
     *
     * @param template the template to validate
     * @return <code>true</code> if validation is successful or no context
     *         type registry is specified, <code>false</code> if validation
     *         fails
     */
    private bool validateTemplate(Template template_) {
        String contextTypeId= template_.getContextTypeId();
        if (contextExists(contextTypeId)) {
            if (fRegistry !is null)
                try {
                    fRegistry.getContextType(contextTypeId).validate(template_.getPattern());
                } catch (TemplateException e) {
                    return false;
                }
            return true;
        }

        return false;
    }

    /**
     * Returns <code>true</code> if a context type id specifies a valid context type
     * or if no context type registry is present.
     *
     * @param contextTypeId the context type id to look for
     * @return <code>true</code> if the context type specified by the id
     *         is present in the context type registry, or if no registry is
     *         specified
     */
    private bool contextExists(String contextTypeId) {
        return contextTypeId !is null && (fRegistry is null || fRegistry.getContextType(contextTypeId) !is null);
    }

    /**
     * Returns the registry.
     *
     * @return Returns the registry
     */
    protected final ContextTypeRegistry getRegistry() {
        return fRegistry;
    }
}

