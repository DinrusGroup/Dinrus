/*******************************************************************************
 * Copyright (c) 2000, 2008 IBM Corporation and others.
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
module dwtx.jface.text.templates.persistence.TemplatePersistenceData;

import dwtx.jface.text.templates.persistence.TemplateReaderWriter; // packageimport
import dwtx.jface.text.templates.persistence.TemplatePersistenceMessages; // packageimport
import dwtx.jface.text.templates.persistence.TemplateStore; // packageimport


import dwt.dwthelper.utils;


import dwtx.core.runtime.Assert;
import dwtx.jface.text.templates.Template;


/**
 * TemplatePersistenceData stores information about a template. It uniquely
 * references contributed templates via their id. Contributed templates may be
 * deleted or modified. All template may be enabled or not.
 * <p>
 * Clients may use this class, although this is not usually needed except when
 * implementing a custom template preference page or template store. This class
 * is not intended to be subclassed.
 * </p>
 *
 * @since 3.0
 * @noextend This class is not intended to be subclassed by clients.
 */
public class TemplatePersistenceData {
    private const Template fOriginalTemplate;
    private const String fId;
    private const bool fOriginalIsEnabled;

    private Template fCustomTemplate= null;
    private bool fIsDeleted= false;
    private bool fCustomIsEnabled= true;

    /**
     * Creates a new, user-added instance that is not linked to a contributed
     * template.
     *
     * @param template the template which is stored by the new instance
     * @param enabled whether the template is enabled
     */
    public this(Template template_, bool enabled) {
        this(template_, enabled, null);
    }

    /**
     * Creates a new instance. If <code>id</code> is not <code>null</code>,
     * the instance is represents a template that is contributed and can be
     * identified via its id.
     *
     * @param template the template which is stored by the new instance
     * @param enabled whether the template is enabled
     * @param id the id of the template, or <code>null</code> if a user-added
     *        instance should be created
     */
    public this(Template template_, bool enabled, String id) {
        Assert.isNotNull(template_);
        fOriginalTemplate= template_;
        fCustomTemplate= template_;
        fOriginalIsEnabled= enabled;
        fCustomIsEnabled= enabled;
        fId= id;
    }

    /**
     * Returns the id of this template store, or <code>null</code> if there is none.
     *
     * @return the id of this template store
     */
    public String getId() {
        return fId;
    }

    /**
     * Returns the deletion state of the stored template. This is only relevant
     * of contributed templates.
     *
     * @return the deletion state of the stored template
     */
    public bool isDeleted() {
        return fIsDeleted;
    }

    /**
     * Sets the deletion state of the stored template.
     *
     * @param isDeleted the deletion state of the stored template
     */
    public void setDeleted(bool isDeleted) {
        fIsDeleted= isDeleted;
    }

    /**
     * Returns the template encapsulated by the receiver.
     *
     * @return the template encapsulated by the receiver
     */
    public Template getTemplate() {
        return fCustomTemplate;
    }


    /**
     * Sets the template encapsulated by the receiver.
     *
     * @param template the new template
     */
    public void setTemplate(Template template_) {
        fCustomTemplate= template_;
    }

    /**
     * Returns whether the receiver represents a custom template, i.e. is either
     * a user-added template or a contributed template that has been modified.
     *
     * @return <code>true</code> if the contained template is a custom
     *         template and cannot be reconstructed from the contributed
     *         templates
     */
    public bool isCustom() {
        return fId is null
                || fIsDeleted
                || fOriginalIsEnabled !is fCustomIsEnabled
                || !fOriginalTemplate.equals(fCustomTemplate);
    }

    /**
     * Returns whether the receiver represents a modified template, i.e. a
     * contributed template that has been changed.
     *
     * @return <code>true</code> if the contained template is contributed but has been modified, <code>false</code> otherwise
     */
    public bool isModified() {
        return isCustom() && !isUserAdded();
    }

    /**
     * Returns <code>true</code> if the contained template was added by a
     * user, i.e. does not reference a contributed template.
     *
     * @return <code>true</code> if the contained template was added by a user, <code>false</code> otherwise
     */
    public bool isUserAdded() {
        return fId is null;
    }


    /**
     * Reverts the template to its original setting.
     */
    public void revert() {
        fCustomTemplate= fOriginalTemplate;
        fCustomIsEnabled= fOriginalIsEnabled;
        fIsDeleted= false;
    }


    /**
     * Returns the enablement state of the contained template.
     *
     * @return the enablement state of the contained template
     */
    public bool isEnabled() {
        return fCustomIsEnabled;
    }

    /**
     * Sets the enablement state of the contained template.
     *
     * @param isEnabled the new enablement state of the contained template
     */
    public void setEnabled(bool isEnabled) {
        fCustomIsEnabled= isEnabled;
    }
}
