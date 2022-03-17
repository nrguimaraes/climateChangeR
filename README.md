# climateChangeR
This is a repository for the datasets and R codes of "Exploring Climate Change Data with R",
a book chapter authored by Nuno Guimarães, Kimmo Vehkalahti, Pedro Campos, and Joachim Engel,
to be published in 2021.

(work in progress - more details to be added later)


```
-- Pre-print draft (July 2021) --
Do not post to other websites or circulate without authors' written consent
This manuscript is copyrighted (C) to the authors
```
```
To appear as Chapter 11 in the book: Statistics forempowerment and social engagement:
teaching Civic Statistics to develop informed citizens. (Chief Editor: Jim Ridgway).
Forthcoming early 2022 from Springer.
```
## Exploring Climate Change Data with R

Nuno Guimarães, CRACS-INESCTEC and University ofPorto, Portugal
nuno.r.guimaraes@inesctec.pt

Kimmo Vehkalahti, University of Helsinki, Finland
kimmo.vehkalahti@helsinki.fi

Pedro Campos, LIADD-INESCTEC and University of Porto, Portugal
pcampos@fep.up.pt

Joachim Engel,Ludwigsburg University of Education,Germany
engel@ph-ludwigsburg.de

### Abstract

Climate change is an existential threat facing humanity and the future of our planet. The
signs of global warming are everywhere, and they are more complex than just the climbing
temperatures. Climate data on a massive scale has been collected by various scientific groups
around the globe. Exploring and extracting useful knowledge from large quantities of data
requires powerful software. In this chapter we present some possibilities for exploring and
visualising climate change data in connection with statistics education using the freely
accessible statistical programming language _R_ togetherwith the computing environment
_RStudio_. In addition to the visualisations, we provideannotated references to climate data
repositories and extracts of our openly published R scripts for encouraging teachers and
students to reproduce and enhance the visualisations.

**Keywords:** R; Coding; Climate Data; Data Visualisation;Multivariate Data

**Proposed citation for this chapter** : Guimarães, N,Vehkalahti, K., Campos, P., & Engel, J.
(2022). Exploring Climate Change Data with R. In J. Ridgway,(Ed.), _Statistics for empowerment and
social engagement: Teaching Civic Statistics to develop informed citizens_. Springer.
See a Book Overview and Table of Contents on the next page


```
Book Overview: J. Ridgway (Ed.). (2022). Statistics for empowerment and social engagement:
teaching Civic Statistics to develop informed citizens. Springer.
```
```
Effective citizen engagement with social issues requires active participation and a broad
understanding of data and statistics about societal issues. However, many statistics curricula are
not designed to teach relevant skills nor to improve learners' statistical literacy.
```
```
This book offers practical approaches to working in a new field of knowledge - Civic Statistics -
which sets out to engage with, and overcome well documented and long-standing problems in
teaching quantitative skills. The book includes 23 peer-reviewed chapters, written in coordination
by an international group of experts from ten countries. The book aims to support and enhance the
work of teachers and lecturers working both at the high school and tertiary (university) levels. It is
designed to promote and improve the critical understanding of quantitative evidence relevant to
burning social issues – such as epidemics, climate change, poverty, migration, natural disasters,
inequality, employment, and racism.
```
```
Evidence about social issues is provided to the public via print and digital media, official statistics
offices, and other information channels, and a great deal of data is accessible both as aggregated
summaries and as individual records. Chapters illustrate the approaches needed to teach and
promote the knowledge, skills, dispositions, and enabling processes associated with critical
understanding of Civic Statistics presented in many forms. These include statistical analysis of
authentic multivariate data, use of dynamic data visualisations, and deconstructing texts about the
social and economic well-being of societies and communities. Chapters discuss ideas regarding the
development of curricula and educational resources, use of emerging technologies and
visualizations, preparation of teachers and teaching approaches and sources for relevant datasets
and rich texts about Civic Statistics, and ideas regarding future research, assessment,
collaborations between different stakeholders, and other systemic issues.
```
**Contents
Chapter Title Authors (with corresponding author email)**

```
Foreword Democracy needs statistical literacy Gerd Gigerenzer
(gigerenzer@mpib-berlin.mpg.de)
Ch 1 Why engage with Civic Statistics? Jim Ridgway (jim.ridgway@durham.ac.uk)
```
**Part I: Redesigning Statistics Education**
Ch 2 Back to the future – rethinking the purpose and
nature of statistics education

```
Joachim Engel (engel@ph-ludwigsburg.de),
Jim Ridgway
Ch 3 A conceptual framework for Civic Statistics and
its educational applications
```
```
Iddo Gal (iddo@research.haifa.ac.il), James
Nicholson, Jim Ridgway
Ch 4 Implementing Civic Statistics –
An agenda for action
```
Iddo Gal (iddo@research.haifa.ac.il), Jim
Ridgway, James Nicholson, Joachim Engel
**Part II: Tools, Data Sets, Lessons, and Lesson Preparation**
Ch 5 Interactive data visualizations for teaching civic
statistics

```
Jim Ridgway (jim.ridgway@durham.ac.uk),
Pedro Campos, James Nicholson, Sónia
Teixeira
Ch 6 Data sets: examples and access for Civic Statistics Sónia Teixeira (sonia.c.teixeira@inesctec.pt),
Pedro Campos, Anna Trostianitser
```

```
Ch 7 Lesson plan approaches: Tasks that motivate
students to think
```
```
Anna Trostianitser
(anna.trostianitser@gmail.com), Sónia
Teixeira, Pedro Campos
Ch 8 Seeing dynamic data visualizations in action:
Gapminder tools
```
```
Peter Kovacs (kovacs.peter@eco.u-szeged.hu),
Klara Kazar, Eva Kuruczleki
Ch 9 Data visualization packages for non-inferential
Civic Statistics in high school classrooms
```
```
Daniel Frischemeier
(dafr@math.uni-paderborn.de), Susanne
Podworny, Rolf Biehler
Ch 10 Civic Statistics and iNZight : Illustrations of some
design principles for educational software
```
```
Chris Wild (c.wild@auckland.ac.nz), Jim
Ridgway
Ch 11 Exploring Climate Change Data with R Nuno Guimarães
(nuno.r.guimaraes@inesctec.pt ), Kimmo
Vehkalahti, Pedro Campos, Joachim Engel
Ch 12 Covid-19 shows why we need Civic Statistics:
illustrations and classroom activities
```
```
Jim Ridgway (jim.ridgway@durham.ac.uk),
Rosie Ridgway
```
**Part III: Implementing Civic Statistics**
Ch 13 Critical understanding of Civic Statistics: Engaging
important contexts, texts, and opinion questions

```
Iddo Gal (iddo@research.haifa.ac.il)
```
```
Ch 14 Implementing Civic Statistics in business
education: Technology in small and large
classrooms
```
```
Peter Kovacs (kovacs.peter@eco.u-szeged.hu),
Klara Kazar, Eva Kuruczleki
```
```
Ch 15 Civic Statistics for prospective teachers:
developing content and pedagogical content
knowledge through project work
```
```
Susanne Podworny (podworny@math.upb.de),
Daniel Frischemeier, Rolf Biehler
```
```
Ch 16 Civic Statistics for prospective teachers:
developing critical questioning of data-based
statements in the media
```
```
Achim Schiller, Joachim Engel
(engel@ph-ludwigsburg.de)
```
```
Ch 17 Civic Statistics at School: Reasoning with real data
in the classroom
```
```
Christoph Wassner
(wassner@martin-behaim-gymnasium.de),
Andreas Proemmel
Ch 18 Preparing for a data-rich world: Civic Statistics
across the curriculum
```
```
James Nicholson
(j.r.nicholson@durham.ac.uk), Joachim Engel,
Josephine Louie
Ch 19 Dynamic, interactive trees and icon arrays for
visualizing risks in Civic Statistics
```
```
Laura Martignon
(martignon@ph-ludwigsburg.de), Daniel
Frischemeier, Michelle McDowell, Christoph
Till
```
**Part IV: The Futures of Civic Statistics**

```
Ch 20 Reflections on Civic Statistics — A triangulation
of citizen, state and statistics: past, present and
future
```
```
Karen François (karen.francois@vub.be),
Carlos Monteiro
```
```
Ch 21 Connecting data science, data movements, and
project-based learning with a social impact
```
```
Leid Zejnilovic (leid.zejnilovic@novasbe.pt),
Pedro Campos
Ch 22 Data science, statistics, and Civic Statistics:
Education for a fast changing world
```
```
Jim Ridgway (jim.ridgway@durham.ac.uk),
Pedro Campos, Rolf Biehler
Ch 23 Civic Statistics in context: mapping the global
evidence ecosystem
```
```
Jim Ridgway (jim.ridgway@durham.ac.uk),
Rosie Ridgway
```


# Chapter 11

# Exploring Climate Change Data with R

Nuno Guimarães, CRACS-INESCTEC and University ofPorto, Portugal
nuno.r.guimaraes@inesctec.pt
Kimmo Vehkalahti, University of Helsinki, Finland
kimmo.vehkalahti@helsinki.fi
Pedro Campos, LIADD-INESCTEC and University of Porto, Portugal
pcampos@fep.up.pt
Joachim Engel,Ludwigsburg University of Education,Germany
engel@ph-ludwigsburg.de

**Abstract**

Climate change is an existential threat facing humanity and the future of our planet. The
signs of global warming are everywhere, and they are more complex than just the climbing
temperatures. Climate data on a massive scale has been collected by various scientific groups
around the globe. Exploring and extracting useful knowledge from large quantities of data
requires powerful software. In this chapter we present some possibilities for exploring and
visualising climate change data in connection with statistics education using the freely
accessible statistical programming language _R_ togetherwith the computing environment
_RStudio_. In addition to the visualisations, we provideannotated references to climate data
repositories and extracts of our openly published R scripts for encouraging teachers and
students to reproduce and enhance the visualisations.

**Keywords:** R; Coding; Climate Data; Data Visualisation;Multivariate Data
