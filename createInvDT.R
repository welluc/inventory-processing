# simpler version of invCreateWrapper.R
# might replace that version altogether
# source inv-pkgs.R and inv-functions.R first

createInvDT <- 
  function(
    w_invcolid,
    w_newinvcolid,
    w_minfileid=1,
    w_maxfileid,
    w_nidgrp=20,
    w_dbpath,
    w_savefile,
    w_writeout=TRUE
  ) {
    
    # import from disk:
    testdt <- importInvFile(
      w_minfileid, w_maxfileid, w_nidgrp,
      invcolid=w_invcolid,
      datapath=w_dbpath,
      filename=list.files(w_dbpath, pattern='.txt')
    )
    
    # reorder cols:
    setcolorder(testdt, w_invcolid)
    
    # rename cols:
    setnames(testdt, colnames(testdt), w_newinvcolid)
    
    
    # output:
    if (w_writeout) {
      save(testdt, file=w_savefile)
      cat(w_savefile, 'complete\n')
    } else {
      return(testdt)
    }
  }
