Functions and scripts to:

1. Transform raw txt files into data.table objects and save as RData files.
2. Perform exploratory processing
3. Perform summary analyses

Memory-efficiency is key for all tasks because files are large relative to available RAM.

Computation time for exploratory processing and summary analyses is important because this will be done interactively. However, computation time for initial transformation from txt to RData is less important because it can be done without user interaction.
