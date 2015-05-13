require(raster)
require(rgdal)
library(maptools)


SweB10k<-readShapePoly("data/Sweden_TerritorySWEREFF99 buffer10k.shp", proj4string=CRS("+proj=utm +zone=33 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"))
GreyColors<-colorRampPalette(c("white", "black"),interpolate="spline", space="Lab")( 16 )
RedBlue<-colorRampPalette(c("blue","white", "red"),interpolate="spline", space="Lab")( 16 )

Amp <- raster("data/Amp.tif")
AmpR <- raster("data/Amp richness.tif")
Buf<-raster("data/Buf.tif")
Pel<-raster("data/Pel.tif")

Bir <- raster("data/Bir.tif")
BirR <- raster("data/Bir richness.tif")
Par<-raster("data/Par.tif")
Poe<-raster("data/Poe.tif")

Pae <- raster("data/Pae.tif")
PaeR <- raster("data/Pae richness.tif")
Pap<-raster("data/Pap.tif")
Col<-raster("data/Col.tif")

Mam <- raster("data/MamLnB.tif")
MamR <- raster("data/MamLnB richness.tif")
Alc<-raster("data/Alc.tif")
Eri<-raster("data/Eri.tif")

Opi <- raster("data/Opi.tif")
OpiR <- raster("data/Opi richness.tif")
Opca<-raster("data/Opc.tif")
Lac<-raster("data/Lac.tif")

Odo <- raster("data/Odo.tif")
OdoR <- raster("data/Odo richness.tif")
Lib<-raster("data/Lib.tif")
Neh<-raster("data/Neh.tif")

Vas <- raster("data/Vas.tif")
VasR <- raster("data/Vas richness.tif")
Pan<-raster("data/Pan.tif")
Eup<-raster("data/Eup.tif")

cellwdata<-which(!is.na(Amp[]))

##################
# Shiny server function
shinyServer(function(input, output) {

# Return the requested dataset
datasetInput <- reactive({
     switch(input$dataset,
           "Amphibia" = Amp,
           "Aves" = Bir,
           "Papilionoidea" = Pae,
           "Mammals" = Mam,
           "Odonata" = Odo,
           "Opilions" = Opi,
           "Tracheophyta" = Vas)
     })
richnessInput <- reactive({
     switch(input$dataset,
           "Amphibia" = AmpR,
           "Aves" = BirR,
           "Papilionoidea" = PaeR,
           "Mammals" = MamR,
           "Odonata" = OdoR,
           "Opilions" = OpiR,
           "Tracheophyta" = VasR)
     })

ignorInput <- reactive({
     dataset <- datasetInput()
     rich <- richnessInput()
     if(input$index==TRUE){
                           o<-dataset
                           o<-dataset/rich
                           o[which(dataset[]==0)]<-0
                           dataset<-o
                           }
     if(input$trans==1){
                          dataset.norm<-calc(dataset, fun=function(x){return(x/dataset@data@max)})
                          CI<-1-dataset.norm
       }
     if(input$trans==2){
                          dataset.log<- calc(dataset, fun=function(x){return(log(x+1))})
                          dataset.norm<- dataset.log/dataset.log@data@max
                          CI<-1-dataset.norm
     }

     if(input$trans==3){
       obs50<-input$obs50
                          CI<-calc(dataset, fun=function(x){return(obs50/(x+obs50))})
      }
     return(CI)
  }) # end ignorInput

  spptargetInput<-reactive({
       #############################
       if(input$dataset=="Amphibia"){
         if(input$target=="Common"){
           sppname<-"Bufo bufo"
           spp<-Buf
         } #en Common

         if(input$target=="Rare"){
           sppname<-"Pelophylax lessonae"
           spp<-Pel
         }  #end Rare
       } #end Amphibians
       #############################
       if(input$dataset=="Aves"){
         if(input$target=="Common"){
           sppname<-"Parus major"
           spp<-Par
         } #end Common

         if(input$target=="Rare"){
           sppname<-"Poecile cinctus"
           spp<-Poe
         } # end Rare
       } #end Birds
       ##############################
       if(input$dataset=="Papilionoidea"){
         if(input$target=="Common"){
           sppname<-"Papilio machaon"
           spp<-Pap
         } #end Common
         if(input$target=="Rare"){
           sppname<-"Colias hecla"
           spp<-Col
         } #end rare
       } #end Mammals
       ##############################
       if(input$dataset=="Mammals"){
         if(input$target=="Common"){
           sppname<-"Alces alces"
           spp<-Alc
         } #end Common
         if(input$target=="Rare"){
           sppname<-"Erinaceus europaeus"
           spp<-Eri
         } #end rare
       } #end Mammals
       #############################
       if(input$dataset=="Opilions"){
         if(input$target=="Common"){
           sppname<-"Opilio canestrinii"
           spp<-Opca
         } #en Common

         if(input$target=="Rare"){
           sppname<-"Lacinius horridus"
           spp<-Lac
         } #end Rare
       } #end Opilions
       #############################
       if(input$dataset=="Odonata"){
         if(input$target=="Common"){
           sppname<-"Libellula quadrimaculata"
           spp<-Lib
         } #en Common

         if(input$target=="Rare"){
           sppname<-"Nehalennia speciosa"
           spp<-Neh
         } #end Rare
       } #end Opilions

       #############################
       if(input$dataset=="Tracheophyta"){
         if(input$target=="Common"){
           sppname<-"Parnassia palustris"
           spp<-Pan
         } #en Common

         if(input$target=="Rare"){
           sppname<-"Euphrasia officinalis officinalis"
           spp<-Eup
         }  #end Rare
       } #end Vascular Plants
       return(list(sppname,spp))
  }) # end sppTarget

  sppPAInput<-reactive({
      spp<-spptargetInput()[[2]]
      sppname<-spptargetInput()[[1]]
      obs50<-input$obs502

      if(input$trans2==1){
                          spp.norm<- calc(spp, fun=function(x){return(x/spp@data@max)})
                          spp.psabs<- 1- spp.norm
                          }
      if(input$trans2==2){
                          spp.log<- calc(spp, fun=function(x){return(log(x+1))})
                          spp.norm<- spp.log/spp.log@data@max
                          spp.psabs<- 1-spp.norm
                          }
      if(input$trans2==3){
                          spp.norm<- calc(spp, fun=function(x){return(x/spp@data@max)})
                          spp.psabs<- calc(spp, fun=function(x){return(obs50/(x+obs50))})
                          }
      if(input$trans2==4){
                          spp.norm<- calc(spp, fun=function(x){return(x/spp@data@max)})
                          spp.psabs<- calc(spp, fun=function(x){
                                                return(ifelse(x<obs50, 1, obs50/(x+obs50)))
                                                })
                          }

      return(list(spp.psabs,spp.norm))
  }) # end reactive sppPA

  output$ObsPlot <- renderPlot({
              par(mfrow=c(1,4), oma=c(1,0,1,0))
              dataset <- datasetInput()
              rich <- richnessInput()
               if(input$index==TRUE){
                           o<-dataset
                           o<-dataset/rich
                           o[which(dataset[]==0)]<-0
                           dataset<-o
                       }

              if(input$trans==2) {
                                 #dataset<- calc(datasetInput(), fun=function(x){return(log(x+1))})
                                 dataset<- calc(dataset, fun=function(x){return(log(x+1))})
                                 }
              CI<-ignorInput()

              par(mar=c(3,4,3,5),cex=1)
              plot(dataset, main=ifelse(input$index==TRUE,paste(ifelse(input$trans!=2,"Obs Index","Log(Obs Index)")," for", as.character(input$dataset)),paste(ifelse(input$trans!=2,"No.","Log(No.)"),"of Obs for", as.character(input$dataset))),
                   zlim=c(0,dataset@data@max),
                   legend.width=2, legend.shrink=0.75,legend.mar=3,
                   axis.args=list(cex.axis=0.8))
              plot(SweB10k, add=TRUE)

              par(mar=c(3,4,3,5),cex=1)
              plot(CI,col=RedBlue, main=paste("Ignorance for", as.character(input$dataset)),
                   zlim=c(0,1),
                   legend.width=2, legend.shrink=0.75,legend.mar=3,
                   axis.args=list(cex.axis=0.8))
              plot(SweB10k, add=TRUE)

             spp.psabs<-sppPAInput()[[1]]
             spp.norm<-sppPAInput()[[2]]
               par(mar=c(3,4,3,5),cex=1)
               plot(spp.psabs, col=RedBlue, main=paste("Ps.absence of",spptargetInput()[[1]]),
                       zlim=c(0,1),
                       legend.width=2, legend.shrink=0.75,legend.mar=3,
                       axis.args=list(cex.axis=0.8))
               plot(SweB10k, add=TRUE)

               par(mar=c(3,4,3,5),cex=1)
               fun="prod" #alt "geomean"
               plot(1-spp.psabs, #overlay(1-spp.psabs,1-CI,fun=fun),
                       zlim=c(0,1),col=GreyColors,
                       main= paste("Presence of",spptargetInput()[[1]]),#paste(ifelse(input$trans2!=2,"P x","Log(P) x"),ifelse(input$trans!=2,"Certainty for","Log(Certainty) for"),spptargetInput()[[1]]),
                       legend.width=2, legend.shrink=0.75,legend.mar=3,
                       axis.args=list(cex.axis=0.8))
               plot(overlay(spp.psabs,1-CI,fun=fun),
                            zlim=c(input$minAbs,1),col="#FF0000",alpha=input$alpha, legend=FALSE, add=T)
               plot(overlay(1-spp.psabs,1-CI,fun=fun), #1-spp.psabs,
                            zlim=c(input$minPres,1),col="#00FF00",alpha=input$alpha,legend=FALSE, add=T)
               plot(SweB10k, add=TRUE)
               legend("topleft", c(paste0("Certain ps.absence (", input$minAbs," - 1)"), paste0("Certain presence (", input$minPres," - 1)")),
                                 col=c(paste0(c("#FF0000","#00FF00"),input$alpha * 100)),
                                 bty="n", pch= 15 )
  }) #end outputPlot

output$TransPlot <- renderPlot({
              par(mfrow=c(1,3), oma=c(1,0,1,0))
              richV <- as.numeric(richnessInput()[cellwdata])
              datasetV<-as.numeric(datasetInput()[cellwdata])

              if(input$index==TRUE){datasetI<-ifelse(datasetV==0, 0, datasetV/richV) }
              if(input$index==FALSE){datasetI<-datasetV}

              if(input$trans!=2) {dataset.D<-datasetI}
              if(input$trans==2) {
                                 dataset.log<- log(datasetI+1)
                                 dataset.D<- dataset.log
              }
              ## Density plot
              par(mar=c(4,4,3,2),cex=1)
              plot(density(dataset.D, from=0), #na.rm=T,
                                      xlab=ifelse(input$index==TRUE,paste(ifelse(input$trans!=2,"Obs Index","Log(Obs Index)")," for", as.character(input$dataset)),paste(ifelse(input$trans!=2,"No.","Log(No.)"),"of Obs for", as.character(input$dataset))),
                                      #paste(ifelse(input$trans!=2,"No.","Log(No.)"),"of Observations for", as.character(input$dataset)),
                                      ylab="Density",
                                      main=paste("Density for", as.character(input$dataset)))


              ## Species Discovery plot
              plot(dataset.D, richV,
                                      pch=19,
                                      xlab=ifelse(input$index==TRUE,paste(ifelse(input$trans!=2,"Obs Index","Log(Obs Index)")," for", as.character(input$dataset)),paste(ifelse(input$trans!=2,"No.","Log(No.)"),"of Obs for", as.character(input$dataset))),
                                      #paste(ifelse(input$trans!=2,"No.","Log(No.)"),"of Observations for", as.character(input$dataset)),
                                      ylab="Richness",
                                      main=paste("Richnes vs. Observations for", as.character(input$dataset)))
              #abline(a=0,b=1)

              ## Algorithms plot
              maxX<-max(datasetI)
              transnorm<-function(x, maxX){
                                    norm<-x/maxX
                                    norm<- 1- norm
                                    return(norm)
              }
              par(mar=c(4,4,3,2),cex=1)
              curve(transnorm(x,maxX), from=0,to=maxX, n = 1001, ylim=c(0,1),
                                    xlab=ifelse(input$index==TRUE,paste("Obs Index for", as.character(input$dataset)),paste("No. of Obs for", as.character(input$dataset))),
                                    #paste("No. of Observations for", as.character(input$dataset)), #paste(ifelse(input$trans!=2,"No.","Log(No.)"),"of Observations for", as.character(input$dataset)),
                                    ylab="Ignorance score",
                                    main="Ignorance scores")

              translog<-function(x,dec){
                      logx<-log(x+dec)#+abs(min(log(x+dec))) ## second term not needed if dec = 1
                      logx.norm<-logx/max(logx)
                      logCI<-1 -(logx.norm)
                      return(logCI)
                      }
              curve(translog(x,1), col=4, add=T)

              obs50<-input$obs50
              par(mar=c(4,4,3,2),cex=1)
              curve(obs50/(x+obs50), add=T, col=2)
              abline(v=1, lty=3)
              abline(v=obs50, lty=3, col=2)
              abline(h=0.5, lty=3, col=2)
              legend("topright", legend=c(paste("Normalized =",expression(1 - x/max(x))),
                                          paste("Log-Normalized =",expression(1 - log(x + 1)/max(log(x + 1)))),
                                          paste("Inversed =",expression(O[0.5]/(x+O[0.5])))), lty=1, col=c("black","blue","red"),bty="n")
  }) #end outputPlot

}) #end server