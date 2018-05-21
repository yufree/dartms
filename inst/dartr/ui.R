library(shiny)

shinyUI(
        navbarPage(
        "Direct Analysis in Real Time (DART) data analysis",
        # first tab for intro
        tabPanel(
                "DART Analysis",
                fluidPage(
                        sidebarLayout(
                                sidebarPanel(
                                        h4("Single file"),
                                        fileInput(
                                                'filedart',
                                                label = 'mzXML file',

                                                accept = c('.mzXML')
                                        ),
                                        h4("Multiple files"),
                                        fileInput(
                                            'filedart2',
                                            label = 'mzXML files',
                                            multiple = T,
                                            accept = c('.mzXML','.zip')
                                        ),
                                        h4('Data filter'),
                                        sliderInput(
                                                "insdart",
                                                "Intensity in Log scale",
                                                min = 0,
                                                max = 10,
                                                value = 4.2,
                                                step = 0.2
                                        ),
                                        selectInput('step','Profile step for mass spectrum',c(1,0.1,0.01,0.001),selected = '1') ),
                                mainPanel(
                                        h3("DART visulization"),
                                        h4("Prepare the data"),
                                        p(
                                                "If you want to visulise the Direct Analysis in Real Time (DART) data, just upload the data (mzXML file) in the sidebar."
                                        ),
                                        h4("Use demo data"),
                                        p(
                                                "You could download demo",
                                                a('data', href = "https://github.com/yufree/xcmsplus/blob/master/data/test.mzXML?raw=true"),
                                                "here and have a try."
                                        ),
                                        h4("Usage"),
                                        p(
                                                "After uploading the data, you could change intensity(in Log scale) by the side slides to filter your data."
                                        ),
                                        dataTableOutput("darttable"),
                                        p(downloadButton('datadart', 'Download Selected Data')),
                                        plotOutput("dartpca"),
                                        plotOutput("dart"),
                                        plotOutput("darttic"),
                                        plotOutput("dartms")

                                )
                        ))),
    tabPanel(
                        "References",
                        p(
                                "If you use this application for publication, please cite this application as webpages and related papers:"
                        ),
                        h6(
                                "Miao Yu, Xingwang Hou, Qian Liu, Yawei
                                                Wang, Jiyan Liu, Guibin Jiang: 2017
                                                Evaluation and reduction of the
                                                analytical uncertainties in GC-MS
                                                analysis using a boundary regression
                                                model Talanta, 164, 141–147."
                        ),
                        h6(
                                "Smith, C.A. and Want, E.J. and
                                                O'Maille, G. and Abagyan,R. and
                                                Siuzdak, G.: XCMS: Processing mass
                                                spectrometry data for metabolite
                                                profiling using nonlinear peak
                                                alignment, matching and identification,
                                                Analytical Chemistry, 78:779-787 (2006)

                                                "
                        ),
                        h6(
                                "Ralf Tautenhahn, Christoph Boettcher,
                                                Steffen Neumann: Highly sensitive
                                                feature detection for high resolution
                                                LC/MS BMC Bioinformatics, 9:504 (2008)

                                                "
                        ),
                        h6(
                                "H. Paul Benton, Elizabeth J. Want and
                                                Timothy M. D. Ebbels Correction of mass
                                                calibration gaps in liquid
                                                chromatography-mass spectrometry
                                                metabolomics data Bioinformatics,
                                                26:2488 (2010)
                                                "
                        )
                )
                )
        )

