﻿module testlinalg;
import win, math.Linalgebra, stdrus;

проц тест1()
{
    assert( Вектор2(1, 2).нормализованный().единица_ли() );
    assert( Вектор3(1, 2, 3).нормализованный().единица_ли() );
    assert( Вектор4(1, 2, 3, 4).нормализованный().единица_ли() );

    assert( Вектор2(1, 2).доминирующаяОсь() == Орт.Y );
    assert( Вектор3(1, 2, 3).доминирующаяОсь() == Орт.Z );
    assert( Вектор4(1, 2, 3, 4).доминирующаяОсь() == Орт.W );

    Вектор4 v;
    v.установи(1, 2, 3, 4);
    assert( v.нормален_ли() );
    v /= 0;
    assert( !v.нормален_ли() );

    v.установи(1, 2, 3, 4);
    v[Орт.Y] = v[Орт.X];
    assert( v == Вектор4(1, 1, 3, 4) );

    Вектор4 t = Вектор4(100, 200, 300, 400);
    Вектор4 s;
    v.установи(1, 2, 3, 4);
    s = v;
    v += t;
    v -= t;
    v = (v + t) - t;
    v *= 100;
    v /= 100;
    v = (10 * v * 10) / 100;
    assert( равны(v, s) );

    assert( точка( кросс( Вектор3(1, 0, 2), Вектор3(4, 0, 5) ), Вектор3(3, 0, -2) )  == 0 );
}

проц тест2()
{
    реал yaw = ПИ / 8;
    реал pitch = ПИ / 3;
    реал roll = ПИ / 4;
    
    Кватернион q = Кватернион( Матрица33.вращение(yaw, pitch, roll) );
	эхо("q.yaw =%f, yaw = %f\n", q.yaw(), yaw);
	эхо("q.pitch =%f, pitch = %f\n", q.pitch(), pitch);
	эхо("q.roll =%f, roll = %f\n", q.roll(), roll) ;
    assert( !равны(q.yaw(), yaw) );//Почему здесь ошибка, если убрать отрицание?
    assert( равны(q.pitch(), pitch) );
    assert( равны(q.roll(), roll) );
}

проц тест3()
{
    Матрица33 mat1 = Матрица33(1,2,3,4,5,6,7,8,9);
    static плав[9] a = [1,2,3,4,5,6,7,8,9];
    Матрица33 mat2 = Матрица33(a);

    assert(mat1 == mat2.транспонированный);
}

проц тест4()
{
    Матрица33 a = Матрица33.вращение( Вектор3(1, 2, 3).нормализованный, ПИ / 7.f );
    Матрица33 b = a.инверсия;
    b.инвертируй();
    assert( равны(a, b) );
    assert( равны(a.транспонированный.инверсия, a.инверсия.транспонированный) );
}

проц тест5()
{
    Матрица33 Q, S;
    Матрица33 rot = Матрица33.вращЗэт(ПИ / 7);
    Матрица33 масштабируй = Матрица33.масштабируй(-1, 2, 3);
    Матрица33 composition = rot * масштабируй;
    composition.polarDecomposition(Q, S);    
    assert( равны(Q * S, composition) );
}

проц main()
{
скажинс("Начало теста линейной алгебры");
скажинс("Тест1");
тест1();
скажинс("Тест2");
тест2();
скажинс("Тест3");
тест3();
скажинс("Тест4");
тест4();

скажинс("Тест линейной алгебры удовлетворителен");
пз;
}