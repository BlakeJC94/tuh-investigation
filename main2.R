# # Testing loading of edf data into R


# ## Get dependencies

# install.packages("edfReader")
library('edfReader')

#install.packages("DiffusionRgqd")
library('DiffusionRgqd')

tqad <- function(hour, min, sec) { 60*60*hour + 60*min + sec }


# ## Set globals

outputDir <- './output/scratchpad/'

edfName <- '00000258_s002_t000.edf'


tspan = c(tqad(0,0,2), tqad(0,0,8))


# ## Import EDF

# ### Search for file

listEDFs <- Sys.glob(file.path("edf/dev/*/*/*/*", "*.edf"))
for (ind in 1:length(listEDFs)){
    if (grepl(edfName, listEDFs[ind])){
        edfPath <- listEDFs[ind]
        break
    }
}

#edfDir <- './edf/dev/01_tcp_ar/002/00000258/s002_2003_07_21/'
#edfPath <- paste(edfDir, edfName, sep='')

hdr <- readEdfHeader(edfPath)
record <- readEdfSignals(hdr)


# ## Get single channel data

sRate <- record[[1]]$sRate
trace <- record[[1]]$signal

time <- seq(0,length=length(trace), by=(1/sRate))

# ### Find Fz and Cz channel
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

# ### Extract signals
FZdata <- record[[FZind]]$signal
CZdata <- record[[CZind]]$signal


# ## Process data for plots

# ### Clip time series to relevant sections

sample = seq(
    max(round(sRate*tspan[1]), 1),
    round(sRate*tspan[2])
)

# ### Fit data to multivariate OU process

GQD.remove()
# X1 coefficients
a10 <- function(t){-theta[1]}
a01 <- function(t){-theta[2]}
c00 <- function(t){theta[5]*theta[5]}
d00 <- function(t){theta[5]*theta[6]}
# X2 coefficients
b10 <- function(t){-theta[3]}
b01 <- function(t){-theta[4]}
e00 <- function(t){theta[5]*theta[6]}
f00 <- function(t){theta[7]*theta[7]}


# Create data matrix
X <- cbind(FZdata[sample]-mean(FZdata[sample]), CZdata[sample]-mean(CZdata[sample]))
tsteps <- seq(1, length(sample), by=1)

# Declare starting parameters for optimisation routine
theta.start <- c(1, 100, 1, 0.5, 1, 1, 1)

# Calculate MLEs of parameter vector
model_l <- BiGQD.mle(X, time[sample], mesh = 20, theta = theta.start)
thetaVec <- model_l$opt$par

#model_l <- BiGQD.density(X, time[sample], mesh = 20, theta = theta.start)

# Crudely EM simulate trajectory
Xsim <- vector(mode = "list", length = length(sample))
Ysim <- vector(mode = "list", length = length(sample))

Xsim[1] <- 0
Ysim[1] <- 0

for (ind in 2:length(sample)){
    Xmu <- -(thetaVec[1] * Xsim[[ind-1]] + thetaVec[2] * Ysim[[ind-1]])
    Ymu <- -(thetaVec[3] * Xsim[[ind-1]] + thetaVec[4] * Ysim[[ind-1]])

    Xsim[ind] <- Xmu / sRate + thetaVec[5] * rnorm(1,sd=1/sRate)
    Ysim[ind] <- Ymu / sRate + thetaVec[6] * rnorm(1,sd=1/sRate) + thetaVec[7] * rnorm(1,sd=1/sRate)
}




# ## Plot data

# ### Simple trace

plotName <- 'testo.png'
plotPath <- paste(outputDir, plotName, sep='')

png(plotPath, width=700, height=500)
plot(
    time[sample], FZdata[sample], type='l',
    xlab = "Time (s)",
    ylab = "Amplitude (\\mu V)",
    main = "testo"
)
dev.off()

# ### Phase plot

plotName <- 'testo2.png'
plotPath <- paste(outputDir, plotName, sep='')

png(plotPath, width=700, height=500)
plot(
    FZdata[sample] - mean(FZdata[sample]),
    CZdata[sample] - mean(CZdata[sample]),
    type='l', lty=3,
    xlab = "Fz-ref Amplitude - mean (\\mu V)",
    ylab = "CZ-ref Amplitude - mean (\\mu V)",
    main = "testo2"
)
dev.off()


# ### Simulation plot

plotName <- 'testo3'
plotPath <- paste(outputDir, plotName, ".png", sep='')

png(plotPath, width=700, height=500)
plot(
    Xsim,
    Ysim,
    type='l', lty=3,
    xlab = "Simulated Fz-ref Amplitude (\\mu V)",
    ylab = "Simulated CZ-ref Amplitude (\\mu V)",
    main = plotName
)
dev.off()


print("PASS!")
