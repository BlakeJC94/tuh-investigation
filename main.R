# Testing loading of edf data into R


# # Get dependencies
#
library('edfReader')  # install.packages("edfReader")
library("DiffusionRgqd")  # install.packages("DiffusionRgqd")

tqad <- function(hour, min, sec) { 60*60*hour + 60*min + sec }

# # Set globals
#
outputDir <- './output/scratchpad/'
edfName <- '00000675_s001_t001.edf'
tspan = c(tqad(0,1,47), tqad(0,1,57))

set.seed(14)




# # Import EDF
#
# ## Find EDF
#
edfList = Sys.glob('./edf/dev/*/*/*/*/*.edf')
for (ind in 1:length(edfList)){
    if (length(grep(edfName, edfList[ind])) > 0){
        edfPath = edfList[ind]
        break
    }
}

# ## Load data
#
hdr <- readEdfHeader(edfPath)
record <- readEdfSignals(hdr)
time <- seq(0,length=length(trace), by=(1/sRate))

# ## Get channel data
#
sRate <- record[[1]]$sRate
trace <- record[[1]]$signal

# ### Find Fz and Cz channel
#
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
FZdata <- record[[FZind]]$signal
CZdata <- record[[CZind]]$signal


# # Process data for plots
#
# ## Clip time series to relevant sections
#
sample = seq(
    max(round(sRate*tspan[1]), 1),
    round(sRate*tspan[2])
)

# ## Fit mOU process to data
#
#GQD.remove()



# # Plot data
#
# ## Simple trace
#
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

# ## Phase plot
#
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




