```r
##################################################
# global variable definitions
##################################################
# source('inv-global-datapath.R') before source('inv-global-vars.R')
# inv-global-datapath.R on pc

g_filename <- list.files(path=g_datapath, pattern='.txt')

g_invcol <- c(
  'Valuation Date', 'Branch Number', 'Product Number', 'Full ISO (S.A1)', 'Product Class USA',
  'Stock Status Code', 'Buy Package', 'Line Point', 'Order Point/Transfer Point', 'Days Out of Stock',
  'Demand Bill_To_Customer', 'Demand Period Used',
  'Unit Replacement Cost', 'On Hand Qty', 'Reserve Amount',
  'COGS $ - 3 Mo', 'Sales $ - 3 Mo', 'Usage Qty - 3 Mo',
  'COGS $ - 12 Mo', 'Sales $ - 12 Mo', 'Usage Qty - 12 Mo'
)

g_newcolname <- c(
  'ValDate', 'BranchNumber', 'EclipseID', 'FullISO', 'ProdClass', 
  'StockStatus', 'BuyPack', 'UpToLevel', 'ReorderPoint', 'DaysOut',
  'CustomerDemand', 'CustomerDemandDays',
  'unit_r_cost', 'qty_on_hand', 'reserve_amt',
  'cogs03', 'sales03', 'usage03',
  'cogs12', 'sales12', 'usage12'
)

g_convcolname <- c(
  'StockStatus', 'BuyPack', 'UpToLevel', 'ReorderPoint', 'DaysOut',
  'CustomerDemand', 'CustomerDemandDays',
  'qty_on_hand', 'usage03', 'usage12'
)

# convert all to integer
g_convcolfunname <- rep('as.integer', times=length(g_convcolname))

g_keycolname <- c('ValDate', 'BranchNumber', 'EclipseID') 
```
