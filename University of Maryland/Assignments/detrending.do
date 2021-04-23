log using question2.log, replace

use "C:\Users\dray\Downloads\minwage.dta"

regress gwage232 t
predict yresid, resid
regress gmwage t
predict residx, resid
regress gcpi t
predict wresid, resid
regress yresid residx wresid
regress gwage232 l.gmwage gcpi t
regress gwage232 gmwage gcpi t
regress gwage232 gmwage gcpi, robust

regress gwage232 t
predict yresid, resid
regress gmwage t
predict residx, resid
regress gcpi t
predict wresid, resid
regress yresid residx wresid

regress gwage232 gcpi gmwage gmwage_1 gmwage_2 gmwage_3 gmwage_4 gmwage_5 gmwage_6 gmwage_7 gmwage_8 gmwage_9 gmwage_10 gmwage_11 gmwage_12
regress gwage232 t
predict yresid, resid
regress gcpi t
predict wresid, resid
regress gmwage t
predict residx_0, resid
regress gmwage_1 t
predict residx_1, resid
regress gmwage_2 t
predict residx2, resid
regress gmwage_3 t
predict residx3, resid
regress gmwage_4 t
predict residx4, resid
regress gmwage_5 t
predict residx5, resid
regress gmwage_6 t
predict residx6, resid
regress gmwage_7 t
predict residx7, resid
regress gmwage_8 t
predict residx8, resid
regress gmwage_9 t
predict residx9, resid
regress gmwage_10 t
predict residx10, resid
regress gmwage_11 t
predict residx11, resid
regress gmwage_12 t
predict residx12, resid
regress yresid wresid residx_0 residx_1 residx2 residx3 residx4 residx5 residx6 residx7 residx8 residx9 residx10 residx11 residx12
