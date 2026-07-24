$ErrorActionPreference = 'Stop'

$Bin = 'C:\Users\HaleD\.codex\tools\postgresql-client\pgsql\bin'
$DataDir = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..\postgres_data'))

& (Join-Path $Bin 'pg_ctl.exe') -D $DataDir stop -m fast
