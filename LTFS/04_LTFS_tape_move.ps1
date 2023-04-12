# テープの移動 
# leadm tape move [global options] [subcommand options] <tape_id>
# 
# Subcommand options
# -L DESTINATION, --distination=DESTINATION
#    Destination slot type homeslot, ieslot or drive [default: homeslot].
# -d DRIVE_SERIAL, --drive-serial=DRIVE SERIAL
#    Destination drive serial number.
# tape_id
#    The ID of the tape that you want to move.

#python "C:\Program Files\IBM\LTFS\leadm" tape move -L ieslot LTO033L6
#python "C:\Program Files\IBM\LTFS\leadm" tape move -L ieslot LTO034L6
#python "C:\Program Files\IBM\LTFS\leadm" tape move -L ieslot LTO018L6



# ドライブから元のスロットへ移動させる場合
python "C:\Program Files\IBM\LTFS\leadm" tape move LTO005L6
python "C:\Program Files\IBM\LTFS\leadm" tape move LTO014L6

# ドライブに移動させる場合
#python "C:\Program Files\IBM\LTFS\leadm" tape move -L drive -d DRIVE_SERIAL LTO016L6