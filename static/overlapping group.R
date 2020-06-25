library(data.table)

testDT <- structure(list(ID = c(54L, 57L, 58L, 60L, 61L, 62L, 64L, 180L
), Age = c(14219L, 13989L, 13883L, 13482L, 13403L, 13383L, 13340L, 
           13994L), AgeMax = c(14343L, 14087L, 13972L, 13540L, 13465L, 13442L, 
                               13407L, 14083L), AgeMin = c(14095L, 13891L, 13794L, 13424L, 13341L, 
                                                           13324L, 13273L, 13905L)), row.names = c(NA, -8L), class = c("data.table", 
                                                                                                                       "data.frame"))
setDT(testDT)

testDT[order(AgeMin)
      ][, .(AgeMin=min(AgeMin), AgeMax=max(AgeMax)),
       by=.(group=cumsum(c(1, tail(AgeMin, -1) > head(AgeMax, -1))))]

testDT[order(AgeMin)
      ][, .(AgeMin=min(AgeMin), AgeMax=max(AgeMax)),
       by=.(group=cumsum(c(1, tail(AgeMin, -1) > head(AgeMax, -1) | tail(AgeMax, -1) < head(AgeMin, -1))))]

