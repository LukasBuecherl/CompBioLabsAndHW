cut -f 2-4 -d , PredPreyData.csv | head -n 1 > PredPreyData_modified.csv
cut -f 2-4 -d , PredPreyData.csv | tail >> PredPreyData_modified.csv 
