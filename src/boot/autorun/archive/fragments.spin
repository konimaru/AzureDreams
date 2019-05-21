PUB null
PRI response_eq(signature, timeout)

  repeat strsize(signature)                             ' check incoming string
    if byte[signature++] <> comm.rxtime(timeout)        ' response against our
      return{FALSE}                                     ' signature

  return TRUE                                           ' match
  
DAT