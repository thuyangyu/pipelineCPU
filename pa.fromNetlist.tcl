
# PlanAhead Launch Script for Post-Synthesis pin planning, created by Project Navigator

create_project -name pipelineCPU -dir "D:/link/computerOrganization/homeworks/pipelineCPU/planAhead_run_3" -part xc3s1200efg320-4
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "D:/link/computerOrganization/homeworks/pipelineCPU/PipelineCPU.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {D:/link/computerOrganization/homeworks/pipelineCPU} }
set_param project.pinAheadLayout  yes
set_property target_constrs_file "PipelineCPU.ucf" [current_fileset -constrset]
add_files [list {PipelineCPU.ucf}] -fileset [get_property constrset [current_run]]
link_design
