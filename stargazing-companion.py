#!/usr/bin/env python

# Stargazing Companion, https://github.com/whitinobservatory/stargazing-companion/
# with gratitude to Steve Berardi and Starplot, https://github.com/steveberardi/starplot/blob/main/CITATION.cff
# 2025 Dec 1 - Jonathan Kemp, initial version, Whitin Observatory
# 2026 Apr 16 - Jonathan Kemp, release version, Whitin Observatory

# stargazing companion
# core python code
# creates dark background graphic, light background graphic, sensible printable graphic
# python required environment
# requires at least python version 3.10
# tested with python version 3.13.5
# starplot required dependency, https://starplot.dev/installation/
# requires at least starplot version 0.19
# tested with starplot version 0.20.2
# uses starplot's zenithplot functionality

# import needed python libraries
from sys import version_info, exit
from importlib.metadata import version, PackageNotFoundError
from datetime import datetime
from zoneinfo import ZoneInfo
from starplot import ZenithPlot, Observer, Planet, callables, _
from starplot.styles import PlotStyle, ObjectStyle, MarkerStyle, MarkerSymbolEnum, FillStyleEnum, ZOrderEnum, LabelStyle, FontWeightEnum, extensions

# required dependencies check
if version_info < (3,10):
    exit("python version at least 3.10 is not installed, exiting")
try:
    if version("starplot") < "0.19":
        exit("starplot version at least 0.19 is not installed, exiting")
except PackageNotFoundError:
    exit("starplot is not installed, exiting")

# set observer timezone
tz = ZoneInfo( "America/New_York" ) # <- USER EDIT
# set observer time
# note: consider date 14th for Feb, 15th for Apr/Jun/Sep/Nov, 16th for Jan/Mar/May/Jul/Aug/Oct/Dec
# note: Feb has 28/29 d, Apr/Jun/Sep/Nov have 30 d, Jan/Mar/May/Jul/Aug/Oct/Dec have 31 d
# note: consider time 21:00 for Feb/Mar/Apr, 22:00 for May/Jun/Jul, 21:00 for Aug/Sept/Oct, 20:00 Nov/Dec/Jan, for mid-northern temperate latitudes
dt = datetime( 2026, 4, 15, 21, 0, tzinfo=tz ) # <- USER EDIT
# set observer geographic coordinates
observer = Observer( dt = dt, lat = 42.2950, lon = -71.3025 ) # <- USER EDIT

# obtain planet data of interest, omit planets not typically seen by visual observers
mercury = Planet.get( name = "Mercury", observer = observer )
venus = Planet.get( name = "Venus", observer = observer )
mars = Planet.get( name = "Mars", observer = observer )
jupiter = Planet.get( name = "Jupiter", observer = observer )
saturn = Planet.get( name = "Saturn", observer = observer )

# define shared plot elements function
def userplot():
    # plot sky elements of general interest
    p.horizon()
    p.constellations()
    p.constellation_labels()
    p.milky_way()
    p.ecliptic( num_labels = 0 )
    p.stars( where = [ _.magnitude < 4.0 ] , where_labels = [ _.magnitude < 2.375 ] )
    p.galaxies( where = [ _.magnitude < 8.5 ] , where_labels = [ _.magnitude < 8.5 ], where_true_size = [ False ]  )
    p.open_clusters( where = [ _.magnitude < 6.0 ] , where_labels = [ _.magnitude < 6.0 ], where_true_size = [ False ] )
    p.globular_clusters( where = [ _.magnitude < 6.0 ] , where_labels = [ _.magnitude < 6.0 ], where_true_size = [ False ] )
    p.nebula( where = [ _.magnitude < 8.0 ] , where_labels = [ _.magnitude < 8.0 ], where_true_size = [ False ] )
    # plot special interest sky elements differently
    p.stars( where = [ _.magnitude <= 3.35, _.dec >= 55.0, _.dec <= 65.0, _.ra >= 0 * 15.0, _.ra <= 2 * 15.0 ], size_fn = lambda d: callables.size_by_magnitude( d ) * 2, # <- USER EDIT
        style__marker__symbol = "star_8", style__label__offset_x = 8, style__label__offset_y = -8, style__label__border_width = 0, where_labels = [ False ] )             # <- USER EDIT
    # create plot legend
    p.legend( title = "Object Types", style__title_font_size = 24, style__font_size = 18, style__symbol_size = 24, style__location = "lower left",
        style__border_padding = 0.75, style__num_columns = 2, style__padding_x = 136, style__padding_y = 136, style__label_padding = 1.25 )
    p.star_magnitude_scale( title = "Star Magnitudes", style__title_font_size = 24, style__font_size = 18, style__symbol_size = 24, style__location = "lower right",
        style__border_padding = 0.75, style__num_columns = 2, style__padding_x = 136, style__padding_y = 136, style__label_padding = 1.25, add_to_legend = False, start = -1, stop = 6, step = 1 )

# configure first zenith plot, dark background graphic, https://starplot.dev/reference-zenithplot/
p = ZenithPlot( observer = observer, style = PlotStyle().extend( extensions.BLUE_NIGHT ), resolution = 4096, autoscale = True, hide_colliding_labels = True )
# plot planets of interest, omit planets not typically seen by visual observers, specify graphic specific color
p.marker( ra = mercury.ra, dec = mercury.dec, label = "MERCURY",
    style = { "marker": { "symbol": MarkerSymbolEnum.CIRCLE, "size": 28, "fill": FillStyleEnum.LEFT, "zorder": ZOrderEnum.LAYER_3, "alpha": 1.0, "color": "#cb8e29", "fill": "full" },
    "label": { "font_size": 28, "font_weight": FontWeightEnum.BOLD, "offset_x": "auto", "offset_y": "auto", "font_color": "#f3cd91" } } )
p.marker( ra = venus.ra, dec = venus.dec, label = "VENUS",
    style = { "marker": { "symbol": MarkerSymbolEnum.CIRCLE, "size": 28, "fill": FillStyleEnum.LEFT, "zorder": ZOrderEnum.LAYER_3, "alpha": 1.0, "color": "#cb8e29", "fill": "full" },
    "label": { "font_size": 28, "font_weight": FontWeightEnum.BOLD, "offset_x": "auto", "offset_y": "auto", "font_color": "#f3cd91" } } )
p.marker( ra = mars.ra, dec = mars.dec, label = "MARS",
    style = { "marker": { "symbol": MarkerSymbolEnum.CIRCLE, "size": 28, "fill": FillStyleEnum.LEFT, "zorder": ZOrderEnum.LAYER_3, "alpha": 1.0, "color": "#cb8e29", "fill": "full" },
    "label": { "font_size": 28, "font_weight": FontWeightEnum.BOLD, "offset_x": "auto", "offset_y": "auto", "font_color": "#f3cd91" } } )
p.marker( ra = jupiter.ra, dec = jupiter.dec, label = "JUPITER",
    style = { "marker": { "symbol": MarkerSymbolEnum.CIRCLE, "size": 28, "fill": FillStyleEnum.LEFT, "zorder": ZOrderEnum.LAYER_3, "alpha": 1.0, "color": "#cb8e29", "fill": "full" },
    "label": { "font_size": 28, "font_weight": FontWeightEnum.BOLD, "offset_x": "auto", "offset_y": "auto", "font_color": "#f3cd91" } } )
p.marker( ra = saturn.ra, dec = saturn.dec, label = "SATURN",
    style = { "marker": { "symbol": MarkerSymbolEnum.CIRCLE, "size": 28, "fill": FillStyleEnum.LEFT, "zorder": ZOrderEnum.LAYER_3, "alpha": 1.0, "color": "#cb8e29", "fill": "full" },
    "label": { "font_size": 28, "font_weight": FontWeightEnum.BOLD, "offset_x": "auto", "offset_y": "auto", "font_color": "#f3cd91" } } )
# plot all planets underneath bottom layer, to activate planets legend entry
p.planets( labels = False, style = { "marker": { "symbol": MarkerSymbolEnum.CIRCLE, "size": 28, "fill": FillStyleEnum.LEFT, "zorder": -2500, "alpha": 1.0, "color": "#cb8e29", "fill": "full" } } )
# call shared plot elements function
userplot()
# save plot graphic
p.export( "stargazing-companion-dark-raw.png", transparent = False, padding = 0.0 )

# configure second zenith plot, light background graphic, https://starplot.dev/reference-zenithplot/
p = ZenithPlot( observer = observer, style = PlotStyle().extend( extensions.BLUE_MEDIUM ), resolution = 4096, autoscale = True, hide_colliding_labels = True )
# plot planets of interest, omit planets not typically seen by visual observers, specify graphic specific color
p.marker( ra = mercury.ra, dec = mercury.dec, label = "MERCURY",
    style = { "marker": { "symbol": MarkerSymbolEnum.CIRCLE, "size": 28, "fill": FillStyleEnum.LEFT, "zorder": ZOrderEnum.LAYER_3, "alpha": 1.0, "color": "#dd952d", "fill": "full" },
    "label": { "font_size": 28, "font_weight": FontWeightEnum.BOLD, "offset_x": "auto", "offset_y": "auto", "font_color": "#000000" } } )
p.marker( ra = venus.ra, dec = venus.dec, label = "VENUS",
    style = { "marker": { "symbol": MarkerSymbolEnum.CIRCLE, "size": 28, "fill": FillStyleEnum.LEFT, "zorder": ZOrderEnum.LAYER_3, "alpha": 1.0, "color": "#dd952d", "fill": "full" },
    "label": { "font_size": 28, "font_weight": FontWeightEnum.BOLD, "offset_x": "auto", "offset_y": "auto", "font_color": "#000000" } } )
p.marker( ra = mars.ra, dec = mars.dec, label = "MARS",
    style = { "marker": { "symbol": MarkerSymbolEnum.CIRCLE, "size": 28, "fill": FillStyleEnum.LEFT, "zorder": ZOrderEnum.LAYER_3, "alpha": 1.0, "color": "#dd952d", "fill": "full" },
    "label": { "font_size": 28, "font_weight": FontWeightEnum.BOLD, "offset_x": "auto", "offset_y": "auto", "font_color": "#000000" } } )
p.marker( ra = jupiter.ra, dec = jupiter.dec, label = "JUPITER",
    style = { "marker": { "symbol": MarkerSymbolEnum.CIRCLE, "size": 28, "fill": FillStyleEnum.LEFT, "zorder": ZOrderEnum.LAYER_3, "alpha": 1.0, "color": "#dd952d", "fill": "full" },
    "label": { "font_size": 28, "font_weight": FontWeightEnum.BOLD, "offset_x": "auto", "offset_y": "auto", "font_color": "#000000" } } )
p.marker( ra = saturn.ra, dec = saturn.dec, label = "SATURN",
    style = { "marker": { "symbol": MarkerSymbolEnum.CIRCLE, "size": 28, "fill": FillStyleEnum.LEFT, "zorder": ZOrderEnum.LAYER_3, "alpha": 1.0, "color": "#dd952d", "fill": "full" },
    "label": { "font_size": 28, "font_weight": FontWeightEnum.BOLD, "offset_x": "auto", "offset_y": "auto", "font_color": "#000000" } } )
# plot all planets underneath bottom layer, to activate planets legend entry
p.planets( labels = False, style = { "marker": { "symbol": MarkerSymbolEnum.CIRCLE, "size": 28, "fill": FillStyleEnum.LEFT, "zorder": -2500, "alpha": 1.0, "color": "#dd952d", "fill": "full" } } )
# call shared plot elements function
userplot()
# save plot graphic
p.export( "stargazing-companion-light-raw.png", transparent = False, padding = 0.0 )

# configure third zenith plot, sensible printable graphic, https://starplot.dev/reference-zenithplot/
p = ZenithPlot( observer = observer, style = PlotStyle().extend( extensions.BLUE_LIGHT ), resolution = 4096, autoscale = True, hide_colliding_labels = True )
# plot planets of interest, omit planets not typically seen by visual observers, specify graphic specific color
p.marker( ra = mercury.ra, dec = mercury.dec, label = "MERCURY",
    style = { "marker": { "symbol": MarkerSymbolEnum.CIRCLE, "size": 28, "fill": FillStyleEnum.LEFT, "zorder": ZOrderEnum.LAYER_3, "alpha": 1.0, "color": "#dd952d", "fill": "full" },
    "label": { "font_size": 28, "font_weight": FontWeightEnum.BOLD, "offset_x": "auto", "offset_y": "auto", "font_color": "#000000" } } )
p.marker( ra = venus.ra, dec = venus.dec, label = "VENUS",
    style = { "marker": { "symbol": MarkerSymbolEnum.CIRCLE, "size": 28, "fill": FillStyleEnum.LEFT, "zorder": ZOrderEnum.LAYER_3, "alpha": 1.0, "color": "#dd952d", "fill": "full" },
    "label": { "font_size": 28, "font_weight": FontWeightEnum.BOLD, "offset_x": "auto", "offset_y": "auto", "font_color": "#000000" } } )
p.marker( ra = mars.ra, dec = mars.dec, label = "MARS",
    style = { "marker": { "symbol": MarkerSymbolEnum.CIRCLE, "size": 28, "fill": FillStyleEnum.LEFT, "zorder": ZOrderEnum.LAYER_3, "alpha": 1.0, "color": "#dd952d", "fill": "full" },
    "label": { "font_size": 28, "font_weight": FontWeightEnum.BOLD, "offset_x": "auto", "offset_y": "auto", "font_color": "#000000" } } )
p.marker( ra = jupiter.ra, dec = jupiter.dec, label = "JUPITER",
    style = { "marker": { "symbol": MarkerSymbolEnum.CIRCLE, "size": 28, "fill": FillStyleEnum.LEFT, "zorder": ZOrderEnum.LAYER_3, "alpha": 1.0, "color": "#dd952d", "fill": "full" },
    "label": { "font_size": 28, "font_weight": FontWeightEnum.BOLD, "offset_x": "auto", "offset_y": "auto", "font_color": "#000000" } } )
p.marker( ra = saturn.ra, dec = saturn.dec, label = "SATURN",
    style = { "marker": { "symbol": MarkerSymbolEnum.CIRCLE, "size": 28, "fill": FillStyleEnum.LEFT, "zorder": ZOrderEnum.LAYER_3, "alpha": 1.0, "color": "#dd952d", "fill": "full" },
    "label": { "font_size": 28, "font_weight": FontWeightEnum.BOLD, "offset_x": "auto", "offset_y": "auto", "font_color": "#000000" } } )
# plot all planets underneath bottom layer, to activate planets legend entry
p.planets( labels = False, style = { "marker": { "symbol": MarkerSymbolEnum.CIRCLE, "size": 28, "fill": FillStyleEnum.LEFT, "zorder": -2500, "alpha": 1.0, "color": "#dd952d", "fill": "full" } } )
# call shared plot elements function
userplot()
# save plot graphics
p.export( "stargazing-companion-print-raw.png", transparent = False, padding = 0.0 )
p.export( "stargazing-companion-print-raw.pdf", transparent = False, padding = 0.0 )
