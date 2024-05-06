 # Paper Airplane Numerical Study
  Final Project: AEM 3103 Spring 2024

  - By: Lainey A. Oliphant

  ## Summary of Findings


| Values  | Initial Velocity (m/s)|  Gamma  |
| ------- | --------------------- | —-------|
| Nominal |          3.55         |  -0.18  | 
| Minimum |           2           |  -0.5   |
| Maximum |          7.5          |   0.4   |


 In this study, I was able to visualize how changing different variables would impact both height and range. From the first figure (see Figures), it is clear that the optimal value to achieve the best range was the nominal value when varying just the flight path angle, gamma. When varying just the initial velocity, however, the highest velocity value was optimal to achieve the best range, not the nominal as expected. From the first graph, each flight path minus the nominal case begins at 2 meters high, fluctuates until about the 10 meter range, then varies linearly until the end of the trial. This results in various peaks and dips in the data trend. This same trend can be seen from the Monte Carlo simulation across the one-hundred trials. 

 
  # Code Listing

PaperPlane.m
This is the main code used to perform the various trials, including both computational and visual tasks.

EqMotion.m
This is a function that calculates xdot given the inputted parameters.


  # Figures

  ## Fig. 1: Single Parameter Variation
 <img width="515" alt="Screenshot 2024-05-06 at 12 44 27 PM" src="https://github.com/laineyoliphant/aem3103-final/assets/167448295/9830f40e-0cca-4386-8d84-4b89353f3f6e">

  The upper subplot shows the Height vs Range of a glide with varying initial velocities, where the different velocities are shown in the legend (note that the nominal velocity is in black). The lower plot shows the same relationship, but with varying glide angles (also shown in the plot’s legend). 


  ## Fig. 2: Monte Carlo Simulation
<img width="503" alt="Screenshot 2024-05-06 at 12 43 49 PM" src="https://github.com/laineyoliphant/aem3103-final/assets/167448295/8a4fecc9-eba4-4083-8c26-42abf73a3adb">


<img width="506" alt="Screenshot 2024-05-06 at 12 42 57 PM" src="https://github.com/laineyoliphant/aem3103-final/assets/167448295/bbbb5fe4-6c4f-4542-8bac-182cdaca05fb">


 The first graph shows one-hundred iterations of a glide’s Height vs Range using randomized parameters to study the impact of simultaneous variations instead of just one at a time. The plot below shows the curve-fitted Range vs Time (top subplot) and Height vs. Time (bottom subplot) for the average of the previous one-hundred iterations. 


 ## Fig. 3: Time Derivatives

 <img width="509" alt="Screenshot 2024-05-06 at 12 42 11 PM" src="https://github.com/laineyoliphant/aem3103-final/assets/167448295/d35fe28e-eb25-462c-b899-d5a32fdec7dc">

  This plot shows the time-derivatives for both height(top) and range (bottom) of the fitted trajectory from the previous figure. 
