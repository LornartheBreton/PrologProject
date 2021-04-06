%[[1,4,5,8],[7,4,1,9],[2,5,5,6],[9,8,3,8]]
% La idea del programa se basa en iterar sobre la lista de listas de enteros
% que representa el tablero y convertirlo a una serie de Facts escritos en
% un archivo llamado "formated.pl" que representen el numero y la coordenada
% de la casilla de esta manera:
%   pos(A,X,Y)
% Donde A es el entero ubicado en esa coordenada, y X y Y son las coordenadas
% X y Y en donde se ubica el entero en el tablero, respectivamente.

% Por ejemplo, el siguiente tablero 2x2:
%   1 5
%   7 9
% Lo procesa el programa como una lista de listas de enteros asi:
%   [[1,5],[7,9]]
% Y lo convierte a esta representacion se representa asi:
%   pos(1,0,0).
%   pos(5,1,0).
%   pos(7,0,1).
%   pos(9,1,1).

%PREDICADOS

% Creacion de los Facts a partir de una lista de enteros

% single_list(Lista de enteros, coordenada X, coordenada Y, siguiente
% coordenada, String que va acumulando los predicados, el String que se
% escribira al archivo)
single_list([],_,_,_,A,B):-
                       B = A.
single_list([H|T],X,Y,X2,String,UltimateString):- 
                       atom_concat(String,'pos(',A),
                       atom_concat(A,H,B),
                       atom_concat(B,',',C),
                       atom_concat(C,X,D),
                       atom_concat(D,',',E),
                       atom_concat(E,Y,F),
                       atom_concat(F,').\n',OtroString),
                       X2 is X+1,
                       single_list(T,X2,Y,_,OtroString,UltimateString).

% Iteracion sobre la lista de listas de enteros

%multiple_list(Lista de listas de enteros, Tamanio del tablero NxN, String 
% acumulativo, String que se va a escribir al archivo)
multiple_list([],_,S,Sinthesis):-
    Sinthesis = S.
multiple_list([H|T],N,S,Sinthesis):-
    single_list(H,0,N,_,S,S2),
    N2 is N+1,
    S3 = S2,
    multiple_list(T,N2,S3,Sinthesis).

% Escribir la lsita de listas de enteros como la representacion ya definida a
% un archivo llamado "formated.pl" para, acto seguido, borrarlo.

%write_to_file(Lista de listas de enteros)
write_to_file(L):- 
    multiple_list(L,0,'',String),
    open('formated.pl',write,Stream),
    write(Stream,String),
    close(Stream),
    consult(formated).
    delete_file('formated.pl').

% ESTA FUNCION NO HACE NADA
saltosEnPosicion(Tablero,X,Y,ListaMov,ListaNums):-
    write_to_file(Tablero),
    punto=coord(X,Y),
    length(Tablero,N).

% Verificar si el elemento A de la lista de enteros es vecino del elemento B,
% para luego indicar en cual direccion cardinal, relativo a A, se encuentra el
% vecino.

% vecinoCheck(Primer Entero, Supuesto entero vecino, Direccion Cardinal hacia
% donde es vecino, coordenada X de A, coordenada Y de A)
 vecinoCheck(A,B,Cardinal,X,Y,X2,Y2):-
    pos(A,X,Y),
    X2 is X,
    Y2 is Y-1,
    pos(B,X,Y2),
    Cardinal = 'norte'.
 
vecinoCheck(A,B,Cardinal,X,Y,X2,Y2):-
    pos(A,X,Y),
    X2 is X,
    Y2 is Y+1,
    pos(B,X,Y2),
    Cardinal = 'sur'.

vecinoCheck(A,B,Cardinal,X,Y,X2,Y2):-
    pos(A,X,Y),
    X2 is X+1,
    Y2 is Y,
    pos(B,X2,Y),
    Cardinal = 'este'.
    
vecinoCheck(A,B,Cardinal,X,Y,X2,Y2):-
    pos(A,X,Y),
    X2 is X-1,
    Y2 is Y,
    pos(B,X2,Y),
    Cardinal = 'oeste'.

% Itera sobre cada elemento de una lista de enteros para verificar que si sean
% vecinos consecutivos cada elementos. Ademas, indica la lista de movimientos
% que se necesitan ejecutar para que la lista sea valida y la coordenada del
% primer elemento de la secuencia.

% procesarSecuencia(Lista de enteros, lista acumulativa de direcciones cardi-
% nales, lista de salida de direcciones cardinales, coordenada X del primer 
% elemento de la lista de enteros, coordenada Y del primer elemento)
procesarSecuencia(L,Viejo,Direcciones,X,Y):-
    length(L,N),
    N =< 1,
    Direcciones = Viejo.

procesarSecuencia([H,B|T],Viejo,Direcciones,X,Y):-
    vecinoCheck(H,B,Cardinal,X,Y,X2,Y2),
    append(Viejo, Cardinal, Nuevo),
    procesarSecuencia([B|T],Nuevo,Direcciones,X2,Y2).

% El "driver code"; toma un tablero representado por una lista de listas de 
% enteros, una lista de enteros propuesta, y la estructura solucion como
% lo indican las instrucciones.

resolver(Tablero,Secuencia,Solucion):-
    %tableroValido(Tablero),
    write_to_file(Tablero),
    procesarSecuencia(Secuencia,[],Direcciones,X,Y),
    Solucion = solucion(Secuencia,X,Y,Direcciones).
