DELIMITER $$
CREATE PROCEDURE `sp_agregarDatos`(IN `ticketscerrados` INT, IN `ticketsNOcerrados` INT, IN `nombre` VARCHAR(65))
BEGIN 
UPDATE `usuarios` SET 
`ticketsCerrados`=ticketscerrados,
`ticketsError`=ticketsNOcerrados 
WHERE `nombreusuario` = nombre;

SET @total = (ticketsNOcerrados/ticketscerrados)*100;  

UPDATE `usuarios` SET 
total=ROUND(@total,2)
WHERE `nombreusuario` = nombre;

SET @departamento = (SELECT departamento    
FROM usuarios WHERE `nombreusuario` = nombre);

CALL `sp_sumsigma`(@departamento);               
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE `sp_cantidadcolabo`()
BEGIN
SET @sum = (SELECT COUNT(id)    
FROM usuarios);

SELECT @sum;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE `sp_cantidadepas`()
BEGIN
SET @sum = (SELECT COUNT(nombre)    
FROM departamentos);

SELECT @sum;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE `sp_mydepa`(IN `depa` VARCHAR(65))
SELECT nombre as 'Nombredeldepartamento',valorsigma as 'valorsigma' FROM departamentos WHERE nombre = depa$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE `sp_sumsigma`(IN `depa` VARCHAR(75))
BEGIN
SET @sub = (SELECT SUM(total)    
FROM usuarios   
WHERE departamento = depa);

SET @Ftotal = (100-@Sub);
SELECT @Ftotal as 'Porcentaje Sigma';

UPDATE `departamentos` SET 
valorsigma=@Ftotal
WHERE `nombre` = depa;


END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE `sp_totalbyusuario`(IN `depa` VARCHAR(70))
SELECT nombreusuario as 'Nombredelcolaborador',total as 'Porcentajesigma' FROM usuarios where departamento = depa AND tipousuario = 2$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE `sp_totalesbyDepartamento`()
SELECT nombre as 'Nombredeldepartamento',valorsigma as 'valorsigma' FROM departamentos$$
DELIMITER ;
