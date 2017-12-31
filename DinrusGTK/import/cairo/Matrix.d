module gtkD.cairo.Matrix;

public  import gtkD.gtkc.cairotypes;

private import gtkD.gtkc.cairo;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;




/**
 * Description
 *  cairo_matrix_t is used throughout cairo to convert between different
 *  coordinate spaces. A cairo_matrix_t holds an affine transformation,
 *  such as a scale, rotation, shear, or a combination of these.
 *  The transformation of a point (x,y)
 *  is given by:
 *  x_new = xx * x + xy * y + x0;
 *  y_new = yx * x + yy * y + y0;
 *  The current transformation matrix of a cairo_t, represented as a
 *  cairo_matrix_t, defines the transformation from user-space
 *  coordinates to device-space coordinates. See cairo_get_matrix() and
 *  cairo_set_matrix().
 */
public class Matrix
{
	
	/** the main Gtk struct */
	protected cairo_matrix_t* cairo_matrix;
	
	
	public cairo_matrix_t* getMatrixStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (cairo_matrix_t* cairo_matrix);
	
	/**
	 */
	
	/**
	 * Sets matrix to be the affine transformation given by
	 * xx, yx, xy, yy, x0, y0. The transformation is given
	 * Params:
	 * xx =  xx component of the affine transformation
	 * yx =  yx component of the affine transformation
	 * xy =  xy component of the affine transformation
	 * yy =  yy component of the affine transformation
	 * x0 =  X translation component of the affine transformation
	 * y0 =  Y translation component of the affine transformation
	 */
	public void init(double xx, double yx, double xy, double yy, double x0, double y0);
	
	/**
	 * Modifies matrix to be an identity transformation.
	 */
	public void initIdentity();
	
	/**
	 * Initializes matrix to a transformation that translates by tx and
	 * ty in the X and Y dimensions, respectively.
	 * Params:
	 * tx =  amount to translate in the X direction
	 * ty =  amount to translate in the Y direction
	 */
	public void initTranslate(double tx, double ty);
	
	/**
	 * Initializes matrix to a transformation that scales by sx and sy
	 * in the X and Y dimensions, respectively.
	 * Params:
	 * sx =  scale factor in the X direction
	 * sy =  scale factor in the Y direction
	 */
	public void initScale(double sx, double sy);
	
	/**
	 * Initialized matrix to a transformation that rotates by radians.
	 * Params:
	 * radians =  angle of rotation, in radians. The direction of rotation
	 * is defined such that positive angles rotate in the direction from
	 * the positive X axis toward the positive Y axis. With the default
	 * axis orientation of cairo, positive angles rotate in a clockwise
	 * direction.
	 */
	public void initRotate(double radians);
	
	/**
	 * Applies a translation by tx, ty to the transformation in
	 * matrix. The effect of the new transformation is to first translate
	 * the coordinates by tx and ty, then apply the original transformation
	 * to the coordinates.
	 * Params:
	 * tx =  amount to translate in the X direction
	 * ty =  amount to translate in the Y direction
	 */
	public void translate(double tx, double ty);
	
	/**
	 * Applies scaling by sx, sy to the transformation in matrix. The
	 * effect of the new transformation is to first scale the coordinates
	 * by sx and sy, then apply the original transformation to the coordinates.
	 * Params:
	 * sx =  scale factor in the X direction
	 * sy =  scale factor in the Y direction
	 */
	public void scale(double sx, double sy);
	
	/**
	 * Applies rotation by radians to the transformation in
	 * matrix. The effect of the new transformation is to first rotate the
	 * coordinates by radians, then apply the original transformation
	 * to the coordinates.
	 * Params:
	 * radians =  angle of rotation, in radians. The direction of rotation
	 * is defined such that positive angles rotate in the direction from
	 * the positive X axis toward the positive Y axis. With the default
	 * axis orientation of cairo, positive angles rotate in a clockwise
	 * direction.
	 */
	public void rotate(double radians);
	
	/**
	 * Changes matrix to be the inverse of it's original value. Not
	 * all transformation matrices have inverses; if the matrix
	 * collapses points together (it is degenerate),
	 * then it has no inverse and this function will fail.
	 * Returns: If matrix has an inverse, modifies matrix to be the inverse matrix and returns CAIRO_STATUS_SUCCESS. Otherwise, returns CAIRO_STATUS_INVALID_MATRIX.
	 */
	public cairo_status_t invert();
	
	/**
	 * Multiplies the affine transformations in a and b together
	 * and stores the result in result. The effect of the resulting
	 * transformation is to first apply the transformation in a to the
	 * coordinates and then apply the transformation in b to the
	 * coordinates.
	 * It is allowable for result to be identical to either a or b.
	 * Params:
	 * a =  a cairo_matrix_t
	 * b =  a cairo_matrix_t
	 */
	public void multiply(Matrix a, Matrix b);
	
	/**
	 * Transforms the distance vector (dx,dy) by matrix. This is
	 * similar to cairo_matrix_transform_point() except that the translation
	 * components of the transformation are ignored. The calculation of
	 * Params:
	 * dx =  X component of a distance vector. An in/out parameter
	 * dy =  Y component of a distance vector. An in/out parameter
	 */
	public void transformDistance(inout double dx, inout double dy);
	
	/**
	 * Transforms the point (x, y) by matrix.
	 * Params:
	 * x =  X position. An in/out parameter
	 * y =  Y position. An in/out parameter
	 */
	public void transformPoint(inout double x, inout double y);
}
