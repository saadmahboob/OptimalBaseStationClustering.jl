#!/usr/bin/env julia

using CoordinatedPrecoding, DistributedBaseStationClustering
using Compat, JLD, LaTeXStrings

sim_name = "SNR"
data = load("$(sim_name).jld")

processed_data_mean = data["processed_data_mean"]
idp_vals = data["simulation_params"]["independent_variable"][2]

# 8-class Set1
colours = Dict(
    :red => "#e41a1c",
    :blue => "#377eb8",
    :green => "#4daf4a",
    :purple => "#984ea3",
    :orange => "#ff7f00",
    :yellow => "#ffff33",
    :brown => "#a65628",
    :pink => "#f781bf",
)

# Plot defaults
PyPlot.rc("lines", linewidth=1., markersize=3, markeredgewidth=0.5)
PyPlot.rc("font", size=6, family="serif", serif="Computer Modern Sans Serif")
PyPlot.rc("text", usetex=true)
PyPlot.rc("text.latex", preamble="\\usepackage{amsmath}")
PyPlot.rc("axes", linewidth=0.5, labelsize=6)
PyPlot.rc("xtick", labelsize=6)
PyPlot.rc("ytick", labelsize=6)
PyPlot.rc("legend", fancybox=true, fontsize=6)
PyPlot.rc("figure", figsize=(3.50,1.2), dpi=125)

# Plot it
fig = PyPlot.figure()
ax = fig[:add_axes]((0.12,0.24,0.88-0.12,0.95-0.24))

ax[:plot](idp_vals, processed_data_mean["BranchAndBoundClustering"]["throughputs"],
    color=colours[:blue], linestyle="-", marker="o", markeredgecolor=colours[:blue], markevery=3,
    label="Branch and bound")
ax[:plot](idp_vals, processed_data_mean["GreedyClustering"]["throughputs"],
    color=colours[:green], linestyle="-", marker="^", markeredgecolor=colours[:green], markevery=3,
    label="Heuristic")
# ax[:plot](idp_vals, processed_data_mean["GreedyClustering_Single"]["throughputs"],
#     color=colours[:green], linestyle="--",
#     label="Heuristic (single)")
# ax[:plot](idp_vals, processed_data_mean["GrandCoalitionClustering"]["throughputs"],
#     color=colours[:brown], linestyle="-",
#     label="Grand coalition")
ax[:plot](idp_vals, processed_data_mean["NoClustering"]["throughputs"],
    color=colours[:pink], linestyle="-", marker="x", markeredgecolor=colours[:pink], markevery=3,
    label="No clustering")
ax[:set_xlabel]("Signal-to-noise ratio [dB]")
ax[:set_ylabel]("Sum t'put [nats/s/Hz]")
legend = ax[:legend](loc="upper left")
legend_frame = legend[:get_frame]()
PyPlot.setp(legend_frame, linewidth=0.5)
fig[:savefig]("SNR.eps")
