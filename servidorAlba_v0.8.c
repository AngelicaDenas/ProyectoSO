#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <my_global.h> //para entorno de produccion (shiva2.upc.edu) 

int main(int argc, char **argv)
{
	MYSQL *conn;
	int err;
	//estructura especial para almacenar resultados de consultas 
	MYSQL_RES *resultado;
	MYSQL_ROW row;
	
	//crear una conexion al servidor MYSQL 
	conn = mysql_init(NULL);
	if (conn==NULL) {
		printf ("Error al crear la conexi￳on: %u %s\n", 
				mysql_errno(conn), mysql_error(conn));
		exit (1);
	}

	//inicializar la conexion
	conn = mysql_real_connect (conn, "localhost", "root", "mysql", "BD",0, NULL, 0);
	if (conn==NULL) {
		printf ("Error al inicializar la conexion: %u %s\n", 
				mysql_errno(conn), mysql_error(conn));
		exit (1);
	}

	//preguntar usuario del jugador
	//faltaria bucle con do-while y funcion usuarioExiste
	//para asegurar que nos introducen un usuario valido
	//sino retornara 0 partidas ganadas aunque el usuario no existaI corro 
	char usuario[35];
	prinf("\nDime el usuario del jugador: ");
	scanf("%s",usuario);

	//realizar la consulta: quantas partidas ha ganado en total el usuario introducido
	char consulta[80];
	srtcpy(consulta,"SELECT COUNT(Partida.ID) FROM Jugador,Juego,Partida WHERE
    Jugador.Usuario = '");
	strcat(consulta,usuario);
	strcat(consulta,"' AND Jugador.ID = Juego.ID_J AND 
					Juego.Id_P = Partida.ID AND Partida.Ganador = Jugador.ID;");

	err=mysql_query(conn, consulta);
	if (err!=0) {
		printf("Error al consultar datos de la base %u %s\n",
				mysql_errno(conn), mysql_error(conn));
		exit(1);
	}

	//recogemos el resultado de la consulta. El resultado de la
	//consulta se devuelve en una variable del tipo puntero a
	//MYSQL_RES tal y como hemos declarado anteriormente.
	//Se trata de una tabla virtual en memoria que es la copia
	//de la tabla real en disco.
	resultado = mysql_store_result(conn);
	// El resultado es una estructura matricial en memoria
	// en la que cada fila contiene los datos de una persona.
	
	// Ahora obtenemos la primera fila que se almacena en una
	// variable de tipo MYSQL_ROW
	row = mysql_fetch_row(resultado);
	
	if (row == NULL)
		printf ("No se han obtenido datos en la consulta\n");
	else
		printf ("\nEl jugador %s ha ganado %s partidas\n\n", usuario, row[0]);
	}

    mysql_close(conn);
    exit(0);
}