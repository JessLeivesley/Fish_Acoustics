`data/` contains raw data for the analysis.

The raw data is contained in this folder as an RDS file. This is loaded into the R project in code section 01 viz. 

Below is a description of each of the columns in the data:
dateTimeSample - Date and time that sampling took place
fishNum - unique individual identifier; LT prefix = lake trout, SMB prefix = smallmouth bass
spCode - unique species identifier; 81 = LT, 316 = LWF
totalLength - total length (nose to tip of tail) of the fish in mm 
forkLength - length of fish from nose to base of tail
weight - mass of fish in grams
girth - circumference of the fish at the widest point in mm
dorsoLatHeight - length between top of the fish and the lateral line in mm
clipTag - does the fish have a fin clip or PIT tag; Y - yes, N - no
sex - sex of the fish; 1 - male, 2 - female
mat - maturity status of the fish; 1 - immature, 2 - mature
airbladderTotalLength - length of the air bladder in mm
airBladderWidth - width of the air bladder mm
Region_name - unique identifier of region; A region is a group of pings that Echoview (the processing software) can confidently assign to one individual.
FishTrack - ping number within the region
MaxTSdiff - difference between the max and min target strength across all frequencies
Ping_time - time that the ping was emitted from the transducer
deltaRange - change in depth from the previous ping; positive values = deeper, negative values = shallower
deltaMinAng - change in minor angle from the previous ping
deltaMaxAng - change in maximum angle from the previous ping
aspectAngle - orientation of the fish relative to the beam; positive = head up, negative = head down
Target_range - the distance from the transducer to the fish
Angle_minor_axis - angle of the fish from the minor axis (horizontal axis)
Angle_major_axis - angle of the fish from the major axis (vertical axis)
Distance_minor_axis - distance of the fish from the minor axis in meters
Distance_major_axis - distance of the fish from the major axis in meters
StandDev_Angles_Minor_Axis - standard deviation of the minor axis angle within the single pulse
StandDev_Angles_Major_Axis - standard deviation of the major axis angle within the single pulse
Target_true_depth - corrected depth of the target in meters, corrected for the depth of the transducer
pingNumber - the number of the ping from the start of the experiment
Ping_S - ping start number of the transect
Ping_E - ping end number of the transect
Num_targets - the number of single targets within the domain/transect
TS_mean - mean target strength in the region across all frequencies
Target_range_mean - The mean range of the target within the region
Speed_4D_mean_unsmoothed - speed of the fish in the region
Fish_track_change_in_range - change in range of the fish during the region
Time_in_beam - the duration of time that the fish spent in the beam during the region
Distance_3D_unsmoothed - distance travelled by the fish in the region
Thickness_mean - the mean thickness of the domain
Exclude_below_line_range_mean - the mean range of the exclude-below line over the domain 
Target_depth_mean - mean depth of the fish in the region
Target_depth_max - maximum depth of the fish in that region
Target_depth_min - minimum depth of the fish in that region
Fish_track_change_in_depth - change in depth over the region
Region_bottom_altitude_min - the minimum altitude (m) of the region's bottom boundary above the exclude below line 
Region_bottom_altitude_max - the maximum altitude (m) of the region's bottom boundary above the exclude below line 
Region_bottom_altitude_mean - the mean altitude (m) of the region's bottom boundary above the exclude below line 
Region_top_altitude_min - the minimum altitude (m) of the region's top boundary above the exclude below line 
Region_top_altitude_max - the maximum altitude (m) of the region's top boundary above the exclude below line 
Region_top_altitude_mean - the mean altitude (m) of the region's top boundary above the exclude below line 
F45:F170 - Target strength at each frequency (dB)
Region - fish number and region name to create unique regions across individual fish
species  - short character species identifier. LT = lake trout, SMB = smallmouth bass. 





