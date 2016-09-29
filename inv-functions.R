##################################################
# function definitions:
##################################################

importInvFile <- function(minfileid, maxfileid, nidgrp, invcolid=g_invcol, datapath=g_datapath, filename=g_filename) {
  
  # cols in alphabetical order so sort invcolid first
  rbindLoop <- function(dt, filenum, rbl_datapath=datapath, rbl_filename=filename, rbl_colname=sort(invcolid), maxbytes=3*1024^3, bytemargin=1024^2) {
    
    objsize <- object.size(dt)  # in bytes
    if (length(filenum) > 0 & nrow(dt) > 0) {
      filenum <- sort(filenum)
      maxfilenum <- max(filenum)
      j <- 1
      
      # only execute loop if still have files to read
      # and next read will not go over memory bound
      while (j <= length(filenum) & objsize <= (maxbytes - bytemargin)) {
        i <- filenum[j]
        cat(
          'i = ', i, 
          ' and object size = ', format(objsize, units='MB'),
          '\n')
        
        tempdt <- fread(
          input=file.path(rbl_datapath, rbl_filename[i]),
          sep='|',
          header=TRUE,
          verbose=FALSE,
          showProgress=FALSE,
          select=rbl_colname
        )
        
        objsize <- objsize + object.size(tempdt)
        
        ifelse(
          objsize <= maxbytes, 
          dt <- rbind(dt, tempdt), 
          return(cat('cannot rbind on iteration i = ', i, 'because objsize > ', maxbytes, '\n'))
        )
        
        j <- j + 1
      }
      
      if (i==maxfilenum) {
        cat('complete\n')
        return(dt)
      } else {
        cat('not complete: stopped on i = ', i, '\n')
        return(dt)
      }
      
    } else {
      cat('dt has 0 rows or zero files to be read and bound')
      return(FALSE)
    }
  }
  
  id <- as.integer(seq(minfileid, maxfileid, length.out=nidgrp))
  
  # cols in alphabetical order so sort invcolid first
  foo <- function(b, fooid=id, foodatapath=datapath, foofilename=filename, fooinvcolid=sort(invcolid)) {
    branchdt <- fread(
      input=file.path(foodatapath, foofilename[fooid[b]]),
      sep='|',
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
  
  tempbranchdt <- do.call(rbind, tempbranchdt)
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

updateInvDT <- function(rawdt, newcolid, convcol, convcolfun, keycol, invcolid=g_invcol, convflag=g_convflag) {
  
  # note: rawdt is pointer to supplied dt obj
  # so, after updateInvDT evaluates, updates will
  # be reflected in supplied rawdt AND supplied dt obj
  # thus, either name can be used downstream (1 object, 2 names)
  
  setcolorder(rawdt, invcolid)
  colnames(rawdt) <- newcolid
  
  # to stay within memory bound, loop 1 column at a time
  # convert each convcol using corresponding convcolfun 
  # will update without copy
  if (convflag) {
    if (length(convcol) > 0) {
      funi <- 1
      for (col in convcol) {
        FUN <- match.fun(convcolfun[funi])
        rawdt[, (col) := FUN(rawdt[[col]])]
        funi <- funi + 1
      }
    }
  }
  
  # no return because updates done by reference
}
