#include "backend/cc.h"
const char datafl[FLMAX] =
	{ 0,0,0,0,1,1,1,1,1,1,1,0,0,1,1,0,1,0,1,0,0,1,1,1,0,0,1,1,0,0,0,1,1,0 };
const char stackfl[FLMAX] =
	{ 0,0,0,0,0,0,0,1,1,0,1,0,0,0,1,0,1,0,0,0,0,1,1,0,0,0,0,1,0,0,0,1,1,0 };
const char segfl[FLMAX] =
	{ -1,-1,-1,1,3,-1,-1,2,2,3,2,1,1,3,2,-1,2,-1,3,-1,-1,2,2,-1,-1,1,-1,2,-1,-1,1,2,2,-1 };
const char flinsymtab[FLMAX] =
	{ 0,0,0,1,1,1,1,1,1,1,1,0,0,1,0,0,0,0,0,0,0,0,0,1,0,1,1,1,0,0,0,0,1,0 };
