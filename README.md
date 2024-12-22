# Dose Calculator

The Dose Calculator is a software for calculation of different values used in the everyday work of R&D and QC departments. This software is developed using Python 3.10.4, QML 6.8.1 and SQLite3.

GitHub: https://github.com/hutouski-aliaksei/DoseCalculatorModern

**Also Android version is available:**
https://github.com/hutouski-aliaksei/DoseCalculatorAndroid

The Dose Calculator has five different modes, there are:
1.	DER calculation with known source, distance and shielding.
2.	Distance calculation with known DER, source and shielding.
3.	Total counts conversion between static and dynamic experiments.
4.	Alarm limits calculation with known background count rate, FAR and search window time.
5.	Background count rates calculation for alarm limits with known FAR and search window time.

Kerma calculated from photons flux using ICRP PUBLICATION 119, Annex I.
For kerma-to-dose conversion used standard ISO 4037-3:2019, Table 14.
Neutron fluence-to-dose coefficients from ISO 8529-1:2001, Table 1.
For attenuation calculations used data from NIST (https://www.nist.gov/pml/x-ray-mass-attenuation-coefficients).

**NOTE!!! Database name must be DoseCalculator_DB.db, and it must be in the same folder as DoseCalculator 0.2.5.exe. When there is no database found, popup message will be shown, and only Dynamic to Static and Alarm limits calculations will be available.**
 
## 1.	DER calculation


 <img width="962" alt="sceen 1" src="https://github.com/user-attachments/assets/100fbf1a-d4fd-4f9f-b286-56af16125cad" />

***

  1.	You can choose an existing source from “Source catalogue”. All source parameters will be automatically filled in corresponding fields: half-life, production date, original activity. Current activity for current date will be also calculated.
  2.	It is also possible to fill all fields manually, except half-life, it loads from database in correspondence with the source chosen.
  3.	All changes in source parameters will entail recalculation of current activity.
  4.	In the list Material you can chose shielding material. If there is no any shielding you should select Air. Air shielding applied automatically, distance for air shield is calculated as difference between distance to the source and thickness of the shield.
  5.	In the Thickness field it is possible to enter the thickness of the shield in centimeters.
  6.	Field Distance is for the distance from the source in centimeters.
  7.	Using list Dose type you can choose ambient (H*) or personal (Hp10) dose rate.
  8.	All changes in Shield parameters section will entail to recalculation of DER and Flux.
  9.	There are data about calculated DER and Flux in the right top corner of the software.
  10.	In the right bottom corner, there are data about gamma lines, yields, DERs and fluxes of corresponding lines.
 
## 2.	Distance calculation with known DER

  1.	For distance calculation you need at first to fill all data about the source.
  2.	Then enter desired DER in µSv/h in the field Desired DER. You must enter the value slowly, number by number, because calculation may take some time. Calculation process is accompanied by animation.
  3.	After calculation is finished necessary distance will be shown in the field Distance in centimeters.
 
## 3.	Dynamic to static total counts conversion


 <img width="962" alt="screen 2" src="https://github.com/user-attachments/assets/fdde820e-cdb2-473b-82be-501bb3470515" />

***

  1.	In the section Dynamic to Static, you can calculate transfer coefficient between dynamic (passing by) and static measurements. It is assumed, that the distance from source to detector (minimal distance in case of dynamic measurement) and experiment time in dynamic and static experiments are the same. It means that thit coefficient shows relation between total counts registered by static detector and total counts registered by moving detector for the same time.
  2.	In the field First to Second ratio, you can find relation of total counts registered between two dynamic experiments, but with different conditions. It is useful when it is necessary to compare or recalculate the sensitivity of detectors according to different standards or circumstances.

**NOTE!!! Air shielding doesn’t took into account in that case.**
 
## 4.	Alarm limits calculation

  1.	Here you can calculate necessary counts value for searching device to alarm according to background count rate and false alarm rate.
  2.	In the field Background must be count rate of the background in CPS.
  3.	FAR field is for the false alarm rate per second. For example, if the standard says, that it should be no more than 1 false alarm per 10 hours, you should set this field to 1/(10*3600) = 0.000028.
  4.	In the Experiment time field, you need to write search window time in seconds.
  5.	Press Calculate to perform alarm limit calculation. The result will be in the row Limit. Calculation process is accompanied by animation.
 
## 5.	Background CPS calculation for different alarm limits

  1.	For this calculation FAR and time values are taken form the section Alarm limit.
  2.	In Max limit field you need to set the maximum limit for which it is necessary to calculate corresponding background CPS.
  3.	Press Calculate to perform calculation. Calculation process is accompanied by animation.
  4.	The result will be shown in the field Background. Index of the CPS value corresponds to the value of the limit. That is, first value for limit equal to 1, second for the limit equal to 2 and so on. The values could be copied to the clipboard by clicking on them.

