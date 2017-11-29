
	/*******************************************************************************
	*  Файл генерирован автоматически с помощью либпроцессора Динрус               *
	*  Дата:28.1.2015                                           Время: 19 ч. 25 мин.

	*******************************************************************************/


	module lib.iconv;

	import stdrus;
	
	alias ук iconv_t;

	проц грузи(Биб биб)
	{

	
		//вяжи(функция_1)("_libiconv_version", биб);

		вяжи(iconv)("libiconv", биб);

		вяжи(iconv_close)("libiconv_close", биб);

		вяжи(iconv_open)("libiconv_open", биб);

		//вяжи(функция_5)("_libiconv_set_relocation_prefix", биб);

		//вяжи(функция_6)("_libiconvctl", биб);

		//вяжи(функция_7)("_libiconvlist", биб);

		//вяжи(функция_8)("_locale_charset", биб);

	}

ЖанБибгр ICONV;

		static this()
		{
			ICONV.заряжай("iconv.dll", &грузи );
		}

	extern(C)
	{


		//проц function(   ) функция_1; 

	/********
	Преобразует, используя дескриптор ‘cd’, максимум ‘*inbytesleft’ байтов,
	начиная с ‘*inbuf’, записывая максимум ‘*outbytesleft’ байтов, начиная с
	‘*outbuf’.
	Уменьшает ‘*inbytesleft’ и увеличивает ‘*inbuf’ на равное количество.
	Уменьшает ‘*outbytesleft’ и увеличивает ‘*outbuf’ на равное количество.
	********/
		size_t function(iconv_t cd,  char** inbuf, size_t *inbytesleft, char** outbuf, size_t *outbytesleft ) iconv;
		
/*************
Освобождает ресурсы, размещённые в памяти для преобразования дескриптора ‘cd’
*************/		
		int function(iconv_t cd ) iconv_close; 

	/****
	Размещает дескриптор для кодового преобразования из кодировки ‘fromcode’ в
   кодировку ‘tocode’. 
   *****/

		iconv_t function(char* tocode, char* fromcode) iconv_open; 

		//проц function(   ) функция_5; 

		//проц function(   ) функция_6; 

		//проц function(   ) функция_7; 

		//проц function(   ) функция_8; 

	}

