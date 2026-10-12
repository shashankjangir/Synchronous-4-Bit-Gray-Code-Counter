$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $PSScriptRoot
Push-Location $projectRoot
try {
    if (-not (Get-Command iverilog -ErrorAction SilentlyContinue) -or
        -not (Get-Command vvp -ErrorAction SilentlyContinue)) {
        throw 'Install Icarus Verilog and add its bin directory to PATH (iverilog and vvp).'
    }
    New-Item -ItemType Directory -Force build | Out-Null
    foreach ($test in @('sr_ff', 'gray_counter_4bit')) {
        & iverilog -g2012 -Wall -s "tb_$test" -o "build/$test.vvp" rtl/sr_ff.v rtl/gray_counter_4bit.v "tb/tb_$test.sv"
        if ($LASTEXITCODE -ne 0) { throw "Compilation failed: $test" }
        & vvp "build/$test.vvp"
        if ($LASTEXITCODE -ne 0) { throw "Simulation failed: $test" }
    }
} finally { Pop-Location }
