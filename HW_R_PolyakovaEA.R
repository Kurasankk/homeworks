motifs2 <- matrix(c(
  "a", "C", "g", "G", "T", "A", "A", "t", "t", "C", "a", "G",
  "t", "G", "G", "G", "C", "A", "A", "T", "t", "C", "C", "a",
  "A", "C", "G", "t", "t", "A", "A", "t", "t", "C", "G", "G",
  "T", "G", "C", "G", "G", "G", "A", "t", "t", "C", "C", "C",
  "t", "C", "G", "a", "A", "A", "A", "t", "t", "C", "a", "G",
  "A", "C", "G", "G", "C", "G", "A", "a", "t", "T", "C", "C",
  "T", "C", "G", "t", "G", "A", "A", "t", "t", "a", "C", "G",
  "t", "C", "G", "G", "G", "A", "A", "t", "t", "C", "a", "C",
  "A", "G", "G", "G", "T", "A", "A", "t", "t", "C", "C", "G",
  "t", "C", "G", "G", "A", "A", "A", "a", "t", "C", "a", "C"
), nrow = 10, byrow = TRUE)

motifs21 <- matrix(toupper(motifs2), nrow = nrow(motifs2))

count_motfis21 <- apply(motifs21, 2, function(col) table(factor(col, levels = c("A", "C", "G", "T"))))

profile_motfis21 <- apply(motifs21, 2, function(x) {
  counts <- table(factor(x, levels = c("A", "C", "G", "T")))
  counts / sum(counts)
})

scoreMotifs21 <- function(motifs2) {
  motifs <- matrix(toupper(motifs2), nrow = nrow(motifs2))
  sum(apply(motifs2, 2, function(col) length(col) - max(table(col))))
}

result <- scoreMotifs21(motifs2)

getConsensus <- function(count_motfis21) {
  apply(count_motfis21, 2, function(col) names(which.max(col)))
}

result_consensus <- getConsensus(count_motfis21)

plotmotifs21 <- count_motfis21[, 3]

barplot(plotmotifs21,
        col = "skyblue",
        main = "Частоты нуклеотидов в 3-м столбце",
        xlab = "Нуклеотиды",
        ylab = "Частота",
        ylim = c(0, max(plotmotifs21) + 0.5),
        names.arg = c("A", "C", "G", "T"))
