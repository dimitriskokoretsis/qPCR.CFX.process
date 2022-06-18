q <- data.table::fread("test_data/admin_2021-02-19 09-57-01_BR002605 -  Quantification Amplification Results_SYBR.csv")[,!c(1,2)] |>
  as.matrix()
# Aiming for Cq(A1)=25.31687, Cq(A2)=25.18056

plot(1:40,q[,A1])
plot(1:40,q[,A2])

ground.phase.ends <- apply(X=q,MARGIN=2,FUN=.ground_phase_end)

exp.phase.ends <- mapply(FUN=function(x,ground.phase.ends) {
  .exponential_phase_end(fluorescence=x,exp.start=ground.phase.ends)
  },
  x = q |> as.data.frame() |> as.list(),
  ground.phase.ends = ground.phase.ends)
