options(shiny.maxRequestSize=2048*1024^2)
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
# You might need the develop version of enviGCMS to run this app. Try `devtools::install_github('yufree/enviGCMS')`
#
library(shiny)
library(xcms)
library(DT)
library(dartms)

shinyServer(function(input, output) {
    # data input
    dartfilter <- reactive({
        if (!is.null(input$filedart2)){
            if(grepl('zip',input$filedart2$name)){

                value <- NULL
                n <- 1
                MZ <- NULL
                group <- NULL
                for(i in input$filedart2$datapath){
                    file <- unzip(i)
                    re <- xcms::xcmsRaw(file[1],profstep = as.numeric(input$step))
                    if(is.null(MZ)){
                        MZ <- xcms::profMz(re)
                    }else{
                        MZ <- intersect(MZ,xcms::profMz(re))
                    }
                    cvalue <- colnames(value)
                    for(j in file){
                        data <- xcms::xcmsRaw(j,profstep = as.numeric(input$step))
                        pf <- xcms::profMat(data)
                        rownames(pf) <- mz <- xcms::profMz(data)
                        colnames(pf) <- rt <- data@scantime
                        mzins <- apply(pf,1,sum)/length(unique(rt))
                        MZ0 <- MZ
                        MZ <- intersect(MZ,mz)

                        value <- cbind(value[MZ0 %in% MZ,], mzins[mz %in% MZ])
                    }
                    value <- value[apply(value, 1, function(x) !all(x==0)),]
                    value <- value[apply(value, 1, function(x) all(x>=10^(input$insdart))),]
                    colnames(value) <- c(cvalue,sub('.mzXML','',basename(file)))
                    group <- c(group,rep(sub('.zip','',input$filedart2$name[n]),length(file)))
                    n <- n+1
                    MZ <- as.numeric(rownames(value))
                }
                return(list(group = group, data = value))
            }else{
                re <- xcms::xcmsRaw(input$filedart2$datapath[1],profstep = as.numeric(input$step))
                MZ <- xcms::profMz(re)
                value <- NULL
                for(i in input$filedart2$datapath){
                    data <- xcms::xcmsRaw(i,profstep = as.numeric(input$step))
                    pf <- xcms::profMat(data)
                    rownames(pf) <- mz <- xcms::profMz(data)
                    colnames(pf) <- rt <- data@scantime
                    mzins <- apply(pf,1,sum)/length(unique(rt))
                    MZ0 <- MZ
                    MZ <- intersect(MZ,mz)
                    value <- cbind(value[MZ0 %in% MZ,], mzins[mz %in% MZ])
                }
                value <- value[apply(value, 1, function(x) !all(x==0)),]
                value <- value[apply(value, 1, function(x) any(x>=10^(input$insdart))),]
                colnames(value) <- sub('.mzXML','',input$filedart2$name)
                group <- gsub('([0-9]|_)','',colnames(value))
                return(list(group = group, data = value))
            }
        }else{
            return(NULL)
        }
    })
    # show the table
    output$darttable <- DT::renderDataTable({
        list <- dartfilter()
        rbind(list$group,list$data)
    })
    # show PCA
    output$dartpca <- renderPlot({
        if (is.null(input$filedart2$datapath)){
            return()
        }else{
            list <- dartfilter()
            enviGCMS::plotpca(data = list$data,lv = as.character(list$group), col = as.numeric(as.factor(list$group)))
        }
    })
    # show the download
    output$datadart = downloadHandler('dart-filtered.csv', content = function(file) {
        list <- dartfilter()
        df <- rbind(list$group,list$data)
        write.csv(df, file)
    })


    # DART analysis
    output$dart <- renderPlot({
        if (is.null(input$filedart$datapath))
            return()
        else
            plotdart(input$filedart$datapath, inscf = input$insdart, profstep = as.numeric(input$step))
    })

    output$darttic <- renderPlot({
        if (is.null(input$filedart$datapath))
            return()
        else
            data <- xcms::xcmsRaw(input$filedart$datapath,profstep = as.numeric(input$step))
        xcms::plotTIC(data)
    })

    output$dartms <- renderPlot({
        if (is.null(input$filedart$datapath))
            return()
        else
            plotdartms(input$filedart$datapath,profstep = as.numeric(input$step))
    })
})
