$ErrorActionPreference = 'Stop'

$Bin = 'C:\Users\HaleD\.codex\tools\postgresql-client\pgsql\bin'
$DataDir = Join-Path $PSScriptRoot '..\postgres_data'
$DataDir = [System.IO.Path]::GetFullPath($DataDir)

New-Item -ItemType Directory -Force -Path $DataDir | Out-Null

& (Join-Path $Bin 'initdb.exe') -D $DataDir -U postgres -A trust -E UTF8
