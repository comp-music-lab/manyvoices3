# This Praat script will extract duration of One particular Tier based on the TextGrid file
# and save result to a TXT file.
# 
# Original script by Pengfei Shao [feipengshao@163.com], modified and used by Zixuan Jia.  
# Distributed under the GNU General Public License.  
# e.g.
# [dir]-----TextGrid
# -------------+----0001.TextGrid
# -------------+----0002.TextGrid
#
# results:
# 
# fileName,IntervalName,duration
# 0001.TextGrid,sil,0.27958612055419324
# 0001.TextGrid,k,0.12670506851255176
# 0002.TextGrid,a2,0.11022310838083771

# Create a folder and put all the recordings and corresponding TextGrid files inside it.  
# The Praat script should also be placed in the same folder.  
# `input_directory` is the path to the folder (remember to add `/` at the end).  
# `reference_tier` should be changed to the tier you want to extract.  
# `save_result` should be set to a `.txt` format file. 

form Information
	comment Directory path of input files:
	text input_directory input_data\
	comment Target Tier:
	positive reference_tier 1
	comment Path of output result file:
	text save_result result_duration_tier_1.txt
endform

if (praatVersion < 6001)
	printline Requires Praat version 6.0 or higher. Please upgrade your Praat version 
	exit
endif

writeFileLine: save_result$, "fileName", ",", "IntervalName", ",", "duration", ",", "start", ",", "end"
Create Strings as file list: "fileList", input_directory$ + "*.TextGrid"
fileNumber = Get number of strings
for file from 1 to fileNumber
	selectObject: "Strings fileList"
	fileName$ = Get string: file
	Read from file: input_directory$ + fileName$
	objectName$ = selected$ ("TextGrid", 1)
	intervalNums = Get number of intervals: reference_tier
	for interval from 1 to intervalNums
		selectObject: "TextGrid " + objectName$
		start = Get start time of interval: reference_tier, interval
		end = Get end time of interval: reference_tier, interval
		duration = end - start
		intervalName$ = Get label of interval: reference_tier, interval
		if intervalName$ <> ""
			appendFileLine: save_result$, fileName$, ",", intervalName$, ",", duration, ",", start, ",", end 
		endif
	endfor
	selectObject: "TextGrid " + objectName$
	Remove
endfor
selectObject: "Strings fileList"
Remove
exit Done!Thank you!
