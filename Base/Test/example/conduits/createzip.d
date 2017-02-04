module createzip;

import io.compress.Zip;
import io.vfs.FileFolder;

/******************************************************************************

  Simple example where the current folder is recursively scanned for .d files 
  before they are zipped into tmp.zip.

  Written and put into the public domain by Piotr Modzelevski.

******************************************************************************/

void main()
{
        char[][] files;
        auto root = new FileFolder (".");
        foreach (file; root.tree.catalog ("*.d"))
                 files ~= file.toString;

        createArchive("tmp.zip", Method.Deflate, files);
}
