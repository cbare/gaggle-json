# Client code for interacting with Gaggle-JSON

# some code mooched from RJSIONIO
dQuote =
function(x)
  paste('"', x, '"', sep = "")


# Create the evelope entries common to all Gaggle JSON structures
# name can be anything
# type is a gaggle data type (or optionally a custom data type)
# metadata is an optional list of key/values pairs for
#  example: list(species="Goose", source="GooseDB")
toGaggleJSONEnvelope <- function(name, type, metadata=NULL) {
  keys = c("name", "type")
  values = dQuote(c(name, type))
  if (!is.null(metadata)) {
    keys = append(keys, "metadata")
    values = append(values, toJSON(metadata))
  }
  paste( dQuote(keys), values, sep=":", collapse="," )
}

# convert an R matrix to a Gaggle-JSON matrix
toGaggleJSONMatrix <- function(m, name, metadata=NULL, digits=5) {
  if (is.null(rownames(m)) || is.null(colnames(m)))
    stop("matrix needs row and column names")
  paste("{",
    toGaggleJSONEnvelope(name, "matrix", metadata),
    ", \"gaggle-data\":{ \"row names\": ",
    toJSON(rownames(m)),
    ",\n \"columns\": [",
    paste("{",
      paste("\"name\"", dQuote(colnames(m)), sep=":"), ",",
      paste("\"values\"", apply(m, 2, function(col) {
        tmp = formatC(col, digits = digits)
        paste("[", paste(tmp, collapse = ", "), "]")
      }), sep=":"),
    "}", collapse = ",\n"),
  "]}}", sep="")
}

fake_matrix <- function(r,c) {
  m = matrix(rnorm(r * c), ncol=c)
  colnames(m) <- sprintf("cond_%04d", 1:c)
  rownames(m) <- sprintf("JCB%04d", 1:r)
  return(m)
}