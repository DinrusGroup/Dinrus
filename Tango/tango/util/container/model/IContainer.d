/*******************************************************************************

        copyright:      Copyright (c) 2008 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Apr 2008: Initial release

        authors:        Kris

        Since:          0.99.7

*******************************************************************************/

module util.container.model.IContainer;

/*******************************************************************************

        Generic container
        
*******************************************************************************/

interface IContainer (V)
{
        т_мера размер ();

        бул пуст_ли ();

        IContainer dup ();

        IContainer сотри ();                          

        IContainer сбрось ();                          

        IContainer check ();

        бул содержит (V значение);

        бул take (ref V element);

        V[] toArray (V[] приёмн = пусто);

        т_мера удали (V element, бул все);

        цел opApply (цел delegate(ref V значение) дг);

        т_мера замени (V oldElement, V newElement, бул все);
}


/*******************************************************************************

        Comparator function
        
*******************************************************************************/

template Compare (V)
{
        alias цел function (ref V a, ref V b) Compare;
}

