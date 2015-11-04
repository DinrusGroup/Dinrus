extern (C) void testMeBetter();

pragma(lib,"testdll.lib");
void main()
{
testMeBetter();
}