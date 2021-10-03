DROP DATABASE IF EXISTS BD;
CREATE DATABASE BD;
USE BD;

CREATE TABLE Jugador (
    ID INT NOT NULL,
    Usuario VARCHAR(35) NOT NULL,
    Contrasenya VARCHAR(15) NOT NULL,
    PRIMARY KEY (ID)
)ENGINE = InnoDB;

CREATE TABLE Partida (
    ID INT NOT NULL,
    Fecha VARCHAR(50),
    Duracion INT,
    Ganador INT, -- puede ser NULL si hay empate (no hay ganador)
    /* FK para relacionar directamente con el jugador que ha ganado
    asegura que no haya referencia a usuarios que no existen */
    FOREIGN KEY (Ganador) REFERENCES Jugador(ID),  
    PRIMARY KEY (ID)
)ENGINE = InnoDB;

CREATE TABLE Juego (
    ID_J INT NOT NULL,
    ID_P INT NOT NULL,
    Puntos INT NOT NULL,
    /* PK para que no pueda haber mas de una relacion
    entre un mismo jugador y una misma partida */
    PRIMARY KEY (ID_J,ID_P),
    FOREIGN KEY (ID_J) REFERENCES Jugador(ID),
    FOREIGN KEY (ID_P) REFERENCES Partida(ID)
)ENGINE = InnoDB;

INSERT INTO Jugador VALUES (1, 'Irene', 'w4T34');
INSERT INTO Jugador VALUES (2, 'Angelica', 'dW3r');
INSERT INTO Jugador VALUES (3, 'Alba', 'arhjfgye32');

INSERT INTO Partida VALUES (1, '11-03-2021 09:00', 19, 2);
INSERT INTO Partida VALUES (2, '11-03-2021 09:30', 26, 1);
INSERT INTO Partida VALUES (3, '11-03-2021 10:00', 12, 3);

INSERT INTO Juego VALUES (1, 2, 50);
INSERT INTO Juego VALUES (2, 1, 0);
INSERT INTO Juego VALUES (3, 2, 12);
INSERT INTO Juego VALUES (2, 3, 5);
INSERT INTO Juego VALUES (1, 1, 8);
INSERT INTO Juego VALUES (3, 3, 112);

-- obtener fechas de todas las partidas que ha jugado 'Alba'
SELECT Partida.Fecha FROM Jugador,Juego,Partida WHERE
    Jugador.Usuario = 'Alba' AND
    Jugador.ID = Juego.ID_J AND
    Juego.ID_P = Partida.ID;

-- obtener ID de todas las partidas que ha jugado 'Alba'
SELECT Partida.ID FROM Jugador,Juego,Partida WHERE
    Jugador.Usuario = 'Alba' AND
    Jugador.ID = Juego.ID_J AND
    Juego.ID_P = Partida.ID;

-- obtener ganador de todas las partidas que ha jugado 'Alba'
-- no necesario que haya ganado 'Alba'
SELECT Partida.Ganador FROM Jugador,Juego,Partida WHERE
    Jugador.Usuario = 'Alba' AND
    Jugador.ID = Juego.ID_J AND
    Juego.ID_P = Partida.ID;

-- obtener ID de todas las partidas que ha ganado 'Alba'
SELECT Partida.ID FROM Jugador,Juego,Partida WHERE
    Jugador.Usuario = 'Alba' AND
    Jugador.ID = Juego.ID_J AND
    Juego.Id_P = Partida.ID AND
    Partida.Ganador = Jugador.ID;

-- contar el número de partidas ha ganado 'Alba'
SELECT COUNT(Partida.ID) FROM Jugador,Juego,Partida WHERE
    Jugador.Usuario = 'Alba' AND
    Jugador.ID = Juego.ID_J AND
    Juego.Id_P = Partida.ID AND
    Partida.Ganador = Jugador.ID;

-- cuantos puntos ha ganado 'Irene'
SELECT SUM(Juego.Puntos) FROM Jugador,Juego WHERE
    Jugador.Usuario = 'Irene' AND
    Jugador.ID = Juego.ID_J;

-- cuantas partidas ha jugado 'Angelica' contra 'Irene'
SELECT COUNT(Juego.ID_P) FROM Jugador,Juego WHERE
    Jugador.Usuario = 'Angelica' AND
    Jugador.ID = Juego.ID_J AND
    Jugador.ID_P IN (SELECT Juego.ID_P FROM Jugador,Juego 
        WHERE Jugador.Usuario = 'Irene' AND Jugador.ID = Juego.ID_J);