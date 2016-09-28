
invCreateWrapper <- 
  function(
    w_evalid,          # id for evaluation (01, 02, ...) (character)
    w_minfileid,       # file to start reading (integer)
    w_maxfileid,       # file to stop reading (integer)
    w_nidgrp,          # number of file chunks (integer)
    w_invcolid,        # col names to read from source (character)
    w_timingfilename,  # name for timing txt file, will postfix with w_evalid (character)
    w_newcolid,        # new col names (character)
    w_convcol,         # names of col to convert (character)
    w_convcolfun,      # conversion function (character)
    w_keycol,          # col to use for key (character)
    w_savefile,        # name for object RData file, will postfix with w_evalid (character)
    w_setkey=FALSE,    # setkey on data.table? (logical)
    w_writeout=FALSE   # write txt and RData files? (logical)
  ) {
    
    # future change: group all writes and save to single block
    
    if (w_writeout) {
      # directory for .txt and .RData writing
      w_datapath <- file.path(
        g_rootdir, 
        g_username, 
        g_srvrdir
      )
      
      # full path for timing file
      timefile <- file.path(w_datapath, paste(w_timingfilename, w_evalid, '.txt', sep=''))
    }
    
    ##################################################
    # IMPORT TXT FILES INTO R
    ##################################################
    start <- Sys.time()
    
    # reminder to rename obj when reading into new session using load()
    renamedt <- importInvFile(w_minfileid, w_maxfileid, w_nidgrp)
    
    stop <- Sys.time()
    
    if (w_writeout) {
      # first call, write new txt file:
      invTimer(start, stop, paste('IMPORT_', w_evalid, ':', sep=''), timefile, FALSE)
    }
    
    ##################################################
    # UPDATE data.table OBJECT
    ##################################################
    start <- Sys.time()
    
    # renamedt updated by reference, no copy
    updateInvDT(rawdt=renamedt, newcolid=w_newcolid, convcol=w_convcol, convcolfun=w_convcolfun, keycol=w_keycol)
    
    stop <- Sys.time()
    
    if (w_writeout) {
      # append to existing txt file:
      invTimer(start, stop, paste('UPDATE_', w_evalid, ':', sep=''), timefile, TRUE)
    }
    
    
    ##################################################
    # SAVE data.table OBJECT
    ##################################################
    start <- Sys.time()
    
    if (w_writeout) {
      # write renamedt to disk
      save(renamedt, file=file.path(w_datapath, paste(w_savefile, w_evalid, '.RData', sep='')))
    }
    
    stop <- Sys.time()
    
    if (w_writeout) {
      # append to existing txt file:
      invTimer(start, stop, paste('SAVE_', w_evalid, ':', sep=''), timefile, TRUE)
    }
    
    if (!w_writeout) {
      return(renamedt)
    }
  }
