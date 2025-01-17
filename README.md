# r-for-cell-biologists

Teaching "R for cell biologists", not teaching R _to_ cell biologists!

--

Materials for teaching "R for cell biologists": a 90 minute workshop to introduce R in a way that cell biologists would actually use it.
For more information read [this]().
This repo is intended for instructors or for self-directed students to generate materials for the workshop.

## Setup

1. Download the repo.
2. Start a new project in RStudio: File > New Project... then New Directory, name the project (suggestion: RTraining) and save somewhere on your computer
3. Open the script `00_r_project_setup.R` and run it. This will make a standardised directory structure in your project folder.
4. Next, open `01_simulate_data.R` and run that. This will generate a series of data files to use in the workshop. They are saved in `Output/Data/`

These steps will help you to familiarise yourself with the directory structure used in the workshop.
You can, skip straight from step 1 to using the zip file of example data, `Data.zip`

## Getting ready for the workshop

Assuming all participants bring their own laptops, let them know that they meed to download and install R and RStudio ahead of the workshop.
Any installation of packages can be done during the session.

The files you generated above need to made available to the participants. Suggestion: make a compressed archive (zip) and send to the students prior to or during the workshop.
They will also need the scripts `00_r_project_setup.R` and `02_training.R`, so distribute these at the same time.

# The Workshop

## Introduction

Three concepts need to be introduced:

### 1. why we use R rather than Microsoft Excel

Emphasise reproducibility, automation, and publication-quality graphics.

### 2. the pathway from experiment to figure

A typical experiment involves setting up cells, imaging them on the microscope, analysing the images in Fiji, and the output is plain text files, one for each image.
To make a figure, we need to process all of these text files and turn them into publication-quality figures using R.

### 3. the steps in R are always the same

We need to:

1. Read in the data
2. Do some calculations or processing (optional)
3. Make some plots

See [here]() for more details.
Depending on the experience of the group, other concepts may need introducing: RStudio as an IDE (what the different panes are for), R as a language, scripting, 1-based vs 0-based languages.

## The hands-on part

Before we tackle steps 1-3, we have a step 0 which is to set up an R project to work _reproducibly_

### 0. R Project setup

- Start a new project in RStudio: File > New Project... then New Directory, name the project (suggestion: training_yymmdd) and save somewhere on your computer.
- Run the script `00_r_project_setup.R` or paste this [gist](https://gist.github.com/quantixed/42625f988a7b5da25b7e333c4a660b97) into the console and press enter.
- Using the course materials, move or copy the scripts into `Script/` and the data files into `Data/`

**Key concept:** a standardised directory structure within the R Project folder helps us to easily process data and save the outputs to a standardised place.
We always use the R Project folder as our working directory.
It makes the project portable and doesn't rely on paths to folders on a specific computer.

**Steps 1-3** execute the script `02_training.R` line by line (cmd + Enter on Mac; ctrl + Enter on Windows/Linux), explaining what each line does as you go.
Check for understanding throughout.

### 1. Read in the data

**Goal:** make one data frame containing all the data

- Begin by reading in one file into a data frame, explain that we have 80 files to read in.
- Show how we can read all of them in to one huge data frame using a simple command, but how do we know which rows belong to what condition and/or which experimental repeat?
- Use the filename to append information as it is read in.

**Key concept:** think about how you'll name the outputs of your analysis in Fiji to make reading the data into R as easy as possible.

An alternative workflow that we use in the lab is to use nested folders for conditions and experimental repeats, rather than a flat structure as in this example.
In that case, folder names are used to append information to the data frame.

### 2. Do some calculations

This is an optional step.
Some examples are shown but they are not needed for this exercise, as we will simply plot the data.

### 3. Make some plots

- Use ggplot to make some plots
- Explain grammar of graphics and demonstrate the power of facetting, theming and so on
- Explore the data, notice that one experiment is different to the others
- Make a SuperPlot
- Save the SuperPlot

**Key concept:** the data frame you made has all the information to make any plot you'd need.

## Homework

To consolidate the learning, ask the participants to figure out how to do the following:

**Which row (from which expt/cond/cell) had the lowest Mean value?**

Explain that the person who did the experiments found out that the rapamycin used in the 4th experiment, was prepared from a stock solution at the wrong concentration.

**How can we exclude the n4 data and remake a new SuperPlot so that all experiments used the correct concentration?**

Explain that getting assistance from an LLM is unlikely to help them learn.
Searching for a solution is fine.
Keywords: subset/subsetting