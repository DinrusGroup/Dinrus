﻿module mesh.Status;

/** Статус биты использован by the Статус class.
 *  See_Also: auxd.OpenMesh.Атрибуты.ИнфОСтатусе
 */
enum Атрибуты : бцел
{

    УДАЛЁН  = 1,   ///< Item имеется been удалён_ли
    БЛОКИРОВАН   = 2,   ///< Item is блокирован_ли.
    ВЫДЕЛЕН = 4,   ///< Item is выделен_ли.
    СКРЫТ   = 8,   ///< Item is скрыт_ли.
    ФИЧА  = 16,  ///< Item is a фича_ли or belongs to a фича_ли.
    ТЭГИРОВАН   = 32,  ///< Item is тэгирован_ли.
    ТЭГИРОВАН2  = 64,  ///< Alternate bit for tagging an item.
    НЕИСПОЛЬЗОВАН   = 128  ///<
}

alias Атрибуты БитыСтатуса ;

/** \class ИнфОСтатусе Статус.hh <OpenMesh/Атрибуты/Статус.hh>
 *
 *   Add status information to a base class.
 *
 *   See_Also: БитыСтатуса
 */
struct ИнфОСтатусе
{
public:

    alias бцел т_значение;

    static ИнфОСтатусе opCall()
    {
        ИнфОСтатусе M;
        with(M)
        {
        } return M;
    }

    /// is удалён_ли ?
    бул удалён_ли() /*const*/
    {
        return установлен_ли_бит(БитыСтатуса.УДАЛЁН);
    }
    /// установи удалён_ли
    проц поставь_удалён(бул _b)
    {
        измени_бит(БитыСтатуса.УДАЛЁН, _b);
    }


    /// is блокирован_ли ?
    бул блокирован_ли() /*const*/
    {
        return установлен_ли_бит(БитыСтатуса.БЛОКИРОВАН);
    }
    /// установи блокирован_ли
    проц поставь_блокирован(бул _b)
    {
        измени_бит(БитыСтатуса.БЛОКИРОВАН, _b);
    }


    /// is выделен_ли ?
    бул выделен_ли() /*const*/
    {
        return установлен_ли_бит(БитыСтатуса.ВЫДЕЛЕН);
    }
    /// установи выделен_ли
    проц поставь_выделен(бул _b)
    {
        измени_бит(БитыСтатуса.ВЫДЕЛЕН, _b);
    }


    /// is скрыт_ли ?
    бул скрыт_ли() /*const*/
    {
        return установлен_ли_бит(БитыСтатуса.СКРЫТ);
    }
    /// установи скрыт_ли
    проц поставь_скрыт(бул _b)
    {
        измени_бит(БитыСтатуса.СКРЫТ, _b);
    }


    /// is фича_ли ?
    бул фича_ли() /*const*/
    {
        return установлен_ли_бит(БитыСтатуса.ФИЧА);
    }
    /// установи фича_ли
    проц поставь_фича(бул _b)
    {
        измени_бит(БитыСтатуса.ФИЧА, _b);
    }


    /// is тэгирован_ли ?
    бул тэгирован_ли() /*const*/
    {
        return установлен_ли_бит(БитыСтатуса.ТЭГИРОВАН);
    }
    /// установи тэгирован_ли
    проц поставь_тэгирован(бул _b)
    {
        измени_бит(БитыСтатуса.ТЭГИРОВАН, _b);
    }


    /// is тэгирован2_ли ? This is just one more tag info.
    бул тэгирован2_ли() /*const*/
    {
        return установлен_ли_бит(БитыСтатуса.ТЭГИРОВАН2);
    }
    /// установи тэгирован_ли
    проц поставь_тэгирован2(бул _b)
    {
        измени_бит(БитыСтатуса.ТЭГИРОВАН2, _b);
    }


    /// return whole status
    бцел биты() /*const*/
    {
        return статус_;
    }
    /// установи whole status at once
    проц установи_биты(бцел _bits)
    {
        статус_ = _bits;
    }


    /// is a certain bit установи ?
    бул установлен_ли_бит(бцел _s) /*const*/
    {
        return (статус_ & _s) > 0;
    }
    /// установи a certain bit
    проц установи_бит(бцел _s)
    {
        статус_ |= _s;
    }
    /// unset a certain bit
    проц отмени_бит(бцел _s)
    {
        статус_ &= ~_s;
    }
    /// установи or unset a certain bit
    проц измени_бит(бцел _s, бул _b)
    {
        if (_b) статус_ |= _s;
        else статус_ &= ~_s;
    }


private:

    т_значение статус_  = 0;
}


unittest
{
    ИнфОСтатусе x;
    x.установи_бит(БитыСтатуса.УДАЛЁН);
    assert(x.установлен_ли_бит(БитыСтатуса.УДАЛЁН));
    assert(x.удалён_ли());
}
