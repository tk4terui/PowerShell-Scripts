# leadm tape format [オプション] テープ名 : テープのフォーマット
#   -c ; 非圧縮にフォーマット
#   -f ; 強制的にフォーマット

#python "C:\Program Files\IBM\LTFS\leadm" tape format -f -c LTO002L6
python "C:\Program Files\IBM\LTFS\leadm" tape format -f -c LTO004L6

## 複数フォーマット
#python "C:\Program Files\IBM\LTFS\leadm" tape format -f LTO011L6 LTO012L6 LTO013L6 LTO014L6 LTO015L6 LTO016L6 LTO017L6 LTO018L6 LTO019L6 LTO020L6
#python "C:\Program Files\IBM\LTFS\leadm" tape format -f -c LTO041L6 LTO042L6 LTO043L6 LTO044L6 LTO045L6 LTO046L6 LTO047L6 LTO048L6 LTO049L6 LTO050L6 LTO051L6 LTO052L6 LTO053L6 LTO054L6 LTO055L6 LTO056L6 LTO057L6 LTO058L6 LTO059L6 LTO060L6 LTO061L6 LTO062L6 LTO063L6 LTO064L6 