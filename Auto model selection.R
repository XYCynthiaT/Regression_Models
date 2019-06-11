mtcars$cyl <- factor(mtcars$cyl)
mtcars$vs <- factor(mtcars$vs)
mtcars$am <- factor(mtcars$am)
mtcars$gear <- factor(mtcars$gear)
mtcars$carb <- factor(mtcars$carb)
terms <- names(mtcars)
outcome <- "mpg"
terms <- terms[-which(terms == outcome)]
ref <- "am"
terms <- terms[-which(terms == ref)]
fits <- vector("list", length = length(terms) + 1)
formulas <- vector("list", length = length(terms) + 1)
formulas[[1]] <- paste(outcome, "~", ref)
fits[[1]] <- lm(as.formula(formulas[[1]]), data = mtcars)
for (i in seq_along(terms)) {
        formulas[[i+1]] <- paste(formulas[[i]], "+", terms[i])
        fits[[i+1]] <- lm(as.formula(formulas[[i+1]]), data = mtcars)
        p <- anova(fits[[i]], fits[[i+1]])$`Pr(>F)`[2]
        if(p >= 0.05) {
                formulas[[i+1]] <- formulas[[i]]
                fits[[i+1]] <- lm(as.formula(formulas[[i+1]]), data = mtcars)
                }
}
fits[[length(fits)]]
formulas[[length(formulas)]]

modelSelection <- function(outcome = "mpg", ref = "am", dat = mtcars){
        terms <- names(dat)
        terms <- terms[-which(terms == outcome)]
        terms <- terms[-which(terms == ref)]
        formulas <- vector("list", length = length(terms))
        fits <- vector("list", length = length(terms))
        formulas[[1]] <- paste(outcome, "~", ref)
        fits[[1]] <- lm(as.formula(formulas[[1]]), data = dat)
        for(i in seq_along(terms)) {
                formulas[[i+1]] <- paste(formulas[i], "+", terms[i])
                fits[[i+1]] <- lm(as.formula(formulas[[i+1]]), data = dat)
                p <- anova(fits[[i]], fits[[i+1]])$`Pr(>F)`[2]
                if(p >= 0.05) {
                        formulas[[i+1]] <- formulas[[i]]
                        fits[[i+1]] <- lm(as.formula(formulas[[i+1]]), data = dat)
                }
        }
        list(fit = fits[[length(fits)]], formula = formulas[[length(formulas)]])
}
