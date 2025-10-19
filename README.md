# [A Programmatic Stage 1 Registered Report of global song-speech relationships replicating and extending Ozaki et al. (2024) and Savage et al. (2024)](https://doi.org/10.31234/osf.io/c2dba)
Savage, P. E., Jia, Z., Ozaki, Y., Pavlovich, D., Purdy, S., Ampiah-Bonney, A., Arabadjiev, A., Arnese, F., Bamford, J., Barbosa, B. S., Beck, A.-K., Cabildo, A., Chiba, G., Dabaghi Varnosfaderani, S., Echim, S., Fujii, S., Gabriel, S., Grassi, M., Guiotto Nai Fovino, L., Hajič jr., J., Hartmann, M., Hansen, N. C., He, Y., Kolios, S., Krzyżanowski, W., Kuikuro, U., Kurdova, D., Liu, F., Loui, P., Mikova, Z., Moya, D., Natsitsabui, R., Niiranen, M., Nguqu, N., Nuska, P., Nweke, F. E., Opondo, P., Parkinson, H., Parselelo, M. L., Perry, G., Pfordresher, P. Q., Podlipniak, P., Popescu, T., Ross, R. M., Shi, Z., Silva-Zurita, J., Soto-Silva, I., Štěpánková, B., Thompson, W. F., Vaida, S., Vanden Bosch der Nederlanden, C. (In Principle Accepted). A Programmatic Stage 1 Registered Report of global song-speech relationships replicating and extending Ozaki et al. (2024) and Savage et al. (2025). Peer Community In Registered Report

<p align="center">
  <img src="https://github.com/user-attachments/assets/6c7f8e7f-5d54-4f4a-a534-a25c06b1ca99" width="400">
  <br>
  <em>Pictured by Nelson Shi</em>
</p>



## 📰 News
**- 2025 May 9.** Our Stage 1 Registered Report received In Principle Acceptance! (https://rr.peercommunityin.org/articles/rec?id=961)

**- 2025 Feb 17.** Our paper is available on PsyArXiv (Savage et al., 2025, https://doi.org/10.31234/osf.io/c2dba)


## 📖 Table of Contents
- [File naming rules](#file-naming-rules)
- [Annotation](#annotation)
- [Time interval elicitation](#time-interval-elicitation)
- [Split the audio](#split-the-audio)
- [F0 elicitation](#f0-elicitation)
- [F0 reprocessed](#f0-reprocessed)
- [Compute effect size](#compute-effect-size)
- [Plotting acoustic features](#plotting-acoustic-features)
- [Plotting effect size](#plotting-effect-size)

## File naming rules
I highly recommend having a consistent naming convention for files, as some scripts rely on the file names to split information. 

The naming convention for my files is ***language_location_group_condition.wav***, for example, ***Mandarin_Auckland_C1_conv.wav***. 

If it's an extracted f0 or time interval file, '_f0' or '_IOI' is added at the end.

## Annotation
The English audio data is available here: https://osf.io/e4pqv/.

The annotation is divided into two tiers:

1. First tier (interval): I labels speaker ID (numbers) among units. 

2. Second tier (speaker): I labeled speakers as 1, 2, 3, etc., corresponding to Speaker 1, Speaker 2, Speaker 3, and so on. Since we have three groups, we may all name participants 1-10 across three groups. To make the participants ID continuous, I may rename the ID. For example, if C1 group have 10 participants with ID from 1-10, for R1 group, I may rename them as 11-20. 

An example of the annotation is shown below in Praat.
![image](https://github.com/user-attachments/assets/89a0fed2-93cc-4eb1-a57e-edb631fd6ee8)


## Time interval elicitation
You can find this Praat script in the repository under:

***Tools (elicit intervals and pitch) -> Get_Duration_of_One_Tier.Praat***

Drag and drop this script, along with your .wav files and annotated .TextGrid files, into the same folder.

Next, open the script in Praat, modify the input directory to match the folder containing your audio files, annotations, and the script. Set the tier number to 1 or 2 as needed, and the corresponding .txt file will be generated. I put it under ***data -> result_duration_tier_1.txt***.

An example of modifying the run information in Praat script is demonstrated below.
![image](https://github.com/user-attachments/assets/c52454be-40c7-4716-9255-b9d89d7aa752)


Since this is a combined file, you may need to split it based on speaker and condition as single file. At this time, you can refer to:

***Tools (elicit intervals and pitch) -> time_generator.py***

And you can just modify line 60-61 in this .py
```python
    # Set input txt path and output folder
    input_txt_file = "/Users/betty/Desktop/manyvoices3_pilot/result_duration_tier_1.txt""  # Your actual txt file path
     output_folder = "/Users/betty/Desktop/manyvoices3_pilot/IOI/""  # Your output directory
```

The elicited intervals of each speaker is stored under ***data -> IOI***

## Split the audio
I splited audio first based on speaker and combined them manually in Praat for future F0 elicitation.

You can find this Praat script in the repository under:

***Tools (elicit intervals and pitch) -> Split_Long_Sound_Files.Praat***

Specify three things in this script: a) input directory b) output directory c)tier number: 2

An example of modifying the run information in Praat script is demonstrated below. 
![image](https://github.com/user-attachments/assets/5e115428-5bcc-44b0-97a0-80e10baaf51c)

And then combine the audio of the same speaker manually in Praat. 

In the Praat interface, you can follow these steps:

*Select all the audio files you want to combine → Click the **Combine** button on the right panel → Click **Concatenate**.*

PS. You may need to cut the overlap or slience manully when combing audios. 

Praat script of merging audios of same speakers will **come soon**.

## F0 elicitation
F0 is extracted based on the pYIN algorithm, estimating one f0 point every 0.005 seconds. 

You can find this Python tool under ***Tools (elicit intervals and pitch) → f0_pYIN.py***.  

In this `.py` file, you only need to modify **lines 58 and 59**:  
```python
# Set input folder containing audio files and output folder for CSV files
input_folder = "/Users/betty/Documents/MATLAB/song_speech_Mandarin/data/combined audio/"  # Replace with your audio file path
output_folder = "/Users/betty/Documents/MATLAB/song_speech_Mandarin/data/pitch delete zero/"  # Replace with CSV output file path
```
You may also need to modify **lines 34 to 35** if your file naming rules are not consistent with mine.

The elicited F0 is stored under ***data -> pitch delete zero***

## F0 reprocessed
We can compute pitch stability based on the files from pitch delete zero using **ft_deltaf0.m**

You can **clone this repository** and **run it directly without any modifications**. It will automatically read data from data -> pitch delete zero and save the processed files to data -> pitch processed.

## Compute effect size
**Clone this repository**, find ***data-> pitch processed -> effectsize_f0.m***, run it directly. And you will get **f0_cohend_results.csv** and **f0_extra_results.csv**

It should be noticed that you may need to change N=14 in **line 1** based on number of your data pairs

And please keep **exactCI.m** in the **same folder with effectsize_f0.m**. 

The effect size for computing pitch stability and IOI is calculated in the same way. The code and CSV results have been placed in the "pitch processed" and "IOI" folders, respectively.

And I dragged all the generated effect size results to ***data -> effectsize*** folder for future plotting.

## Plotting acoustic features
Run **plot_acoustic features.R**, three points need to be modified：

(1) Line 8: Modify the path to the location where the ***pitch processed folder*** is stored on your local computer.
```R
folder_path <- "/Users/betty/Desktop/manyvoices3/data/pitch processed/" 
```
（2） Line 93: Modify the path to the location where ***interval_Englishpilot.csv*** is stored on your local computer.
```R
# Set the path where the interval file is located
data4 <- read.csv("/Users/betty/Desktop/manyvoices3/data/interval_Englishpilot.csv")
```
（3）Line 143: Modify the path to the location where you want to save the images on your local computer.
```R
ggsave("/Users/betty/Desktop/manyvoices3/data/combined_plot_acoustic features_English.png", plot = combined_plot, width = 12, height = 6)
```
## Plotting effect size
Run ***plot_cohend.R***, change the file paths from **line 7 to line 23** to the corresponding locations where the files are stored on your local computer.
```R
effectsize_f0 <- read_csv("./f0_cohend_results.csv") %>%
  mutate(Feature = "Pitch Height")
effectsize_f0stab <- read_csv("./f0stab_cohend_results.csv") %>%
  mutate(Feature = "Pitch Stability")
effectsize_IOI <- read_csv("./IOI_cohend_results.csv") %>%
  mutate(Feature = "IOI Rate")

combined_data <- bind_rows(effectsize_f0, effectsize_f0stab, effectsize_IOI)
cohen_data <- combined_data %>%
  select(Feature, Cohens_d)
print(cohen_data)

CI_f0 <- read_csv("./f0_extra_results.csv") %>%
  mutate(Feature = "Pitch Height")
CI_f0stab <- read_csv("./f0stab_extra_results.csv") %>%
  mutate(Feature = "Pitch Stability")
CI_IOI <- read_csv("./IOI_extra_results.csv") %>%
  mutate(Feature = "IOI Rate")
```
