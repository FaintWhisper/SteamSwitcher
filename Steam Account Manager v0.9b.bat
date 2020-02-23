@echo off & CHCP 1252 >nul
color 30
setlocal enabledelayedexpansion
Title Steam Account Manger By RYSKZ

:Home
cd %~dp0
if exist settings.dat (
 for /f "tokens=1 delims=Users_Created:" %%a in (settings.dat) do set UsersCreated=%%a
) else (
 set UsersCreated=0
)

set N=1
set T=1

cls
echo					 ________________________________________________
echo					/                                                /
echo					/                                                /
echo					/                                                /
echo					/             Steam Account Manager              /
echo					/                Creado Por RYSKZ                /
echo					/                                                /
echo					/                                                /
echo					/                                                /
echo					/________________________________________________/
echo.

for /l %%u in (1,1,%UsersCreated%) do (
if exist account%%u.dat (
for /f "tokens=1 delims=[]" %%b in (account%%u.dat) do (
echo							!T!. Cargar Perfil %%b
set /a T+=1
)
)
)
echo							%T%. Crear Perfil
set /a T+=1
echo							%T%. Reiniciar Steam
set /a T+=1
echo							%T%. Cerrar Steam
set /a T+=1
echo							%T%. Cerrar Aplicación
echo.

set /p Option=Introduzaca la opción deseada:

set /a A=%UsersCreated%+1
set /a B=%UsersCreated%+2
set /a C=%UsersCreated%+3
set /a D=%UsersCreated%+4

if %Option%==%A% (goto :AddUser)
 if %Option%==%B% (goto :RestartSteam)
  if %Option%==%C% (goto :CloseSteam)
   if %Option%==%D% (goto :CloseApp)
    if %Option% lss 1 (goto :Home)
     if %Option% gtr !T! (goto :Home)

for /l %%o in (1,1,%UsersCreated%) do (
 if %Option%==%%o (goto :LoadProfile)
)

:AddUser
cls
echo						 Intrdouzca el Usuario y la Contraseña.
echo					Solo tendrá que introducir esta información una única vez.
echo.
echo				   Asegúrese de estar en un lugar discreto antes de introducir los datos
echo.
echo.

set /p DisplayName=Nombre a mostrar:
set /p User=Usuario:
set /p Password=Contraseña:
echo Añadiendo Perfil...
set /a UsersCreated+=1
echo Users_Created:%UsersCreated%> settings.dat
echo [%DisplayName%] %User% %Password% AutoLogOff> account%UsersCreated%.dat
goto :LoadProfile

:LoadProfile
cls
set UserNum=%Option%
set AlreadyLog=No

for /f "tokens=1 delims=[]" %%c in (account%UserNum%.dat) do set DisplayName=%%c
echo Cargando perfil %DisplayName%...
timeout /t 3 /nobreak >nul
for /f "tokens=2 delims= " %%d in (account%UserNum%.dat) do set User=%%d
for /f "tokens=3 delims= " %%e in (account%UserNum%.dat) do set Password=%%e
for /f "tokens=4 delims= " %%f in (account%UserNum%.dat) do set AutoLog=%%f

:ManageProfile
cd %~dp0
cls

if %AlreadyLog%==No (
if !AutoLog! equ AutoLogOn (goto :LoginSteam)
)

echo                                             	Gestor de perfiles
echo.
echo						1. Iniciar Sesión en Steam
if !AutoLog!==AutoLogOn (
echo						2. Desabilitar inicio de sesión automático
) else (
echo						2. Habilitar inicio de sesión automático
)
echo						3. Modificar perfil
echo						4. Eliminar perfil
echo						5. Volver al Inicio
echo.
echo.

set /p Option2=Introduzca la opción deseada:

if %Option2%==1 (goto :LoginSteam)
if %Option2%==2 (goto :SetAutoLogin)
if %Option2%==3 (goto :EditProfile)
if %Option2%==4 (goto :DeleteProfile)
if %Option2%==5 (goto :Home)
if %Option2% lss 1 (goto :ManageProfile)
if %Option2% gtr 5 (goto :ManageProfile)

:LoginSteam
cls
echo Iniciando sesión en Steam...
timeout /t 3 /nobreak >nul
start /D "C:\Program Files (x86)\Steam\" steam.exe -login %User% %Password%
set AlreadyLog=Yes
cls
if %errorlevel%==0 (echo Sesión iniciada con éxito)
if %errorlevel% gtr 0 (echo Se produjo un error al iniciar sesión)
timeout /t 3 /nobreak >nul
goto :ManageProfile

:SetAutoLogin
if !AutoLog!==AutoLogOn (
set AutoLog=AutoLogOff
echo [%DisplayName%] %User% %Password% !AutoLog!> account!UserNum!.dat
goto :ManageProfile
)
if !AutoLog!==AutoLogOff (
set AutoLog=AutoLogOn
echo [%DisplayName%] %User% %Password% !AutoLog!> account!UserNum!.dat
goto :ManageProfile
)
goto :ManageProfile

:EditProfile
cls
echo							Modificación del Perfil
echo					Si no desea modificar algún apartado déjelo en blanco
echo.
echo				 Asegúrese de estar en un lugar discreto antes de introducir los datos
echo.
echo.

set /p NewDisplayName=Nombre a mostrar:
set /p NewUser=Usuario:
set /p NewPassword=Contraseña:

if DisplayName equ "" (set NewDisplayName=%DisplayName%)
if User equ "" (set NewUser=%User%)
if Password equ "" (set NewPassword=%Password%)
echo [%NewDisplayName%] %NewUser% %NewPassword% !AutoLog!> account!UserNum!.dat
goto :LoadProfile

:DeleteProfile
cls
echo Eliminando el perfil...
timeout /t 3 /nobreak >nul
del /q account%UserNum%.dat
set /a UsersCreated=%UsersCreated%-1
echo Users_Created:%UsersCreated%> settings.dat
goto :Home

:RestartSteam
cls
echo Reiniciando Steam...
timeout /t 3 /nobreak >nul
taskkill /im Steam.exe >nul 2>&1
cls
if %errorlevel%==0 (goto :RestartingSteam)
if %errorlevel% equ 128 (
echo Steam no se encuentra abierto.
timeout /t 3 /nobreak >nul
goto :Home
)
:RestartingSteam
start /D "C:\Program Files (x86)\Steam\" Steam.exe
if %errorlevel%==0 (echo Steam se ha reiniciado correctamente)
if %errorlevel% gtr 0 (echo Se produjo un error al reiniciar Steam)
timeout /t 3 /nobreak >nul
goto :Home

:CloseSteam
cls
echo Cerrando Steam...
timeout /t 3 /nobreak >nul
taskkill /im Steam.exe >nul 2>&1
cls
if %errorlevel%==0 (echo Steam se cerró correctamente.)
if %errorlevel% geq 1 (echo Steam no se encuentra abierto.)

timeout /t 3 /nobreak >nul

goto :Home

:CloseApp
cls
echo Cerrando aplicación...
timeout /t 3 /nobreak >nul
exit