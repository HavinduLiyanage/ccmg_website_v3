$files = Get-ChildItem -Path "c:\Users\havin\OneDrive\Desktop\CCMG Website new designs\*.html" -File

$iconMap = @{
    "arrow_forward" = "arrow-right"
    "menu" = "list"
    "close" = "x"
    "handshake" = "handshake"
    "bolt" = "lightning"
    "eco" = "leaf"
    "account_balance" = "bank"
    "verified" = "check-circle"
    "groups" = "users"
    "fact_check" = "clipboard-text"
    "rocket_launch" = "rocket-launch"
    "schedule" = "clock"
    "add" = "plus"
    "remove" = "minus"
    "check" = "check"
    "business" = "buildings"
    "description" = "file-text"
    "gavel" = "gavel"
    "engineering" = "hard-hat"
    "fire_extinguisher" = "fire-extinguisher"
    "pipeline" = "git-commit"
    "expand_more" = "caret-down"
    "check_circle" = "check-circle"
}

foreach ($file in $files) {
    $content = Get-Content -Path $file.FullName -Raw

    # 1. Fonts Links
    $content = $content -replace '<link href="https://fonts.googleapis.com/css2\?family=DM\+Sans[^"]+" rel="stylesheet" />', '<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600&family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet" />'
    $content = $content -replace '<link href="https://fonts.googleapis.com/css2\?family=Material\+Symbols[^"]+" rel="stylesheet" />', '<script src="https://unpkg.com/@phosphor-icons/web"></script>'
    
    # 2. Tailwind Config Colors
    $content = $content -replace '"primary":\s*"#0A2647"', '"primary": "#050B14"'
    $content = $content -replace '"primary-light":\s*"#144272"', '"primary-light": "#0F1A2C"'
    $content = $content -replace '"accent":\s*"#205295"', '"accent": "#1E314B"'
    $content = $content -replace '"teal":\s*"#0D7377"', '"teal": "#0F766E"'
    $content = $content -replace '"teal-dark":\s*"#094D4F"', '"teal-dark": "#042F2E"'
    $content = $content -replace '"teal-light":\s*"#14919B"', '"teal-light": "#14B8A6"'
    $content = $content -replace '"ivory":\s*"#FAFAF8"', '"ivory": "#F8FAFC"'
    $content = $content -replace '"warm":\s*"#F5F3EF"', '"warm": "#F1F5F9"'
    
    # 3. Tailwind Config Fonts
    $content = $content -replace '"DM Sans"', '"Inter"'
    $content = $content -replace '"Cormorant Garamond"', '"Outfit"'
    $content = $content -replace '"serif":\s*\["Outfit", "serif"\]', '"serif": ["Outfit", "sans-serif"]'
    $content = $content -replace '"serif":\s*\["Cormorant Garamond", "serif"\]', '"serif": ["Outfit", "sans-serif"]'
    
    # 4. CSS
    $content = $content -replace "font-family: 'DM Sans', sans-serif;", "font-family: 'Inter', sans-serif;"
    $content = $content -replace "font-family: 'Cormorant Garamond', serif;", "font-family: 'Outfit', sans-serif;"
    
    # 5. Icons via Regex
    $content = [regex]::Replace($content, '<span class="material-symbols-outlined([^"]*)">\s*([a-z_]+)\s*</span>', {
        param($match)
        $classes = $match.Groups[1].Value
        $iconName = $match.Groups[2].Value
        $phName = $iconMap[$iconName]
        if (-not $phName) { $phName = $iconName -replace "_", "-" }
        
        return "<i class=`"ph ph-$phName$classes`"></i>"
    })
    
    Set-Content -Path $file.FullName -Value $content
}
Write-Host "Replaced all files successfully."
