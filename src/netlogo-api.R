
# Run NetLogo simulation from R - Examples using nlrx and RNetlogo

# Set-up ---------------------------------------------------------------------------------

library("nlrx") # NetLogo interface


# nlrx -----------------------------------------------------------------------------------

# Set up the path to the netlogo program, model and the output directory
netlogo_path <- file.path("/Applications/NetLogo 6.1.1")
model_path <- file.path("netlogo/dancing-plague.nlogo")
out_path <- file.path("output/simulation-results")

# Create an nl object with the memory allocated to the java virtual machine
nl <- nl(
  nlversion = "6.0.3",
  nlpath = netlogo_path,
  modelpath = model_path,
  jvmmem = 1024
)

# Define the experiment
nl@experiment <- experiment(
  expname = "dancing-plague",
  outpath = out_path,
  repetition = 1,
  tickmetrics = "true",
  idsetup = "setup",
  idgo = "go",
  stopcond = "all? turtles [not infected? and not infected-sym?]",
  # runtime = 50,
  evalticks = seq(40, 50),
  metrics = c("count people with [dead?] / count people", "money-spent"),
  variables = list(
    "lockdown-strictness" = list(values = seq(0, 100, by = 5)),
    "hospital-capacity" = list(values = seq(0, 100, by = 5))
  ),
  constants = list(
    "number-of-people" = 800,
    "number-of-encounters" = 4,
    "initially-infected-people" = 10,
    "transmission-rate" = 0.15,
    "fatality-rate-infected" = 8,
    "fatality-rate-treated" = 3
  )
)

# Define the simulation design
nl@simdesign <- simdesign_ff(
  nl = nl,
  nseeds = 1
)

# Run the simulations
# results <- run_nl_one(nl, seed = 3, siminputrow = 1)
results <- run_nl_all(nl)

# Save the results
saveRDS(results, "output/simulation-results/dancing-plague-sim-results.rds")

# Attach results to nl object:
setsim(nl, "simoutput") <- results

# Write output to outpath of experiment within nl
write_simoutput(nl)

# Do further analysis:
a <- analyze_nl(nl)
