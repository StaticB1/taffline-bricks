# ============================================================
#  Taffline Bricks - Image Renaming Script
#  Run this from D:\taffline-bricks\
#  Usage: .\rename-images.ps1
# ============================================================

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "   TAFFLINE BRICKS - Renaming images..." -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# -- Supported image extensions --
$extensions = @("*.jpg", "*.jpeg", "*.png", "*.webp", "*.JPG", "*.JPEG", "*.PNG", "*.WEBP")

# -- Folders and their rename prefix --
$folderPrefixes = @{
    "images\hero"      = "hero"
    "images\bricks"    = "bricks"
    "images\cement"    = "cement"
    "images\pavers"    = "pavers"
    "images\sand"      = "sand"
    "images\quarry"    = "quarry"
    "images\timber"    = "timber"
    "images\rooftiles" = "rooftiles"
    "images\trucks"    = "trucks"
    "images\gallery"   = "gallery"
    "images\about"     = "about"
}

$totalRenamed = 0
$totalSkipped = 0

foreach ($folder in $folderPrefixes.Keys) {
    $prefix = $folderPrefixes[$folder]

    # Check folder exists
    if (-Not (Test-Path $folder)) {
        Write-Host "  [!] Skipping (not found) --> $folder" -ForegroundColor DarkGray
        continue
    }

    # Collect all image files in this folder (exclude _README.txt etc)
    $files = @()
    foreach ($ext in $extensions) {
        $files += Get-ChildItem -Path $folder -Filter $ext
    }

    # Sort by name for consistent ordering
    $files = $files | Sort-Object Name

    if ($files.Count -eq 0) {
        Write-Host "  [~] Empty    --> $folder" -ForegroundColor DarkGray
        continue
    }

    Write-Host ""
    Write-Host "  Processing: $folder ($($files.Count) images)" -ForegroundColor Cyan

    $counter = 1
    foreach ($file in $files) {
        # Get the extension in lowercase
        $ext = $file.Extension.ToLower()
        if ($ext -eq ".jpeg") { $ext = ".jpg" }

        # Build new name e.g. bricks-01.jpg
        $newName = "$prefix-{0:D2}$ext" -f $counter

        $newPath = Join-Path $folder $newName

        # Skip if already correctly named
        if ($file.Name -eq $newName) {
            Write-Host "    [=] Already correct  -->  $($file.Name)" -ForegroundColor DarkGray
            $counter++
            $totalSkipped++
            continue
        }

        # If target name already exists (conflict), add temp suffix first
        if (Test-Path $newPath) {
            $tempName = "$prefix-temp-{0:D2}$ext" -f $counter
            $tempPath = Join-Path $folder $tempName
            Rename-Item -Path $file.FullName -NewName $tempName
            Write-Host "    [~] Temp rename  -->  $($file.Name) -> $tempName" -ForegroundColor DarkYellow
        } else {
            Rename-Item -Path $file.FullName -NewName $newName
            Write-Host "    [+] Renamed  -->  $($file.Name)  ->  $newName" -ForegroundColor Green
            $totalRenamed++
        }

        $counter++
    }

    # -- Resolve any temp-named files --
    $tempFiles = Get-ChildItem -Path $folder -Filter "*-temp-*"
    foreach ($tempFile in $tempFiles) {
        $ext = $tempFile.Extension.ToLower()
        if ($ext -eq ".jpeg") { $ext = ".jpg" }
        # Extract number from temp name
        if ($tempFile.Name -match "-temp-(\d+)") {
            $num = [int]$Matches[1]
            $finalName = "$prefix-{0:D2}$ext" -f $num
            $finalPath = Join-Path $folder $finalName
            Rename-Item -Path $tempFile.FullName -NewName $finalName
            Write-Host "    [+] Resolved -->  $($tempFile.Name)  ->  $finalName" -ForegroundColor Green
            $totalRenamed++
        }
    }
}

# -- Done --
Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "   DONE!" -ForegroundColor Cyan
Write-Host "   Renamed : $totalRenamed files" -ForegroundColor Green
Write-Host "   Skipped : $totalSkipped files (already correct)" -ForegroundColor DarkGray
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "  All images are now named consistently." -ForegroundColor White
Write-Host "  Example: bricks-01.jpg, pavers-03.jpg, gallery-07.jpg" -ForegroundColor Gray
Write-Host ""

# -- Print final file list per folder --
Write-Host "  Final image list:" -ForegroundColor Cyan
foreach ($folder in ($folderPrefixes.Keys | Sort-Object)) {
    if (Test-Path $folder) {
        $imgs = @()
        foreach ($ext in $extensions) {
            $imgs += Get-ChildItem -Path $folder -Filter $ext
        }
        if ($imgs.Count -gt 0) {
            Write-Host ""
            Write-Host "  [$folder]" -ForegroundColor Yellow
            foreach ($img in ($imgs | Sort-Object Name)) {
                Write-Host "    - $($img.Name)" -ForegroundColor White
            }
        }
    }
}
Write-Host ""
