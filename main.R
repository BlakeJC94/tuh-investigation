# Testing loading of edf data into R


## Get dependencies

# install.packages("edfReader")
library('edfReader')

tqad <- function(hour, min, sec) { 60*60*hour + 60*min + sec }


## Set globals

edfDir <- './edf/dev/01_tcp_ar/002/00000258/s002_2003_07_21/'
edfName <- '00000258_s002_t000.edf'
edfPath <- paste(edfDir, edfName, sep='')

outputDir <- './output/scratchpad/'

tspan = c(tqad(0,0,12), tqad(0,0,22))


## Import EDF

hdr <- readEdfHeader(edfPath)
record <- readEdfSignals(hdr)
time <- seq(0,length=length(trace), by=(1/sRate))


## Get single channel data

sRate <- record[[1]]$sRate
trace <- record[[1]]$signal

### Find Fz and Cz channel
for (ind in 1:length(record)) {
    label <- record[[ind]]$label
    if (length(grep('[Ff][Zz]', label)) == 1) {
        print(label)
        FZind <- ind
    }
    if (length(grep('[Cc][Zz]', label)) == 1) {
        print(label)
        CZind <- ind
    }
}

### Extract signals
FZdata <- record[[FZind]]$signal
CZdata <- record[[CZind]]$signal



## Process data for plots

### Clip time series to relevant sections

sample = seq(
    max(round(sRate*tspan[1]), 1),
    round(sRate*tspan[2])
)



## Plot data

### Simple trace

plotName <- 'testo.png'
plotPath <- paste(outputDir, plotName, sep='')

png(plotPath, width=700, height=500)
plot(
    time[sample], trace[sample], type='l',
    xlab = "Time (s)",
    ylab = "Amplitude (\\mu V)",
    main = "testo"
)
dev.off()

### Phase plot

plotName <- 'testo2.png'
plotPath <- paste(outputDir, plotName, sep='')

png(plotPath, width=700, height=500)
plot(
    FZdata[sample], CZdata[sample], type='l', lty=3,
    xlab = "Fz-ref Amplitude (\\mu V)",
    ylab = "CZ-ref Amplitude (\\mu V)",
    main = "testo2"
)
dev.off()




