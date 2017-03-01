const unsigned char optab1[OPMAX] =
	{
	0x0,0x2d,0x21,0xcd,0x81,0x1,0x21,0x21,
	0x4d,0x2d,0x2d,0x21,0x2,0x2,0x2,0x1,
	0x1,0x1,0x1,0x1,0x2,0x2,0x2,0x2,
	0x12,0x2,0x2,0x2,0x2,0x2,0x2,0x1,
	0x1,0x1,0x11,0x2,0x11,0x11,0x1,0x11,
	0x1,0x11,0x2,0x1,0x2,0x2,0x1,0x11,
	0x11,0x11,0x2,0x21,0x21,0x1,0x2,0x11,
	0x12,0x31,0x31,0x11,0x31,0x31,0xd1,0x91,
	0x11,0x31,0x31,0x51,0x31,0x31,0x31,0x5,
	0x5,0x5,0x5,0x5,0x5,0x5,0x5,0x5,
	0x5,0x5,0x5,0x5,0x5,0x5,0x5,0x5,
	0x5,0x5,0x5,0x5,0x5,0x5,0x5,0x5,
	0x5,0x2,0x2,0x2,0x2,0x2,0x2,0x2,
	0x2,0x2,0x2,0x2,0x2,0x2,0x2,0x2,
	0x2,0x2,0x2,0x2,0x2,0x2,0x2,0x2,
	0x2,0x2,0x2,0x2,0x2,0x2,0x2,0x2,
	0x2,0x2,0x1,0x11,0x12,0x1,0x2,0x0,
	0x2,0x0,0x2,0x0,0x0,0x0,0x0,0x1,
	0x1,0x0,0x0,0x10,0x1,0x10,0x12,0x12,
	0x10,0x10,0x12,0x1,0x1,0x0,0x0,0x2,
	0x11,0x12,0x11,0x0,0x0,0x0,0x0,0x1,
	0x2,0x1,0x2,0x2,0x12	};
const unsigned char optab2[OPMAX] =
	{
	0x0,0x42,0x42,0x42,0x40,0x40,0x40,0x42,
	0x42,0x42,0x42,0x40,0x41,0x41,0x42,0x0,
	0x0,0x1,0x1,0x0,0x40,0x40,0x42,0x0,
	0x0,0x40,0x40,0x40,0x40,0x40,0x40,0x40,
	0x0,0x0,0x38,0x40,0x28,0x20,0x40,0x28,
	0x40,0x28,0x0,0x40,0x40,0x40,0x41,0x20,
	0x20,0x20,0x40,0x40,0x40,0x41,0x40,0x38,
	0x32,0x38,0x38,0x38,0x3a,0x3a,0x3a,0x38,
	0x38,0x3a,0x3a,0x3a,0x3a,0x3a,0x3a,0x41,
	0x41,0x41,0x41,0x41,0x41,0x41,0x41,0x41,
	0x41,0x41,0x41,0x41,0x41,0x41,0x41,0x41,
	0x41,0x41,0x41,0x41,0x41,0x41,0x41,0x41,
	0x41,0x40,0x40,0x40,0x40,0x40,0x40,0x40,
	0x40,0x40,0x40,0x40,0x40,0x40,0x40,0x40,
	0x40,0x40,0x40,0x40,0x40,0x40,0x40,0x40,
	0x40,0x40,0x40,0x40,0x40,0x40,0x40,0x40,
	0x40,0x40,0x0,0x2c,0x24,0x4c,0x44,0x40,
	0x0,0x0,0x0,0x40,0x40,0x40,0x0,0x0,
	0x0,0x0,0x40,0x20,0x8,0x0,0x0,0x0,
	0x0,0x0,0x0,0x40,0x40,0x0,0x40,0x0,
	0x38,0x0,0x0,0x0,0x0,0x0,0x0,0x0,
	0x0,0x0,0x0,0x0,0x0	};
const unsigned char optab3[OPMAX] =
	{
	0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,
	0x0,0x0,0x0,0x0,0x0,0x1,0x0,0x0,
	0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x1,
	0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,
	0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,
	0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,
	0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,
	0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,
	0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,
	0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,
	0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,
	0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,
	0x0,0x1,0x0,0x0,0x0,0x1,0x0,0x1,
	0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x1,
	0x1,0x1,0x0,0x1,0x1,0x0,0x1,0x1,
	0x0,0x1,0x1,0x0,0x1,0x1,0x0,0x0,
	0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,
	0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,
	0x0,0x0,0x1,0x0,0x0,0x0,0x0,0x0,
	0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,
	0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,
	0x0,0x0,0x0,0x0,0x0	};
const unsigned char opcost[OPMAX] =
	{
	0x0,0x7,0x7,0xa,0xb,0xb,0x9,0x9,
	0x7,0x7,0x7,0x9,0x5,0x5,0x2,0x7,
	0x7,0xa,0xa,0x7,0x2,0x2,0x2,0x2,
	0x2,0x2,0x2,0x2,0x2,0x2,0x2,0x7,
	0x7,0x7,0x7,0x2,0x7,0x7,0x7,0x7,
	0x7,0x7,0x2,0x7,0x2,0x2,0xa,0x7,
	0x7,0x7,0x2,0x9,0x9,0xa,0x2,0x7,
	0x2,0x7,0x7,0x7,0x7,0x7,0x7,0x7,
	0x7,0x7,0x7,0x7,0x7,0x7,0x7,0xa,
	0xa,0xa,0xa,0xa,0xa,0xa,0xa,0xa,
	0xa,0xa,0xa,0xa,0xa,0xa,0xa,0xa,
	0xa,0xa,0xa,0xa,0xa,0xa,0xa,0xa,
	0xa,0x2,0x2,0x2,0x2,0x2,0x2,0x2,
	0x2,0x2,0x2,0x2,0x2,0x2,0x2,0x2,
	0x2,0x2,0x2,0x2,0x2,0x2,0x2,0x2,
	0x2,0x2,0x2,0x2,0x2,0x2,0x2,0x2,
	0x2,0x2,0x7,0x11,0xc,0x11,0xc,0x0,
	0x2,0x0,0x2,0x0,0x0,0x1,0x0,0x7,
	0x7,0x0,0x0,0x0,0x7,0x0,0x2,0x2,
	0x0,0x0,0x2,0x7,0x7,0x0,0x0,0x2,
	0x7,0x2,0x7,0x0,0x0,0x0,0x0,0x7,
	0x2,0x7,0x2,0x2,0x2	};
unsigned char rel_not[] =
{ 0x58,0x55,0x57,0x56,0x4c,0x4b,0x59,0x5a,
  0x5b,0x5c,0x5d,0x5e,0x5f,0x60,0x48,0x4a,
  0x49,0x47,0x4d,0x4e,0x4f,0x50,0x51,0x52,
  0x53,0x54,
};
unsigned char rel_swap[] =
{ 0x4a,0x49,0x48,0x47,0x4b,0x4c,0x4d,0x4e,
  0x4f,0x52,0x53,0x50,0x51,0x54,0x57,0x58,
  0x55,0x56,0x59,0x5a,0x5b,0x5e,0x5f,0x5c,
  0x5d,0x60,
};
unsigned char rel_integral[] =
{ 0x47,0x48,0x49,0x4a,0x4b,0x4c,0x00,0x4c,
  0x01,0x47,0x49,0x4a,0x48,0x4b,0x47,0x49,
  0x4a,0x48,0x01,0x4b,0x00,0x48,0x4a,0x49,
  0x47,0x4c,
};
unsigned char rel_exception[] =
{ 0x01,0x01,0x01,0x01,0x00,0x00,0x00,0x01,
  0x01,0x00,0x00,0x00,0x00,0x00,0x01,0x01,
  0x01,0x01,0x00,0x01,0x01,0x00,0x00,0x00,
  0x00,0x00,
};
unsigned char rel_unord[] =
{ 0x00,0x00,0x00,0x00,0x00,0x01,0x01,0x00,
  0x00,0x01,0x01,0x01,0x01,0x01,0x01,0x01,
  0x01,0x01,0x00,0x01,0x01,0x00,0x00,0x00,
  0x00,0x00,
};
