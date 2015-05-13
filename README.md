Simple algorithms to display ignorance maps of raw distributional data accessed from species observation databases
=======================================================================================================================
The Swedish LifeWatch implementation


This is an HTML interactive application compiled in R that accompanies the text:
Simple algorithms to display ignorance maps of raw distributional data accessed from species observation databases: the Swedish LifeWatch implementation

This interactive application exemplifies the use of three algorithms to map the ignorance (i.e. lack of sampling effort) found in the observations accessed through the Swedish LifeWatch biodiversity analysis portal.

To run it you will need R <http://www.r-project.org/> with the following packages installed: shiny, raster, rgdal, and maptools.

       install.packages(c("shiny", "raster", "rgdal", "maptools"))

NOTE: there are some known issues when installing the package "rgdal" on Linux.
Please, refer to this blog <http://robinlovelace.net/r/2013/11/26/installing-rgdal-on-ubuntu.html>  or this blog <https://philmikejones.wordpress.com/2014/07/14/installing-rgdal-in-r-on-linux/> to solve the issue.

All data required to run this script is provided in the ZIP file.
The structure of this folder should be kept as is.

Execute the following script in R to run the interactive application.

	require(shiny)
  shiny::runGitHub(repo="IgnoranceMaps", username="alejandroruete", subdir="SLWapp")

Alternarively, download the files and run the following scripts.
  runApp("~/SLWapp") # where ~ indicates the path of the folder.
	runApp("~/SLWapp",display.mode = "showcase") # Use this command to see the R code



### Authors and Contributors
Application developed by Alejandro Ruete in Dec 2014.

<p>Author: Alejandro Ruete, for the Swedish LifeWatch</p>

<p>Swedish Species Information Centre, Swedish University of Agricultural Sciences (SLU). P.O.7007, SE-750 07. Uppsala, Sweden. </p>

<p>E-mail: <a href="mailto:aleruete@gmail.com">aleruete@gmail.com</a><u></u></p>

<p><i>Keywords</i>:citizen-science data, open-access biodiversity database, presence-only data, sampling effort, spatial bias, species distribution model, temporal bias</p>

<p><o:p></o:p></p>

<p>This interactive application exemplifies the use of three
different algorithms to map the ignorance (i.e. bias and lack of sampling
effort) found in the observations accessed through the Swedish LifeWatch biodiversity analysis portal
<a href="http://www.swedishlifewatch.se">www.swedishlifewatch.se</a>.</p>

<p>Examples are provided for seven reference taxonomic groups
(i.e. Amphibians, Birds, Butterflies, Land Mammals, Harvestmen, Dragonflies,
and Vascular Plants) as groups with different sampling effort intensity and
extension as well as different number of amateur observers reporting
observations to the database. For each group we show examples of a common (or
widely distributed) and a rare (or locally distributed) species. Note that in
many cases common species are not reported as enthusiastically as more
interesting species are (in Sweden, a moose is not as frequently reported as
hedgehogs are). Therefore, one can expect that for common species the observations
are very scattered and they do not cover the whole expected range of the
species.</p>

<p><b>Tabs (Maps, Data plots, and Read me)</b></p>

<p>You are now reading under the &ldquo;Read me&rdquo; tab. The data is
shown the form of &ldquo;Maps&rdquo; and &ldquo;Data plots&rdquo;. Four maps of Sweden with a
resolution of 10 x 10 km are plotted under the tab &ldquo;Maps&rdquo; displaying: </p>

<p> 1) the number of observations per pixel for the
reference taxonomic group selected,</p>

<p> 2) the ignorance scores per pixel,</p>

<p> 3) an estimate of pseudo-absence (henceforth ps.absences) for the
selected target species. Ps.absences are estimated with the same algorithms used to produce the
ignorance maps. Be aware that the results of the algorithms for a single
species have a different interpretation than for a reference target group. For
individual target species the lack of observations could represent a true
absence or lack of observers. To separate true absences from the lack of
observers we could weight ps.absence estimates with
the ignorance map as it is shown in the next map. Also, be aware that
especially for common species or species that are not likely to be reported as
frequently as they are seen, these estimates of ps.absences
are not reliable because the raw data is not reliable. <br>Disclaimer: the pseudo-absence
map is only an exercise to explore the use of the ignorance map.</br></p>

<p> 4) the presence map (P = 1- ps.absences; i.e. scaled observations). This is an
example of the use of ignorance maps to weight and mask different estimates for
target species. In this case, the black to white scale represents the scaled
observations or the knowledge we have on the presence of the species. On top, a
transparent layer shows areas where a minimum certainty for ps.absences
or presence is achieved after multiplying 1-ignorance (i.e. certainty) by the ps.absences (red) or presence (green). Then, areas where
there is low ignorance but the target species has not been found are shown in
red, while areas where the target species has been found but a minimum
certainty is required are shown in green. </p>

<p>The outline in those maps is a 10km buffer around the
Swedish land surface. </p>

<p>Under the &ldquo;ata plots&rdquo; tab you find: </p>

<p> 1) a density plot of the number of observations per
grid cell, </p>

<p> 2) a species discovery plot and </p>

<p> 3) curves of the transformations of the number of observation into ignorance scores (note that
this later plot is reactive to the value set for <i>O</i><sub>0.5</sub>).</p>

<p><b>Options<o:p></o:p></b></p>

<p>On the left panel you find options for the Reference
taxonomic group and Target species to be displayed. First, you can opt to use
the raw observations as a measure of sampling effort or the Observation Index,
a sampling effort relative to the number of species sampled in a particular
grid cell. On each subpanel you can set the algorithm can be set and O<sub>0.5</sub>
(the number of observations that are enough to reduce the ignorance score to
0.5) for the Inversed algorithm. For target species, a Step algorithm is added
where any observation number below O<sub>0.5</sub> sets the ignorance score to
0. Else the Step algorithm is equal to the Inversed algorithm.</p>
