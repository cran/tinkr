## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(tinkr)

## -----------------------------------------------------------------------------
library("tinkr")
library("xml2")
path <- system.file("extdata", "example1.md", package = "tinkr")
head(readLines(path))
ex1 <- tinkr::yarn$new(path)
# find all ropensci.org blog links
xml_find_all(
  x = ex1$body, 
  xpath = ".//md:link[contains(@destination,'ropensci.org/blog')]", 
  ns = ex1$ns
)

## -----------------------------------------------------------------------------
library("magrittr")
library("tinkr")
# From Markdown to XML
path <- system.file("extdata", "example1.md", package = "tinkr")
# Level 3 header example:
cat(tail(readLines(path, 40)), sep = "\n")
ex1  <- tinkr::yarn$new(path)
# transform level 3 headers into level 1 headers
ex1$body %>%
  xml2::xml_find_all(xpath = ".//md:heading[@level='3']", ex1$ns) %>% 
  xml2::xml_set_attr("level", 1)

# Back to Markdown
tmp <- tempfile(fileext = "md")
ex1$write(tmp)
# Level three headers are now Level one:
cat(tail(readLines(tmp, 40)), sep = "\n")
unlink(tmp)

## -----------------------------------------------------------------------------
path <- system.file("extdata", "example2.Rmd", package = "tinkr")
rmd <- tinkr::yarn$new(path)
rmd$body

## ----new-block----------------------------------------------------------------
path <- system.file("extdata", "example2.Rmd", package = "tinkr")
rmd <- tinkr::yarn$new(path)
xml2::xml_find_first(rmd$body, ".//md:code_block", rmd$ns)
new_code <- c(
  "```{r xml-block, message = TRUE}",
  "message(\"this is a new chunk from {tinkr}\")",
  "```")
new_table <- data.frame(
  package = c("xml2", "xslt", "commonmark", "tinkr"),
  cool = TRUE
)
# Add chunk into document after the first chunk
rmd$add_md(new_code, where = 1L)
# Add a table after the second chunk:
rmd$add_md(knitr::kable(new_table), where = 2L)
# show the first 21 lines of modified document
rmd$head(21)

## ----protect-math-------------------------------------------------------------
path <- system.file("extdata", "math-example.md", package = "tinkr")
math <- tinkr::yarn$new(path)
math$tail() # malformed
math$protect_math()$tail() # success!

## ---- basic, error = TRUE-----------------------------------------------------
path <- system.file("extdata", "basic-math.md", package = "tinkr")
math <- tinkr::yarn$new(path)
math$head(15) # malformed
math$protect_math() #error

