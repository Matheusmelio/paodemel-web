param(
    [string]$ServerInstance = "DESKTOP-N7F37J3\SQLEXPRESS",
    [switch]$UseSqlAuth,
    [string]$Username = "sa"
)

$ErrorActionPreference = "Stop"
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$sqlDir = Join-Path $scriptDir "sqlserver-academico"
$logDir = Join-Path $sqlDir "logs"
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$logFile = Join-Path $logDir "exec_$timestamp.log"

if (-not (Test-Path $sqlDir)) {
    throw "Pasta nao encontrada: $sqlDir"
}

New-Item -ItemType Directory -Force -Path $logDir | Out-Null

$files = @(
    "01_modelo_fisico.sql",
    "02_automacao.sql",
    "03_dados_exemplo.sql",
    "04_consultas_checklist.sql"
)

function Write-Log {
    param([string]$Message)
    $line = "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] $Message"
    Add-Content -Path $logFile -Value $line
    Write-Host $line
}

function Invoke-SqlFile {
    param(
        [string]$FilePath
    )

    $content = Get-Content -Path $FilePath -Raw -Encoding UTF8
  $batches = $content -split '(?m)^\s*GO\s*$' | Where-Object { $_.Trim() -ne "" }

    foreach ($batch in $batches) {
        if ($UseSqlAuth) {
            Invoke-Sqlcmd -ServerInstance $ServerInstance -Username $Username -Query $batch -ErrorAction Stop | Out-Null
        } else {
            Invoke-Sqlcmd -ServerInstance $ServerInstance -TrustServerCertificate -Query $batch -ErrorAction Stop | Out-Null
        }
    }
}

function Test-SqlCmdAvailable {
    return [bool](Get-Command sqlcmd -ErrorAction SilentlyContinue)
}

function Invoke-SqlFileWithSqlCmd {
    param(
        [string]$FilePath
    )

    $args = @("-S", $ServerInstance, "-i", $FilePath, "-b")

    if ($UseSqlAuth) {
        $securePassword = Read-Host "Senha do usuario $Username" -AsSecureString
        $bstr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePassword)
        $plainPassword = [Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr)
        $args += @("-U", $Username, "-P", $plainPassword)
    } else {
        $args += "-E"
    }

    & sqlcmd @args
    if ($LASTEXITCODE -ne 0) {
        throw "sqlcmd falhou ao executar $FilePath"
    }
}

Write-Log "Iniciando execucao dos scripts SQL"
Write-Log "Servidor: $ServerInstance"
Write-Log "Autenticacao: $(if ($UseSqlAuth) { 'SQL' } else { 'Windows' })"

$useSqlCmd = Test-SqlCmdAvailable
Write-Log "Metodo: $(if ($useSqlCmd) { 'sqlcmd' } else { 'Invoke-Sqlcmd' })"

if (-not $useSqlCmd) {
    if (-not (Get-Module -ListAvailable -Name SqlServer)) {
        throw "Nem sqlcmd nem o modulo SqlServer estao disponiveis. Instale SQL Server tools ou o modulo SqlServer."
    }
    Import-Module SqlServer -ErrorAction Stop
}

foreach ($file in $files) {
    $fullPath = Join-Path $sqlDir $file
    if (-not (Test-Path $fullPath)) {
        throw "Arquivo nao encontrado: $fullPath"
    }

    Write-Log "Executando $file"
    try {
        if ($useSqlCmd) {
            Invoke-SqlFileWithSqlCmd -FilePath $fullPath
        } else {
            Invoke-SqlFile -FilePath $fullPath
        }
        Write-Log "OK: $file"
    } catch {
        Write-Log "ERRO em $file : $($_.Exception.Message)"
        throw
    }
}

Write-Log "Execucao concluida com sucesso"
Write-Log "Log salvo em: $logFile"
Write-Host ""
Write-Host "Banco PaoDeMel pronto. Teste no SSMS com:"
Write-Host "USE PaoDeMel; SELECT * FROM dbo.Cliente;"
