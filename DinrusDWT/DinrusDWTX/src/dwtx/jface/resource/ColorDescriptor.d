/*******************************************************************************
 * Copyright (c) 2004, 2006 IBM Corporation and others.
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
module dwtx.jface.resource.ColorDescriptor;

import dwtx.jface.resource.DeviceResourceDescriptor;
import dwtx.jface.resource.RGBColorDescriptor;

import dwt.graphics.Color;
import dwt.graphics.Device;
import dwt.graphics.RGB;

import dwt.dwthelper.utils;

/**
 * Lightweight descriptor for an DWT color. Each ColorDescriptor will create a particular DWT
 * Color on demand. This object will be compared so hashCode(...) and equals(...) must
 * return meaningful values.
 *
 * @since 3.1
 */
public abstract class ColorDescriptor : DeviceResourceDescriptor {

    /**
     * Creates a ColorDescriptor from an existing Color, given the Device associated
     * with the original Color. This is the usual way to convert a Color into
     * a ColorDescriptor. Note that the returned ColorDescriptor depends on the
     * original Color, and disposing the Color will invalidate the ColorDescriptor.
     *
     * @deprecated use {@link ColorDescriptor#createFrom(Color)}
     *
     * @since 3.1
     *
     * @param toCreate Color to convert into a ColorDescriptor.
     * @param originalDevice this must be the same Device that was passed into the
     * original Color's constructor.
     * @return a newly created ColorDescriptor that describes the given Color.
     */
    public static ColorDescriptor createFrom(Color toCreate, Device originalDevice) {
        return new RGBColorDescriptor(toCreate);
    }

    /**
     * Creates a ColorDescriptor from an existing color.
     *
     * The returned ColorDescriptor depends on the original Color. Disposing
     * the original colour while the color descriptor is still in use may cause
     * DWT to throw a graphic disposed exception.
     *
     * @since 3.1
     *
     * @param toCreate Color to generate a ColorDescriptor from
     * @return a newly created ColorDescriptor
     */
    public static ColorDescriptor createFrom(Color toCreate) {
        return new RGBColorDescriptor(toCreate);
    }

    /**
     * Returns a color descriptor for the given RGB values
     * @since 3.1
     *
     * @param toCreate RGB values to create
     * @return a new ColorDescriptor
     */
    public static ColorDescriptor createFrom(RGB toCreate) {
        return new RGBColorDescriptor(toCreate);
    }

    /**
     * Returns the Color described by this descriptor.
     *
     * @param device DWT device on which to allocate the Color
     * @return a newly allocated DWT Color object (never null)
     * @throws DeviceResourceException if unable to allocate the Color
     */
    public abstract Color createColor(Device device);

    /**
     * Undoes whatever was done by createColor.
     *
     * @since 3.1
     *
     * @param toDestroy a Color that was previously allocated by an equal ColorDescriptor
     */
    public abstract void destroyColor(Color toDestroy);

    /* (non-Javadoc)
     * @see dwtx.jface.resource.DeviceResourceDescriptor#createResource(dwt.graphics.Device)
     */
    public override final Object createResource(Device device){
        return createColor(device);
    }

    /* (non-Javadoc)
     * @see dwtx.jface.resource.DeviceResourceDescriptor#destroyResource(java.lang.Object)
     */
    public override final void destroyResource(Object previouslyCreatedObject) {
        destroyColor(cast(Color)previouslyCreatedObject);
    }
}
