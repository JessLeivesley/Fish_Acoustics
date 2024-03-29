`figs/`

Static visualizations generated during the pipeline go here.

* Every file should be a graphic format (.png, .jpg, .pdf, .svg...)
* Code that generates figures does not go here; it should be in a pipeline script


Analyses of the Figures from Raw data to aid in Explaninability:
1. figs/01_raw_data_viz/freq_response_avg_per_individual.png
   A noticebale cross-over of the mean-of-means at Frequency 100.  Beyond 100, SMB has higher Target strength than LT.
2. figs/01_raw_data_viz/normalized_freq_response_all_reps_mean_CI.png
   Each individual frequency is normalized by the (weighted) mean of that frequency across all samples at that frequency.
3. figs/01_raw_data_viz/normalized_freq_response_avg_per_individual.png
   Each individual frequency is normalized first by the mean across samples per individual and then by the mean of the individuals.
   Noticeable cross-over between SMB and LT again at ~100.

   Take-aways from visualizations of the raw-data.
The mean of the means show a seapartaion of the target strengths between the two species. Specially after the cros--over point, the separation of the target strengths can be used as a null model.
To target the explainnability of the model and increase the accuracy of the model, (is the model picking up on the how the target strengths are separated), chunks of frequencies were the separation is highest could be used as input. Intermediate regios around the cross-over point may be convoluting the signal strengths.
