# すべてのwingetパッケージをアップデートし、ライセンス同意を自動でYESにする
winget upgrade --all --accept-source-agreements --accept-package-agreements

# 不明なパッケージも含めてアップデートする場合はこちらを使用
#winget upgrade --all --accept-source-agreements --accept-package-agreements --include-unknown

# アップデート後に不要なパッケージを自動でクリーンアップする場合はこちらを使用
#winget upgrade --all --accept-source-agreements --accept-package-agreements; winget cleanup --accept-source-agreements --accept-package-agreements