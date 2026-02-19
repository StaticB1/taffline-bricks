# ============================================================
#  Taffline Bricks - Project Folder Setup Script
#  Usage: .\setup-taffline.ps1
# ============================================================

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "   TAFFLINE BRICKS - Setting up project..." -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# -- Define all folders to create --
$folders = @(
    "images\hero",
    "images\bricks",
    "images\cement",
    "images\pavers",
    "images\sand",
    "images\quarry",
    "images\timber",
    "images\rooftiles",
    "images\trucks",
    "images\gallery",
    "images\about"
)

# -- Create each folder --
foreach ($folder in $folders) {
    if (-Not (Test-Path $folder)) {
        New-Item -ItemType Directory -Path $folder -Force | Out-Null
        Write-Host "  [+] Created  -->  $folder" -ForegroundColor Green
    } else {
        Write-Host "  [~] Exists   -->  $folder" -ForegroundColor Yellow
    }
}

# -- Create README guide files inside each image folder --
$readmes = @{
    "images\hero"      = "Drop 1-3 wide landscape photos here.`nBest: loaded truck, materials yard, or busy construction site."
    "images\bricks"    = "Drop 2-4 brick photos here.`nBest: stacked bricks, brick wall closeups, bricks being laid."
    "images\cement"    = "Drop 2-3 cement photos here.`nBest: cement bags stacked, wheelbarrow mixing, delivery shots."
    "images\pavers"    = "Drop 3-5 paver photos here.`nBest: finished driveways, laying in progress, paver patterns."
    "images\sand"      = "Drop 2-3 sand photos here.`nBest: sand piles, delivery, river sand texture shots."
    "images\quarry"    = "Drop 2-3 quarry photos here.`nBest: quarry stones pile, 3/4 stones, stones on truck."
    "images\timber"    = "Drop 2-3 timber photos here.`nBest: timber stacks, boards, roof structure."
    "images\rooftiles" = "Drop 2-3 roof tile photos here.`nBest: tiles on roof, tile stacks, patterns."
    "images\trucks"    = "Drop 3-5 truck photos here.`nBest: tipper trucks, grabber in action, truck loading."
    "images\gallery"   = "Drop your 9-12 BEST photos here.`nMix of products + completed work. These show on the main gallery."
    "images\about"     = "Drop 1 photo here.`nBest: site/yard photo, team photo, or your depot."
}

Write-Host ""
Write-Host "  Creating guide files..." -ForegroundColor Cyan

foreach ($path in $readmes.Keys) {
    $readmePath = "$path\_README.txt"
    $readmes[$path] | Out-File -FilePath $readmePath -Encoding UTF8
    Write-Host "  [+] Guide    -->  $readmePath" -ForegroundColor DarkGray
}

# -- Create index.html placeholder if it does not exist --
Write-Host ""
if (-Not (Test-Path "index.html")) {
    "<!-- Paste your Taffline Bricks HTML here -->" | Out-File -FilePath "index.html" -Encoding UTF8
    Write-Host "  [+] Created  -->  index.html (placeholder)" -ForegroundColor Green
} else {
    Write-Host "  [~] Exists   -->  index.html" -ForegroundColor Yellow
}

# -- Print summary --
Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "   DONE! Your project is ready." -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "  Next steps:" -ForegroundColor White
Write-Host "  1. Paste your index.html into the root folder" -ForegroundColor Gray
Write-Host "  2. Rename your photos (e.g. bricks-01.jpg)" -ForegroundColor Gray
Write-Host "  3. Copy photos into the correct image folders" -ForegroundColor Gray
Write-Host "  4. Open index.html in VS Code" -ForegroundColor Gray
Write-Host ""
Write-Host "  TIP: No spaces in filenames! Use - or _ only." -ForegroundColor DarkYellow
Write-Host ""

# -- Show final folder tree --
Write-Host "  Project structure:" -ForegroundColor Cyan
Get-ChildItem -Recurse -Directory | ForEach-Object {
    $depth = ($_.FullName.Split("\").Count - $PWD.Path.Split("\").Count)
    $indent = "  " + ("  " * $depth)
    Write-Host "$indent[DIR] $($_.Name)" -ForegroundColor White
}
Write-Host "  [FILE] index.html" -ForegroundColor White
Write-Host ""