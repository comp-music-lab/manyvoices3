# [A Programmatic Stage 1 Registered Report of global song-speech relationships replicating and extending Ozaki et al. (2024) and Savage et al. (2024)](https://doi.org/10.31234/osf.io/c2dba)
Savage, P. E., Jia, Z., Ozaki, Y., Pavlovich, D., Purdy, S., Ampiah-Bonney, A., Arabadjiev, A., Arnese, F., Bamford, J., Barbosa, B. S., Beck, A.-K., Cabildo, A., Chiba, G., Coissac, C., Dabaghi Varnosfaderani, S., Echim, S., Fujii, S., Gabriel, S., Grassi, M., Guiotto Nai Fovino, L., Hajič jr., J., Hansen, N. C., He, Y., Kitayama, Y., Kolios, S., Krzyżanowski, W., Kuikuro, U., Kurdova, D., Liu, F., Loui, P., Mikova, Z., Moya, D., Natsitsabui, R., Nguqu, N., Novembre, G., Nuska, P., Nweke, F. E., Opondo, P., Parkinson, H., Parselelo, M. L., Perry, G., Pfordresher, P. Q., Podlipniak, P., Popescu, T., Ravignani, A., Ross, R. M., Silva-Zurita, J., Soto-Silva, I., Thompson, W. F., Vaida, S., Vanden Bosch der Nederlanden, C. (2025). A Programmatic Stage 1 Registered Report of global song-speech relationships replicating and extending Ozaki et al. (2024) and Savage et al. (2025). PsyArXiv preprint: https://doi.org/10.31234/osf.io/c2dba    

## 📰 News
**- 2025 Feb 17** Our paper is available on PsyArXiv (Savage et al., 2025, https://doi.org/10.31234/osf.io/c2dba)

## 📖 Table of Contents
- [Annotation](#annotation)
- [Time interval elicitation](#time-interval-elicitation)
- [Split the audio](#split-the-audio)
- F0 elicitation
- F0 reprocessed (for cleaning and computing pitch stability)
- Plotting acoustic features
- Plotting effect size
- [File naming rules](#file-naming-rules)
- Some other useful tools (not necessary)

## 💻 Annotation
The English audio data is available here: https://osf.io/e4pqv/.

The annotation is divided into two tiers:

1. First tier (interval): I used letters (a, b, c, ...) to represent speaker-specific units. You can modify them to numbers as needed.

2. Second tier (speaker): I labeled speakers as s1, s2, s3, etc., corresponding to Speaker 1, Speaker 2, Speaker 3, and so on.

An example of the annotation is shown below in Praat.
![image](https://github.com/user-attachments/assets/e64fa003-72e6-42ee-b61d-30c5496b2d95)

## ⏰ Time interval elicitation
You can find this Praat script in the repository under:

*Data -> Tools (elicit intervals and pitch) -> Get_Duration_of_One_Tier.Praat*

Drag and drop this script, along with your .wav files and annotated .TextGrid files, into the same folder.

Next, open the script in Praat, modify the input directory to match the folder containing your audio files, annotations, and the script. Set the tier number to 1 or 2 as needed, and the corresponding .txt file will be generated. 

An example of modifying the run information in Praat script is demonstrated below.
![image](https://github.com/user-attachments/assets/fd601a5e-bd91-42ca-8f60-a451ac0206bf)

## 🔊 Split the audio
I splited audio first based on speaker and combined them manually in Praat for future F0 elicitation.

You can find this Praat script in the repository under:

*Data -> Tools (elicit intervals and pitch) -> Split_Long_Sound_Files.Praat*

Specify three things in this script: a) input directory b) output directory c)tier number: 2

An example of modifying the run information in Praat script is demonstrated below. 
![image](https://github.com/user-attachments/assets/5e115428-5bcc-44b0-97a0-80e10baaf51c)

And then combine the audio of the same speaker manually in Praat. 

In the Praat interface, you can follow these steps:

*Select all the audio files you want to combine → Click the **Combine** button on the right panel → Click **Concatenate**.*

## 📁 File naming rules
I highly recommend having a consistent naming convention for files, as some scripts rely on the file names to split information. 

The naming convention for my files is **language_experiment date_subject number_condition**, for example, English_20240725_6_conv.wav. 

If it's an extracted f0 or time interval file, '_f0' or '_IOI' is added at the end."
