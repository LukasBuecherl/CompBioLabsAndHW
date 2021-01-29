grep Swallow BirdList.txt | grep -v Swallow-tail | tail +2
grep Swallow BirdList.txt | grep -v Swallow-tail | tail +2 | wc -l

cut -f 2-4 -d , PredPreyData.csv > PredPreyData_cut.csv 
cut -f 2-4 -d , PredPreyData.csv | tail 

cut -f 2-4 -d , PredPreyData.csv | head -n 1 > PredPreyData_modified.csv
cut -f 2-4 -d , PredPreyData.csv | tail >> PredPreyData_modified.csv 
