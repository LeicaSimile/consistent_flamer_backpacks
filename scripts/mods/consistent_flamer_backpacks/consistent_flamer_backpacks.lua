-- Author: LeicaSimile
local mod = get_mod("consistent_flamer_backpacks")
local HEALTH_STEPS = {
	{
		health_step = 1,
		health_threshold = 0.95,
	},
	{
		health_step = 2,
		health_threshold = 0.9,
	},
	{
		health_step = 3,
		health_threshold = 0.75,
	},
	{
		health_step = 4,
		health_threshold = 0.5,
	},
}
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local FixedFrame = require("scripts/utilities/fixed_frame")
local mbt_path = "scripts/settings/buff/minion_buff_templates"
local MinionBuffTemplates = require(mbt_path)
local orig_proc_func = MinionBuffTemplates.flamer_backpack_counter.proc_func

mod:hook_require("scripts/settings/buff/minion_buff_templates", function (templates)
    mod.on_enabled = function(_)
        templates.flamer_backpack_counter.proc_func = function (params, template_data, template_context)
            if not template_context.is_server then
                return
            end
    
            if params.hit_zone_name_or_nil == "backpack" and params.attack_type ~= "melee" then
                local statistics_component = Blackboard.write_component(template_data.blackboard, "statistics")
                local gib_override_component = Blackboard.write_component(template_data.blackboard, "gib_override")
    
                gib_override_component.should_override = true
                statistics_component.flamer_backpack_impacts = statistics_component.flamer_backpack_impacts + 1
    
                local unit = template_context.unit
                local t = FixedFrame.get_latest_fixed_time()
                local buff_extension = ScriptUnit.extension(unit, "buff_system")
                local health_extension = ScriptUnit.extension(template_context.unit, "health_system")
                local buff_name = template_data.buff_name
                local current_health_percent = health_extension:current_health_percent()
                local health_step_value = 1  -- Changed from 0 to 1, guarantees showing the warning fx
    
                for i = 1, #HEALTH_STEPS do
                    local health_step_data = HEALTH_STEPS[i]
    
                    if current_health_percent <= health_step_data.health_threshold then
                        health_step_value = health_step_data.health_step
                    else
                        break
                    end
                end
    
                local current_stacks_or_nil = buff_extension:current_stacks(buff_name)
                local times_to_apply_stack = health_step_value - current_stacks_or_nil
                for i = 1, times_to_apply_stack do
                    buff_extension:add_internally_controlled_buff(buff_name, t)
                    buff_extension:_update_stat_buffs_and_keywords(t)
                end
            end
        end
    end
    
    mod.on_disabled = function(_)
        templates.flamer_backpack_counter.proc_func = orig_proc_func
    end
end)
