$ErrorActionPreference = 'Stop'

$Bin = 'C:\Users\HaleD\.codex\tools\postgresql-client\pgsql\bin'
$DataDir = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..\postgres_data'))
$LogFile = Join-Path $DataDir 'postgres.log'

& (Join-Path $Bin 'pg_ctl.exe') start -D $DataDir -l $LogFile -o "-h 127.0.0.1 -p 5433" -w
& (Join-Path $Bin 'pg_isready.exe') -h 127.0.0.1 -p 5433 -U postgres
