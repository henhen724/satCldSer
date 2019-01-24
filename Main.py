import nexradaws
from os import walk, remove
from datetime import datetime

def downloadRange (start, end, station, conInt):
    fileObjs = conInt.get_avail_scans_in_range(start, end, station)
    return conInt.download(fileObjs, '.\\localWeatherFiles\\', False, 8)
#test here
def clearLclWthFls ():
    wthFlDr = '.\\localWeatherFiles\\'
    for dirpath, dirnames, filenames in walk(wthFlDr):
        for filename in filenames:
            remove(wthFlDr + filename)

conn = nexradaws.NexradAwsInterface()

start = datetime(2018, 12, 21, 20)
end = datetime(2018, 12, 22, 0)
station = 'KTLX'

downRslt = downloadRange (start, end, station, conn)

for failure in downRslt.iter_failed():
    print "Failed to download %s which started at %r" % (failure.filename(), failure.scantime())

for localFile in downRslt.iter_success():
        radar = localFile.open_pyart()
        radar.close()
clearLclWthFls()
