# Organizing the code and analysis:

The first step toward making a reproducible analysis is to organize the project code in a sensible way that will be easy for others to follow. Additionally, it is important to create code that can be run in batches or during non-interactive R sessions. I am going to present code organized using the R package `ProjectTemplate`. It allows for easy organization, loading and running of code.

The project architecture I use is diagrammed here. I will refer to starting points A, B and C.
![architecture](workflow.jpg)

In order to best organize code for a reproducible project, you must understand the purpose that a specific code chunk has in the broader project. Some pieces of code are for cleaning and preprocessing the data, some are for doing the statistical analysis, and some are for creating graphics. Code for different purposes will be stored in different directories.

## Column A

Because bioinformatics uses non-standard data formats with CEL files for microarrays, I create a new directory called “datasrc” that stores my code (both R code and unix commands) for obtaining the data (in this case from the Gene Expression Omnibus and directly from a collaborator) and creating an expression set. This code is only reproducible in an interactive session since it involes opening and closing R. Often I will integrate this datasrc code into a README.markdown file in the data directory that explains exactly how I obtained the code.

 I store the expression set I get from this process in the `data` directory. For reproducibility, I consider this data source to be the “primary” data source. If someone wants to go back to GEO, that is fine and the code is provided in the `datasrc` or README file. But for reproducibility purposes, if someone wants to reproduce my project, this expression set of the raw data is the easiest starting point, since the entire analysis from this point forward is performed in R. Starting with munging would be starting at point A in the diagram. 

Now that the raw data has been stored, the next step is to preprocess it. All of the preprocessing code is stored in the `munge` directory (munge is a term for data obtaining and data cleaning). At the end of munging the data, the new preprocessed objects are cached to the `cache` directory, where they can be loaded for further analysis. The benefit of organizing the preprocessing steps this way is two-fold. First, once they are completed and the preprocessed datasets are cached, you do not need to re-run the (often time-consuming) munging step and can instead start the analysis with the cached datasets (point B in the diagram). Second, in the ProjectTemplate `config` file, you can easily toggle between having the munging step on or off. That way, if you want to rerun the analysis from scratch, you can do so. But, most of the time you will want to start from these cached datasets instead.

In addition to the expression set, you may have a file containing annotation information (many common file formats are loaded automatically by ProjectTemplate if they are in the `data` diretory). It's a good idea to cache smaller files so that you can load them without also loading the large raw dataset.

The config file will likely look like this during this portion of the analysis (i.e. starting from point A):
    data_loading: on
    cache_loading: off
    munging: on

## Column B
After this, the bulk of the “research” code goes into the `src` directory. This is where you place all of your code for discovering things from the data. However, a useful step at this point is to create helper functions. Ideally, code in the `src` directory would mostly be calling functions that are either from pacakges, or stored in the `lib` directory. All the contents of the `lib` directory are loaded to your R worksplace when you load the project. This will help keep your `src` code clean and easy to follow.

The config file will likely look like this during this portion of the analysis (i.e. starting from point B):
    data_loading: off
    cache_loading: on
    munging: off

## Column C
Finally, an important part of this process is creating a reproducible document -- likely a journal article. This can be accomplished using the R package `knitr`, which creates dynamic reports that evaluate R code in order to produce the graphics/tables therein. The document is put in the `doc` directory, and knit from there. The majority of the R code evaluated within the knit document should be creating graphs and tables from the cached results that were produced in column B in the diagram. Because this code evaluates quickly, this allows for the knitting process to be fast (note that unless you are creating graphs of the raw data, you should turn off data loading to expediate the knitting process). Without cached results, knitting genomic analyses would be impossible due to the time it takes to run an individual analysis.

The config file should look like this while creating and knitting the document (i.e. starting from point B):
    data_loading: off
    cache_loading: on
    munging: off
	
With the config file like that, the user needs simply run


```r
library(knitr)
knit(paper.Rnw)
```


and the fully reproducible paper is created.

## General Project Notes
Finally, when possible, it is best to put the entire project on to GitHub. If you have very large data files (in this case I have the CEL files) it's a good idea to use the .gitignore file. Add to the file the directories you want to ignore. For files that 

Ideally, when this system is working, the reproduction of a paper is almost effortless. If someone wants to play around with your data and results, they need simply clone the project to their comptuer. Then, they just open an R session, set the working directory to the home directory of the cloned project, and run 


```r
library(ProjectTemplate)
load.project()
```

	
with the appropriate config file.


# This Analysis
First I load the data (obtained from a collaborator -- reading in the CEL files is in the `datasrc` directory).


```r
library(ProjectTemplate)
load.project()
```
























