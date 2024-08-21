from pyswmm import Simulation, Links, Nodes, SystemStats
import matlab.engine

eng = matlab.engine.connect_matlab()

# Current_Test = "series_merging"
#
# switch Current_Test


# # System Code
# with Simulation('SWMM File/System_Test/hurricane/System.inp') as sim:
#     J1 = Nodes(sim)["J1"]
#     J3 = Nodes(sim)["J3"]
#     J5 = Nodes(sim)["J5"]
#
#     J1inflow = []
#     J3inflow = []
#     J5inflow = []
#
#     J2 = Nodes(sim)["J2"]
#     SU1 = Nodes(sim)["SU1"]
#     J5 = Nodes(sim)["J5"]
#     SU2 = Nodes(sim)["SU2"]
#     SU3 = Nodes(sim)["SU3"]
#     J8 = Nodes(sim)["J8"]
#     J9 = Nodes(sim)["J9"]
#
#     J2level = []
#     SU1level = []
#     J5level = []
#     SU2level = []
#     SU3level = []
#     J8level = []
#     J9level = []
#
#     J4 = Nodes(sim)["J4"]
#     J6 = Nodes(sim)["J6"]
#     J7 = Nodes(sim)["J7"]
#
#     J4level = []
#     J6level = []
#     J7level = []
#     for step in sim:
#         J1inflow.append(J1.lateral_inflow)
#         J3inflow.append(J3.lateral_inflow)
#         J5inflow.append(J5.lateral_inflow)
#
#         J2level.append(J2.depth)
#         SU1level.append(SU1.depth)
#         J5level.append(J5.depth)
#         SU2level.append(SU2.depth)
#         SU3level.append(SU3.depth)
#         J8level.append(J8.depth)
#         J9level.append(J9.depth)
#
#         J4level.append(J4.depth)
#         J6level.append(J6.depth)
#         J7level.append(J7.depth)
#
#     input_data = [J1inflow, J3inflow,J5inflow,J2level,SU1level,J5level,SU2level,SU3level,J8level,J9level,J4level,J6level,J7level]
#     input_string = ["J1inflow", "J3inflow", "J5inflow", "J2level", "SU1level", "J5level", "SU2level", "SU3level", "J8level", "J9level",
#                   "J4level", "J6level", "J7level"]
#     output = eng.save_system_data(J1inflow, J3inflow,J5inflow,J2level,SU1level,J5level,SU2level,SU3level,J8level,J9level,J4level,J6level,J7level)



# Storage With Direct Outfall Code
# with Simulation('SWMM File/Storage_Test/new_hurricane/Storage.inp') as sim:
#     J1 = Nodes(sim)["J1"]
#     SU1 = Nodes(sim)["SU1"]
#
#     J1inflow = []
#     SU1level = []
#
#     for step in sim:
#         J1inflow.append(J1.lateral_inflow)
#         SU1level.append(SU1.depth)
#
#     output = eng.save_storage_onelink_data(J1inflow,SU1level)

# Storage with three links upstream
# with Simulation('SWMM File/Three_Cascade_Link_Test/storage down/ThreeConduit.inp') as sim:
#     J1 = Nodes(sim)["J1"]
#     J2 = Nodes(sim)["J2"]
#     J3 = Nodes(sim)["J3"]
#     SU = Nodes(sim)["SU"]
#
#     J1inflow = []
#     J2level = []
#     J3level = []
#     SUlevel = []
#
#     for step in sim:
#         J1inflow.append(J1.lateral_inflow)
#         J2level.append(J2.depth)
#         J3level.append(J3.depth)
#         SUlevel.append(SU.depth)
#
#     output = eng.save_storage_3links_data(J1inflow,J2level,J3level,SUlevel)


# Storage with Merging
# with Simulation('SWMM File/Merging_Test/storage down/Merging.inp') as sim:
#     J1 = Nodes(sim)["J1"]
#     J2 = Nodes(sim)["J2"]
#     Merg = Nodes(sim)["Merg"]
#     SU = Nodes(sim)["SU"]
#
#     J1inflow = []
#     J2inflow = []
#     Merglevel = []
#     SUlevel = []
#
#     for step in sim:
#         J1inflow.append(J1.lateral_inflow)
#         J2inflow.append(J2.lateral_inflow)
#         Merglevel.append(Merg.depth)
#         SUlevel.append(SU.depth)
#
#     output = eng.save_merging_storage_data(J1inflow,J2inflow,Merglevel,SUlevel)

# Merging with Direct Storage
# with Simulation('SWMM File/Merging_Test/direct storage/Merging.inp') as sim:
#     J1 = Nodes(sim)["J1"]
#     J2 = Nodes(sim)["J2"]
#     Merg = Nodes(sim)["Merg"]
#
#     J1inflow = []
#     J2inflow = []
#     Merglevel = []
#
#     for step in sim:
#         J1inflow.append(J1.lateral_inflow)
#         J2inflow.append(J2.lateral_inflow)
#         Merglevel.append(Merg.depth)
#
#     output = eng.save_merging_storage_data(J1inflow,J2inflow,Merglevel)


# Only Merging System
# with Simulation('SWMM File/System_Test/only_merging/System.inp') as sim:
#     J1 = Nodes(sim)["J1"]
#     J3 = Nodes(sim)["J3"]
#     J6 = Nodes(sim)["J5"]
#
#     J1inflow = []
#     J3inflow = []
#     J6inflow = []
#
#     SU1 = Nodes(sim)["SU1"]
#     SU2 = Nodes(sim)["SU2"]
#
#     SU1level = []
#     SU2level = []
#     for step in sim:
#         J1inflow.append(J1.lateral_inflow)
#         J3inflow.append(J3.lateral_inflow)
#         J6inflow.append(J6.lateral_inflow)
#
#         SU1level.append(SU1.depth)
#         SU2level.append(SU2.depth)
#
#     output = eng.save_system_data(J1inflow, J3inflow,J6inflow,SU1level,SU2level)

# Series-Merging Test
with Simulation('SWMM File/cascade/three_conduit.inp') as sim:
    string_input = []
    for node in Nodes(sim):
        node_name = node.nodeid
        exec(node_name + "= node")
        exec(node_name + "inflow" + "= []") # First quantity needed
        string_input.append(node_name + "inflow")
        exec(node_name + "level" + "= []") # Second quantity needed
        string_input.append(node_name + "level")

    for link in Links(sim):
        link_name = link.linkid
        exec(link_name + "= link")
        exec(link_name + "flow" + "= []") # Third quantity needed
        string_input.append(link_name + "flow")
        exec(link_name + "downlevel" + '= []') # Fourth quantity needed
        string_input.append(link_name + "downlevel")
        down_node = Nodes(sim)[link.outlet_node]
        exec(link_name + "_down_node" + "= down_node")

    system_stats = SystemStats(sim)
    rainfall = []

    for step in sim:
        for node in Nodes(sim):
            node_name = node.nodeid
            exec(node_name + "inflow.append(" + node_name + ".lateral_inflow)")
            exec(node_name + "level.append(" + node_name + ".depth)")

        for link in Links(sim):
            link_name = link.linkid
            exec(link_name + "flow.append(" + link_name + ".flow)")
            exec(link_name + "downlevel.append(" + link_name +"_down_node.depth)")
        runoffstats = system_stats.runoff_stats
        rainfall.append(runoffstats.get('rainfall'))

    #Now save all four quantities in data
    data_input = []
    for node in Nodes(sim):
        node_name = node.nodeid
        exec("data_input.append(" + node_name + "inflow)")
        exec("data_input.append(" + node_name + "level)")
    for link in Links(sim):
        link_name = link.linkid
        exec("data_input.append(" + link_name + "flow)")
        exec("data_input.append(" + link_name + "downlevel)")
    data_input.append(rainfall)
    string_input.append("rainfall")

    output = eng.save_system_data(data_input,string_input)