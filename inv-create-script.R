##################################################
# Inventory Create Script
##################################################

source('inv-pkgs.R')
source('inv-global-vars.R')
source('inv-functions.R')
source('invCreateWrapper.R')

inventoryAnalysisCreateWrapper(
  w_evalid='01',
  w_minfileid=1,
  w_maxfileid=776/4 + 1,  # necessary bc of loop logic in rbindloop. look at creation of b and looping over b to understand.
  w_nidgrp=20,
  w_invcolid=g_invcol,
  w_timingfilename='CreateInvTiming',
  w_newcolid=g_newcolname,
  w_convcol=g_convcolname,
  w_convcolfun=g_convcolfunname,
  w_keycol=g_keycolname,
  w_savefile='invdt',
  w_writeout=TRUE
)

inventoryAnalysisCreateWrapper(
  w_evalid='02',
  w_minfileid=776/4 + 1,
  w_maxfileid=2*776/4 + 1,
  w_nidgrp=20,
  w_invcolid=g_invcol,
  w_timingfilename='CreateInvTiming',
  w_newcolid=g_newcolname,
  w_convcol=g_convcolname,
  w_convcolfun=g_convcolfunname,
  w_keycol=g_keycolname,
  w_savefile='invdt',
  w_writeout=TRUE
)

inventoryAnalysisCreateWrapper(
  w_evalid='03',
  w_minfileid=2*776/4 + 1,
  w_maxfileid=3*776/4 + 1,
  w_nidgrp=20,
  w_invcolid=g_invcol,
  w_timingfilename='CreateInvTiming',
  w_newcolid=g_newcolname,
  w_convcol=g_convcolname,
  w_convcolfun=g_convcolfunname,
  w_keycol=g_keycolname,
  w_savefile='invdt',
  w_writeout=TRUE
)

inventoryAnalysisCreateWrapper(
  w_evalid='04',
  w_minfileid=3*776/4 + 1,
  w_maxfileid=776,  # read stops at (w_maxfileid - 1) and there are 775 files
  w_nidgrp=20,
  w_invcolid=g_invcol,
  w_timingfilename='CreateInvTiming',
  w_newcolid=g_newcolname,
  w_convcol=g_convcolname,
  w_convcolfun=g_convcolfunname,
  w_keycol=g_keycolname,
  w_savefile='invdt',
  w_writeout=TRUE
)
