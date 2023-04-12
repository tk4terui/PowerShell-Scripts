# leadm tape list : テープカートリッジの状態確認【マウント後実行】
#
#     Location = { SLOT | DRIVE | IE_SLOT }
##                  SLOT(homeslot)
##                  DRIVE <- ここにいるときはテープの読み書き可能
##                  IE_SLOT(I/O Station) <- テープの入れ替えを行うところ
# 
#     Status = { WRITABLE | NEED_ASSIGN | NEED_FORMAT }
##                WRITABLE : フォーマット済み
##                NEED_ASSIGN : 未登録
##                NEED_FORMAT : 未フォーマット
##                その他コードについては下記を参照
##                https://www.ibm.com/support/knowledgecenter/STZMZN_2.4.1/ltfs_tape_status_codes.html#ltfs_tape_status_codes
#
# 管理情報を更新する場合はこちらを実行
# python "C:\Program Files\IBM\LTFS\leadm" tape list -r

python "C:\Program Files\IBM\LTFS\leadm" tape list