module lib.ode;
import stdrus, cidrus: фук;

// odeconfig.h
alias цел int32;
alias бцел uint32;
alias крат int16;
alias бкрат uint16;
alias байт int8;
alias ббайт uint8;

// common.h
version(ДвойнаяТочность)
{
    alias дво dReal;
}
else
{
    alias плав dReal;
}
alias dReal дРеал;
alias ПИ M_PI;
alias КВКОР1_2 M_SQRT1_2;

version(DerelictOde_TriMesh_16Bit_Indices)
{
    alias uint16 dTriIndex;
}
else
{
    alias uint32 dTriIndex;
}

цел dPAD(цел a)
{
    return (a > 1) ? (((a - 1)|3)+1) : a;
}

typedef dReal dVector3[4]; alias dVector3 дВектор3;
typedef dReal dVector4[4]; alias dVector4 дВектор4;
typedef dReal dMatrix3[4*3]; alias dMatrix3 дМатрица3;
typedef dReal dMatrix4[4*4]; alias dMatrix4 дМатрица4;
typedef dReal dMatrix6[8*6]; alias dMatrix6 дМатрица6;
typedef dReal dQuaternion[4]; alias dQuaternion дКватернион;

дРеал dRecip(дРеал x)
{
    return 1.0/x;
}

дРеал dRecipSqrt(дРеал x)
{
    return 1.0/квкор(x);
}

дРеал dFMod(дРеал a, дРеал b)
{
    version(Tango)
    {
        return modff(a, &b);
    }
    else
    {
        real c;
        return модф(a, c);
    }
}

alias квкор dSqrt;
alias син dSin;
alias кос dCos;
alias фабс dFabs;
alias атан2 dAtan2;
alias нч_ли dIsNan;
alias копируйзнак dCopySign;

struct dxWorld {};
struct dxSpace {};
struct dxBody {};
struct dxGeom {};
struct dxJoint {};
struct dxJointNode {};
struct dxJointGroup {};

alias dxWorld* dWorldID;
alias dxSpace* dSpaceID;
alias dxBody* dBodyID;
alias dxGeom* dGeomID;
alias dxJoint* dJointID;
alias dxJointGroup* dJointGroupID;

enum
{
    d_ERR_UNKNOWN,
    d_ERR_IASSERT,
    d_ERR_UASSERT,
    d_ERR_LCP
}

alias цел dJointType;
enum
{
    dJointTypeNone,
    dJointTypeBall,
    dJointTypeHinge,
    dJointTypeSlider,
    dJointTypeContact,
    dJointTypeUniversal,
    dJointTypeHinge2,
    dJointTypeFixed,
    dJointTypeNull,
    dJointTypeAMotor,
    dJointTypeLMotor,
    dJointTypePlane2D,
    dJointTypePR,
    dJointTypePU,
    dJointTypePiston,
}

enum
{
    dParamLoStop = 0,
    dParamHiStop,
    dParamVel,
    dParamFMax,
    dParamFudgeFactor,
    dParamBounce,
    dParamCFM,
    dParamStopERP,
    dParamStopCFM,
    dParamSuspensionERP,
    dParamSuspensionCFM,
    dParamERP,
    dParamsInGroup,
    dParamLoStop1 = 0x000,
    dParamHiStop1,
    dParamVel1,
    dParamFMax1,
    dParamFudgeFactor1,
    dParamBounce1,
    dParamCFM1,
    dParamStopERP1,
    dParamStopCFM1,
    dParamSuspensionERP1,
    dParamSuspensionCFM1,
    dParamERP1,
    dParamLoStop2 = 0x100,
    dParamHiStop2,
    dParamVel2,
    dParamFMax2,
    dParamFudgeFactor2,
    dParamBounce2,
    dParamCFM2,
    dParamStopERP2,
    dParamStopCFM2,
    dParamSuspensionERP2,
    dParamSuspensionCFM2,
    dParamERP2,
    dParamLoStop3 = 0x200,
    dParamHiStop3,
    dParamVel3,
    dParamFMax3,
    dParamFudgeFactor3,
    dParamBounce3,
    dParamCFM3,
    dParamStopERP3,
    dParamStopCFM3,
    dParamSuspensionERP3,
    dParamSuspensionCFM3,
    dParamERP3,
    dParamGroup = 0x100
}

enum
{
    dAMotorUser,
    dAMotorEuler,
}

struct dJointFeedback
{
    дВектор3 f1;
    дВектор3 t1;
    дВектор3 f2;
    дВектор3 t2;
}

// collision.h
enum
{
    CONTACTS_UNIMPORTANT = 0x80000000
}

enum
{
    dMaxUserClasses = 4
}

enum
{
    dSphereClass = 0,
    dBoxClass,
    dCapsuleClass,
    dCylinderClass,
    dPlaneClass,
    dRayClass,
    dConvexClass,
    dGeomTransformClass,
    dTriMeshClass,
    dHeightFieldClass,
    dFirstSpaceClass,
    dSimpleSpaceClass = dFirstSpaceClass,
    dHashSpaceClass,
    dSweepAndPruneClass,
    dQuadTreeClass,
    dLastSpaceClass = dQuadTreeClass,
    dFirstUserClass,
    dLastUserClass = dFirstUserClass + dMaxUserClasses - 1,
    dGeomNumClasses
}

alias dCapsuleClass dCCapsuleClass;

struct dxHeightfieldData;
alias dxHeightfieldData* dHeightfieldDataID;

extern(C)
{
    alias дРеал function(ук, цел, цел) dHeightfieldGetHeight;
    alias проц function(dGeomID, дРеал[6]) dGetAABBFn;
    alias цел function(dGeomID, dGeomID, цел, dContactGeom*, цел) dColliderFn;
    alias dColliderFn function(цел) dGetColliderFnFn;
    alias проц function(dGeomID) dGeomDtorFn;
    alias цел function(dGeomID, dGeomID, дРеал[6]) dAABBTestFn;
}


struct dGeomClass
{
    цел bytes;
    dGetColliderFnFn collider;
    dGetAABBFn aabb;
    dAABBTestFn aabb_test;
    dGeomDtorFn dtor;
}

// collision_space.h
alias extern(C) проц function(ук, dGeomID, dGeomID) dNearCallback;

enum
{
    dSAP_AXES_XYZ = ((0)|(1<<2)|(2<<4)),
    dSAP_AXES_XZY = ((0)|(2<<2)|(1<<4)),
    dSAP_AXES_YXZ = ((1)|(0<<2)|(2<<4)),
    dSAP_AXES_YZX = ((1)|(2<<2)|(0<<4)),
    dSAP_AXES_ZXY = ((2)|(0<<2)|(1<<4)),
    dSAP_AXES_ZYX = ((2)|(1<<2)|(0<<4))
}

// collision_trimesh.h
struct dxTriMeshData {}
alias dxTriMeshData* dTriMeshDataID;

enum { TRIMESH_FACE_NORMALS }

extern(C)
{
    alias цел function(dGeomID, dGeomID, цел) dTriCallback;
    alias проц function(dGeomID, dGeomID, in цел*, цел) dTriArrayCallback;
    alias цел function(dGeomID, dGeomID, цел, дРеал, дРеал) dTriRayCallback;
    alias цел function(dGeomID, цел, цел) dTriTriMergeCallback;
}

// contact.h
enum
{
    dContactMu2 = 0x001,
    dContactFDir1 = 0x002,
    dContactBounce = 0x004,
    dContactSoftERP = 0x008,
    dContactSoftCFM = 0x010,
    dContactMotion1 = 0x020,
    dContactMotion2 = 0x040,
    dContactMotionN = 0x080,
    dContactSlip1 = 0x100,
    dContactSlip2 = 0x200,

    dContactApprox0 = 0x0000,
    dContactApprox1_1 = 0x1000,
    dContactApprox1_2 = 0x2000,
    dContactApprox1 = 0x3000
}

struct dSurfaceParameters
{
    цел mode;
    дРеал mu;
    дРеал mu2;
    дРеал bounce;
    дРеал bounce_vel;
    дРеал soft_erp;
    дРеал soft_cfm;
    дРеал motion1, motion2, motionN;
    дРеал slip1, slip2;
}

struct dContactGeom
{
    дВектор3 pos;
    дВектор3 normal;
    дРеал depth;
    dGeomID g1, g2;
    цел side1, side2;
}

struct dContact
{
    dSurfaceParameters surface;
    dContactGeom geom;
    дВектор3 fdir1;
}

// error.h
extern(C) alias проц function(цел, ткст0, va_list ap) dMessageFunction;

// mass.h
struct dMass
{
    дРеал mass;
    дВектор3 C;
    дМатрица3 I;
}

// memory.h
extern(C)
{
    alias ук function(size_t) dAllocFunction;
    alias ук function(ук, size_t, size_t) dReallocFunction;
    alias проц function(ук, size_t) dFreeFunction;
}

// odeinit.h
enum : бцел
{
    dInitFlagManualThreadCleanup = 0x00000001
}

enum : бцел
{
    dAllocateFlagsBasicData = 0,
    dAllocateFlagsCollisionData = 0x00000001,
    dAllocateMaskAll = ~0U,
}

// timer.h
struct dStopwatch
{
    дво time;
    бцел cc[2];
}

private проц грузи(Биб биб)
{
    вяжи(dGetConfiguration)("dGetConfiguration", биб);
    вяжи(dCheckConfiguration)("dCheckConfiguration", биб);
    вяжи(dGeomDestroy)("dGeomDestroy", биб);
    вяжи(dGeomSetData)("dGeomSetData", биб);
    вяжи(dGeomGetData)("dGeomGetData", биб);
    вяжи(dGeomSetBody)("dGeomSetBody", биб);
    вяжи(dGeomGetBody)("dGeomGetBody", биб);
    вяжи(dGeomSetPosition)("dGeomSetPosition", биб);
    вяжи(dGeomSetRotation)("dGeomSetRotation", биб);
    вяжи(dGeomSetQuaternion)("dGeomSetQuaternion", биб);
    вяжи(dGeomGetPosition)("dGeomGetPosition", биб);
    вяжи(dGeomCopyPosition)("dGeomCopyPosition", биб);
    вяжи(dGeomGetRotation)("dGeomGetRotation", биб);
    вяжи(dGeomCopyRotation)("dGeomCopyRotation", биб);
    вяжи(dGeomGetQuaternion)("dGeomGetQuaternion", биб);
    вяжи(dGeomGetAABB)("dGeomGetAABB", биб);
    вяжи(dGeomIsSpace)("dGeomIsSpace", биб);
    вяжи(dGeomGetSpace)("dGeomGetSpace", биб);
    вяжи(dGeomGetClass)("dGeomGetClass", биб);
    вяжи(dGeomSetCategoryBits)("dGeomSetCategoryBits", биб);
    вяжи(dGeomSetCollideBits)("dGeomSetCollideBits", биб);
    вяжи(dGeomGetCategoryBits)("dGeomGetCategoryBits", биб);
    вяжи(dGeomGetCollideBits)("dGeomGetCollideBits", биб);
    вяжи(dGeomEnable)("dGeomEnable", биб);
    вяжи(dGeomDisable)("dGeomDisable", биб);
    вяжи(dGeomIsEnabled)("dGeomIsEnabled", биб);
    вяжи(dGeomSetOffsetPosition)("dGeomSetOffsetPosition", биб);
    вяжи(dGeomSetOffsetRotation)("dGeomSetOffsetRotation", биб);
    вяжи(dGeomSetOffsetQuaternion)("dGeomSetOffsetQuaternion", биб);
    вяжи(dGeomSetOffsetWorldPosition)("dGeomSetOffsetWorldPosition", биб);
    вяжи(dGeomSetOffsetWorldRotation)("dGeomSetOffsetWorldRotation", биб);
    вяжи(dGeomSetOffsetWorldQuaternion)("dGeomSetOffsetWorldQuaternion", биб);
    вяжи(dGeomClearOffset)("dGeomClearOffset", биб);
    вяжи(dGeomIsOffset)("dGeomIsOffset", биб);
    вяжи(dGeomGetOffsetPosition)("dGeomGetOffsetPosition", биб);
    вяжи(dGeomCopyOffsetPosition)("dGeomCopyOffsetPosition", биб);
    вяжи(dGeomGetOffsetRotation)("dGeomGetOffsetRotation", биб);
    вяжи(dGeomGetOffsetQuaternion)("dGeomGetOffsetQuaternion", биб);
    вяжи(dCollide)("dCollide", биб);
    вяжи(dSpaceCollide)("dSpaceCollide", биб);
    вяжи(dSpaceCollide2)("dSpaceCollide2", биб);
    вяжи(dCreateSphere)("dCreateSphere", биб);
    вяжи(dGeomSphereSetRadius)("dGeomSphereSetRadius", биб);
    вяжи(dGeomSphereGetRadius)("dGeomSphereGetRadius", биб);
    вяжи(dGeomSpherePointDepth)("dGeomSpherePointDepth", биб);
    вяжи(dCreateConvex)("dCreateConvex", биб);
    вяжи(dGeomSetConvex)("dGeomSetConvex", биб);
    вяжи(dCreateBox)("dCreateBox", биб);
    вяжи(dGeomBoxSetLengths)("dGeomBoxSetLengths", биб);
    вяжи(dGeomBoxGetLengths)("dGeomBoxGetLengths", биб);
    вяжи(dGeomBoxPointDepth)("dGeomBoxPointDepth", биб);
    вяжи(dCreatePlane)("dCreatePlane", биб);
    вяжи(dGeomPlaneSetParams)("dGeomPlaneSetParams", биб);
    вяжи(dGeomPlaneGetParams)("dGeomPlaneGetParams", биб);
    вяжи(dGeomPlanePointDepth)("dGeomPlanePointDepth", биб);
    вяжи(dCreateCapsule)("dCreateCapsule", биб);
    вяжи(dGeomCapsuleSetParams)("dGeomCapsuleSetParams", биб);
    вяжи(dGeomCapsuleGetParams)("dGeomCapsuleGetParams", биб);
    вяжи(dGeomCapsulePointDepth)("dGeomCapsulePointDepth", биб);
    вяжи(dCreateCylinder)("dCreateCylinder", биб);
    вяжи(dGeomCylinderSetParams)("dGeomCylinderSetParams", биб);
    вяжи(dGeomCylinderGetParams)("dGeomCylinderGetParams", биб);
    вяжи(dCreateRay)("dCreateRay", биб);
    вяжи(dGeomRaySetLength)("dGeomRaySetLength", биб);
    вяжи(dGeomRayGetLength)("dGeomRayGetLength", биб);
    вяжи(dGeomRaySet)("dGeomRaySet", биб);
    вяжи(dGeomRayGet)("dGeomRayGet", биб);
    вяжи(dGeomRaySetParams)("dGeomRaySetParams", биб);
    вяжи(dGeomRayGetParams)("dGeomRayGetParams", биб);
    вяжи(dGeomRaySetClosestHit)("dGeomRaySetClosestHit", биб);
    вяжи(dGeomRayGetClosestHit)("dGeomRayGetClosestHit", биб);
    вяжи(dCreateGeomTransform)("dCreateGeomTransform", биб);
    вяжи(dGeomTransformSetGeom)("dGeomTransformSetGeom", биб);
    вяжи(dGeomTransformGetGeom)("dGeomTransformGetGeom", биб);
    вяжи(dGeomTransformSetCleanup)("dGeomTransformSetCleanup", биб);
    вяжи(dGeomTransformGetCleanup)("dGeomTransformGetCleanup", биб);
    вяжи(dGeomTransformSetInfo)("dGeomTransformSetInfo", биб);
    вяжи(dGeomTransformGetInfo)("dGeomTransformGetInfo", биб);
    вяжи(dCreateHeightfield)("dCreateHeightfield", биб);
    вяжи(dGeomHeightfieldDataCreate)("dGeomHeightfieldDataCreate", биб);
    вяжи(dGeomHeightfieldDataDestroy)("dGeomHeightfieldDataDestroy", биб);
    вяжи(dGeomHeightfieldDataBuildCallback)("dGeomHeightfieldDataBuildCallback", биб);
    вяжи(dGeomHeightfieldDataBuildByte)("dGeomHeightfieldDataBuildByte", биб);
    вяжи(dGeomHeightfieldDataBuildShort)("dGeomHeightfieldDataBuildShort", биб);
    вяжи(dGeomHeightfieldDataBuildSingle)("dGeomHeightfieldDataBuildSingle", биб);
    вяжи(dGeomHeightfieldDataBuildDouble)("dGeomHeightfieldDataBuildDouble", биб);
    вяжи(dGeomHeightfieldDataSetBounds)("dGeomHeightfieldDataSetBounds", биб);
    вяжи(dGeomHeightfieldSetHeightfieldData)("dGeomHeightfieldSetHeightfieldData", биб);
    вяжи(dGeomHeightfieldGetHeightfieldData)("dGeomHeightfieldGetHeightfieldData", биб);
    вяжи(dClosestLineSegmentPoints)("dClosestLineSegmentPoints", биб);
    вяжи(dBoxTouchesBox)("dBoxTouchesBox", биб);
    вяжи(dBoxBox)("dBoxBox", биб);
    вяжи(dInfiniteAABB)("dInfiniteAABB", биб);
    вяжи(dCreateGeomClass)("dCreateGeomClass", биб);
    вяжи(dGeomGetClassData)("dGeomGetClassData", биб);
    вяжи(dCreateGeom)("dCreateGeom", биб);
    вяжи(dSetColliderOverride)("dSetColliderOverride", биб);

    // collision_space.h
    вяжи(dSimpleSpaceCreate)("dSimpleSpaceCreate", биб);
    вяжи(dHashSpaceCreate)("dHashSpaceCreate", биб);
    вяжи(dQuadTreeSpaceCreate)("dQuadTreeSpaceCreate", биб);
    вяжи(dSweepAndPruneSpaceCreate)("dSweepAndPruneSpaceCreate", биб);
    вяжи(dSpaceDestroy)("dSpaceDestroy", биб);
    вяжи(dHashSpaceSetLevels)("dHashSpaceSetLevels", биб);
    вяжи(dHashSpaceGetLevels)("dHashSpaceGetLevels", биб);
    вяжи(dSpaceSetCleanup)("dSpaceSetCleanup", биб);
    вяжи(dSpaceGetCleanup)("dSpaceGetCleanup", биб);
    вяжи(dSpaceSetSublevel)("dSpaceSetSublevel", биб);
    вяжи(dSpaceGetSublevel)("dSpaceGetSublevel", биб);
    вяжи(dSpaceAdd)("dSpaceAdd", биб);
    вяжи(dSpaceRemove)("dSpaceRemove", биб);
    вяжи(dSpaceQuery)("dSpaceQuery", биб);
    вяжи(dSpaceClean)("dSpaceClean", биб);
    вяжи(dSpaceGetNumGeoms)("dSpaceGetNumGeoms", биб);
    вяжи(dSpaceGetGeom)("dSpaceGetGeom", биб);
    вяжи(dSpaceGetClass)("dSpaceGetClass", биб);

    // collision_trimesh.h
    вяжи(dGeomTriMeshDataCreate)("dGeomTriMeshDataCreate", биб);
    вяжи(dGeomTriMeshDataDestroy)("dGeomTriMeshDataDestroy", биб);
    вяжи(dGeomTriMeshDataSet)("dGeomTriMeshDataSet", биб);
    вяжи(dGeomTriMeshDataGet)("dGeomTriMeshDataGet", биб);
    вяжи(dGeomTriMeshSetLastTransform)("dGeomTriMeshSetLastTransform", биб);
    вяжи(dGeomTriMeshGetLastTransform)("dGeomTriMeshGetLastTransform", биб);
    вяжи(dGeomTriMeshDataBuildSingle)("dGeomTriMeshDataBuildSingle", биб);
    вяжи(dGeomTriMeshDataBuildSingle1)("dGeomTriMeshDataBuildSingle1", биб);
    вяжи(dGeomTriMeshDataBuildDouble)("dGeomTriMeshDataBuildDouble", биб);
    вяжи(dGeomTriMeshDataBuildDouble1)("dGeomTriMeshDataBuildDouble1", биб);
    вяжи(dGeomTriMeshDataBuildSimple)("dGeomTriMeshDataBuildSimple", биб);
    вяжи(dGeomTriMeshDataBuildSimple1)("dGeomTriMeshDataBuildSimple1", биб);
    вяжи(dGeomTriMeshDataPreprocess)("dGeomTriMeshDataPreprocess", биб);
    вяжи(dGeomTriMeshDataGetBuffer)("dGeomTriMeshDataGetBuffer", биб);
    вяжи(dGeomTriMeshDataSetBuffer)("dGeomTriMeshDataSetBuffer", биб);
    вяжи(dGeomTriMeshSetCallback)("dGeomTriMeshSetCallback", биб);
    вяжи(dGeomTriMeshGetCallback)("dGeomTriMeshGetCallback", биб);
    вяжи(dGeomTriMeshSetArrayCallback)("dGeomTriMeshSetArrayCallback", биб);
    вяжи(dGeomTriMeshGetArrayCallback)("dGeomTriMeshGetArrayCallback", биб);
    вяжи(dGeomTriMeshSetRayCallback)("dGeomTriMeshSetRayCallback", биб);
    вяжи(dGeomTriMeshGetRayCallback)("dGeomTriMeshGetRayCallback", биб);
    вяжи(dGeomTriMeshSetTriMergeCallback)("dGeomTriMeshSetTriMergeCallback", биб);
    вяжи(dGeomTriMeshGetTriMergeCallback)("dGeomTriMeshGetTriMergeCallback", биб);
    вяжи(dCreateTriMesh)("dCreateTriMesh", биб);
    вяжи(dGeomTriMeshSetData)("dGeomTriMeshSetData", биб);
    вяжи(dGeomTriMeshGetData)("dGeomTriMeshGetData", биб);
    вяжи(dGeomTriMeshEnableTC)("dGeomTriMeshEnableTC", биб);
    вяжи(dGeomTriMeshIsTCEnabled)("dGeomTriMeshIsTCEnabled", биб);
    вяжи(dGeomTriMeshClearTCCache)("dGeomTriMeshClearTCCache", биб);
    вяжи(dGeomTriMeshGetTriMeshDataID)("dGeomTriMeshGetTriMeshDataID", биб);
    вяжи(dGeomTriMeshGetTriangle)("dGeomTriMeshGetTriangle", биб);
    вяжи(dGeomTriMeshGetPoint)("dGeomTriMeshGetPoint", биб);
    вяжи(dGeomTriMeshGetTriangleCount)("dGeomTriMeshGetTriangleCount", биб);
    вяжи(dGeomTriMeshDataUpdate)("dGeomTriMeshDataUpdate", биб);

    // error.h
    вяжи(dSetErrorHandler)("dSetErrorHandler", биб);
    вяжи(dSetDebugHandler)("dSetDebugHandler", биб);
    вяжи(dSetMessageHandler)("dSetMessageHandler", биб);
    вяжи(dGetErrorHandler)("dGetErrorHandler", биб);
    вяжи(dGetDebugHandler)("dGetDebugHandler", биб);
    вяжи(dGetMessageHandler)("dGetMessageHandler", биб);
    вяжи(dError)("dError", биб);
    вяжи(dDebug)("dDebug", биб);
    вяжи(dMessage)("dMessage", биб);

    // mass.h
    вяжи(dMassCheck)("dMassCheck", биб);
    вяжи(dMassSetZero)("dMassSetZero", биб);
    вяжи(dMassSetParameters)("dMassSetParameters", биб);
    вяжи(dMassSetSphere)("dMassSetSphere", биб);
    вяжи(dMassSetSphereTotal)("dMassSetSphereTotal", биб);
    вяжи(dMassSetCapsule)("dMassSetCapsule", биб);
    вяжи(dMassSetCapsuleTotal)("dMassSetCapsuleTotal", биб);
    вяжи(dMassSetCylinder)("dMassSetCylinder", биб);
    вяжи(dMassSetCylinderTotal)("dMassSetCylinderTotal", биб);
    вяжи(dMassSetBox)("dMassSetBox", биб);
    вяжи(dMassSetBoxTotal)("dMassSetBoxTotal", биб);
    вяжи(dMassSetTrimesh)("dMassSetTrimesh", биб);
    вяжи(dMassSetTrimeshTotal)("dMassSetTrimeshTotal", биб);
    вяжи(dMassAdjust)("dMassAdjust", биб);
    вяжи(dMassTranslate)("dMassTranslate", биб);
    вяжи(dMassRotate)("dMassRotate", биб);
    вяжи(dMassAdd)("dMassAdd", биб);

    // matrix.h
    вяжи(dSetZero)("dSetZero", биб);
    вяжи(dSetValue)("dSetValue", биб);
    вяжи(dDot)("dDot", биб);
    вяжи(dMultiply0)("dMultiply0", биб);
    вяжи(dMultiply1)("dMultiply1", биб);
    вяжи(dMultiply2)("dMultiply2", биб);
    вяжи(dFactorCholesky)("dFactorCholesky", биб);
    вяжи(dSolveCholesky)("dSolveCholesky", биб);
    вяжи(dInvertPDMatrix)("dInvertPDMatrix", биб);
    вяжи(dIsPositiveDefinite)("dIsPositiveDefinite", биб);
    вяжи(dFactorLDLT)("dFactorLDLT", биб);
    вяжи(dSolveL1)("dSolveL1", биб);
    вяжи(dSolveL1T)("dSolveL1T", биб);
    вяжи(dVectorScale)("dVectorScale", биб);
    вяжи(dSolveLDLT)("dSolveLDLT", биб);
    вяжи(dLDLTAddTL)("dLDLTAddTL", биб);
    вяжи(dLDLTRemove)("dLDLTRemove", биб);
    вяжи(dRemoveRowCol)("dRemoveRowCol", биб);

    // memory.h
    вяжи(dSetAllocHandler)("dSetAllocHandler", биб);
    вяжи(dSetReallocHandler)("dSetReallocHandler", биб);
    вяжи(dSetFreeHandler)("dSetFreeHandler", биб);
    вяжи(dGetAllocHandler)("dGetAllocHandler", биб);
    вяжи(dGetReallocHandler)("dGetReallocHandler", биб);
    вяжи(dGetFreeHandler)("dGetFreeHandler", биб);
    вяжи(dAlloc)("dAlloc", биб);
    вяжи(dRealloc)("dRealloc", биб);
    вяжи(dFree)("dFree", биб);

    // misc.h
    вяжи(dTestRand)("dTestRand", биб);
    вяжи(dRand)("dRand", биб);
    вяжи(dRandGetSeed)("dRandGetSeed", биб);
    вяжи(dRandSetSeed)("dRandSetSeed", биб);
    вяжи(dRandInt)("dRandInt", биб);
    вяжи(dRandReal)("dRandReal", биб);
    вяжи(dPrintMatrix)("dPrintMatrix", биб);
    вяжи(dMakeRandomVector)("dMakeRandomVector", биб);
    вяжи(dMakeRandomMatrix)("dMakeRandomMatrix", биб);
    вяжи(dClearUpperTriangle)("dClearUpperTriangle", биб);
    вяжи(dMaxDifference)("dMaxDifference", биб);
    вяжи(dMaxDifferenceLowerTriangle)("dMaxDifferenceLowerTriangle", биб);

    // objects.h
    вяжи(dWorldCreate)("dWorldCreate", биб);
    вяжи(dWorldDestroy)("dWorldDestroy", биб);
    вяжи(dWorldSetGravity)("dWorldSetGravity", биб);
    вяжи(dWorldGetGravity)("dWorldGetGravity", биб);
    вяжи(dWorldSetERP)("dWorldSetERP", биб);
    вяжи(dWorldGetERP)("dWorldGetERP", биб);
    вяжи(dWorldSetCFM)("dWorldSetCFM", биб);
    вяжи(dWorldGetCFM)("dWorldGetCFM", биб);
    вяжи(dWorldStep)("dWorldStep", биб);
    вяжи(dWorldImpulseToForce)("dWorldImpulseToForce", биб);
    вяжи(dWorldQuickStep)("dWorldQuickStep", биб);
    вяжи(dWorldSetQuickStepNumIterations)("dWorldSetQuickStepNumIterations", биб);
    вяжи(dWorldGetQuickStepNumIterations)("dWorldGetQuickStepNumIterations", биб);
    вяжи(dWorldSetQuickStepW)("dWorldSetQuickStepW", биб);
    вяжи(dWorldGetQuickStepW)("dWorldGetQuickStepW", биб);
    вяжи(dWorldSetContactMaxCorrectingVel)("dWorldSetContactMaxCorrectingVel", биб);
    вяжи(dWorldGetContactMaxCorrectingVel)("dWorldGetContactMaxCorrectingVel", биб);
    вяжи(dWorldSetContactSurfaceLayer)("dWorldSetContactSurfaceLayer", биб);
    вяжи(dWorldGetContactSurfaceLayer)("dWorldGetContactSurfaceLayer", биб);
    вяжи(dWorldStepFast1)("dWorldStepFast1", биб);
    вяжи(dWorldSetAutoEnableDepthSF1)("dWorldSetAutoEnableDepthSF1", биб);
    вяжи(dWorldGetAutoEnableDepthSF1)("dWorldGetAutoEnableDepthSF1", биб);
    вяжи(dWorldGetAutoDisableLinearThreshold)("dWorldGetAutoDisableLinearThreshold", биб);
    вяжи(dWorldSetAutoDisableLinearThreshold)("dWorldSetAutoDisableLinearThreshold", биб);
    вяжи(dWorldGetAutoDisableAngularThreshold)("dWorldGetAutoDisableAngularThreshold", биб);
    вяжи(dWorldSetAutoDisableAngularThreshold)("dWorldSetAutoDisableAngularThreshold", биб);
    вяжи(dWorldGetAutoDisableAverageSamplesCount)("dWorldGetAutoDisableAverageSamplesCount", биб);
    вяжи(dWorldSetAutoDisableAverageSamplesCount)("dWorldSetAutoDisableAverageSamplesCount", биб);
    вяжи(dWorldGetAutoDisableSteps)("dWorldGetAutoDisableSteps", биб);
    вяжи(dWorldSetAutoDisableSteps)("dWorldSetAutoDisableSteps", биб);
    вяжи(dWorldGetAutoDisableTime)("dWorldGetAutoDisableTime", биб);
    вяжи(dWorldSetAutoDisableTime)("dWorldSetAutoDisableTime", биб);
    вяжи(dWorldGetAutoDisableFlag)("dWorldGetAutoDisableFlag", биб);
    вяжи(dWorldSetAutoDisableFlag)("dWorldSetAutoDisableFlag", биб);
    вяжи(dWorldGetLinearDampingThreshold)("dWorldGetLinearDampingThreshold", биб);
    вяжи(dWorldSetLinearDampingThreshold)("dWorldSetLinearDampingThreshold", биб);
    вяжи(dWorldGetAngularDampingThreshold)("dWorldGetAngularDampingThreshold", биб);
    вяжи(dWorldSetAngularDampingThreshold)("dWorldSetAngularDampingThreshold", биб);
    вяжи(dWorldGetLinearDamping)("dWorldGetLinearDamping", биб);
    вяжи(dWorldSetLinearDamping)("dWorldSetLinearDamping", биб);
    вяжи(dWorldGetAngularDamping)("dWorldGetAngularDamping", биб);
    вяжи(dWorldSetAngularDamping)("dWorldSetAngularDamping", биб);
    вяжи(dWorldSetDamping)("dWorldSetDamping", биб);
    вяжи(dWorldGetMaxAngularSpeed)("dWorldGetMaxAngularSpeed", биб);
    вяжи(dWorldSetMaxAngularSpeed)("dWorldSetMaxAngularSpeed", биб);
    вяжи(dBodyGetAutoDisableLinearThreshold)("dBodyGetAutoDisableLinearThreshold", биб);
    вяжи(dBodySetAutoDisableLinearThreshold)("dBodySetAutoDisableLinearThreshold", биб);
    вяжи(dBodyGetAutoDisableAngularThreshold)("dBodyGetAutoDisableAngularThreshold", биб);
    вяжи(dBodySetAutoDisableAngularThreshold)("dBodySetAutoDisableAngularThreshold", биб);
    вяжи(dBodyGetAutoDisableAverageSamplesCount)("dBodyGetAutoDisableAverageSamplesCount", биб);
    вяжи(dBodySetAutoDisableAverageSamplesCount)("dBodySetAutoDisableAverageSamplesCount", биб);
    вяжи(dBodyGetAutoDisableSteps)("dBodyGetAutoDisableSteps", биб);
    вяжи(dBodySetAutoDisableSteps)("dBodySetAutoDisableSteps", биб);
    вяжи(dBodyGetAutoDisableTime)("dBodyGetAutoDisableTime", биб);
    вяжи(dBodySetAutoDisableTime)("dBodySetAutoDisableTime", биб);
    вяжи(dBodyGetAutoDisableFlag)("dBodyGetAutoDisableFlag", биб);
    вяжи(dBodySetAutoDisableFlag)("dBodySetAutoDisableFlag", биб);
    вяжи(dBodySetAutoDisableDefaults)("dBodySetAutoDisableDefaults", биб);
    вяжи(dBodyGetWorld)("dBodyGetWorld", биб);
    вяжи(dBodyCreate)("dBodyCreate", биб);
    вяжи(dBodyDestroy)("dBodyDestroy", биб);
    вяжи(dBodySetData)("dBodySetData", биб);
    вяжи(dBodyGetData)("dBodyGetData", биб);
    вяжи(dBodySetPosition)("dBodySetPosition", биб);
    вяжи(dBodySetRotation)("dBodySetRotation", биб);
    вяжи(dBodySetQuaternion)("dBodySetQuaternion", биб);
    вяжи(dBodySetLinearVel)("dBodySetLinearVel", биб);
    вяжи(dBodySetAngularVel)("dBodySetAngularVel", биб);
    вяжи(dBodyGetPosition)("dBodyGetPosition", биб);
    вяжи(dBodyCopyPosition)("dBodyCopyPosition", биб);
    вяжи(dBodyGetRotation)("dBodyGetRotation", биб);
    вяжи(dBodyCopyRotation)("dBodyCopyRotation", биб);
    вяжи(dBodyGetQuaternion)("dBodyGetQuaternion", биб);
    вяжи(dBodyCopyQuaternion)("dBodyCopyQuaternion", биб);
    вяжи(dBodyGetLinearVel)("dBodyGetLinearVel", биб);
    вяжи(dBodyGetAngularVel)("dBodyGetAngularVel", биб);
    вяжи(dBodySetMass)("dBodySetMass", биб);
    вяжи(dBodyGetMass)("dBodyGetMass", биб);
    вяжи(dBodyAddForce)("dBodyAddForce", биб);
    вяжи(dBodyAddTorque)("dBodyAddTorque", биб);
    вяжи(dBodyAddRelForce)("dBodyAddRelForce", биб);
    вяжи(dBodyAddRelTorque)("dBodyAddRelTorque", биб);
    вяжи(dBodyAddForceAtPos)("dBodyAddForceAtPos", биб);
    вяжи(dBodyAddForceAtRelPos)("dBodyAddForceAtRelPos", биб);
    вяжи(dBodyAddRelForceAtPos)("dBodyAddRelForceAtPos", биб);
    вяжи(dBodyAddRelForceAtRelPos)("dBodyAddRelForceAtRelPos", биб);
    вяжи(dBodyGetForce)("dBodyGetForce", биб);
    вяжи(dBodyGetTorque)("dBodyGetTorque", биб);
    вяжи(dBodySetForce)("dBodySetForce", биб);
    вяжи(dBodySetTorque)("dBodySetTorque", биб);
    вяжи(dBodyGetRelPointPos)("dBodyGetRelPointPos", биб);
    вяжи(dBodyGetRelPointVel)("dBodyGetRelPointVel", биб);
    вяжи(dBodyGetPointVel)("dBodyGetPointVel", биб);
    вяжи(dBodyGetPosRelPoint)("dBodyGetPosRelPoint", биб);
    вяжи(dBodyVectorToWorld)("dBodyVectorToWorld", биб);
    вяжи(dBodyVectorFromWorld)("dBodyVectorFromWorld", биб);
    вяжи(dBodySetFiniteRotationMode)("dBodySetFiniteRotationMode", биб);
    вяжи(dBodySetFiniteRotationAxis)("dBodySetFiniteRotationAxis", биб);
    вяжи(dBodyGetFiniteRotationMode)("dBodyGetFiniteRotationMode", биб);
    вяжи(dBodyGetFiniteRotationAxis)("dBodyGetFiniteRotationAxis", биб);
    вяжи(dBodyGetNumJoints)("dBodyGetNumJoints", биб);
    вяжи(dBodyGetJoint)("dBodyGetJoint", биб);
    вяжи(dBodySetDynamic)("dBodySetDynamic", биб);
    вяжи( dBodySetKinematic)("dBodySetKinematic", биб);
    вяжи(dBodyIsKinematic)("dBodyIsKinematic", биб);
    вяжи(dBodyEnable)("dBodyEnable", биб);
    вяжи(dBodyDisable)("dBodyDisable", биб);
    вяжи(dBodyIsEnabled)("dBodyIsEnabled", биб);
    вяжи(dBodySetGravityMode)("dBodySetGravityMode", биб);
    вяжи(dBodyGetGravityMode)("dBodyGetGravityMode", биб);
    вяжи(dBodySetMovedCallback)("dBodySetMovedCallback", биб);
    вяжи(dBodyGetFirstGeom)("dBodyGetFirstGeom", биб);
    вяжи(dBodyGetNextGeom)("dBodyGetNextGeom", биб);
    вяжи(dBodySetDampingDefaults)("dBodySetDampingDefaults", биб);
    вяжи(dBodyGetLinearDamping)("dBodyGetLinearDamping", биб);
    вяжи(dBodySetLinearDamping)("dBodySetLinearDamping", биб);
    вяжи(dBodyGetAngularDamping)("dBodyGetAngularDamping", биб);
    вяжи(dBodySetAngularDamping)("dBodySetAngularDamping", биб);
    вяжи(dBodySetDamping)("dBodySetDamping", биб);
    вяжи(dBodyGetLinearDampingThreshold)("dBodyGetLinearDampingThreshold", биб);
    вяжи(dBodySetLinearDampingThreshold)("dBodySetLinearDampingThreshold", биб);
    вяжи(dBodyGetAngularDampingThreshold)("dBodyGetAngularDampingThreshold", биб);
    вяжи(dBodySetAngularDampingThreshold)("dBodySetAngularDampingThreshold", биб);
    вяжи(dBodyGetMaxAngularSpeed)("dBodyGetMaxAngularSpeed", биб);
    вяжи(dBodySetMaxAngularSpeed)("dBodySetMaxAngularSpeed", биб);
    вяжи(dBodyGetGyroscopicMode)("dBodyGetGyroscopicMode", биб);
    вяжи(dBodySetGyroscopicMode)("dBodySetGyroscopicMode", биб);
    вяжи(dJointCreateBall)("dJointCreateBall", биб);
    вяжи(dJointCreateHinge)("dJointCreateHinge", биб);
    вяжи(dJointCreateSlider)("dJointCreateSlider", биб);
    вяжи(dJointCreateContact)("dJointCreateContact", биб);
    вяжи(dJointCreateHinge2)("dJointCreateHinge2", биб);
    вяжи(dJointCreateUniversal)("dJointCreateUniversal", биб);
    вяжи(dJointCreatePR)("dJointCreatePR", биб);
    вяжи(dJointCreatePU)("dJointCreatePU", биб);
    вяжи(dJointCreatePiston)("dJointCreatePiston", биб);
    вяжи(dJointCreateFixed)("dJointCreateFixed", биб);
    вяжи(dJointCreateNull)("dJointCreateNull", биб);
    вяжи(dJointCreateAMotor)("dJointCreateAMotor", биб);
    вяжи(dJointCreateLMotor)("dJointCreateLMotor", биб);
    вяжи(dJointCreatePlane2D)("dJointCreatePlane2D", биб);
    вяжи(dJointDestroy)("dJointDestroy", биб);
    вяжи(dJointGroupCreate)("dJointGroupCreate", биб);
    вяжи(dJointGroupDestroy)("dJointGroupDestroy", биб);
    вяжи(dJointGroupEmpty)("dJointGroupEmpty", биб);
    вяжи(dJointGetNumBodies)("dJointGetNumBodies", биб);
    вяжи(dJointAttach)("dJointAttach", биб);
    вяжи(dJointEnable)("dJointEnable", биб);
    вяжи(dJointDisable)("dJointDisable", биб);
    вяжи(dJointIsEnabled)("dJointIsEnabled", биб);
    вяжи(dJointSetData)("dJointSetData", биб);
    вяжи(dJointGetData)("dJointGetData", биб);
    вяжи(dJointGetType)("dJointGetType", биб);
    вяжи(dJointGetBody)("dJointGetBody", биб);
    вяжи(dJointSetFeedback)("dJointSetFeedback", биб);
    вяжи(dJointGetFeedback)("dJointGetFeedback", биб);
    вяжи(dJointSetBallAnchor)("dJointSetBallAnchor", биб);
    вяжи(dJointSetBallAnchor2)("dJointSetBallAnchor2", биб);
    вяжи(dJointSetBallParam)("dJointSetBallParam", биб);
    вяжи(dJointSetHingeAnchor)("dJointSetHingeAnchor", биб);
    вяжи(dJointSetHingeAnchorDelta)("dJointSetHingeAnchorDelta", биб);
    вяжи(dJointSetHingeAxis)("dJointSetHingeAxis", биб);
    вяжи(dJointSetHingeAxisOffset)("dJointSetHingeAxisOffset", биб);
    вяжи(dJointSetHingeParam)("dJointSetHingeParam", биб);
    вяжи(dJointAddHingeTorque)("dJointAddHingeTorque", биб);
    вяжи(dJointSetSliderAxis)("dJointSetSliderAxis", биб);
    вяжи(dJointSetSliderAxisDelta)("dJointSetSliderAxisDelta", биб);
    вяжи(dJointSetSliderParam)("dJointSetSliderParam", биб);
    вяжи(dJointAddSliderForce)("dJointAddSliderForce", биб);
    вяжи(dJointSetHinge2Anchor)("dJointSetHinge2Anchor", биб);
    вяжи(dJointSetHinge2Axis1)("dJointSetHinge2Axis1", биб);
    вяжи(dJointSetHinge2Axis2)("dJointSetHinge2Axis2", биб);
    вяжи(dJointSetHinge2Param)("dJointSetHinge2Param", биб);
    вяжи(dJointAddHinge2Torques)("dJointAddHinge2Torques", биб);
    вяжи(dJointSetUniversalAnchor)("dJointSetUniversalAnchor", биб);
    вяжи(dJointSetUniversalAxis1)("dJointSetUniversalAxis1", биб);
    вяжи(dJointSetUniversalAxis1Offset)("dJointSetUniversalAxis1Offset", биб);
    вяжи(dJointSetUniversalAxis2)("dJointSetUniversalAxis2", биб);
    вяжи(dJointSetUniversalAxis2Offset)("dJointSetUniversalAxis2Offset", биб);
    вяжи(dJointSetUniversalParam)("dJointSetUniversalParam", биб);
    вяжи(dJointAddUniversalTorques)("dJointAddUniversalTorques", биб);
    вяжи(dJointSetPRAnchor)("dJointSetPRAnchor", биб);
    вяжи(dJointSetPRAxis1)("dJointSetPRAxis1", биб);
    вяжи(dJointSetPRAxis2)("dJointSetPRAxis2", биб);
    вяжи(dJointSetPRParam)("dJointSetPRParam", биб);
    вяжи(dJointAddPRTorque)("dJointAddPRTorque", биб);
    вяжи(dJointSetPUAnchor)("dJointSetPUAnchor", биб);
    вяжи(dJointSetPUAnchorOffset)("dJointSetPUAnchorOffset", биб);
    вяжи(dJointSetPUAxis1)("dJointSetPUAxis1", биб);
    вяжи(dJointSetPUAxis2)("dJointSetPUAxis2", биб);
    вяжи(dJointSetPUAxis3)("dJointSetPUAxis3", биб);
    вяжи(dJointSetPUAxisP)("dJointSetPUAxisP", биб);
    вяжи(dJointSetPUParam)("dJointSetPUParam", биб);
    вяжи(dJointSetPistonAnchor)("dJointSetPistonAnchor", биб);
    вяжи(dJointSetPistonAnchorOffset)("dJointSetPistonAnchorOffset", биб);
    вяжи(dJointSetPistonAxis)("dJointSetPistonAxis", биб);
    вяжи(dJointSetPistonParam)("dJointSetPistonParam", биб);
    вяжи(dJointAddPistonForce)("dJointAddPistonForce", биб);
    вяжи(dJointSetFixed)("dJointSetFixed", биб);
    вяжи(dJointSetFixedParam)("dJointSetFixedParam", биб);
    вяжи(dJointSetAMotorNumAxes)("dJointSetAMotorNumAxes", биб);
    вяжи(dJointSetAMotorAxis)("dJointSetAMotorAxis", биб);
    вяжи(dJointSetAMotorAngle)("dJointSetAMotorAngle", биб);
    вяжи(dJointSetAMotorParam)("dJointSetAMotorParam", биб);
    вяжи(dJointSetAMotorMode)("dJointSetAMotorMode", биб);
    вяжи(dJointAddAMotorTorques)("dJointAddAMotorTorques", биб);
    вяжи(dJointSetLMotorNumAxes)("dJointSetLMotorNumAxes", биб);
    вяжи(dJointSetLMotorAxis)("dJointSetLMotorAxis", биб);
    вяжи(dJointSetLMotorParam)("dJointSetLMotorParam", биб);
    вяжи(dJointSetPlane2DXParam)("dJointSetPlane2DXParam", биб);
    вяжи(dJointSetPlane2DYParam)("dJointSetPlane2DYParam", биб);
    вяжи(dJointSetPlane2DAngleParam)("dJointSetPlane2DAngleParam", биб);
    вяжи(dJointGetBallAnchor)("dJointGetBallAnchor", биб);
    вяжи(dJointGetBallAnchor2)("dJointGetBallAnchor2", биб);
    вяжи(dJointGetBallParam)("dJointGetBallParam", биб);
    вяжи(dJointGetHingeAnchor)("dJointGetHingeAnchor", биб);
    вяжи(dJointGetHingeAnchor2)("dJointGetHingeAnchor2", биб);
    вяжи(dJointGetHingeAxis)("dJointGetHingeAxis", биб);
    вяжи(dJointGetHingeParam)("dJointGetHingeParam", биб);
    вяжи(dJointGetHingeAngle)("dJointGetHingeAngle", биб);
    вяжи(dJointGetHingeAngleRate)("dJointGetHingeAngleRate", биб);
    вяжи(dJointGetSliderPosition)("dJointGetSliderPosition", биб);
    вяжи(dJointGetSliderPositionRate)("dJointGetSliderPositionRate", биб);
    вяжи(dJointGetSliderAxis)("dJointGetSliderAxis", биб);
    вяжи(dJointGetSliderParam)("dJointGetSliderParam", биб);
    вяжи(dJointGetHinge2Anchor)("dJointGetHinge2Anchor", биб);
    вяжи(dJointGetHinge2Anchor2)("dJointGetHinge2Anchor2", биб);
    вяжи(dJointGetHinge2Axis1)("dJointGetHinge2Axis1", биб);
    вяжи(dJointGetHinge2Axis2)("dJointGetHinge2Axis2", биб);
    вяжи(dJointGetHinge2Param)("dJointGetHinge2Param", биб);
    вяжи(dJointGetHinge2Angle1)("dJointGetHinge2Angle1", биб);
    вяжи(dJointGetHinge2Angle1Rate)("dJointGetHinge2Angle1Rate", биб);
    вяжи(dJointGetHinge2Angle2Rate)("dJointGetHinge2Angle2Rate", биб);
    вяжи(dJointGetUniversalAnchor)("dJointGetUniversalAnchor", биб);
    вяжи(dJointGetUniversalAnchor2)("dJointGetUniversalAnchor2", биб);
    вяжи(dJointGetUniversalAxis1)("dJointGetUniversalAxis1", биб);
    вяжи(dJointGetUniversalAxis2)("dJointGetUniversalAxis2", биб);
    вяжи(dJointGetUniversalParam)("dJointGetUniversalParam", биб);
    вяжи(dJointGetUniversalAngles)("dJointGetUniversalAngles", биб);
    вяжи(dJointGetUniversalAngle1)("dJointGetUniversalAngle1", биб);
    вяжи(dJointGetUniversalAngle2)("dJointGetUniversalAngle2", биб);
    вяжи(dJointGetUniversalAngle1Rate)("dJointGetUniversalAngle1Rate", биб);
    вяжи(dJointGetUniversalAngle2Rate)("dJointGetUniversalAngle2Rate", биб);
    вяжи(dJointGetPRAnchor)("dJointGetPRAnchor", биб);
    вяжи(dJointGetPRPosition)("dJointGetPRPosition", биб);
    вяжи(dJointGetPRPositionRate)("dJointGetPRPositionRate", биб);
    вяжи(dJointGetPRAngle)("dJointGetPRAngle", биб);
    вяжи(dJointGetPRAngleRate)("dJointGetPRAngleRate", биб);
    вяжи(dJointGetPRAxis1)("dJointGetPRAxis1", биб);
    вяжи(dJointGetPRAxis2)("dJointGetPRAxis2", биб);
    вяжи(dJointGetPRParam)("dJointGetPRParam", биб);
    вяжи(dJointGetPUAnchor)("dJointGetPUAnchor", биб);
    вяжи(dJointGetPUPosition)("dJointGetPUPosition", биб);
    вяжи(dJointGetPUPositionRate)("dJointGetPUPositionRate", биб);
    вяжи(dJointGetPUAxis1)("dJointGetPUAxis1", биб);
    вяжи(dJointGetPUAxis2)("dJointGetPUAxis2", биб);
    вяжи(dJointGetPUAxis3)("dJointGetPUAxis3", биб);
    вяжи(dJointGetPUAxisP)("dJointGetPUAxisP", биб);
    вяжи(dJointGetPUAngles)("dJointGetPUAngles", биб);
    вяжи(dJointGetPUAngle1)("dJointGetPUAngle1", биб);
    вяжи(dJointGetPUAngle1Rate)("dJointGetPUAngle1Rate", биб);
    вяжи(dJointGetPUAngle2)("dJointGetPUAngle2", биб);
    вяжи(dJointGetPUAngle2Rate)("dJointGetPUAngle2Rate", биб);
    вяжи(dJointGetPUParam)("dJointGetPUParam", биб);
    вяжи(dJointGetPistonPosition)("dJointGetPistonPosition", биб);
    вяжи(dJointGetPistonPositionRate)("dJointGetPistonPositionRate", биб);
    вяжи(dJointGetPistonAngle)("dJointGetPistonAngle", биб);
    вяжи(dJointGetPistonAngleRate)("dJointGetPistonAngleRate", биб);
    вяжи(dJointGetPistonAnchor)("dJointGetPistonAnchor", биб);
    вяжи(dJointGetPistonAnchor2)("dJointGetPistonAnchor2", биб);
    вяжи(dJointGetPistonAxis)("dJointGetPistonAxis", биб);
    вяжи(dJointGetPistonParam)("dJointGetPistonParam", биб);
    вяжи(dJointGetAMotorNumAxes)("dJointGetAMotorNumAxes", биб);
    вяжи(dJointGetAMotorAxis)("dJointGetAMotorAxis", биб);
    вяжи(dJointGetAMotorAxisRel)("dJointGetAMotorAxisRel", биб);
    вяжи(dJointGetAMotorAngle)("dJointGetAMotorAngle", биб);
    вяжи(dJointGetAMotorAngleRate)("dJointGetAMotorAngleRate", биб);
    вяжи(dJointGetAMotorParam)("dJointGetAMotorParam", биб);
    вяжи(dJointGetAMotorMode)("dJointGetAMotorMode", биб);
    вяжи(dJointGetLMotorNumAxes)("dJointGetLMotorNumAxes", биб);
    вяжи(dJointGetLMotorAxis)("dJointGetLMotorAxis", биб);
    вяжи(dJointGetLMotorParam)("dJointGetLMotorParam", биб);
    вяжи(dJointGetFixedParam)("dJointGetFixedParam", биб);
    вяжи(dConnectingJoint)("dConnectingJoint", биб);
    вяжи(dConnectingJointList)("dConnectingJointList", биб);
    вяжи(dAreConnected)("dAreConnected", биб);
    вяжи(dAreConnectedExcluding)("dAreConnectedExcluding", биб);

    // odeinit.h
    вяжи(dInitODE)("dInitODE", биб);
    вяжи(dInitODE2)("dInitODE2", биб);
    вяжи(dAllocateODEDataForThread)("dAllocateODEDataForThread", биб);
    вяжи(dCleanupODEAllDataForThread)("dCleanupODEAllDataForThread", биб);
    вяжи(dCloseODE)("dCloseODE", биб);

    // rotation.h
    вяжи(dRSetIdentity)("dRSetIdentity", биб);
    вяжи(dRFromAxisAndAngle)("dRFromAxisAndAngle", биб);
    вяжи(dRFromEulerAngles)("dRFromEulerAngles", биб);
    вяжи(dRFrom2Axes)("dRFrom2Axes", биб);
    вяжи(dRFromZAxis)("dRFromZAxis", биб);
    вяжи(dQSetIdentity)("dQSetIdentity", биб);
    вяжи(dQFromAxisAndAngle)("dQFromAxisAndAngle", биб);
    вяжи(dQMultiply0)("dQMultiply0", биб);
    вяжи(dQMultiply1)("dQMultiply1", биб);
    вяжи(dQMultiply2)("dQMultiply2", биб);
    вяжи(dQMultiply3)("dQMultiply3", биб);
    вяжи(dRfromQ)("dRfromQ", биб);
    вяжи(dQfromR)("dQfromR", биб);
    вяжи(dDQfromW)("dDQfromW", биб);

    // timer.h
    вяжи(dStopwatchReset)("dStopwatchReset", биб);
    вяжи(dStopwatchStart)("dStopwatchStart", биб);
    вяжи(dStopwatchStop)("dStopwatchStop", биб);
    вяжи(dStopwatchTime)("dStopwatchTime", биб);
    вяжи(dTimerStart)("dTimerStart", биб);
    вяжи(dTimerNow)("dTimerNow", биб);
    вяжи(dTimerEnd)("dTimerEnd", биб);
    вяжи(dTimerReport)("dTimerReport", биб);
    вяжи(dTimerTicksPerSecond)("dTimerTicksPerSecond", биб);
    вяжи(dTimerResolution)("dTimerResolution", биб);

    // defined in interface, present in ODE source, but consistently fails to грузи
    // вяжи(dWorldExportDIF)("dWorldExportDIF", биб);
}

ЖанБибгр ОДЕ;
static this() {
    version(ДвойнаяТочность)
    {
        char[] winlib = "ode_double.dll";
        char[] linlib = "libode_double.so";
    }
    else
    {
        char[] winlib = "ode_single.dll";
        char[] linlib = "ode_double.dll";
    }
    ОДЕ.заряжай( "ode.dll",  &грузи );
	ОДЕ.загружай();
}

extern(C)
{
    // common.h
    ткст0 function() dGetConfiguration;
    цел function(in ткст0) dCheckConfiguration;

    // collision.h
    проц function(dGeomID) dGeomDestroy;
    проц function(dGeomID, ук) dGeomSetData;
    ук function(dGeomID) dGeomGetData;
    проц function(dGeomID, dBodyID) dGeomSetBody;
    dBodyID function(dGeomID) dGeomGetBody;
    проц function(dGeomID, дРеал, дРеал, дРеал) dGeomSetPosition;
    проц function(dGeomID, in дМатрица3) dGeomSetRotation;
    проц function(dGeomID, in дКватернион) dGeomSetQuaternion;
    дРеал* function(dGeomID) dGeomGetPosition;
    проц function(dGeomID, дВектор3) dGeomCopyPosition;
    дРеал* function(dGeomID)  dGeomGetRotation;
    проц function(dGeomID, дМатрица3) dGeomCopyRotation;
    проц function(dGeomID, дКватернион) dGeomGetQuaternion;
    проц function(dGeomID, дРеал[6]) dGeomGetAABB;
    цел function(dGeomID) dGeomIsSpace;
    dSpaceID function(dGeomID) dGeomGetSpace;
    цел function(dGeomID) dGeomGetClass;
    проц function(dGeomID, бцел) dGeomSetCategoryBits;
    проц function(dGeomID, бцел) dGeomSetCollideBits;
    бцел function(dGeomID) dGeomGetCategoryBits;
    бцел function(dGeomID) dGeomGetCollideBits;
    проц function(dGeomID) dGeomEnable;
    проц function(dGeomID) dGeomDisable;
    цел function(dGeomID) dGeomIsEnabled;
    проц function(dGeomID, дРеал, дРеал, дРеал) dGeomSetOffsetPosition;
    проц function(dGeomID, in дМатрица3) dGeomSetOffsetRotation;
    проц function(dGeomID, in дКватернион) dGeomSetOffsetQuaternion;
    проц function(dGeomID, дРеал, дРеал, дРеал) dGeomSetOffsetWorldPosition;
    проц function(dGeomID, in дМатрица3) dGeomSetOffsetWorldRotation;
    проц function(dGeomID, цел дКватернион) dGeomSetOffsetWorldQuaternion;
    проц function(dGeomID) dGeomClearOffset;
    цел function(dGeomID) dGeomIsOffset;
    дРеал* function(dGeomID) dGeomGetOffsetPosition;
    проц function(dGeomID, дВектор3) dGeomCopyOffsetPosition;
    дРеал* function(dGeomID) dGeomGetOffsetRotation;
    проц function(dGeomID, дКватернион) dGeomGetOffsetQuaternion;
    цел function(dGeomID, dGeomID, цел, dContactGeom*) dCollide;
    проц function(dSpaceID, ук, dNearCallback) dSpaceCollide;
    проц function(dGeomID, dGeomID, ук, dNearCallback) dSpaceCollide2;
    dGeomID function(dSpaceID, дРеал) dCreateSphere;
    проц function(dGeomID, дРеал) dGeomSphereSetRadius;
    дРеал function(dGeomID) dGeomSphereGetRadius;
    дРеал function(dGeomID, дРеал, дРеал, дРеал) dGeomSpherePointDepth;
    dGeomID function(dSpaceID, дРеал*, бцел, дРеал*, бцел, бцел*) dCreateConvex;
    проц function(dGeomID, дРеал*, бцел, дРеал*, бцел, бцел*) dGeomSetConvex;
    dGeomID function(dSpaceID, дРеал, дРеал, дРеал) dCreateBox;
    проц function(dGeomID, дРеал, дРеал, дРеал) dGeomBoxSetLengths;
    проц function(dGeomID, дВектор3) dGeomBoxGetLengths;
    дРеал function(dGeomID, дРеал, дРеал, дРеал) dGeomBoxPointDepth;
    dGeomID function(dSpaceID, дРеал, дРеал, дРеал, дРеал) dCreatePlane;
    проц function(dGeomID, дРеал, дРеал, дРеал, дРеал) dGeomPlaneSetParams;
    проц function(dGeomID, дВектор4) dGeomPlaneGetParams;
    дРеал function(dGeomID, дРеал, дРеал, дРеал) dGeomPlanePointDepth;
    dGeomID function(dSpaceID, дРеал, дРеал) dCreateCapsule;
    проц function(dGeomID, дРеал, дРеал) dGeomCapsuleSetParams;
    проц function(dGeomID, дРеал*, дРеал*) dGeomCapsuleGetParams;
    дРеал function(dGeomID, дРеал, дРеал, дРеал) dGeomCapsulePointDepth;
    dGeomID function(dSpaceID, дРеал, дРеал) dCreateCylinder;
    проц function(dGeomID, дРеал, дРеал) dGeomCylinderSetParams;
    проц function(dGeomID, дРеал*, дРеал*) dGeomCylinderGetParams;
    dGeomID function(dSpaceID, дРеал) dCreateRay;
    проц function(dGeomID, дРеал) dGeomRaySetLength;
    дРеал function(dGeomID) dGeomRayGetLength;
    проц function(dGeomID, дРеал, дРеал, дРеал, дРеал, дРеал, дРеал) dGeomRaySet;
    проц function(dGeomID, дВектор3, дВектор3) dGeomRayGet;
    проц function(dGeomID, цел, цел) dGeomRaySetParams;
    проц function(dGeomID, цел*, цел*) dGeomRayGetParams;
    проц function(dGeomID, цел) dGeomRaySetClosestHit;
    цел function(dGeomID) dGeomRayGetClosestHit;
    dGeomID function(dSpaceID) dCreateGeomTransform;
    проц function(dGeomID, dGeomID) dGeomTransformSetGeom;
    dGeomID function(dGeomID) dGeomTransformGetGeom;
    проц function(dGeomID, цел) dGeomTransformSetCleanup;
    цел function(dGeomID) dGeomTransformGetCleanup;
    проц function(dGeomID, цел) dGeomTransformSetInfo;
    цел function(dGeomID) dGeomTransformGetInfo;
    dGeomID function(dSpaceID, dHeightfieldDataID, цел) dCreateHeightfield;
    dHeightfieldDataID function() dGeomHeightfieldDataCreate;
    проц function(dHeightfieldDataID) dGeomHeightfieldDataDestroy;
    проц function(dHeightfieldDataID, ук, dHeightfieldGetHeight, дРеал, дРеал, цел, цел, дРеал, дРеал, дРеал, цел) dGeomHeightfieldDataBuildCallback;
    проц function(dHeightfieldDataID, in ббайт*, цел, дРеал, дРеал, цел, цел, дРеал, дРеал, дРеал, цел) dGeomHeightfieldDataBuildByte;
    проц function(dHeightfieldDataID, in крат*, цел, дРеал, дРеал, цел, цел, дРеал, дРеал, дРеал, цел) dGeomHeightfieldDataBuildShort;
    проц function(dHeightfieldDataID, in плав*, цел, дРеал, дРеал, цел, цел, дРеал, дРеал, дРеал, цел) dGeomHeightfieldDataBuildSingle;
    проц function(dHeightfieldDataID, in дво*, цел, дРеал, дРеал, цел, цел, дРеал, дРеал, дРеал, цел) dGeomHeightfieldDataBuildDouble;
    проц function(dHeightfieldDataID, дРеал, дРеал) dGeomHeightfieldDataSetBounds;
    проц function(dGeomID, dHeightfieldDataID) dGeomHeightfieldSetHeightfieldData;
    dHeightfieldDataID function(dGeomID) dGeomHeightfieldGetHeightfieldData;
    проц function(in дВектор3, in дВектор3, in дВектор3, in дВектор3, дВектор3, дВектор3) dClosestLineSegmentPoints;
    цел function(in дВектор3, in дМатрица3, in дВектор3, in дВектор3, in дМатрица3, in дВектор3) dBoxTouchesBox;
    цел function(in дВектор3, in дМатрица3, in дВектор3, in дВектор3, in дМатрица3, in дВектор3, дВектор3, дРеал*, цел*, цел, dContactGeom*, цел) dBoxBox;
    проц function(dGeomID, дРеал[6]) dInfiniteAABB;
    цел function(in dGeomClass*) dCreateGeomClass;
    ук function(dGeomID) dGeomGetClassData;
    dGeomID function(цел) dCreateGeom;
    проц function(цел, цел, dColliderFn) dSetColliderOverride;

    alias dCreateCapsule dCreateCCylinder;
    alias dGeomCapsuleSetParams dGeomCCylinderSetParams;
    alias dGeomCapsuleGetParams dGeomCCylinderGetParams;
    alias dGeomCapsulePointDepth dGeomCCylinderPointDepth;

    // collision_space.h
    dSpaceID function(dSpaceID) dSimpleSpaceCreate;
    dSpaceID function(dSpaceID) dHashSpaceCreate;
    dSpaceID function(dSpaceID, in дВектор3, in дВектор3, цел) dQuadTreeSpaceCreate;
    dSpaceID function(dSpaceID, цел) dSweepAndPruneSpaceCreate;
    проц function(dSpaceID) dSpaceDestroy;
    проц function(dSpaceID, цел, цел) dHashSpaceSetLevels;
    проц function(dSpaceID, цел*, цел*) dHashSpaceGetLevels;
    проц function(dSpaceID, цел) dSpaceSetCleanup;
    цел function(dSpaceID) dSpaceGetCleanup;
    проц function(dSpaceID, цел) dSpaceSetSublevel;
    цел function(dSpaceID) dSpaceGetSublevel;
    проц function(dSpaceID, dGeomID) dSpaceAdd;
    проц function(dSpaceID, dGeomID) dSpaceRemove;
    цел function(dSpaceID, dGeomID) dSpaceQuery;
    проц function(dSpaceID) dSpaceClean;
    цел function(dSpaceID) dSpaceGetNumGeoms;
    dGeomID function(dSpaceID, цел) dSpaceGetGeom;
    цел function(dSpaceID) dSpaceGetClass;

    // collision_trimesh.h
    dTriMeshDataID function() dGeomTriMeshDataCreate;
    проц function(dTriMeshDataID) dGeomTriMeshDataDestroy;
    проц function(dTriMeshDataID, цел, ук) dGeomTriMeshDataSet;
    ук function(dTriMeshDataID, цел) dGeomTriMeshDataGet;
    проц function(dGeomID, дМатрица4) dGeomTriMeshSetLastTransform;
    дРеал* function(dGeomID) dGeomTriMeshGetLastTransform;
    проц function(dTriMeshDataID, in ук, цел, цел, in ук, цел, цел) dGeomTriMeshDataBuildSingle;
    проц function(dTriMeshDataID, in ук, цел, цел, in ук, цел, цел, in ук) dGeomTriMeshDataBuildSingle1;
    проц function(dTriMeshDataID, in ук, цел, цел, in ук, цел, цел) dGeomTriMeshDataBuildDouble;
    проц function(dTriMeshDataID, in ук, цел, цел, in ук, цел, цел, in ук) dGeomTriMeshDataBuildDouble1;
    проц function(dTriMeshDataID, in дРеал*, цел, in dTriIndex*, цел) dGeomTriMeshDataBuildSimple;
    проц function(dTriMeshDataID, in дРеал*, цел, in dTriIndex*, цел, in цел*) dGeomTriMeshDataBuildSimple1;
    проц function(dTriMeshDataID) dGeomTriMeshDataPreprocess;
    проц function(dTriMeshDataID, ббайт**, цел*) dGeomTriMeshDataGetBuffer;
    проц function(dTriMeshDataID, ббайт*) dGeomTriMeshDataSetBuffer;
    проц function(dGeomID, dTriCallback) dGeomTriMeshSetCallback;
    dTriCallback function(dGeomID) dGeomTriMeshGetCallback;
    проц function(dGeomID, dTriArrayCallback) dGeomTriMeshSetArrayCallback;
    dTriArrayCallback function(dGeomID) dGeomTriMeshGetArrayCallback;
    проц function(dGeomID, dTriRayCallback) dGeomTriMeshSetRayCallback;
    dTriRayCallback function(dGeomID) dGeomTriMeshGetRayCallback;
    проц function(dGeomID, dTriTriMergeCallback) dGeomTriMeshSetTriMergeCallback;
    dTriTriMergeCallback function(dGeomID) dGeomTriMeshGetTriMergeCallback;
    dGeomID function(dSpaceID, dTriMeshDataID, dTriCallback, dTriArrayCallback, dTriRayCallback) dCreateTriMesh;
    проц function(dGeomID, dTriMeshDataID) dGeomTriMeshSetData;
    dTriMeshDataID function(dGeomID) dGeomTriMeshGetData;
    проц function(dGeomID, цел, цел) dGeomTriMeshEnableTC;
    цел function(dGeomID, цел) dGeomTriMeshIsTCEnabled;
    проц function(dGeomID) dGeomTriMeshClearTCCache;
    dTriMeshDataID function(dGeomID) dGeomTriMeshGetTriMeshDataID;
    проц function(dGeomID, цел, дВектор3*, дВектор3*, дВектор3*) dGeomTriMeshGetTriangle;
    проц function(dGeomID, цел, дРеал, дРеал, дВектор3) dGeomTriMeshGetPoint;
    цел function(dGeomID) dGeomTriMeshGetTriangleCount;
    проц function(dTriMeshDataID) dGeomTriMeshDataUpdate;

    // error.h
    проц function(dMessageFunction) dSetErrorHandler;
    проц function(dMessageFunction) dSetDebugHandler;
    проц function(dMessageFunction) dSetMessageHandler;
    dMessageFunction function() dGetErrorHandler;
    dMessageFunction function() dGetDebugHandler;
    dMessageFunction function() dGetMessageHandler;
    проц function(цел, in ткст0, ...) dError;
    проц function(цел, in ткст0, ...) dDebug;
    проц function(цел, in ткст0, ...) dMessage;

    // mass.h
    цел function(in dMass*) dMassCheck;
    проц function(dMass*) dMassSetZero;
    проц function(dMass*, дРеал, дРеал, дРеал, дРеал, дРеал, дРеал, дРеал, дРеал, дРеал, дРеал) dMassSetParameters;
    проц function(dMass*, дРеал, дРеал) dMassSetSphere;
    проц function(dMass*, дРеал, дРеал) dMassSetSphereTotal;
    проц function(dMass*, дРеал, цел, дРеал, дРеал) dMassSetCapsule;
    проц function(dMass*, дРеал, цел, дРеал, дРеал) dMassSetCapsuleTotal;
    проц function(dMass*, дРеал, цел, дРеал, дРеал) dMassSetCylinder;
    проц function(dMass*, дРеал, цел, дРеал, дРеал) dMassSetCylinderTotal;
    проц function(dMass*, дРеал, дРеал, дРеал, дРеал) dMassSetBox;
    проц function(dMass*, дРеал, дРеал, дРеал, дРеал) dMassSetBoxTotal;
    проц function(dMass*, дРеал, dGeomID) dMassSetTrimesh;
    проц function(dMass*, дРеал, dGeomID) dMassSetTrimeshTotal;
    проц function(dMass*, дРеал) dMassAdjust;
    проц function(dMass*, дРеал, дРеал, дРеал) dMassTranslate;
    проц function(dMass*, in дМатрица3) dMassRotate;
    проц function(dMass*, in dMass*) dMassAdd;

    // matrix.h
    проц function(дРеал*, цел) dSetZero;
    проц function(дРеал*, цел, дРеал) dSetValue;
    дРеал function(in дРеал*, in дРеал*, цел) dDot;
    проц function(дРеал*, in дРеал*, in дРеал*, цел, цел, цел) dMultiply0;
    проц function(дРеал*, in дРеал*, in дРеал*, цел, цел, цел) dMultiply1;
    проц function(дРеал*, in дРеал*, in дРеал*, цел, цел, цел) dMultiply2;
    цел function(дРеал*, цел) dFactorCholesky;
    проц function(in дРеал*, дРеал*, цел) dSolveCholesky;
    цел function(in дРеал*, дРеал*, цел) dInvertPDMatrix;
    цел function(in дРеал*, цел) dIsPositiveDefinite;
    проц function(дРеал*, дРеал*, цел, цел) dFactorLDLT;
    проц function(in дРеал*, дРеал*, цел, цел) dSolveL1;
    проц function(in дРеал*, дРеал*, цел, цел) dSolveL1T;
    проц function(дРеал*, in дРеал*, цел) dVectorScale;
    проц function(in дРеал*, in дРеал*, дРеал*, цел, цел) dSolveLDLT;
    проц function(дРеал*, дРеал*, in дРеал*, цел, цел) dLDLTAddTL;
    проц function(дРеал**, in цел*, дРеал*, дРеал*, цел, цел, цел, цел) dLDLTRemove;
    проц function(дРеал*, цел, цел, цел) dRemoveRowCol;

    // memory.h
    проц function(dAllocFunction) dSetAllocHandler;
    проц function(dReallocFunction) dSetReallocHandler;
    проц function(dFreeFunction) dSetFreeHandler;
    dAllocFunction function() dGetAllocHandler;
    dReallocFunction function() dGetReallocHandler;
    dFreeFunction function() dGetFreeHandler;
    ук function(size_t) dAlloc;
    ук function(ук, size_t, size_t) dRealloc;
    проц function(ук, size_t) dFree;

    // misc.h
    цел function() dTestRand;
    бцел function() dRand;
    бцел function() dRandGetSeed;
    проц function(бцел) dRandSetSeed;
    цел function(цел) dRandInt;
    дРеал function() dRandReal;
    проц function(in дРеал*, цел, цел, ткст0, фук) dPrintMatrix;
    проц function(дРеал, цел, дРеал) dMakeRandomVector;
    проц function(дРеал*, цел, цел, дРеал) dMakeRandomMatrix;
    проц function(дРеал*, цел) dClearUpperTriangle;
    дРеал function(in дРеал*, in дРеал*, цел, цел) dMaxDifference;
    дРеал function(in дРеал*, in дРеал*, цел) dMaxDifferenceLowerTriangle;

    // objects.h
    dWorldID function() dWorldCreate;
    проц function(dWorldID) dWorldDestroy;
    проц function(dWorldID, дРеал, дРеал, дРеал) dWorldSetGravity;
    проц function(dWorldID, дВектор3) dWorldGetGravity;
    проц function(dWorldID, дРеал) dWorldSetERP;
    дРеал function(dWorldID) dWorldGetERP;
    проц function(dWorldID, дРеал) dWorldSetCFM;
    дРеал function(dWorldID) dWorldGetCFM;
    проц function(dWorldID, дРеал) dWorldStep;
    проц function(dWorldID, дРеал, дРеал, дРеал, дРеал, дВектор3) dWorldImpulseToForce;
    проц function(dWorldID, дРеал) dWorldQuickStep;
    проц function(dWorldID, цел) dWorldSetQuickStepNumIterations;
    цел function(dWorldID) dWorldGetQuickStepNumIterations;
    проц function(dWorldID, дРеал) dWorldSetQuickStepW;
    дРеал function(dWorldID) dWorldGetQuickStepW;
    проц function(dWorldID, дРеал) dWorldSetContactMaxCorrectingVel;
    дРеал function(dWorldID) dWorldGetContactMaxCorrectingVel;
    проц function(dWorldID, дРеал) dWorldSetContactSurfaceLayer;
    дРеал function(dWorldID) dWorldGetContactSurfaceLayer;
    проц function(dWorldID, дРеал, цел) dWorldStepFast1;
    проц function(dWorldID, цел) dWorldSetAutoEnableDepthSF1;
    цел function(dWorldID) dWorldGetAutoEnableDepthSF1;
    дРеал function(dWorldID) dWorldGetAutoDisableLinearThreshold;
    проц function(dWorldID, дРеал) dWorldSetAutoDisableLinearThreshold;
    дРеал function(dWorldID) dWorldGetAutoDisableAngularThreshold;
    проц function(dWorldID, дРеал) dWorldSetAutoDisableAngularThreshold;
    цел function(dWorldID) dWorldGetAutoDisableAverageSamplesCount;
    проц function(dWorldID, бцел) dWorldSetAutoDisableAverageSamplesCount;
    цел function(dWorldID) dWorldGetAutoDisableSteps;
    проц function(dWorldID, цел) dWorldSetAutoDisableSteps;
    дРеал function(dWorldID) dWorldGetAutoDisableTime;
    проц function(dWorldID, дРеал) dWorldSetAutoDisableTime;
    цел function(dWorldID) dWorldGetAutoDisableFlag;
    проц function(dWorldID, цел) dWorldSetAutoDisableFlag;
    дРеал function(dWorldID) dWorldGetLinearDampingThreshold;
    проц function(dWorldID, дРеал) dWorldSetLinearDampingThreshold;
    дРеал function(dWorldID) dWorldGetAngularDampingThreshold;
    проц function(dWorldID, дРеал) dWorldSetAngularDampingThreshold;
    дРеал function(dWorldID) dWorldGetLinearDamping;
    проц function(dWorldID, дРеал) dWorldSetLinearDamping;
    дРеал function(dWorldID) dWorldGetAngularDamping;
    проц function(dWorldID, дРеал) dWorldSetAngularDamping;
    проц function(dWorldID, дРеал, дРеал) dWorldSetDamping;
    дРеал function(dWorldID) dWorldGetMaxAngularSpeed;
    проц function(dWorldID, дРеал) dWorldSetMaxAngularSpeed;
    дРеал function(dBodyID) dBodyGetAutoDisableLinearThreshold;
    проц function(dBodyID, дРеал) dBodySetAutoDisableLinearThreshold;
    дРеал function(dBodyID) dBodyGetAutoDisableAngularThreshold;
    проц function(dBodyID, дРеал) dBodySetAutoDisableAngularThreshold;
    цел function(dBodyID) dBodyGetAutoDisableAverageSamplesCount;
    проц function(dBodyID, бцел) dBodySetAutoDisableAverageSamplesCount;
    цел function(dBodyID) dBodyGetAutoDisableSteps;
    проц function(dBodyID, цел) dBodySetAutoDisableSteps;
    дРеал function(dBodyID) dBodyGetAutoDisableTime;
    проц function(dBodyID, дРеал) dBodySetAutoDisableTime;
    цел function(dBodyID) dBodyGetAutoDisableFlag;
    проц function(dBodyID, цел) dBodySetAutoDisableFlag;
    проц function(dBodyID) dBodySetAutoDisableDefaults;
    dWorldID function(dBodyID) dBodyGetWorld;
    dBodyID function(dWorldID) dBodyCreate;
    проц function(dBodyID) dBodyDestroy;
    проц function(dBodyID, ук) dBodySetData;
    ук function(dBodyID) dBodyGetData;
    проц function(dBodyID, дРеал, дРеал, дРеал) dBodySetPosition;
    проц function(dBodyID, in дМатрица3) dBodySetRotation;
    проц function(dBodyID, in дКватернион) dBodySetQuaternion;
    проц function(dBodyID, дРеал, дРеал, дРеал) dBodySetLinearVel;
    проц function(dBodyID, дРеал, дРеал, дРеал) dBodySetAngularVel;
    дРеал* function(dBodyID) dBodyGetPosition;
    проц function(dBodyID, дВектор3) dBodyCopyPosition;
    дРеал* function(dBodyID) dBodyGetRotation;
    проц function(dBodyID, дМатрица3) dBodyCopyRotation;
    дРеал* function(dBodyID) dBodyGetQuaternion;
    проц function(dBodyID, дКватернион) dBodyCopyQuaternion;
    дРеал* function(dBodyID) dBodyGetLinearVel;
    дРеал* function(dBodyID) dBodyGetAngularVel;
    проц function(dBodyID, in dMass*) dBodySetMass;
    проц function(dBodyID, dMass*) dBodyGetMass;
    проц function(dBodyID, дРеал, дРеал, дРеал) dBodyAddForce;
    проц function(dBodyID, дРеал, дРеал, дРеал) dBodyAddTorque;
    проц function(dBodyID, дРеал, дРеал, дРеал) dBodyAddRelForce;
    проц function(dBodyID, дРеал, дРеал, дРеал) dBodyAddRelTorque;
    проц function(dBodyID, дРеал, дРеал, дРеал, дРеал, дРеал, дРеал) dBodyAddForceAtPos;
    проц function(dBodyID, дРеал, дРеал, дРеал, дРеал, дРеал, дРеал) dBodyAddForceAtRelPos;
    проц function(dBodyID, дРеал, дРеал, дРеал, дРеал, дРеал, дРеал) dBodyAddRelForceAtPos;
    проц function(dBodyID, дРеал, дРеал, дРеал, дРеал, дРеал, дРеал) dBodyAddRelForceAtRelPos;
    дРеал* function(dBodyID) dBodyGetForce;
    дРеал* function(dBodyID) dBodyGetTorque;
    проц function(dBodyID, дРеал, дРеал, дРеал) dBodySetForce;
    проц function(dBodyID, дРеал, дРеал, дРеал) dBodySetTorque;
    проц function(dBodyID, дРеал, дРеал, дРеал, дВектор3) dBodyGetRelPointPos;
    проц function(dBodyID, дРеал, дРеал, дРеал, дВектор3) dBodyGetRelPointVel;
    проц function(dBodyID, дРеал, дРеал, дРеал, дВектор3) dBodyGetPointVel;
    проц function(dBodyID, дРеал, дРеал, дРеал, дВектор3) dBodyGetPosRelPoint;
    проц function(dBodyID, дРеал, дРеал, дРеал, дВектор3) dBodyVectorToWorld;
    проц function(dBodyID, дРеал, дРеал, дРеал, дВектор3) dBodyVectorFromWorld;
    проц function(dBodyID, цел) dBodySetFiniteRotationMode;
    проц function(dBodyID, дРеал, дРеал, дРеал) dBodySetFiniteRotationAxis;
    цел function(dBodyID) dBodyGetFiniteRotationMode;
    проц function(dBodyID, дВектор3) dBodyGetFiniteRotationAxis;
    цел function(dBodyID) dBodyGetNumJoints;
    dJointID function(dBodyID) dBodyGetJoint;
    проц function(dBodyID) dBodySetDynamic;
    проц function(dBodyID) dBodySetKinematic;
    цел function(dBodyID) dBodyIsKinematic;
    проц function(dBodyID) dBodyEnable;
    проц function(dBodyID) dBodyDisable;
    цел function(dBodyID) dBodyIsEnabled;
    проц function(dBodyID, цел) dBodySetGravityMode;
    цел function(dBodyID) dBodyGetGravityMode;
    проц function(dBodyID, проц (*callback)(dBodyID)) dBodySetMovedCallback;
    dGeomID function(dBodyID) dBodyGetFirstGeom;
    dGeomID function(dGeomID) dBodyGetNextGeom;
    проц function(dBodyID) dBodySetDampingDefaults;
    дРеал function(dBodyID) dBodyGetLinearDamping;
    проц function(dBodyID, дРеал) dBodySetLinearDamping;
    дРеал function(dBodyID) dBodyGetAngularDamping;
    проц function(dBodyID, дРеал) dBodySetAngularDamping;
    проц function(dBodyID, дРеал, дРеал) dBodySetDamping;
    дРеал function(dBodyID) dBodyGetLinearDampingThreshold;
    проц function(dBodyID, дРеал) dBodySetLinearDampingThreshold;
    дРеал function(dBodyID) dBodyGetAngularDampingThreshold;
    проц function(dBodyID, дРеал) dBodySetAngularDampingThreshold;
    дРеал function(dBodyID) dBodyGetMaxAngularSpeed;
    проц function(dBodyID, дРеал) dBodySetMaxAngularSpeed;
    цел function(dBodyID) dBodyGetGyroscopicMode;
    проц function(dBodyID, цел) dBodySetGyroscopicMode;
    dJointID function(dWorldID, dJointGroupID) dJointCreateBall;
    dJointID function(dWorldID, dJointGroupID) dJointCreateHinge;
    dJointID function(dWorldID, dJointGroupID) dJointCreateSlider;
    dJointID function(dWorldID, dJointGroupID, in dContact*) dJointCreateContact;
    dJointID function(dWorldID, dJointGroupID) dJointCreateHinge2;
    dJointID function(dWorldID, dJointGroupID) dJointCreateUniversal;
    dJointID function(dWorldID, dJointGroupID) dJointCreatePR;
    dJointID function(dWorldID, dJointGroupID) dJointCreatePU;
    dJointID function(dWorldID, dJointGroupID) dJointCreatePiston;
    dJointID function(dWorldID, dJointGroupID) dJointCreateFixed;
    dJointID function(dWorldID, dJointGroupID) dJointCreateNull;
    dJointID function(dWorldID, dJointGroupID) dJointCreateAMotor;
    dJointID function(dWorldID, dJointGroupID) dJointCreateLMotor;
    dJointID function(dWorldID, dJointGroupID) dJointCreatePlane2D;
    проц function(dJointID) dJointDestroy;
    dJointGroupID function(цел) dJointGroupCreate;
    проц function(dJointGroupID) dJointGroupDestroy;
    проц function(dJointGroupID) dJointGroupEmpty;
    цел function(dJointID) dJointGetNumBodies;
    проц function(dJointID, dBodyID, dBodyID) dJointAttach;
    проц function(dJointID) dJointEnable;
    проц function(dJointID) dJointDisable;
    цел function(dJointID) dJointIsEnabled;
    проц function(dJointID, ук) dJointSetData;
    ук function(dJointID) dJointGetData;
    dJointType function(dJointID) dJointGetType;
    dBodyID function(dJointID, цел) dJointGetBody;
    проц function(dJointID, dJointFeedback*) dJointSetFeedback;
    dJointFeedback* function(dJointID) dJointGetFeedback;
    проц function(dJointID, дРеал, дРеал, дРеал) dJointSetBallAnchor;
    проц function(dJointID, дРеал, дРеал, дРеал) dJointSetBallAnchor2;
    проц function(dJointID, цел, дРеал) dJointSetBallParam;
    проц function(dJointID, дРеал, дРеал, дРеал) dJointSetHingeAnchor;
    проц function(dJointID, дРеал, дРеал, дРеал, дРеал, дРеал, дРеал) dJointSetHingeAnchorDelta;
    проц function(dJointID, дРеал, дРеал, дРеал) dJointSetHingeAxis;
    проц function(dJointID, дРеал, дРеал, дРеал, дРеал) dJointSetHingeAxisOffset;
    проц function(dJointID, цел, дРеал) dJointSetHingeParam;
    проц function(dJointID, дРеал) dJointAddHingeTorque;
    проц function(dJointID, дРеал, дРеал, дРеал) dJointSetSliderAxis;
    проц function(dJointID, дРеал, дРеал, дРеал, дРеал, дРеал, дРеал) dJointSetSliderAxisDelta;
    проц function(dJointID, цел, дРеал) dJointSetSliderParam;
    проц function(dJointID, дРеал) dJointAddSliderForce;
    проц function(dJointID, дРеал, дРеал, дРеал) dJointSetHinge2Anchor;
    проц function(dJointID, дРеал, дРеал, дРеал) dJointSetHinge2Axis1;
    проц function(dJointID, дРеал, дРеал, дРеал) dJointSetHinge2Axis2;
    проц function(dJointID, цел, дРеал) dJointSetHinge2Param;
    проц function(dJointID, дРеал, дРеал) dJointAddHinge2Torques;
    проц function(dJointID, дРеал, дРеал, дРеал) dJointSetUniversalAnchor;
    проц function(dJointID, дРеал, дРеал, дРеал) dJointSetUniversalAxis1;
    проц function(dJointID, дРеал, дРеал, дРеал, дРеал, дРеал) dJointSetUniversalAxis1Offset;
    проц function(dJointID, дРеал, дРеал, дРеал) dJointSetUniversalAxis2;
    проц function(dJointID, дРеал, дРеал, дРеал, дРеал, дРеал) dJointSetUniversalAxis2Offset;
    проц function(dJointID, цел, дРеал) dJointSetUniversalParam;
    проц function(dJointID, дРеал, дРеал) dJointAddUniversalTorques;
    проц function(dJointID, дРеал, дРеал, дРеал) dJointSetPRAnchor;
    проц function(dJointID, дРеал, дРеал, дРеал) dJointSetPRAxis1;
    проц function(dJointID, дРеал, дРеал, дРеал) dJointSetPRAxis2;
    проц function(dJointID, цел, дРеал) dJointSetPRParam;
    проц function(dJointID, дРеал) dJointAddPRTorque;
    проц function(dJointID, дРеал, дРеал, дРеал) dJointSetPUAnchor;
    проц function(dJointID, дРеал, дРеал, дРеал, дРеал, дРеал, дРеал) dJointSetPUAnchorOffset;
    проц function(dJointID, дРеал, дРеал, дРеал) dJointSetPUAxis1;
    проц function(dJointID, дРеал, дРеал, дРеал) dJointSetPUAxis2;
    проц function(dJointID, дРеал, дРеал, дРеал) dJointSetPUAxis3;
    проц function(dJointID, дРеал, дРеал, дРеал) dJointSetPUAxisP;
    проц function(dJointID, цел, дРеал) dJointSetPUParam;
    проц function(dJointID, дРеал, дРеал, дРеал) dJointSetPistonAnchor;
    проц function(dJointID, дРеал, дРеал, дРеал, дРеал, дРеал, дРеал) dJointSetPistonAnchorOffset;
    проц function(dJointID, дРеал, дРеал, дРеал) dJointSetPistonAxis;
    проц function(dJointID, цел, дРеал) dJointSetPistonParam;
    проц function(dJointID, дРеал) dJointAddPistonForce;
    проц function(dJointID) dJointSetFixed;
    проц function(dJointID, цел, дРеал) dJointSetFixedParam;
    проц function(dJointID, цел) dJointSetAMotorNumAxes;
    проц function(dJointID, цел, цел, дРеал, дРеал, дРеал) dJointSetAMotorAxis;
    проц function(dJointID, цел, дРеал) dJointSetAMotorAngle;
    проц function(dJointID, цел, дРеал) dJointSetAMotorParam;
    проц function(dJointID, цел) dJointSetAMotorMode;
    проц function(dJointID, дРеал, дРеал, дРеал) dJointAddAMotorTorques;
    проц function(dJointID, цел) dJointSetLMotorNumAxes;
    проц function(dJointID, цел, цел, дРеал, дРеал, дРеал) dJointSetLMotorAxis;
    проц function(dJointID, цел, дРеал) dJointSetLMotorParam;
    проц function(dJointID, цел, дРеал) dJointSetPlane2DXParam;
    проц function(dJointID, цел, дРеал) dJointSetPlane2DYParam;
    проц function(dJointID, цел, дРеал) dJointSetPlane2DAngleParam;
    проц function(dJointID, дВектор3) dJointGetBallAnchor;
    проц function(dJointID, дВектор3) dJointGetBallAnchor2;
    дРеал function(dJointID, цел) dJointGetBallParam;
    проц function(dJointID, дВектор3) dJointGetHingeAnchor;
    проц function(dJointID, дВектор3) dJointGetHingeAnchor2;
    проц function(dJointID, дВектор3) dJointGetHingeAxis;
    дРеал function(dJointID, цел) dJointGetHingeParam;
    дРеал function(dJointID) dJointGetHingeAngle;
    дРеал function(dJointID) dJointGetHingeAngleRate;
    дРеал function(dJointID) dJointGetSliderPosition;
    дРеал function(dJointID) dJointGetSliderPositionRate;
    проц function(dJointID, дВектор3) dJointGetSliderAxis;
    дРеал function(dJointID, цел) dJointGetSliderParam;
    проц function(dJointID, дВектор3) dJointGetHinge2Anchor;
    проц function(dJointID, дВектор3) dJointGetHinge2Anchor2;
    проц function(dJointID, дВектор3) dJointGetHinge2Axis1;
    проц function(dJointID, дВектор3) dJointGetHinge2Axis2;
    дРеал function(dJointID, цел) dJointGetHinge2Param;
    дРеал function(dJointID) dJointGetHinge2Angle1;
    дРеал function(dJointID) dJointGetHinge2Angle1Rate;
    дРеал function(dJointID) dJointGetHinge2Angle2Rate;
    проц function(dJointID, дВектор3) dJointGetUniversalAnchor;
    проц function(dJointID, дВектор3) dJointGetUniversalAnchor2;
    проц function(dJointID, дВектор3) dJointGetUniversalAxis1;
    проц function(dJointID, дВектор3) dJointGetUniversalAxis2;
    дРеал function(dJointID, цел) dJointGetUniversalParam;
    проц function(dJointID, дРеал*, дРеал*) dJointGetUniversalAngles;
    дРеал function(dJointID) dJointGetUniversalAngle1;
    дРеал function(dJointID) dJointGetUniversalAngle2;
    дРеал function(dJointID) dJointGetUniversalAngle1Rate;
    дРеал function(dJointID) dJointGetUniversalAngle2Rate;
    проц function(dJointID, дВектор3) dJointGetPRAnchor;
    дРеал function(dJointID) dJointGetPRPosition;
    дРеал function(dJointID) dJointGetPRPositionRate;
    дРеал function(dJointID) dJointGetPRAngle;
    дРеал function(dJointID) dJointGetPRAngleRate;
    проц function(dJointID, дВектор3) dJointGetPRAxis1;
    проц function(dJointID, дВектор3) dJointGetPRAxis2;
    дРеал function(dJointID, цел) dJointGetPRParam;
    проц function(dJointID, дВектор3) dJointGetPUAnchor;
    дРеал function(dJointID) dJointGetPUPosition;
    дРеал function(dJointID) dJointGetPUPositionRate;
    проц function(dJointID, дВектор3) dJointGetPUAxis1;
    проц function(dJointID, дВектор3) dJointGetPUAxis2;
    проц function(dJointID, дВектор3) dJointGetPUAxis3;
    проц function(dJointID, дВектор3) dJointGetPUAxisP;
    проц function(dJointID, дРеал*, дРеал*) dJointGetPUAngles;
    дРеал function(dJointID) dJointGetPUAngle1;
    дРеал function(dJointID) dJointGetPUAngle1Rate;
    дРеал function(dJointID) dJointGetPUAngle2;
    дРеал function(dJointID) dJointGetPUAngle2Rate;
    дРеал function(dJointID, цел) dJointGetPUParam;
    дРеал function(dJointID) dJointGetPistonPosition;
    дРеал function(dJointID) dJointGetPistonPositionRate;
    дРеал function(dJointID) dJointGetPistonAngle;
    дРеал function(dJointID) dJointGetPistonAngleRate;
    проц function(dJointID, дВектор3) dJointGetPistonAnchor;
    проц function(dJointID, дВектор3) dJointGetPistonAnchor2;
    проц function(dJointID, дВектор3) dJointGetPistonAxis;
    дРеал function(dJointID, цел) dJointGetPistonParam;
    цел function(dJointID) dJointGetAMotorNumAxes;
    проц function(dJointID, цел, дВектор3) dJointGetAMotorAxis;
    цел function(dJointID, цел) dJointGetAMotorAxisRel;
    дРеал function(dJointID, цел) dJointGetAMotorAngle;
    дРеал function(dJointID, цел) dJointGetAMotorAngleRate;
    дРеал function(dJointID, цел) dJointGetAMotorParam;
    цел function(dJointID) dJointGetAMotorMode;
    цел function(dJointID) dJointGetLMotorNumAxes;
    проц function(dJointID, цел, дВектор3) dJointGetLMotorAxis;
    дРеал function(dJointID, цел) dJointGetLMotorParam;
    дРеал function(dJointID, цел) dJointGetFixedParam;
    dJointID function(dBodyID, dBodyID) dConnectingJoint;
    цел function(dBodyID, dBodyID, dJointID*) dConnectingJointList;
    цел function(dBodyID, dBodyID) dAreConnected;
    цел function(dBodyID, dBodyID, цел) dAreConnectedExcluding;

    // odeinit.h
    проц function() dInitODE;
    цел function(бцел) dInitODE2;
    цел function(бцел) dAllocateODEDataForThread;
    проц function() dCleanupODEAllDataForThread;
    проц function() dCloseODE;

    // rotation.h
    проц function(дМатрица3) dRSetIdentity;
    проц function(дМатрица3, дРеал, дРеал, дРеал, дРеал) dRFromAxisAndAngle;
    проц function(дМатрица3, дРеал, дРеал, дРеал) dRFromEulerAngles;
    проц function(дМатрица3, дРеал, дРеал, дРеал, дРеал, дРеал, дРеал) dRFrom2Axes;
    проц function(дМатрица3, дРеал, дРеал, дРеал) dRFromZAxis;
    проц function(дКватернион) dQSetIdentity;
    проц function(дКватернион, дРеал, дРеал, дРеал, дРеал) dQFromAxisAndAngle;
    проц function(дКватернион, in дКватернион, in дКватернион) dQMultiply0;
    проц function(дКватернион, in дКватернион, in дКватернион) dQMultiply1;
    проц function(дКватернион, in дКватернион, in дКватернион) dQMultiply2;
    проц function(дКватернион, in дКватернион, in дКватернион) dQMultiply3;
    проц function(дМатрица3, in дКватернион) dRfromQ;
    проц function(дКватернион, in дМатрица3) dQfromR;
    проц function(дРеал[4], in дВектор3, in дКватернион) dDQfromW;

    // timer.h
    проц function(dStopwatch*) dStopwatchReset;
    проц function(dStopwatch*) dStopwatchStart;
    проц function(dStopwatch*) dStopwatchStop;
    дво function(dStopwatch*) dStopwatchTime;
    проц function(in ткст0) dTimerStart;
    проц function(in ткст0) dTimerNow;
    проц function() dTimerEnd;
    проц function(фук, цел) dTimerReport;
    дво function() dTimerTicksPerSecond;
    дво function() dTimerResolution;
}