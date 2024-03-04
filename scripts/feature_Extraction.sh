#!/bin/sh
for entry1 in `ls ../dataset/data/Normal/*.wav`;do
fname=`basename $entry1 .wav`
echo $fname 
./ahocoder16_64 "../dataset/data/Normal/$fname.wav" "../dataset/features/US_102/Normal/f0/$fname.f0" "../dataset/features/US_102/Normal/mcc/$fname.mcc" "../dataset/features/US_102/Normal/fv/$fname.fv"
done


#!/bin/sh
for entry1 in `ls ../dataset/data/Whisper/*.wav`;do
fname=`basename $entry1 .wav`
echo $fname 
./ahocoder16_64 "../dataset/data/Whisper/$fname.wav" "../dataset/features/US_102/Whisper/f0/$fname.f0" "../dataset/features/US_102/Whisper/mcc/$fname.mcc" "../dataset/features/US_102/Whisper/fv/$fname.fv"
done
exit
