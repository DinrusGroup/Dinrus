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
module dwt.graphics.Transform;

import dwt.DWT;
import dwt.DWTError;
import dwt.DWTException;
import dwt.internal.gdip.Gdip;

import dwt.graphics.Resource;
import dwt.graphics.Device;

import tango.text.convert.Format;
import dwt.dwthelper.utils;

/**
 * Instances of this class represent transformation matrices for
 * points expressed as (x, y) pairs of floating point numbers.
 * <p>
 * Application code must explicitly invoke the <code>Transform.dispose()</code>
 * method to release the operating system resources managed by each instance
 * when those instances are no longer required.
 * </p>
 * <p>
 * This class requires the operating system's advanced graphics subsystem
 * which may not be available on some platforms.
 * </p>
 *
 * @see <a href="http://www.eclipse.org/swt/examples.php">DWT Example: GraphicsExample</a>
 * @see <a href="http://www.eclipse.org/swt/">Sample code and further information</a>
 *
 * @since 3.1
 */
public class Transform : Resource
{
    alias Resource.init_ init_;
    /**
     * the OS resource for the Transform
     * (Warning: This field is platform dependent)
     * <p>
     * <b>IMPORTANT:</b> This field is <em>not</em> part of the DWT
     * public API. It is marked public only so that it can be shared
     * within the packages provided by DWT. It is not available on all
     * platforms and should never be accessed from application code.
     * </p>
     */
    public Gdip.Matrix handle;

    /**
     * Constructs a new identity Transform.
     * <p>
     * This operation requires the operating system's advanced
     * graphics subsystem which may not be available on some
     * platforms.
     * </p>
     *
     * @param device the device on which to allocate the Transform
     *
     * @exception IllegalArgumentException <ul>
     *    <li>ERROR_NULL_ARGUMENT - if device is null and there is no current device</li>
     * </ul>
     * @exception DWTException <ul>
     *    <li>ERROR_NO_GRAPHICS_LIBRARY - if advanced graphics are not available</li>
     * </ul>
     * @exception DWTError <ul>
     *    <li>ERROR_NO_HANDLES if a handle for the Transform could not be obtained</li>
     * </ul>
     *
     * @see #dispose()
     */
    public this (Device device)
    {
        this(device, 1, 0, 0, 1, 0, 0);
    }

    /**
     * Constructs a new Transform given an array of elements that represent the
     * matrix that describes the transformation.
     * <p>
     * This operation requires the operating system's advanced
     * graphics subsystem which may not be available on some
     * platforms.
     * </p>
     *
     * @param device the device on which to allocate the Transform
     * @param elements an array of floats that describe the transformation matrix
     *
     * @exception IllegalArgumentException <ul>
     *    <li>ERROR_NULL_ARGUMENT - if device is null and there is no current device, or the elements array is null</li>
     *    <li>ERROR_INVALID_ARGUMENT - if the elements array is too small to hold the matrix values</li>
     * </ul>
     * @exception DWTException <ul>
     *    <li>ERROR_NO_GRAPHICS_LIBRARY - if advanced graphics are not available</li>
     * </ul>
     * @exception DWTError <ul>
     *    <li>ERROR_NO_HANDLES if a handle for the Transform could not be obtained</li>
     * </ul>
     *
     * @see #dispose()
     */
    public this(Device device, float[] elements)
    {
        this (device, checkTransform(elements)[0], elements[1], elements[2], elements[3], elements[4], elements[5]);
    }

    /**
     * Constructs a new Transform given all of the elements that represent the
     * matrix that describes the transformation.
     * <p>
     * This operation requires the operating system's advanced
     * graphics subsystem which may not be available on some
     * platforms.
     * </p>
     *
     * @param device the device on which to allocate the Transform
     * @param m11 the first element of the first row of the matrix
     * @param m12 the second element of the first row of the matrix
     * @param m21 the first element of the second row of the matrix
     * @param m22 the second element of the second row of the matrix
     * @param dx the third element of the first row of the matrix
     * @param dy the third element of the second row of the matrix
     *
     * @exception IllegalArgumentException <ul>
     *    <li>ERROR_NULL_ARGUMENT - if device is null and there is no current device</li>
     * </ul>
     * @exception DWTException <ul>
     *    <li>ERROR_NO_GRAPHICS_LIBRARY - if advanced graphics are not available</li>
     * </ul>
     * @exception DWTError <ul>
     *    <li>ERROR_NO_HANDLES if a handle for the Transform could not be obtained</li>
     * </ul>
     *
     * @see #dispose()
     */
    public this (Device device, float m11, float m12, float m21, float m22, float dx, float dy)
    {
        super(device);
        this.device.checkGDIP();
        handle = Gdip.Matrix_new(m11, m12, m21, m22, dx, dy);
        if (handle is null) DWT.error(DWT.ERROR_NO_HANDLES);
        init_();
    }

    static float[] checkTransform(float[] elements)
    {
        if (elements is null) DWT.error(DWT.ERROR_NULL_ARGUMENT);
        if (elements.length < 6) DWT.error(DWT.ERROR_INVALID_ARGUMENT);
        return elements;
    }

    void destroy()
    {
        Gdip.Matrix_delete(handle);
        handle = null;
    }

    /**
     * Fills the parameter with the values of the transformation matrix
     * that the receiver represents, in the order {m11, m12, m21, m22, dx, dy}.
     *
     * @param elements array to hold the matrix values
     *
     * @exception DWTException <ul>
     *    <li>ERROR_GRAPHIC_DISPOSED - if the receiver has been disposed</li>
     * </ul>
     * @exception IllegalArgumentException <ul>
     *    <li>ERROR_NULL_ARGUMENT - if the parameter is null</li>
     *    <li>ERROR_INVALID_ARGUMENT - if the parameter is too small to hold the matrix values</li>
     * </ul>
     */
    public void getElements(float[] elements)
    {
        if (isDisposed()) DWT.error(DWT.ERROR_GRAPHIC_DISPOSED);
        if (elements is null) DWT.error(DWT.ERROR_NULL_ARGUMENT);
        if (elements.length < 6) DWT.error(DWT.ERROR_INVALID_ARGUMENT);
        Gdip.Matrix_GetElements(handle, elements.ptr);
    }

    /**
     * Modifies the receiver such that the matrix it represents becomes the
     * identity matrix.
     *
     * @exception DWTException <ul>
     *    <li>ERROR_GRAPHIC_DISPOSED - if the receiver has been disposed</li>
     * </ul>
     *
     * @since 3.4
     */
    public void identity()
    {
        if (isDisposed()) DWT.error(DWT.ERROR_GRAPHIC_DISPOSED);
        Gdip.Matrix_SetElements(handle, 1, 0, 0, 1, 0, 0);
    }

    /**
     * Modifies the receiver such that the matrix it represents becomes
     * the mathematical inverse of the matrix it previously represented.
     *
     * @exception DWTException <ul>
     *    <li>ERROR_GRAPHIC_DISPOSED - if the receiver has been disposed</li>
     *    <li>ERROR_CANNOT_INVERT_MATRIX - if the matrix is not invertible</li>
     * </ul>
     */
    public void invert()
    {
        if (isDisposed()) DWT.error(DWT.ERROR_GRAPHIC_DISPOSED);
        if (Gdip.Matrix_Invert(handle) !is 0) DWT.error(DWT.ERROR_CANNOT_INVERT_MATRIX);
    }

    /**
     * Returns <code>true</code> if the Transform has been disposed,
     * and <code>false</code> otherwise.
     * <p>
     * This method gets the dispose state for the Transform.
     * When a Transform has been disposed, it is an error to
     * invoke any other method using the Transform.
     *
     * @return <code>true</code> when the Transform is disposed, and <code>false</code> otherwise
     */
    override public bool isDisposed()
    {
        return handle is null;
    }

    /**
     * Returns <code>true</code> if the Transform represents the identity matrix
     * and false otherwise.
     *
     * @return <code>true</code> if the receiver is an identity Transform, and <code>false</code> otherwise
     */
    public bool isIdentity()
    {
        if (isDisposed()) DWT.error(DWT.ERROR_GRAPHIC_DISPOSED);
        return cast(bool) Gdip.Matrix_IsIdentity(handle);
    }

    /**
     * Modifies the receiver such that the matrix it represents becomes the
     * the result of multiplying the matrix it previously represented by the
     * argument.
     *
     * @param matrix the matrix to multiply the receiver by
     *
     * @exception DWTException <ul>
     *    <li>ERROR_GRAPHIC_DISPOSED - if the receiver has been disposed</li>
     * </ul>
     * @exception IllegalArgumentException <ul>
     *    <li>ERROR_NULL_ARGUMENT - if the parameter is null</li>
     *    <li>ERROR_INVALID_ARGUMENT - if the parameter has been disposed</li>
     * </ul>
     */
    public void multiply(Transform matrix)
    {
        if (isDisposed()) DWT.error(DWT.ERROR_GRAPHIC_DISPOSED);
        if (matrix is null) DWT.error(DWT.ERROR_NULL_ARGUMENT);
        if (matrix.isDisposed()) DWT.error(DWT.ERROR_INVALID_ARGUMENT);
        Gdip.Matrix_Multiply(handle, matrix.handle, Gdip.MatrixOrderPrepend);
    }

    /**
     * Modifies the receiver so that it represents a transformation that is
     * equivalent to its previous transformation rotated by the specified angle.
     * The angle is specified in degrees and for the identity transform 0 degrees
     * is at the 3 o'clock position. A positive value indicates a clockwise rotation
     * while a negative value indicates a counter-clockwise rotation.
     *
     * @param angle the angle to rotate the transformation by
     *
     * @exception DWTException <ul>
     *    <li>ERROR_GRAPHIC_DISPOSED - if the receiver has been disposed</li>
     * </ul>
     */
    public void rotate(float angle)
    {
        if (isDisposed()) DWT.error(DWT.ERROR_GRAPHIC_DISPOSED);
        Gdip.Matrix_Rotate(handle, angle, Gdip.MatrixOrderPrepend);
    }

    /**
     * Modifies the receiver so that it represents a transformation that is
     * equivalent to its previous transformation scaled by (scaleX, scaleY).
     *
     * @param scaleX the amount to scale in the X direction
     * @param scaleY the amount to scale in the Y direction
     *
     * @exception DWTException <ul>
     *    <li>ERROR_GRAPHIC_DISPOSED - if the receiver has been disposed</li>
     * </ul>
     */
    public void scale(float scaleX, float scaleY)
    {
        if (isDisposed()) DWT.error(DWT.ERROR_GRAPHIC_DISPOSED);
        Gdip.Matrix_Scale(handle, scaleX, scaleY, Gdip.MatrixOrderPrepend);
    }

    /**
     * Modifies the receiver to represent a new transformation given all of
     * the elements that represent the matrix that describes that transformation.
     *
     * @param m11 the first element of the first row of the matrix
     * @param m12 the second element of the first row of the matrix
     * @param m21 the first element of the second row of the matrix
     * @param m22 the second element of the second row of the matrix
     * @param dx the third element of the first row of the matrix
     * @param dy the third element of the second row of the matrix
     *
     * @exception DWTException <ul>
     *    <li>ERROR_GRAPHIC_DISPOSED - if the receiver has been disposed</li>
     * </ul>
     */
    public void setElements(float m11, float m12, float m21, float m22, float dx, float dy)
    {
        if (isDisposed()) DWT.error(DWT.ERROR_GRAPHIC_DISPOSED);
        Gdip.Matrix_SetElements(handle, m11, m12, m21, m22, dx, dy);
    }

    /**
     * Modifies the receiver so that it represents a transformation that is
     * equivalent to its previous transformation sheared by (shearX, shearY).
     *
     * @param shearX the shear factor in the X direction
     * @param shearY the shear factor in the Y direction
     *
     * @exception DWTException <ul>
     *    <li>ERROR_GRAPHIC_DISPOSED - if the receiver has been disposed</li>
     * </ul>
     *
     * @since 3.4
     */
    public void shear(float shearX, float shearY)
    {
        if (isDisposed()) DWT.error(DWT.ERROR_GRAPHIC_DISPOSED);
        Gdip.Matrix_Shear(handle, shearX, shearY, Gdip.MatrixOrderPrepend);
    }

    /**
     * Given an array containing points described by alternating x and y values,
     * modify that array such that each point has been replaced with the result of
     * applying the transformation represented by the receiver to that point.
     *
     * @param pointArray an array of alternating x and y values to be transformed
     *
     * @exception IllegalArgumentException <ul>
     *    <li>ERROR_NULL_ARGUMENT - if the point array is null</li>
     * </ul>
     * @exception DWTException <ul>
     *    <li>ERROR_GRAPHIC_DISPOSED - if the receiver has been disposed</li>
     * </ul>
     */
    public void transform(float[] pointArray)
    {
        if (isDisposed()) DWT.error(DWT.ERROR_GRAPHIC_DISPOSED);
        if (pointArray is null) DWT.error(DWT.ERROR_NULL_ARGUMENT);
        Gdip.Matrix_TransformPoints(handle, cast(Gdip.PointF*)pointArray.ptr, pointArray.length / 2);
    }

    /**
     * Modifies the receiver so that it represents a transformation that is
     * equivalent to its previous transformation translated by (offsetX, offsetY).
     *
     * @param offsetX the distance to translate in the X direction
     * @param offsetY the distance to translate in the Y direction
     *
     * @exception DWTException <ul>
     *    <li>ERROR_GRAPHIC_DISPOSED - if the receiver has been disposed</li>
     * </ul>
     */
    public void translate(float offsetX, float offsetY)
    {
        if (isDisposed()) DWT.error(DWT.ERROR_GRAPHIC_DISPOSED);
        Gdip.Matrix_Translate(handle, offsetX, offsetY, Gdip.MatrixOrderPrepend);
    }

    /**
     * Returns a string containing a concise, human-readable
     * description of the receiver.
     *
     * @return a string representation of the receiver
     */
    override public String toString()
    {
        if (isDisposed()) return "Transform {*DISPOSED*}";
        float[6] elements;
        getElements(elements);
        return Format("Transform {{{},{},{},{},{}}", elements [0], elements [1], elements [2], elements [3], elements [4], elements [5] );
    }

}
