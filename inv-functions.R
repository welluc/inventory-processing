##################################################
# function definitions:
##################################################

importInvFile <- function(minfileid, maxfileid, nidgrp, invcolid=g_invcol, datapath=g_datapath, filename=g_filename) {
  
  # cols in alphabetical order so sort invcolid first
  rbindLoop <- function(dt, filenum, rbl_datapath=datapath, rbl_filename=filename, rbl_colname=sort(invcolid)) {
    
    if (length(filenum) > 0 & nrow(dt) > 0) {
      filenum <- sort(filenum)
      maxfilenum <- max(filenum)
      j <- 1
      
      # only execute loop if still have files to read
      while (j <= length(filenum)) {
        i <- filenum[j]
        
        tempdt <- fread(
          input=file.path(rbl_datapath, rbl_filename[i]),
          header=TRUE,
          verbose=FALSE,
          showProgress=FALSE,
          select=rbl_colname
        )
        
        dt <- rbind(dt, tempdt)
        
        j <- j + 1
      }
      
      return(dt)
      
    } else {
      return(NA)
    }
  }
  
  id <- as.integer(seq(minfileid, maxfileid, length.out=nidgrp))
  
  # cols in alphabetical order so sort invcolid first
  foo <- function(b, fooid=id, foodatapath=datapath, foofilename=filename, fooinvcolid=sort(invcolid)) {
    branchdt <- fread(
      input=file.path(foodatapath, foofilename[fooid[b]]),
      header=TRUE,
      verbose=FALSE,
      showProgress=FALSE,
      select=fooinvcolid
    )
    branchdt <- rbindLoop(branchdt, filenum=(fooid[b]+1):(fooid[b+1]-1))
    return(branchdt)
  }
  
  
  cl <- makeCluster(4)
  registerDoParallel(cl)
  tempbranchdt <- foreach(b=1:(length(id)-1), .packages='data.table') %dopar% {
    foo(b)
  }
  stopCluster(cl)
  
  tempbranchdt <- rbindlist(tempbranchdt)
  return(tempbranchdt)
}

invTimer <- function(t1, t2, desc, outfile, appendflag) {
  cat(
    '\n\n\n', 
    paste(
      desc,
      '\n  Start time = ', t1, 
      '\n  End Time = ', t2,
      '\n  Elapsed time = ', t2 - t1,
      sep=''
    ), 
    file=outfile,
    append=appendflag
  )
}
