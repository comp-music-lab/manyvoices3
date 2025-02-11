import librosa
import numpy as np
import datetime, csv

def get_f0(audiofilepath, dataname, outputdir):
    ####
    N = 2048
    M = 512

    ####
    y, sr = librosa.load(audiofilepath, mono=True)
    f0, voiced_flag, voiced_probs = librosa.pyin(y, sr=sr, fmin=25, fmax=2048, frame_length=N, hop_length=M)
    t = librosa.times_like(f0, sr=sr, hop_length=M)

    f0[np.isnan(f0)] = 0

    ####
    outputfilepath = outputdir + dataname + "_f0.csv"
    np.savetxt(outputfilepath, np.vstack([t, f0]).transpose(), delimiter=',', header="time,voice_1", comments="")

if __name__ == "__main__":
    """
    outputdir = r'C:\yuto\Documents\MATLAB\projects\song-speech-analysis\data\Automated F0' + '\\'
    audiodir = r'G:\Datasets\Hilton\IDS-corpus-raw\IDS-corpus-raw' + '\\'
    dataname = ["ACO02A", "ACO02B", "ACO02C", "ACO02D",
                "ACO05A", "ACO05B", "ACO05C", "ACO05D",
                "ACO09A", "ACO09B", "ACO09C", "ACO09D",
                "BEJ01A", "BEJ01B", "BEJ01C", "BEJ01D",
                "BEJ16A", "BEJ16B", "BEJ16C", "BEJ16D",
                "BEJ21A", "BEJ21B", "BEJ21C", "BEJ21D",
                "WEL01A", "WEL01B", "WEL01C", "WEL01D",
                "WEL21A", "WEL21B", "WEL21C", "WEL21D",
                "WEL51A", "WEL51B", "WEL51C", "WEL51D",]
    """

    """
    audiodir = r'../data/Stage 1 RR Audio/full-length/'
    dataname = ["Parimal_Sadaphal_Marathi_Spiritual_Maajhe Maahera Pandhari_20220320_song",
                "Parimal_Sadaphal_Marathi_Spiritual_Maajhe Maahera Pandhari_20220430_desc",
                "Parimal_Sadaphal_Marathi_Spiritual_Maajhe Maahera Pandhari_20220320_inst",
                "Parimal_Sadaphal_Marathi_Spiritual_Maajhe Maahera Pandhari_20220320_recit",
                "Shafagh_Hadavi_Farsi_Iran_Traditional_YekHamoomi_20220430_recit",
                "Shafagh_Hadavi_Farsi_Iran_Traditional_YekHamoomi_20220430_song",
                "Shafagh_Hadavi_Farsi_Iran_Traditional_YekHamoomi_20220502_desc",
                "Shafagh_Hadavi_Farsi_Iran_Traditional_YekHamoomi_20220507_inst",
                "Yuto_Ozaki_Japanese_Japanese_Traditional_Asatoya-Yunta_20220209_desc",
                "Yuto_Ozaki_Japanese_Japanese_Traditional_Asatoya-Yunta_20220209_recit",
                "Yuto_Ozaki_Japanese_Japanese_Traditional_Asatoya-Yunta_20220209_song",
                "Yuto_Ozaki_Japanese_Japanese_Traditional_Asatoya-Yunta_20220224_inst",
                "Florence_Nweke_Yoruba_Yoruba_Traditional_Ise-Agbe_20220504_desc",
                "Florence_Nweke_Yoruba_Yoruba_Traditional_Ise-Agbe_20220504_inst",
                "Florence_Nweke_Yoruba_Yoruba_Traditional_Ise-Agbe_20220504_recit",
                "Florence_Nweke_Yoruba_Yoruba_Traditional_Ise-Agbe_20220504_song",
                "John_McBride_English_Irish_Anthem_FieldsOfAthenry_20220219_desc",
                "John_McBride_English_Irish_Anthem_FieldsOfAthenry_20220219_inst",
                "John_McBride_English_Irish_Anthem_FieldsOfAthenry_20220219_recit",
                "John_McBride_English_Irish_Anthem_FieldsOfAthenry_20220219_song",
                ]
    """
    datasetinfo = ['../datainfo_Hilton-pyin.csv', '../datainfo_pyin-praat.csv']

    for dinfo in datasetinfo:
        print(datetime.datetime.now().isoformat() + " ** " + dinfo)

        with open(dinfo, encoding="utf_8") as f:
            reader = csv.reader(f)
            T = [row for row in reader]
            T = T[1:]

            for row in T:
                audiofilepath = row[2] + row[0] + '.' + row[3]
                dataname = row[0]
                outputdir = '.' + row[1]

                print(datetime.datetime.now().isoformat() + " - " + dataname)
                get_f0(audiofilepath, dataname, outputdir)

    print(datetime.datetime.now().isoformat() + " - done")