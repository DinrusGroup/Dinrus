module gtkD.glgdk.GLDraw;

public  import gtkD.gtkglc.glgdktypes;

private import gtkD.gtkglc.glgdk;
private import gtkD.glib.ConstructionException;






/**
 * Description
 */
public class GLDraw
{
	
	/**
	 */
	
	/**
	 * Renders a cube.
	 * The cube is centered at the modeling coordinates origin with sides of
	 * length size.
	 * Params:
	 * solid =  TRUE if the cube should be solid.
	 * size =  length of cube sides.
	 */
	public static void cube(int solid, double size);

	/**
	 * Renders a sphere centered at the modeling coordinates origin of
	 * the specified radius. The sphere is subdivided around the Z axis into
	 * slices and along the Z axis into stacks.
	 * Params:
	 * solid =  TRUE if the sphere should be solid.
	 * radius =  the radius of the sphere.
	 * slices =  the number of subdivisions around the Z axis (similar to lines of
	 *  longitude).
	 * stacks =  the number of subdivisions along the Z axis (similar to lines of
	 *  latitude).
	 */
	public static void sphere(int solid, double radius, int slices, int stacks);
	
	/**
	 * Renders a cone oriented along the Z axis.
	 * The base of the cone is placed at Z = 0, and the top at Z = height.
	 * The cone is subdivided around the Z axis into slices, and along
	 * the Z axis into stacks.
	 * Params:
	 * solid =  TRUE if the cone should be solid.
	 * base =  the radius of the base of the cone.
	 * height =  the height of the cone.
	 * slices =  the number of subdivisions around the Z axis.
	 * stacks =  the number of subdivisions along the Z axis.
	 */
	public static void cone(int solid, double base, double height, int slices, int stacks);
	
	/**
	 * Renders a torus (doughnut) centered at the modeling coordinates
	 * origin whose axis is aligned with the Z axis.
	 * Params:
	 * solid =  TRUE if the torus should be solid.
	 * innerRadius =  inner radius of the torus.
	 * outerRadius =  outer radius of the torus.
	 * nsides =  number of sides for each radial section.
	 * rings =  number of radial divisions for the torus.
	 */
	public static void torus(int solid, double innerRadius, double outerRadius, int nsides, int rings);
	
	/**
	 * Renders a tetrahedron centered at the modeling coordinates
	 * origin with a radius of the square root of 3.
	 * Params:
	 * solid =  TRUE if the tetrahedron should be solid.
	 */
	public static void tetrahedron(int solid);
	
	/**
	 * Renders a octahedron centered at the modeling coordinates
	 * origin with a radius of 1.0.
	 * Params:
	 * solid =  TRUE if the octahedron should be solid.
	 */
	public static void octahedron(int solid);
	
	/**
	 * Renders a dodecahedron centered at the modeling coordinates
	 * origin with a radius of the square root of 3.
	 * Params:
	 * solid =  TRUE if the dodecahedron should be solid.
	 */
	public static void dodecahedron(int solid);
	
	/**
	 * Renders a icosahedron.
	 * The icosahedron is centered at the modeling coordinates origin
	 * and has a radius of 1.0.
	 * Params:
	 * solid =  TRUE if the icosahedron should be solid.
	 */
	public static void icosahedron(int solid);
	
	/**
	 * Renders a teapot.
	 * Both surface normals and texture coordinates for the teapot are generated.
	 * The teapot is generated with OpenGL evaluators.
	 * Params:
	 * solid =  TRUE if the teapot should be solid.
	 * scale =  relative size of the teapot.
	 * <<Font Rendering
	 * Tokens>>
	 */
	public static void teapot(int solid, double scale);
}
