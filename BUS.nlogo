globals [ infected-population infx infy nb-infected nb-exposed nb-protected protect nb-dist stayhome ]
breed [ humanes human ]
breed [city1human a-city1human]
turtles-own [exposed? infected? noninfectious? day]       ; the humanes can gain infected
patches-own [ countdown ]

to setup
  clear-all

  ask patches

;  [ set pcolor 33 ]   ;uncomment for ncr map
 ; import-pcolors-rgb "Train.png"
;  ask patches with [ not shade-of? 33 pcolor ] [
;    ; if you're not part of the ocean, you are part of the continent
;    set pcolor 55
;  ]

  [

    ifelse (pycor < 0 and pxcor = 1) or (pycor < 0 and pxcor = 3) or (pycor < 0 and pxcor = 5) or (pycor < 0 and pxcor = 7) or (pycor < 0 and pxcor = 9) or
    (pycor < 0 and pxcor = -1) or (pycor < 0 and pxcor = -3) or (pycor < 0 and pxcor = -5) or (pycor < 0 and pxcor = -7) or ;(pycor < 0 and pxcor = -9) or
   (pycor > 0 and pxcor = 1) or (pycor > 0 and pxcor = 3) or (pycor > 0 and pxcor = 5) or (pycor > 0 and pxcor = 7) or (pycor > 0 and pxcor = 9) or
    (pycor > 0 and pxcor = -1) or (pycor > 0 and pxcor = -3) or (pycor > 0 and pxcor = -5) or (pycor > 0 and pxcor = -7) or (pxcor = -9) or
    (pycor < 0 and pxcor = 11) or (pycor < 0 and pxcor = 13) or (pycor > 0 and pxcor = 11) or (pycor > 0 and pxcor = 13)
    [set pcolor 46]
    [ifelse (pycor < 0)
      [ set pcolor 33]
      [ ifelse (pycor > 0)
         [ set pcolor 33]
        [set pcolor 86 ]
      ]
    ]


  ]



  set-default-shape city1human "person"
  create-city1human maximum-capacity * crowd-density  ; create the humanes, then initialize their variables
  [
    set color white
    set size 1  ; easier to see
    ifelse social-distancing? [
      ifelse who < 25
      [
      move-to one-of patches with [ pcolor = 46 and (pycor = -2 or pycor = 0 or pycor = 2)  and not any? turtles-here ]]

      [
        move-to one-of patches with [ pcolor = 86  ]]
    ]
     [ifelse who < 49
      [
      move-to one-of patches with [ pcolor = 46 and not any? turtles-here ]]

      [
        move-to one-of patches with [ pcolor = 86  ]]]
    set infected? false
    set exposed? false
    if (random-float 100 < init-inf)
    [
      set infected? true
      set nb-infected (nb-infected + 1)

    ]
    if (random-float 100 < init-exp)
    [
      set exposed? true
      set nb-exposed (nb-exposed + 1)

    ]
    assign-color
  ]


  reset-ticks
end

to assign-color  ;; turtle procedure
  if infected?
    [ set color red ]
  if exposed?
    [ set color yellow]
end

to go
;  ifelse interact? [
;    if count turtles with [color = white or color = yellow] = 0 [ user-message "All have been infected" stop ]
;  ]
;  [
    if ticks > 10 [ user-message  (word "No. of infecteds are " nb-infected ) stop]
;  ]
  ;if count turtles with [color = white] = 0 [ user-message "All have been infected" stop ]
   ask turtles [
    move
    bounce
    ;death
  ]
  ask turtles with [ exposed? ]
  [
   handwash
   ;positive
  ]
  ask turtles with [ infected? ]
  [
      infect

  ]

  tick
  ;display-labels
end
to handwash
  ;ask humanes with [ exposed? ]
  ask turtles with [color = yellow]
  [ifelse random-float 100 < Protection
    [ set exposed? false
      set nb-protected (nb-protected + 1)
      set color white
    ]

    [ set infected? true
      set nb-infected (nb-infected + 1)
      set color red
    ]
  ]
end

to infect  ;; turtle procedure
if day <= 14
  [
   let nearby-uninfected (turtles-on neighbors)
   with [ not infected? and not exposed? ]


  ask nearby-uninfected
   [ ask nearby-uninfected in-radius 2 ;2 persons away
      [ if random-float 100 < 50
         [ set exposed? true
           set nb-exposed (nb-exposed + 1)
          set color yellow
         ]
       ]
  ]
  ask nearby-uninfected
    [ ask nearby-uninfected in-radius 1 ;1 person away
      [ if random-float 100 < 100
         [ set exposed? true
           set nb-exposed (nb-exposed + 1)
          set color yellow
         ]
       ]
  ]
   set day day + 1


  ]
end


;to positive
;  ;ask humanes with [ exposed? ]
;
;  ask humanes with [color = yellow]
;  [if random-float 100 < 90
;    [ set infected? true
;      set nb-infected (nb-infected + 1)
;      set color red
;    ]
;  ]
;end


to move  ; turtle procedure
  rt random 50
  lt random 50
  ifelse interact?
  [ fd 1
  ]
  [fd 0]
end

to bounce  ;for turtles to not go to the borders
  if (pxcor = min-pxcor or pycor = min-pycor or pxcor = max-pxcor or pycor = max-pycor) [
      set heading (heading + 180) mod 360
  ]
  if social-distancing? [
  ask turtles in-radius 1
    [ set heading (heading + 180) mod 360
      set nb-dist (nb-dist + 1)
    ]
  ]
end

;to death  ; turtle procedure
;  if (random-float 100 < death-rate) [ die ]
;end



; Copyright 1997 Uri Wilensky.
; See Info tab for full copyright and license.
@#$#@#$#@
GRAPHICS-WINDOW
417
68
1298
259
-1
-1
36.4
1
14
1
1
1
0
0
0
1
-9
14
-2
2
1
1
1
ticks
30.0

BUTTON
8
28
77
61
setup
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
91
29
158
62
go
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

TEXTBOX
12
67
125
85
Human settings
11
0.0
0

SWITCH
167
28
299
61
social-distancing?
social-distancing?
0
1
-1000

TEXTBOX
1180
401
1330
419
NIL
11
0.0
1

TEXTBOX
-1
818
149
836
Monitors
11
0.0
1

TEXTBOX
0
977
183
1005
========Output========
11
0.0
1

TEXTBOX
-6
646
144
664
Treatment Area settings
11
0.0
1

TEXTBOX
-4
733
146
751
Infection Area settings
11
0.0
1

MONITOR
166
89
238
134
NIL
nb-infected
17
1
11

INPUTBOX
7
85
162
145
maximum-capacity
49.0
1
0
Number

MONITOR
240
89
319
134
NIL
nb-protected
17
1
11

MONITOR
322
88
396
133
NIL
nb-exposed
17
1
11

INPUTBOX
41
523
196
583
init-exp
0.0
1
0
Number

TEXTBOX
7
278
157
296
primary cases (in %)
11
0.0
1

SLIDER
5
236
177
269
Protection
Protection
0
100
50.0
1
1
NIL
HORIZONTAL

TEXTBOX
7
218
196
246
Protection after being exposed ( %)
11
0.0
1

SWITCH
301
28
413
61
interact?
interact?
1
1
-1000

MONITOR
187
159
280
204
NIL
count (turtles)
17
1
11

PLOT
180
218
412
338
No. of Infecteds
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Infecteds" 1.0 0 -8053223 true "" "plot count turtles with [ color = red]"
"Exposed" 1.0 0 -1184463 true "plot count turtles with [color = yellow]" "plot count turtles with [ color = yellow]"

SLIDER
4
170
176
203
crowd-density
crowd-density
0
2
0.5
.1
1
NIL
HORIZONTAL

TEXTBOX
13
153
163
171
crowd density
11
0.0
1

SLIDER
4
300
176
333
init-inf
init-inf
0
100
25.0
1
1
NIL
HORIZONTAL

TEXTBOX
190
141
340
159
current load
11
0.0
1

@#$#@#$#@
## WHAT IS IT?

This model explores the stability of predator-prey ecosystems. Such a system is called unstable if it tends to result in extinction for one or more species involved.  In contrast, a system is stable if it tends to maintain itself over time, despite fluctuations in population sizes.

## HOW IT WORKS

There are two main variations to this model.

In the first variation, wolves and sheep wander randomly around the landscape, while the wolves look for sheep to prey on. Each step costs the wolves energy, and they must eat sheep in order to replenish their energy - when they run out of energy they die. To allow the population to continue, each wolf or sheep has a fixed probability of reproducing at each time step. This variation produces interesting population dynamics, but is ultimately unstable.

The second variation includes grass (green) in addition to wolves and sheep. The behavior of the wolves is identical to the first variation, however this time the sheep must eat grass in order to maintain their energy - when they run out of energy they die. Once grass is eaten it will only regrow after a fixed amount of time. This variation is more complex than the first, but it is generally stable.

The construction of this model is described in two papers by Wilensky & Reisman referenced below.

## HOW TO USE IT

1. Set the GRASS? switch to TRUE to include grass in the model, or to FALSE to only include wolves (red) and sheep (white).
2. Adjust the slider parameters (see below), or use the default settings.
3. Press the SETUP button.
4. Press the GO button to begin the simulation.
5. Look at the monitors to see the current population sizes
6. Look at the POPULATIONS plot to watch the populations fluctuate over time

Parameters:
INITIAL-NUMBER-SHEEP: The initial size of sheep population
INITIAL-NUMBER-WOLVES: The initial size of wolf population
SHEEP-GAIN-FROM-FOOD: The amount of energy sheep get for every grass patch eaten
WOLF-GAIN-FROM-FOOD: The amount of energy wolves get for every sheep eaten
SHEEP-REPRODUCE: The probability of a sheep reproducing at each time step
WOLF-REPRODUCE: The probability of a wolf reproducing at each time step
GRASS?: Whether or not to include grass in the model
GRASS-REGROWTH-TIME: How long it takes for grass to regrow once it is eaten
SHOW-ENERGY?: Whether or not to show the energy of each animal as a number

Notes:
- one unit of energy is deducted for every step a wolf takes
- when grass is included, one unit of energy is deducted for every step a sheep takes

## THINGS TO NOTICE

When grass is not included, watch as the sheep and wolf populations fluctuate. Notice that increases and decreases in the sizes of each population are related. In what way are they related? What eventually happens?

Once grass is added, notice the green line added to the population plot representing fluctuations in the amount of grass. How do the sizes of the three populations appear to relate now? What is the explanation for this?

Why do you suppose that some variations of the model might be stable while others are not?

## THINGS TO TRY

Try adjusting the parameters under various settings. How sensitive is the stability of the model to the particular parameters?

Can you find any parameters that generate a stable ecosystem that includes only wolves and sheep?

Try setting GRASS? to TRUE, but setting INITIAL-NUMBER-WOLVES to 0. This gives a stable ecosystem with only sheep and grass. Why might this be stable while the variation with only sheep and wolves is not?

Notice that under stable settings, the populations tend to fluctuate at a predictable pace. Can you find any parameters that will speed this up or slow it down?

Try changing the reproduction rules -- for example, what would happen if reproduction depended on energy rather than being determined by a fixed probability?

## EXTENDING THE MODEL

There are a number ways to alter the model so that it will be stable with only wolves and sheep (no grass). Some will require new elements to be coded in or existing behaviors to be changed. Can you develop such a version?

Can you modify the model so the sheep will flock?

Can you modify the model so that wolf actively chase sheep?

## NETLOGO FEATURES

Note the use of breeds to model two different kinds of "turtles": wolves and sheep. Note the use of patches to model grass.

Note use of the ONE-OF agentset reporter to select a random sheep to be eaten by a wolf.

## RELATED MODELS

Look at Rabbits Grass Weeds for another model of interacting populations with different rules.

## CREDITS AND REFERENCES

Wilensky, U. & Reisman, K. (1999). Connected Science: Learning Biology through Constructing and Testing Computational Theories -- an Embodied Modeling Approach. International Journal of Complex Systems, M. 234, pp. 1 - 12. (This model is a slightly extended version of the model described in the paper.)

Wilensky, U. & Reisman, K. (2006). Thinking like a Wolf, a Sheep or a Firefly: Learning Biology through Constructing and Testing Computational Theories -- an Embodied Modeling Approach. Cognition & Instruction, 24(2), pp. 171-209. http://ccl.northwestern.edu/papers/wolfsheep.pdf

## HOW TO CITE

If you mention this model or the NetLogo software in a publication, we ask that you include the citations below.

For the model itself:

* Wilensky, U. (1997).  NetLogo Wolf Sheep Predation model.  http://ccl.northwestern.edu/netlogo/models/WolfSheepPredation.  Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL.

Please cite the NetLogo software as:

* Wilensky, U. (1999). NetLogo. http://ccl.northwestern.edu/netlogo/. Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL.

## COPYRIGHT AND LICENSE

Copyright 1997 Uri Wilensky.

![CC BY-NC-SA 3.0](http://ccl.northwestern.edu/images/creativecommons/byncsa.png)

This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 3.0 License.  To view a copy of this license, visit https://creativecommons.org/licenses/by-nc-sa/3.0/ or send a letter to Creative Commons, 559 Nathan Abbott Way, Stanford, California 94305, USA.

Commercial licenses are also available. To inquire about commercial licenses, please contact Uri Wilensky at uri@northwestern.edu.

This model was created as part of the project: CONNECTED MATHEMATICS: MAKING SENSE OF COMPLEX PHENOMENA THROUGH BUILDING OBJECT-BASED PARALLEL MODELS (OBPML).  The project gratefully acknowledges the support of the National Science Foundation (Applications of Advanced Technologies Program) -- grant numbers RED #9552950 and REC #9632612.

This model was converted to NetLogo as part of the projects: PARTICIPATORY SIMULATIONS: NETWORK-BASED DESIGN FOR SYSTEMS LEARNING IN CLASSROOMS and/or INTEGRATED SIMULATION AND MODELING ENVIRONMENT. The project gratefully acknowledges the support of the National Science Foundation (REPP & ROLE programs) -- grant numbers REC #9814682 and REC-0126227. Converted from StarLogoT to NetLogo, 2000.

<!-- 1997 2000 -->
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.0.4
@#$#@#$#@
set grass? true
setup
repeat 75 [ go ]
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="Aggregation Experiment Trial" repetitions="1" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="1000"/>
    <metric>mean [parasites] of fishes</metric>
    <enumeratedValueSet variable="parasite-load-in-zooplankton">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="zooplankton-reproduction-rate">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fatal-parasite-load">
      <value value="80"/>
    </enumeratedValueSet>
    <steppedValueSet variable="initial-number-zooplankton" first="550" step="1000" last="5550"/>
    <enumeratedValueSet variable="fish-reproduction-rate">
      <value value="0"/>
    </enumeratedValueSet>
    <steppedValueSet variable="initial-fish-population" first="50" step="100" last="550"/>
    <enumeratedValueSet variable="show-parasites?">
      <value value="true"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="experiment" repetitions="1" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="1000"/>
    <metric>mean [parasites] of fishes</metric>
    <metric>variance [parasites] of fishes</metric>
    <metric>( ( mean [parasites] of fishes ^ 2 ) - ( ( variance [parasites] of fishes ) / N ) ) / ( ( variance [parasites] of fishes ) - ( mean [parasites] of fishes ) )</metric>
    <metric>a</metric>
    <enumeratedValueSet variable="zooplankton-reproduction-rate">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="parasite-load-in-zooplankton">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fatal-parasite-load">
      <value value="80"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-number-zooplankton">
      <value value="550"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fish-reproduction-rate">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-fish-population">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="show-parasites?">
      <value value="true"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Aggregation Experiment" repetitions="1" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="1000"/>
    <metric>( ( mean [parasites] of fishes ^ 2 ) - ( ( variance [parasites] of fishes ) / N ) ) / ( ( variance [parasites] of fishes ) - ( mean [parasites] of fishes ) )</metric>
    <steppedValueSet variable="initial-number-zooplankton" first="550" step="1000" last="5550"/>
    <steppedValueSet variable="initial-fish-population" first="50" step="100" last="550"/>
    <steppedValueSet variable="zooplankton-reproduction-rate" first="0" step="0.5" last="3"/>
    <steppedValueSet variable="fish-reproduction-rate" first="0" step="0.25" last="1.5"/>
    <steppedValueSet variable="parasite-load-in-zooplankton" first="2" step="2" last="10"/>
    <enumeratedValueSet variable="fatal-parasite-load">
      <value value="80"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="show-parasites?">
      <value value="true"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Aggregation Experiment spatial 1" repetitions="1" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="1000"/>
    <metric>( ( mean [parasites] of fishes ^ 2 ) - ( ( variance [parasites] of fishes ) / N ) ) / ( ( variance [parasites] of fishes ) - ( mean [parasites] of fishes ) )</metric>
    <enumeratedValueSet variable="initial-number-zooplankton">
      <value value="550"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-fish-population">
      <value value="50"/>
    </enumeratedValueSet>
    <steppedValueSet variable="zooplankton-reproduction-rate" first="0" step="0.5" last="3"/>
    <steppedValueSet variable="fish-reproduction-rate" first="0" step="0.25" last="1.5"/>
    <steppedValueSet variable="parasite-load-in-zooplankton" first="2" step="2" last="10"/>
    <enumeratedValueSet variable="fatal-parasite-load">
      <value value="80"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="show-parasites?">
      <value value="true"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Aggregation Experiment complete spatial" repetitions="1" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="1000"/>
    <metric>( ( mean [parasites] of fishes ^ 2 ) - ( ( variance [parasites] of fishes ) / N ) ) / ( ( variance [parasites] of fishes ) - ( mean [parasites] of fishes ) )</metric>
    <steppedValueSet variable="initial-number-zooplankton" first="550" step="1000" last="5550"/>
    <steppedValueSet variable="initial-fish-population" first="50" step="100" last="550"/>
    <steppedValueSet variable="zooplankton-reproduction-rate" first="0" step="0.5" last="3"/>
    <steppedValueSet variable="fish-reproduction-rate" first="0" step="0.25" last="1.5"/>
    <steppedValueSet variable="parasite-load-in-zooplankton" first="2" step="2" last="10"/>
    <steppedValueSet variable="infcor" first="0" step="10" last="40"/>
    <steppedValueSet variable="trecor" first="0" step="10" last="40"/>
    <enumeratedValueSet variable="fatal-parasite-load">
      <value value="80"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="show-parasites?">
      <value value="true"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Aggregation Experiment spatial fixed popu" repetitions="1" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="1000"/>
    <metric>( ( mean [parasites] of fishes ^ 2 ) - ( ( variance [parasites] of fishes ) / N ) ) / ( ( variance [parasites] of fishes ) - ( mean [parasites] of fishes ) )</metric>
    <enumeratedValueSet variable="initial-number-zooplankton">
      <value value="550"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-fish-population">
      <value value="50"/>
    </enumeratedValueSet>
    <steppedValueSet variable="zooplankton-reproduction-rate" first="0" step="0.5" last="3"/>
    <steppedValueSet variable="fish-reproduction-rate" first="0" step="0.25" last="1.5"/>
    <steppedValueSet variable="parasite-load-in-zooplankton" first="2" step="2" last="10"/>
    <steppedValueSet variable="infcor" first="0" step="10" last="40"/>
    <steppedValueSet variable="trecor" first="0" step="10" last="40"/>
    <enumeratedValueSet variable="fatal-parasite-load">
      <value value="80"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="show-parasites?">
      <value value="true"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Aggregation Experiment spatial fixed popu treatment" repetitions="1" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="1000"/>
    <metric>( ( mean [parasites] of fishes ^ 2 ) - ( ( variance [parasites] of fishes ) / N ) ) / ( ( variance [parasites] of fishes ) - ( mean [parasites] of fishes ) )</metric>
    <enumeratedValueSet variable="initial-number-zooplankton">
      <value value="550"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-fish-population">
      <value value="50"/>
    </enumeratedValueSet>
    <steppedValueSet variable="zooplankton-reproduction-rate" first="0" step="0.5" last="3"/>
    <steppedValueSet variable="fish-reproduction-rate" first="0" step="0.25" last="1.5"/>
    <steppedValueSet variable="parasite-load-in-zooplankton" first="2" step="2" last="10"/>
    <steppedValueSet variable="trecor" first="0" step="10" last="40"/>
    <enumeratedValueSet variable="infcor">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fatal-parasite-load">
      <value value="80"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="show-parasites?">
      <value value="true"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="clustering" repetitions="1" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="1000"/>
    <metric>count turtles</metric>
    <enumeratedValueSet variable="parasite-load-in-zooplankton">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="zooplankton-reproduction-rate">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="add-infectionarea?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="infection-area-size">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fatal-parasite-load">
      <value value="80"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-number-zooplankton">
      <value value="5550"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fish-reproduction-rate">
      <value value="0.25"/>
      <value value="0.5"/>
      <value value="0.75"/>
      <value value="1"/>
      <value value="1.25"/>
      <value value="1.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="add-treatment?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-fish-population">
      <value value="550"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="show-parasites?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="treatment-area-size">
      <value value="0"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="experiment" repetitions="1" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <metric>count turtles</metric>
    <enumeratedValueSet variable="zooplankton-reproduction-rate">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="add-infectionarea?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-number-hospital">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="biratnagar">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="show-resources?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="kathmandu">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dhangadhi">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="infection-area-size">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-human-population">
      <value value="26480"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="add-treatment?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="death-rate">
      <value value="0.06283"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="human-reproduction-rate">
      <value value="0.0212"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="treatment-area-size">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="infection-rate">
      <value value="0.003"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pokhara">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nepalganj">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="birgunj">
      <value value="0"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="project" repetitions="1" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <metric>treated-individuals</metric>
    <enumeratedValueSet variable="infection-rate">
      <value value="0.003"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-number-hospital">
      <value value="6"/>
    </enumeratedValueSet>
    <steppedValueSet variable="biratnagar" first="0" step="0.2" last="1"/>
    <enumeratedValueSet variable="show-resources?">
      <value value="true"/>
    </enumeratedValueSet>
    <steppedValueSet variable="kathmandu" first="0" step="0.2" last="1"/>
    <steppedValueSet variable="pokhara" first="0" step="0.2" last="1"/>
    <steppedValueSet variable="dhangadhi" first="0" step="0.2" last="1"/>
    <enumeratedValueSet variable="initial-human-population">
      <value value="26480"/>
    </enumeratedValueSet>
    <steppedValueSet variable="nepalganj" first="0" step="0.2" last="1"/>
    <steppedValueSet variable="birgunj" first="0" step="0.2" last="1"/>
    <enumeratedValueSet variable="human-reproduction-rate">
      <value value="0.0212"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="death-rate">
      <value value="0.06283"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="project2" repetitions="1" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="1000"/>
    <metric>treated-individuals</metric>
    <enumeratedValueSet variable="infection-rate">
      <value value="0.003"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-number-hospital">
      <value value="6"/>
    </enumeratedValueSet>
    <steppedValueSet variable="all" first="0" step="0.05" last="1"/>
    <enumeratedValueSet variable="show-resources?">
      <value value="true"/>
    </enumeratedValueSet>
    <steppedValueSet variable="kathmandu" first="0" step="0.05" last="1"/>
    <enumeratedValueSet variable="initial-human-population">
      <value value="26480"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="human-reproduction-rate">
      <value value="0.0212"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="death-rate">
      <value value="0.06283"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
