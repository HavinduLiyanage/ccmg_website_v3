$files = Get-ChildItem -Path "c:\Users\havin\OneDrive\Desktop\CCMG Website new designs\*.html" -File

foreach ($file in $files) {
    $content = Get-Content -Path $file.FullName -Raw

    $oldString = '"serif": ["Outfit", "sans-serif"],'
    $newString = '"serif": ["Outfit", "sans-serif"],
                    boxShadow: {
                        "sm": "0 2px 8px -2px rgba(5, 11, 20, 0.05)",
                        "md": "0 4px 16px -4px rgba(5, 11, 20, 0.08)",
                        "lg": "0 8px 32px -8px rgba(5, 11, 20, 0.1)",
                        "xl": "0 12px 48px -12px rgba(5, 11, 20, 0.12)",
                        "2xl": "0 24px 64px -24px rgba(5, 11, 20, 0.15)",
                    },'
    
    $content = $content.Replace($oldString, $newString)
    
    # Also add image treatment CSS class
    $oldCss = '/* === Base === */'
    $newCss = '/* === Base === */
        .image-grade { mix-blend-mode: luminosity; opacity: 0.85; transition: all 0.7s cubic-bezier(0.25,0.46,0.45,0.94); }
        .image-grade:hover { mix-blend-mode: normal; opacity: 1; transform: scale(1.03); }'
        
    $content = $content.Replace($oldCss, $newCss)
    
    # Apply .image-grade to all <img class="...">
    # Wait, the images often already have scale/hover effects.
    # We will just append image-grade to their class list.
    $content = $content -replace '<img([^>]+)class="([^"]+)"', '<img$1class="$2 image-grade"'
    
    Set-Content -Path $file.FullName -Value $content
}
Write-Host "Shadows and image formatting applied."
