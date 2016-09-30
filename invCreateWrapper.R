invCreateWrapper <- 
  function(
    w_evalid,          # id for evaluation (01, 02, ...) (character)
    w_minfileid,       # file to start reading (integer)
    w_maxfileid,       # file to stop reading (integer)
    w_nidgrp,          # number of file chunks (integer)
    w_invcolid,        # col names to read from source (character)
    w_timingfilename,  # name for timing txt file, will postfix with w_evalid (character)
    w_newcolid,        # new col names (character)
    w_convflag,        # flag to control col conversion in updateInvDT (logical)
    w_convcol,         # names of col to convert (character)
    w_convcolfun,      # conversion function (character)
    w_savefile,        # name for object RData file, will postfix with w_evalid (character)
    w_writeout=FALSE   # write txt and RData files? (logical)
  ) {
    
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
    
    start_import <- Sys.time()
    # reminder to rename obj when reading into new session using load()
    #renamedt <- importInvFile(w_minfileid, w_maxfileid, w_nidgrp)
    renamedt <- importInvFile(w_minfileid, w_maxfileid, w_nidgrp, invcolid=w_invcolid)
    stop_import <- Sys.time()
    
    ##################################################
    # UPDATE data.table OBJECT
    ##################################################
    
    setcolorder(renamedt, w_invcolid)
    setnames(renamedt, old=w_invcolid, new=w_newcolid)
    
    # to stay within memory bound, loop 1 column at a time
    # convert each convcol using corresponding convcolfun 
    # will update without copy
    if (w_convflag & (length(w_convcol) > 0)) {
      funi <- 1
      for (col in w_convcol) {
        FUN <- match.fun(w_convcolfun[funi])
        renamedt[, (col) := FUN(renamedt[[col]])]
        funi <- funi + 1
      }
    }
    
    ##################################################
    # SAVE data.table OBJECT
    ##################################################

    if (w_writeout) {
      # write renamedt to disk
      start_save <- Sys.time()
      save(renamedt, file=file.path(w_datapath, paste(w_savefile, w_evalid, '.RData', sep='')))
      stop_save <- Sys.time()
      
      # write new timing file:
      invTimer(start_import, stop_import, paste('IMPORT_', w_evalid, ':', sep=''), timefile, FALSE)
      # append to existing timing file:
      invTimer(start_save, stop_save, paste('SAVE_', w_evalid, ':', sep=''), timefile, TRUE)
      
      # print 'complete' message
      return(cat('complete\n'))
    } else {
      return(renamedt)
    }
  }
