# [Many Voices 3: Acoustic relationships between song and speech across languages ](https://rr.peercommunityin.org/articles/rec?id=961)

This repository contains data, code, and analysis instructions used in a Programmatic Registered Report. Programmatic Registered Reports are a new form of research where multiple journal articles are published all sharing a single peer-reviewed Stage 1 Registered Report protocol (https://rr.peercommunityin.org/PCIRegisteredReports/help/guide_for_authors#h_52492857233251613309610581). 

This "Many Voices 3" Programmatic Registered Report will ultimately result in up to 27 different articles, representing song/speech data from up to 26 different locations/languages and one meta-analyses across all languages. This repository will continue to be updated as each dataset is analysed and each article published. Currently, the repository contains data/code for the following items, which have completed peer review:

**0) Stage 1 protocol** (this is the main protocol on which all articles will be based): Savage, P. E., Jia, Z., Ozaki, Y., Pavlovich, D., Purdy, S., Ampiah-Bonney, A., Arabadjiev, A., Arnese, F., Bamford, J., Barbosa, B. S., Beck, A.-K., Cabildo, A., Chiba, G., Dabaghi Varnosfaderani, S., Echim, S., Fujii, S., Gabriel, S., Grassi, M., Guiotto Nai Fovino, L., Hajič jr., J., Hartmann, M., Hansen, N. C., He, Y., Kolios, S., Krzyżanowski, W., Kuikuro, U., Kurdova, D., Liu, F., Loui, P., Mikova, Z., Moya, D., Natsitsabui, R., Niiranen, M., Nguqu, N., Nuska, P., Nweke, F. E., Opondo, P., Parkinson, H., Parselelo, M. L., Perry, G., Pfordresher, P. Q., Podlipniak, P., Popescu, T., Ross, R. M., Shi, Z., Silva-Zurita, J., Soto-Silva, I., Štěpánková, B., Thompson, W. F., Vaida, S., Vanden Bosch der Nederlanden, C. (In Principle Accepted). A Programmatic Stage 1 Registered Report of global song-speech relationships replicating and extending Ozaki et al. (2024) and Savage et al. (2025). Peer Community In Registered Reports. https://doi.org/10.31234/osf.io/c2dba_v6 [editorial recommendation and peer review: https://rr.peercommunityin.org/articles/rec?id=961] 

**1) Mandarin speakers from Auckland**: Jia, Z., Purdy, S., & Savage, P. E. (2026 [In press]). Higher pitch, slower tempo, and greater stability in singing than in conversation among Mandarin speakers in Auckland: A Registered Report replicating Ozaki et al. (2024). Peer Community Journal, 6. https://doi.org/10.24072/pcjournal.698  [Peer Community In Registered Reports editorial recommendation and Stage 2 peer review: https://doi.org/10.24072/pci.rr.101216]

To reproduce the analyses for any of these articles, use the code below, but replace the data sub-directory with the one corresponding to the article in question (e.g., replacing "manyvoices3_pilot" with "Mandarin_Auckland" to reproduce the analyses in Jia et al., 2026). All articles use the same standard analysis code/pipeline below for confirmatory analyses (testing three hypotheses about differences in pitch height, pitch stability, and temporal rate between song and speech). However, each paper may also include separate exploratory analyses (detailed in the folder labeled "Exploratory analysis").

The full confirmatory analysis requires four programs - please download and install them if you haven't already. Three (R, Python, Praat) are free and open source; one (Matlab) is proprietary with various trial and licensing options.
Praat: https://www.fon.hum.uva.nl/praat/
R: https://www.r-project.org/
Python: https://www.python.org/ 
Matlab: https://au.mathworks.com/products/matlab.html  
Note that the key figures and results reported in the papers can be reproduced using only R and the provided output data files from the other analysis programs. To easily reproduce all results, clone this GitHub repository to your local computer, replace "/Users/psav050/Documents/GitHub/manyvoices3" in line 5 in !JiaEtAlMV3.R with the directory of this cloned repository and then run the following command in R:
```R
setwd('/Users/psav050/Documents/GitHub/manyvoices3')
source('!JiaEtAlMV3.R')
```


<p align="center">
  <img src="https://github.com/user-attachments/assets/6c7f8e7f-5d54-4f4a-a534-a25c06b1ca99" width="400">
  <br>
  <em>Figure by Nelson Shi</em>
</p>



## 📰 News
**- 2026 Mar ??.** Our first full (Stage 2) journal article (analysing Mandarin speakers from Auckland) will be published in Peer Community Journal! (https://doi.org/10.24072/pcjournal.698)

**- 2026 Feb 13.** Our Registered Report analysing Mandarin speakers from Auckland completed Stage 2 peer review and was recommended for publication! (https://doi.org/10.24072/pci.rr.101216)

**- 2025 May 9.** Our Stage 1 Registered Report protocol received In Principle Acceptance! (https://rr.peercommunityin.org/articles/rec?id=961)

**- 2025 Feb 17.** Our Stage 1 Registered Report protocol is available on PsyArXiv (Savage et al., 2025, https://doi.org/10.31234/osf.io/c2dba)


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
- [Inter rater reliability](#Inter-rater-reliability)

## File naming rules
Please use a consistent naming convention for files, as some scripts rely on the file names to split information. 

The naming convention for files is ***language_location_group_condition.wav***, for example, ***Mandarin_Auckland_C1_conv.wav***. 

If it's an extracted f0 or time interval file, '_f0' or '_IOI' is added at the end.

## Annotation
Audio data is available here: https://osf.io/e4pqv/.

The annotation is divided into two tiers:

1. First tier (interval): label speaker ID (numbers) among units. 

2. Second tier (speaker): label speakers as 1, 2, 3, etc., corresponding to Speaker 1, Speaker 2, Speaker 3, and so on. Since we have three groups, we may all name participants 1-10 across three groups. To make the participants ID continuous, we may rename the ID. For example, if C1 group have 10 participants with ID from 1-10, for R1 group, we may rename them as 11-20. 

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

And you can just modify line35-37 (for assign gender); line 42 (for generating combined whole csv document) line 60-61 (for splited documents) in this .py
```python
#Line 35-37: 
    def assign_gender(speaker_id):
        male_speakers = {2, 4, 6, 7, 10, 11, 19}  # Modify this set if needed
        return "Male" if speaker_id in male_speakers else "Female"
#Line 42
    combined_csv_path = "/Users/betty/Desktop/manyvoices3_pilot/All_Speakers_IOI.csv"
#Line 66-67
    input_txt_file = "/Users/betty/Desktop/manyvoices3_pilot/result_duration_tier_1.txt"
    output_folder = "/Users/betty/Desktop/manyvoices3_pilot/IOI/"
```

The elicited intervals of each speaker is stored under ***data -> IOI***

## Split the audio
Split audio first based on speaker and combine them manually in Praat for future F0 elicitation.

You can find this Praat script in the repository under:

***Tools (elicit intervals and pitch) -> Split_Long_Sound_Files.Praat***

Specify three things in this script: a) input directory b) output directory c)tier number: 2

An example of modifying the run information in Praat script is demonstrated below. 
![image](https://github.com/user-attachments/assets/07185d2d-2585-4641-a1d7-63cd53880522)


And then combine the audio of the same speaker using ***Tools (elicit intervals and pitch) -> concatenate.py***

Before running the script, make sure the required packages are installed.
In your terminal, run the following commands:

```terminal
pip install pydub
brew install ffmpeg
```

These will install pydub (for audio processing) and ffmpeg (for handling audio file formats).

In **concatenate.py**, you need to modify ***line 6 & 7*** for changing the path and ***line 29-32*** for naming the gender 
```python
# Line6-7: Input and output directories
input_folder = '/Users/betty/Desktop/manyvoices3_pilot/split audio/'
output_folder = '/Users/betty/Desktop/manyvoices3_pilot/combined/'

# Line 29-32: Define gender based on speaker number
if speaker_int in [2, 4, 6, 7, 10, 11, 19]: #This is what you need to renumber based on your experiment
   gender = 'M'
else:
   gender = 'F'
```
## F0 elicitation
F0 is extracted based on the pYIN algorithm, estimating one f0 point every 0.005 seconds. 

You can find this Python tool under ***Tools (elicit intervals and pitch) → f0_pYIN.py***.  

In this `.py` file, you only need to modify **lines 60 and 61**:  
```python
# Set input folder containing audio files and output folder for CSV files
input_folder = "/Users/betty/Desktop/manyvoices3_pilot/combined/"  # Replace with your audio file path
output_folder = "/Users/betty/Desktop/manyvoices3_pilot/pitch delete zero/"  # Replace with csv output file path
```
You may also need to modify **lines 34 to 42** if your file naming rules are not consistent with mine.

The elicited F0 is stored under ***data -> pitch delete zero***

## F0 reprocessed
We can compute pitch stability based on the files from pitch delete zero using **ft_deltaf0.m**

Please download **ft_deltaf0.m** and **cwtdiff.m** and drag it into the same folder (Mine is **manyvoices3_pilot**)


## Compute effect size
**Clone this repository**, find ***data-> pitch processed -> effectsize_f0.m***, run it directly. And you will get **f0_cohend_results.csv** and **f0_extra_results.csv**

It should be noticed that you may need to change N=14 in **line 1** based on your number of data pairs

And please keep **exactCI.m** **pb_effectsize.m** in the **same folder with effectsize_f0.m**. 

The effect size for computing pitch stability and IOI is calculated in the same way. The code and CSV results have been placed in the "pitch processed" and "IOI" folders, respectively.

All the generated effect size results are dragged to ***data -> effectsize*** folder for future plotting.

## Plotting acoustic features
Run **plot_acoustic features.R**. This will read files and store outputs in the appropriate files on your computer to reproduce Jia et al.'s analysis. To replicate with other datasets, you'll need to change the folders accordingly：

(1) Line 8: Modify the path to the location where the ***pitch processed folder*** is stored on your local computer.
```R
folder_path <- "./JiaEtAl(MandarinAuckland)/Confirmatory analysis/data/pitch processed zero/" #Modify the path to the location where the ***pitch processed folder*** is stored on your local computer
```
（2） Line 93: Modify the path to the location where the ***IOI files*** are stored on your local computer.
```R
# Set the path where the interval file is located
folder_path2 <- "./JiaEtAl(MandarinAuckland)/Confirmatory analysis/data/IOI/" #Modify the path to the location where the ***IOI files*** are stored on your local computer
```
（3）Line 143: Modify the path to the location where you want to save the images on your local computer.
```R
ggsave("./JiaEtAl(MandarinAuckland)/Confirmatory analysis/figures/combined_plot_acoustic features.png", plot = combined_plot, width = 12, height = 6) #Modify the path to the location where you want to save the images on your local computer
```
## Plotting effect size
Run ***plot_cohend.R***. This will read files and store outputs in the appropriate files on your computer to reproduce Jia et al.'s analysis. To replicate this with new data, make sure you upload the data to GitHub in an appropriate folder and change the file paths from **line 7 to line 23** to the corresponding GitHub URLs where the files are uploaded.
```R
effectsize_f0 <- read_csv(file='https://raw.githubusercontent.com/comp-music-lab/manyvoices3/refs/heads/main/JiaEtAl(MandarinAuckland)/Confirmatory%20analysis/data/pitch%20processed%20zero/f0_cohend_results.csv') %>%
  mutate(Feature = "Pitch Height")
effectsize_f0stab <- read_csv(file='https://raw.githubusercontent.com/comp-music-lab/manyvoices3/refs/heads/main/JiaEtAl(MandarinAuckland)/Confirmatory%20analysis/data/pitch%20processed%20zero/f0stab_cohend_results.csv') %>%
  mutate(Feature = "Pitch Stability")
effectsize_IOI <- read_csv(file='https://raw.githubusercontent.com/comp-music-lab/manyvoices3/refs/heads/main/JiaEtAl(MandarinAuckland)/Confirmatory%20analysis/data/IOI/IOI_cohend_results.csv') %>%
  mutate(Feature = "IOI Rate")

combined_data <- bind_rows(effectsize_f0, effectsize_f0stab, effectsize_IOI)
cohen_data <- combined_data %>%
  select(Feature, Cohens_d)
print(cohen_data)

CI_f0 <- read_csv(file='https://raw.githubusercontent.com/comp-music-lab/manyvoices3/refs/heads/main/JiaEtAl(MandarinAuckland)/Confirmatory%20analysis/data/pitch%20processed%20zero/f0_extra_results.csv') %>%
  mutate(Feature = "Pitch Height")
CI_f0stab <- read_csv(file='https://raw.githubusercontent.com/comp-music-lab/manyvoices3/refs/heads/main/JiaEtAl(MandarinAuckland)/Confirmatory%20analysis/data/pitch%20processed%20zero/f0stab_extra_results.csv') %>%
  mutate(Feature = "Pitch Stability")
CI_IOI <- read_csv(file='https://raw.githubusercontent.com/comp-music-lab/manyvoices3/refs/heads/main/JiaEtAl(MandarinAuckland)/Confirmatory%20analysis/data/IOI/IOI_extra_results.csv') %>%
  mutate(Feature = "IOI Rate")
```
Line 32 **print(CI_data)** is the result including the mean translated Cohen'd to report in your paper (specifically "mu_hat").
You'll also need to report the relative effect size "p<sub>re</sub>" and p value, which you can find in the "_extra_results.csv", where "mu_hat"" refers to the relative effect size. 

## Inter rater reliability
Step 1. Randomly choose a participant ID (using a random number generator; for Zixuan Jia to annotate so you can compare her annotations with yours).

Open the corresponding full TextGrid file of that participant in Praat, select “Extract one tier”, and type “2” to retain only the tier 2 (speaker) annotations while removing tier 1.

Note: You need to send **two (group) recordings**, **two Textgrid (Tier 1 removed)**, tell Jia **participant ID** that you want Jia to annotate, and the **transcription (both singing and conversation)** from that participant (see example in the Inter rater reliability folder) to email **zjia109@aucklanduni.ac.nz** cc Patrick Savage **patrick.savage@auckland.ac.nz**
![image](https://github.com/user-attachments/assets/203eab6f-8141-4af3-bac1-97b34820a70e)

Step 2. Put Jia's Textgrids and your Textgrids into the same folder. Using ***Tools > Get Duration of One Tier. Praat*** to get the intervals from Tier 1. 

Please name Jia's and your Textgrids as **Annotator_Language_Location_Group_Condition.Textgrid** (e.g. Jia_Mandarin_Auckland_C1_conv.Textgrid)
![image](https://github.com/user-attachments/assets/67c8fdfd-cba0-42d6-a0b4-1096e2da0a34)

Step 3. Run the ***Tools > separate annotation.py*** to separate the annotations from target participants based on Condition and Annotator

Modify line 5-6, line 17, line 30. 

```python
input_file = "/Users/betty/Desktop/Rater/result_duration_tier_4.txt"
output_dir = "/Users/betty/Desktop/Rater/"

df_filtered = df[df['IntervalName'] == 19]

out_path = os.path.join(annotator_folder, f"p19_{condition}.csv")
```

Step 4. Run the **plot_irr.R** to calculate the intraclass correlation

This will read files and store outputs in the appropriate files on your computer to reproduce Jia et al.'s analysis. To replicate with other datasets, you'll need to change the folders accordingly, including line 5-6, 8, 12, 15, 28, 54, 63, 65
