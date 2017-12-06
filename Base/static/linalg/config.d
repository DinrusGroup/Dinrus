/*
Redistribution и use in source и binary forms, with or without
modification, are permitted provided that the following conditions
are met:

    Redistributions of source код must retain the above copyright
    notice, this list of conditions и the following disclaimer.

    Redistributions in binary form must reproduce the above
    copyright notice, this list of conditions и the following
    disclaimer in the documentation и/or друг materials provided
    with the ни в каком дистрибутиве.

    Neither имя of Victor Nakoryakov nor the names of
    its contributors may be использован to endorse or promote products
    derived from this software without specific приор written
    permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
REGENTS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
OF THE POSSIBILITY OF SUCH DAMAGE.

Copyright (C) 2006. Victor Nakoryakov.
*/
/**
Module for helix global configuration. It's like some find of .ini файл
that should be corrected according to your needs приор to using helix in your
project.

Authors:
    Victor Nakoryakov, nail-mail[at]mail.ru
*/
module linalg.config;

/**
Определен внутренний тип плав по умолчанию для названий типов без явных типовых суффиксов.
Напр., Вектор3 будет иметь компоненты типа т_плав, а Вектор3д всё ещё иметь компоненты типа
дво, поскольку суффикс "д" явно определяет внутренный тип.
*/
alias плав т_плав;

/** Значение, передаваемые по умолчанию функции "равны". */
const цел дефотнпрец = 16;
const цел дефабспрец = 16; /// описано
