/*******************************************************************************

        copyright:      Copyright (c) 2005 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Initial release: March 2005      
        
        author:         Kris

*******************************************************************************/

module io.model.IFile;

/*******************************************************************************

        Generic файл-oriented атрибуты

*******************************************************************************/

interface ФайлКонст
{
        /***********************************************************************
        
                A установи of файл-system specific constants for файл and путь
                разделители (chars and strings).

                Keep these constants mirrored for each OS

        ***********************************************************************/

        version (Win32)
        {
                ///
                enum : сим 
                {
                        /// The current дир character
                        CurrentDirChar = '.',
                        
                        /// The файл разделитель character
                        СимФайлРазд = '.',
                        
                        /// The путь разделитель character
                        СимПутьРазд = '/',
                        
                        /// The system путь character
                        SystemPathChar = ';',
                }

                /// The предок дир ткст
                static const ткст ParentDirString = "..";
                
                /// The current дир ткст
                static const ткст CurrentDirString = ".";
                
                /// The файл разделитель ткст
                static const ткст FileSeparatorString = ".";
                
                /// The путь разделитель ткст
                static const ткст СимПутьРазд = "/";
                
                /// The system путь ткст
                static const ткст СимСистПуть = ";";

                /// The нс ткст
                static const ткст НовСтрЗнак = "\r\n";
        }

        version (Posix)
        {
                ///
                enum : сим 
                {
                        /// The current дир character
                        CurrentDirChar = '.',
                        
                        /// The файл разделитель character
                        СимФайлРазд = '.',
                        
                        /// The путь разделитель character
                        СимПутьРазд = '/',
                        
                        /// The system путь character
                        SystemPathChar = ':',
                }

                /// The предок дир ткст
                static const ткст ParentDirString = "..";
                
                /// The current дир ткст
                static const ткст CurrentDirString = ".";
                
                /// The файл разделитель ткст
                static const ткст FileSeparatorString = ".";
                
                /// The путь разделитель ткст
                static const ткст СимПутьРазд = "/";
                
                /// The system путь ткст
                static const ткст СимСистПуть = ":";

                /// The нс ткст
                static const ткст НовСтрЗнак = "\n";
        }
}

/*******************************************************************************

        Passed around during файл-scanning

*******************************************************************************/

struct ИнфОФайле
{
        ткст          путь,
                        имя;
        бдол           байты;
        бул            папка,
                        скрытый,
                        system;
}

