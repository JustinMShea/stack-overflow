library(quantmod)

# First file downloaded from: https://www.nseindia.com/corporates/content/securities_info.htm
EQUITY_L <- read.csv("~/R/stack-overflow/data/EQUITY_L.csv", stringsAsFactors = FALSE)

# Each symbol for NSE apparently needs an ".NS" suffix, so add it.
NSE_Symbols <- paste0(EQUITY_L$SYMBOL,".NS")

# create new environment to dump every stock into and keeing your global environment manageable.
NSE_stocks <- new.env()

# Pass holding symbols to quantmod::getSymbols function for daily data.
sapply(NSE_Symbols, function(x){
        try(getSymbols(x, env=NSE_stocks), silent=TRUE)
}
)

### TEST ##
# Check to see what downloaded and what didn't
> length(NSE_Symbols[!(NSE_Symbols %in% names(NSE_stocks))])
[1] 17

# which ones?
NSE_Symbols[!(NSE_Symbols %in% names(NSE_stocks))]
[1] "3PLAND.NS"     "BHAGYANGR.NS"  "CHEMFAB.NS"    "ELECTROSL.NS"  "GANGESSECU.NS" "GMMPFAUDLR.NS"
[7] "GUJRAFFIA.NS"  "HBSL.NS"       "KALYANI.NS"    "MAGADSUGAR.NS" "MANAKCOAT.NS"  "MCDOWELL-N.NS"
[13] "NIRAJISPAT.NS" "PALASHSECU.NS" "SIGIND.NS"     "SPTL.NS"       "SUBCAPCITY.NS"

getSymbols(NSE_Symbols[!(NSE_Symbols %in% names(NSE_stocks))])

## 
NSE_xts <- do.call(merge, eapply(NSE_stocks, Ad))

