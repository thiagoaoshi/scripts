$Path = Get-Location
Get-ChildItem $Path -Directory | Where-Object { $_.Name -match '^\d+$' } | Remove-Item -Recurse -Force
