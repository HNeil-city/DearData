# plan

I plan to collect data on time spent first implementing a "feature" (function/class) vs time spent debuggin it

*I will be using an application called "Chill with you - lofi story", available on steam, to track the hours spent. It is a conveniant tool that allows me check and see the number of hours spent using the inbuilt timer each day.*

## Data representation

I want to have a sort of "TREE" arise from my data. I will convert the number of hours of hom study / uni time into a ratio, then depending on the "strength" of the ratio (how far it deviates from 1) the tree will branch  either left or right using an arc through some angle, dependant on the ratio. the LENGTH of the arc will depcit the total time spent working that day. Each week will have its own tree. The mouseX pos will be used to determine the weight of the turn (e.g more left mouse pos will mean a larger multiplier for the left leaning arcs.) I'd also like to implement changing the hue of each arc based on the total number of hours worked in the week. The most hours worked will have the largest hue value and the least hours worked will have the smalles hue value, to produce a nice colour representation