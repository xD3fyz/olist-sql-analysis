$ErrorActionPreference = 'Stop'

$Bin = 'C:\Users\HaleD\.codex\tools\postgresql-client\pgsql\bin'
$Root = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$sqlFiles = @(
    'sql/01_schema.sql',
    'sql/02_seed_data.sql',
    'sql/03_basic_analysis.sql',
    'sql/04_customer_repurchase.sql',
    'sql/05_rfm_segmentation.sql',
    'sql/06_product_analysis.sql',
    'sql/07_delivery_review_analysis.sql',
    'sql/08_optimization.sql'
)

& (Join-Path $Bin 'createdb.exe') -h 127.0.0.1 -p 5433 -U postgres -T template0 sql_demo

foreach ($file in $sqlFiles) {
    $full = Join-Path $Root $file
    & (Join-Path $Bin 'psql.exe') -h 127.0.0.1 -p 5433 -U postgres -d sql_demo -v ON_ERROR_STOP=1 -f $full
}
