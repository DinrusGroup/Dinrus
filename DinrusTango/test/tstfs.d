

import io.Stdout, io.Path, io.stream.TextFile;

/+
        проц ткстВВ()
        {
                auto t = new ТекстФайлВвод ("tstio.d");
                foreach (строка; t)
                         Квывод(строка).нс;                  
        }
		+/
		
        проц main()
        { 
		//ткстВВ();
		
				assert (нормализуй ("\\foo\\..\\john") == "/john");
                assert (нормализуй ("foo\\..\\john") == "john");
                assert (нормализуй ("foo\\bar\\..") == "foo/");
                assert (нормализуй ("foo\\bar\\..\\john") == "foo/john");
                assert (нормализуй ("foo\\bar\\doe\\..\\..\\john") == "foo/john");
                assert (нормализуй ("foo\\bar\\doe\\..\\..\\john\\..\\bar") == "foo/bar");
                assert (нормализуй (".\\foo\\bar\\doe") == "foo/bar/doe");
                assert (нормализуй (".\\foo\\bar\\doe\\..\\..\\john\\..\\bar") == "foo/bar");
                assert (нормализуй (".\\foo\\bar\\..\\..\\john\\..\\bar") == "bar");
                assert (нормализуй ("foo\\bar\\.\\doe\\..\\..\\john") == "foo/john");
                assert (нормализуй ("..\\..\\foo\\bar") == "../../foo/bar");
                assert (нормализуй ("..\\..\\..\\foo\\bar") == "../../../foo/bar");
                assert (нормализуй(r"C:") == "C:");
                assert (нормализуй(r"C") == "C");
                assert (нормализуй(r"c:\") == "C:/");
                assert (нормализуй(r"C:\..\.\..\..\") == "C:/");
                assert (нормализуй(r"c:..\.\boo\") == "C:../boo/");
                assert (нормализуй(r"C:..\..\boo\foo\..\.\..\..\bar") == "C:../../../bar");
                assert (нормализуй(r"C:boo\..") == "C:");
				
				
                foreach (файл; коллируй (".", "*.d", да))
                         Стдвыв (файл).нс;      
        }