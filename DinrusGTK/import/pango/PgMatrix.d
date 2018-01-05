module gtkD.pango.PgMatrix;

public  import gtkD.gtkc.pangotypes;

private import gtkD.gtkc.pango;
private import gtkD.glib.ConstructionException;






/**
 * Description
 * pango_shape() produces a string of glyphs which
 * can be measured or drawn to the screen. The following
 * structures are used to store information about
 * glyphs.
 */
public class PgMatrix
{
	
	/** the main Gtk struct */
	protected PangoMatrix* pangoMatrix;
	
	
	public PangoMatrix* getPgMatrixStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (PangoMatrix* pangoMatrix);
	
	/**
	 */
	
	/**
	 * Converts a number in Pango units to floating-point: divides
	 * it by PANGO_SCALE.
	 * Since 1.16
	 * Params:
	 * i =  value in Pango units
	 * Returns: the double value.
	 */
	public static double unitsToDouble(int i);

	/**
	 * Converts a floating-point number to Pango units: multiplies
	 * it by PANGO_SCALE and rounds to nearest integer.
	 * Since 1.16
	 * Params:
	 * d =  double floating-point value
	 * Returns: the value in Pango units.
	 */
	public static int unitsFromDouble(double d);
	
	/**
	 * Converts extents from Pango units to device units, dividing by the
	 * PANGO_SCALE factor and performing rounding.
	 * The inclusive rectangle is converted by flooring the x/y coordinates and extending
	 * width/height, such that the final rectangle completely includes the original
	 * rectangle.
	 * The nearest rectangle is converted by rounding the coordinates
	 * of the rectangle to the nearest device unit (pixel).
	 * The rule to which argument to use is: if you want the resulting device-space
	 * rectangle to completely contain the original rectangle, pass it in as inclusive.
	 * If you want two touching-but-not-overlapping rectangles stay
	 * touching-but-not-overlapping after rounding to device units, pass them in
	 * as nearest.
	 * Since 1.16
	 * Params:
	 * inclusive =  rectangle to round to pixels inclusively, or NULL.
	 * nearest =  rectangle to round to nearest pixels, or NULL.
	 */
	public static void extentsToPixels(PangoRectangle* inclusive, PangoRectangle* nearest);
	
	/**
	 * Copies a PangoMatrix.
	 * Since 1.6
	 * Params:
	 * matrix =  a PangoMatrix, may be NULL
	 * Returns: the newly allocated PangoMatrix, which should be freed with pango_matrix_free(), or NULL if matrix was NULL.
	 */
	public PgMatrix matrixCopy();
	
	/**
	 * Free a PangoMatrix created with pango_matrix_copy().
	 * Since 1.6
	 * Params:
	 * matrix =  a PangoMatrix, may be NULL
	 */
	public void matrixFree();
	
	/**
	 * Changes the transformation represented by matrix to be the
	 * transformation given by first translating by (tx, ty)
	 * then applying the original transformation.
	 * Since 1.6
	 * Params:
	 * matrix =  a PangoMatrix
	 * tx =  amount to translate in the X direction
	 * ty =  amount to translate in the Y direction
	 */
	public void matrixTranslate(double tx, double ty);
	
	/**
	 * Changes the transformation represented by matrix to be the
	 * transformation given by first scaling by sx in the X direction
	 * and sy in the Y direction then applying the original
	 * transformation.
	 * Since 1.6
	 * Params:
	 * matrix =  a PangoMatrix
	 * scaleX =  amount to scale by in X direction
	 * scaleY =  amount to scale by in Y direction
	 */
	public void matrixScale(double scaleX, double scaleY);
	
	/**
	 * Changes the transformation represented by matrix to be the
	 * transformation given by first rotating by degrees degrees
	 * counter-clockwise then applying the original transformation.
	 * Since 1.6
	 * Params:
	 * matrix =  a PangoMatrix
	 * degrees =  degrees to rotate counter-clockwise
	 */
	public void matrixRotate(double degrees);

	/**
	 * Changes the transformation represented by matrix to be the
	 * transformation given by first applying transformation
	 * given by new_matrix then applying the original transformation.
	 * Since 1.6
	 * Params:
	 * matrix =  a PangoMatrix
	 * newMatrix =  a PangoMatrix
	 */
	public void matrixConcat(PgMatrix newMatrix);
	
	/**
	 * Transforms the point (x, y) by matrix.
	 * Since 1.16
	 * Params:
	 * matrix =  a PangoMatrix, or NULL
	 * x =  in/out X position
	 * y =  in/out Y position
	 */
	public void matrixTransformPoint(inout double x, inout double y);
	
	/**
	 * Transforms the distance vector (dx,dy) by matrix. This is
	 * similar to pango_matrix_transform_point() except that the translation
	 * components of the transformation are ignored. The calculation of
	 * Since 1.16
	 * Params:
	 * matrix =  a PangoMatrix, or NULL
	 * dx =  in/out X component of a distance vector
	 * dy =  yn/out Y component of a distance vector
	 */
	public void matrixTransformDistance(inout double dx, inout double dy);
	
	/**
	 * First transforms rect using matrix, then calculates the bounding box
	 * of the transformed rectangle. The rectangle should be in Pango units.
	 * This function is useful for example when you want to draw a rotated
	 * PangoLayout to an image buffer, and want to know how large the image
	 * should be and how much you should shift the layout when rendering.
	 * If you have a rectangle in device units (pixels), use
	 * pango_matrix_transform_pixel_rectangle().
	 * If you have the rectangle in Pango units and want to convert to
	 * transformed pixel bounding box, it is more accurate to transform it first
	 * (using this function) and pass the result to pango_extents_to_pixels(),
	 * first argument, for an inclusive rounded rectangle.
	 * However, there are valid reasons that you may want to convert
	 * to pixels first and then transform, for example when the transformed
	 * coordinates may overflow in Pango units (large matrix translation for
	 * example).
	 * Since 1.16
	 * Params:
	 * matrix =  a PangoMatrix, or NULL
	 * rect =  in/out bounding box in Pango units, or NULL
	 */
	public void matrixTransformRectangle(PangoRectangle* rect);
	
	/**
	 * First transforms the rect using matrix, then calculates the bounding box
	 * of the transformed rectangle. The rectangle should be in device units
	 * (pixels).
	 * This function is useful for example when you want to draw a rotated
	 * PangoLayout to an image buffer, and want to know how large the image
	 * should be and how much you should shift the layout when rendering.
	 * For better accuracy, you should use pango_matrix_transform_rectangle() on
	 * original rectangle in Pango units and convert to pixels afterward
	 * using pango_extents_to_pixels()'s first argument.
	 * Since 1.16
	 * Params:
	 * matrix =  a PangoMatrix, or NULL
	 * rect =  in/out bounding box in device units, or NULL
	 */
	public void matrixTransformPixelRectangle(PangoRectangle* rect);
	
	/**
	 * Returns the scale factor of a matrix on the height of the font.
	 * That is, the scale factor in the direction perpendicular to the
	 * vector that the X coordinate is mapped to.
	 * Since 1.12
	 * Params:
	 * matrix =  a PangoMatrix, may be NULL
	 * Returns: the scale factor of matrix on the height of the font,or 1.0 if matrix is NULL.
	 */
	public double matrixGetFontScaleFactor();
}
